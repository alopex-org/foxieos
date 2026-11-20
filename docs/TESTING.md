# FoxieOS testing

**Status: planned.**
None of the scripts below exist yet; roadmap tasks T3, T6 and T7 build them.
Until device #1 arrives (roadmap decision D1, task T7), layers L1–L4 run on the Cuttlefish virtual device ([Virtual devices](#virtual-devices)); layers L5 and L7 need the phone.

How builds are signed and shipped is in [RELEASING.md](RELEASING.md).
Sources are listed at the [end of this file](#sources) and in [FEASIBILITY.md](FEASIBILITY.md#sources).

## The pipeline

```
Every change:
  L0 static checks → L1 build and L2 unit tests (presubmit) → review → merge

Every night:
  L1 full builds → L3 Cuttlefish boot and smoke tests → L4 CTS against the baseline

Every release candidate:
  build target-files → sign offline → L6 signature checks → L5 OTA tests → L7 device QA
  → testing channel (48 hours or more) → beta (7 days or more) → stable
```

A failure at any layer stops the pipeline.
Fix forward, and never skip a layer for a stable release.
A security hotfix may shorten L8 to 24 hours on testing and 48 hours on beta, with a note in the release notes.

## Test layers

| Layer | Runs | On | Passes when |
|---|---|---|---|
| [L0 static checks](#l0-static-checks) | every commit | any machine | no findings |
| [L1 build](#l1-build) | every pull request; nightly | build host | the build exits 0 |
| [L2 unit tests](#l2-unit-tests) | every pull request | build host | all tests pass |
| [L3 boot and smoke](#l3-boot-and-smoke) | pull requests touching the system; nightly | Cuttlefish | it boots and smoke passes |
| [L4 compatibility](#l4-compatibility) | nightly; every release candidate | Cuttlefish; devices | no failures beyond the baseline |
| [L5 OTA](#l5-ota) | every release candidate | device | every scenario passes |
| [L6 signatures](#l6-signatures) | every release candidate | signing host | only release keys |
| [L7 device QA](#l7-device-qa) | every release candidate | each device | checklist complete |
| [L8 soak](#l8-soak) | after L7 | testers | no serious regressions |

### L0 static checks

- **When:** every commit, as a pre-commit hook and in CI.
- **What:**
  - `gitleaks`, which blocks keys and secrets;
  - `shellcheck` and `yamllint`;
  - `xmllint --noout` on overlays and manifests;
  - `bpfmt -d` on `Android.bp` files (unsourced);
  - a check that commit messages follow `scope: description`.
- **Passes when** there are no findings.
- **Budget:** under 2 minutes.

### L1 build

- **When:** every pull request (an incremental build of the Cuttlefish target) and nightly (clean builds of Cuttlefish and of every supported device as `userdebug`; there are none until T7).
- **Where:** the build host, with a ccache of 50–100 GB.
- **Passes when** the build exits 0, with no new Soong or Kati errors.
- **Budget:** under 60 minutes for an incremental build; nightly builds take hours.

### L2 unit tests

- **When:** every pull request.
- **What:** the `atest` presubmit group from the `TEST_MAPPING` of every project the change touches; host tests with `--host`.
- **Passes when** all tests pass, and every module FoxieOS owns has a `TEST_MAPPING` entry.
- **Budget:** under 30 minutes.

### L3 boot and smoke

- **When:** every pull request that touches the system image, and nightly.
- **Where:** Cuttlefish, which needs KVM; on each device as part of L7.
- **What:** boot, then run `tests/smoke/run.sh` ([Smoke suite](#smoke-suite)).
- **Passes when** `sys.boot_completed` is reached within 5 minutes and every smoke check passes.
- **Budget:** under 15 minutes.

### L4 compatibility

- **When:** nightly on Cuttlefish; on devices for every release candidate; a full CTS run on a device before each stable release.
- **Where:** Cuttlefish, on the build host or a second test host; devices.
- **What:** `cts-tradefed`, with the `cts-virtual-device-stable` plan on Cuttlefish and the modules in `tests/cts/modules-device.txt` on devices.
- **Passes when** no test fails that didn't also fail on stock LineageOS for the same target ([CTS strategy](#cts-strategy)).
- **Budget:** under 3 hours nightly.

### L5 OTA

- **When:** every release candidate.
- **Where:** the device; also Cuttlefish if roadmap check C11 passes.
- **What:** the [OTA scenarios](#ota-tests): full and incremental updates, two versions back to current, an interrupted install, and anti-rollback.
- **Passes when** every scenario passes and user data is intact.
- **Budget:** about half a day.

### L6 signatures

- **When:** every release candidate, after signing.
- **Where:** the signing host.
- **What:** the checks in [RELEASING.md](RELEASING.md#verification).
- **Passes when** every artifact is signed with release keys and nothing carries test-keys.
- **Budget:** under 30 minutes.

### L7 device QA

- **When:** every release candidate.
- **Where:** each supported device.
- **What:** the checklist in `tests/qa/<codename>.md`, plus the smoke suite on the device (`-s <serial>`).
- **Passes when** every item is ticked or has a known issue filed.
- **Budget:** about 2 hours per device.

### L8 soak

- **When:** after L7.
- **Who:** testers on the update channels: `testing` for at least 48 hours, then `beta` for at least 7 days, then `stable`.
- **Passes when** nobody reports boot loops, data loss or radio regressions.

## Commands

Check the ⚠ ones on first use, then remove the marker.

```bash
# Sync (task T2). Flags from LineageOS's build page for lineage-24.0, checked 2026-11-20.
repo init -u https://github.com/LineageOS/android.git -b lineage-24.0 --git-lfs --no-clone-bundle
repo sync    # the LineageOS manifest already sets -c and -j4; the wiki asks for no extra options

# Build environment
source build/envsetup.sh
breakfast <codename>                # select a device target
brunch <codename>                   # full device build
mka target-files-package otatools   # the inputs for offline signing

# Virtual device (tasks T2–T6), from the same tree
lunch lineage_cf_phone_x86_64-userdebug
mka
launch_cvd --daemon                 # needs the Cuttlefish host tools (⚠ roadmap check C1)
adb devices                         # expect 127.0.0.1:6520
stop_cvd
```

Sources: [LineageOS build page for shiba][lineage-shiba-build], [LineageOS emulator page][lineage-emulator], [Cuttlefish: get started][cf-start].

## Virtual devices

**Cuttlefish is the CI target** (decided 2026-11-20, virtual first).
The goldfish emulator stays available for interactive use.
Both come from the same LineageOS 24.0 tree; no separate AOSP checkout is needed.
Checked on 2026-11-20 in `vendor/lineage/build/target/product/AndroidProducts.mk` on lineage-24.0 ([AndroidProducts.mk][lineage-products]) and on the LineageOS wiki.

- **Emulator (goldfish):** `lineage_sdk_phone_x86_64-userdebug` is a lunch choice.
  The wiki builds it with `breakfast sdk_phone_x86_64 eng` (or `userdebug`) and then `mka`, and `mka emu_img_zip` packs it for Android Studio.
  LineageOS 24.0 is on the wiki's list of tested versions.
  Use x86_64 for native KVM speed.
  ([LineageOS emulator page][lineage-emulator])
- **Cuttlefish:** `lineage_cf_phone_x86_64-userdebug` is a lunch choice, as is `lineage_cf_phone_arm64`.
  It inherits AOSP's `aosp_cf.mk` plus LineageOS's generic target configuration, and uses the prebuilt Cuttlefish kernel ([lineage_cf_phone_x86_64.mk][lineage-cf-mk]).
  The LineageOS manifest carries AOSP's `device/google/cuttlefish`.
  It is AOSP's own CI device, with a `cts-virtual-device-stable` CTS plan ([CTS strategy](#cts-strategy)).
  The host needs KVM and Google's `cuttlefish-base` and `cuttlefish-user` Debian packages, or their Docker or Podman container images on other distributions ([Cuttlefish: get started][cf-start], [google/android-cuttlefish][cf-github]).
  ⚠ Whether OTA tests work on it is roadmap check C11; AOSP made it a Virtual A/B device (unsourced).
- Neither is a "virtual Pixel": Android Studio's Pixel profiles only set the screen size and skin over a generic image (unsourced).
  Hardware tests (verified-boot relocking, the modem, cameras, sensors, the battery) need the D1 phone.
- The rule that every flash needs a go-ahead ([AGENTS.md](../AGENTS.md), hard rule 2) covers physical devices only.
  Cuttlefish instances on the build host can be started, wiped and reflashed freely.
- For a headless emulator run: `emulator -no-window -no-audio -no-snapshot -gpu swiftshader_indirect` (unsourced).
  The emulator needs KVM and doesn't work under Wayland, so run it headless in CI, or under X ([GrapheneOS build guide][graphene-build]).

## Smoke suite

`tests/smoke/run.sh [-s SERIAL]` prints TAP output and runs against Cuttlefish, the emulator or a physical device.

| Check | Command (sketch) | Expected |
|---|---|---|
| Boot completes | `adb wait-for-device`, then poll `getprop sys.boot_completed` with a timeout | `1` within 300 s |
| SELinux enforcing | `adb shell getenforce` | `Enforcing` (a LineageOS charter requirement) |
| No `su` | `adb shell 'command -v su'` | empty (a LineageOS charter requirement) |
| Identity properties | `getprop ro.foxie.version` and `ro.foxie.build.channel` | non-empty and matching the build |
| Patch level | `getprop ro.build.version.security_patch` | the value in the release notes |
| Key tags | `getprop ro.build.tags` | `release-keys` on release candidates; `test-keys` only in CI |
| Debuggable | `getprop ro.debuggable` | matches the variant (`0` on `user`) |
| Encryption | `getprop ro.crypto.state` and `ro.crypto.type` | `encrypted` and `file` (unsourced) |
| No crash loop | `adb logcat -b crash -d` after 5 minutes idle; compare the `system_server` PID | empty; same PID |
| Packages | `adb shell pm list packages` against `tests/smoke/packages-{required,forbidden}.txt` | all required present, none forbidden |
| Updater URL | `getprop lineage.updater.uri`, or the overlay value | the FoxieOS URL for the channel |
| Privacy defaults | `settings get <namespace> <key>` for each default in `tests/smoke/settings.txt` | matches |
| Browser present | `pm list packages` | the shipped browser is installed |

FoxieOS keeps a browser because LineageOS requires one in its official builds ([LineageOS charter][lineage-charter]).

## CTS strategy

- CTS can be downloaded publicly as `android-cts-17_rN-linux_x86-{arm,x86}.zip` from `dl.google.com`.
  Run it with `./android-cts/tools/cts-tradefed`, then `run cts --plan …` and `run retry --retry N` ([CTS downloads][cts-downloads]).
- A CTS host needs at least 32 GB of RAM and 256 GB of disk, JDK 11 or later, `adb`, `aapt2`, and FFmpeg 5.1.3 or later.
  Keep the unzipped folder's name unchanged ([CTS][cts]).
- **Baseline method.**
  LineageOS itself doesn't pass all of CTS (unsourced), and not all of CTS passes on Cuttlefish ([Cuttlefish: run CTS][cf-cts]).
  1. Run the same plan or module list on stock lineage-24.0, built from the same manifest snapshot, for the same target.
  2. Save the failures to `tests/cts/baseline-<lineage-tag>-<target>.txt`: `cf_x86_64` in task T3, `<codename>` in task T7.
  3. The FoxieOS gate is that no test fails that isn't in the baseline.
  4. Regenerate the baselines whenever FoxieOS rebases.
- **Nightly on Cuttlefish:** the `cts-virtual-device-stable` plan, which tracks the part of CTS that is stable on virtual devices.
  ⚠ Roadmap check C3 confirms that the CTS 17 download includes it; if not, build CTS from the tree as AOSP's Cuttlefish guide does.
  AOSP's example runs `cts-tradefed run cts-virtual-device-stable --no-enable-parameterized-modules --max-testcase-run-count 2 --retry-strategy RETRY_ANY_FAILURE --reboot-at-last-retry --shard-count 8` on 8 instances: 184 modules in about 22 minutes.
  Each instance needs Wi-Fi enabled (`WifiUtil.apk`) ([Cuttlefish: run CTS][cf-cts]).
- **Devices**, for every release candidate: the modules in `tests/cts/modules-device.txt`.
  ⚠ Confirm the names with `list modules` (roadmap check C3).
  The planned list: `CtsSecurityTestCases`, `CtsSecurityBulletinHostTestCases`, `CtsPermissionTestCases`, `CtsPermission3TestCases`, `CtsAppSecurityHostTestCases`, `CtsSelinuxTargetSdkCurrentTestCases`, `CtsOsTestCases`, `CtsNetTestCases`, `CtsKeystoreTestCases`, `CtsAppTestCases`.
- **Before every stable release:** a full CTS run on a physical device running a `user` build, which the security tests need.
  Prepare the device as the CTS setup page describes: Wi-Fi with IPv6, SIM lock off, location on ([CTS][cts]).
- Passing CTS does **not** bring Google certification or Play Integrity; never claim it does.
- VTS and CTS-on-GSI are optional, and useful only for the GSI track ([CTS][cts]).
- **More than one test host** (planned, task T6).
  Cuttlefish and CTS can run on a second host from copied images, so the build host can start the next build.
  To split one CTS run across hosts, start the same plan on each with `--shard-count N --shard-index i`: every host builds the same test list and runs a disjoint slice of it.
  Tradefed doesn't merge sharded results, so the nightly script merges them ([Tradefed sharding][tf-sharding], [sharded results][tf-sharded-runner]).
  A test host needs KVM and enough RAM for its Cuttlefish instances; a virtual machine also needs nested virtualization (roadmap check C5).

## OTA tests

The scenarios live in `tests/ota/`.
How the packages are built is in [RELEASING.md](RELEASING.md#ota-packages).

They run on the physical device, where every flash needs a go-ahead.
If roadmap check C11 passes, scenarios 1–4 run on Cuttlefish first.

1. **Incremental update**, from the previous build (N-1) to the new one (N), through the Updater on the `testing` channel.
   Afterwards the device boots, the slot has switched, the smoke suite passes, and seeded user data is intact: a contact, a file in `/sdcard`, an installed app with its data, and a saved Wi-Fi network.
2. **Full update** from two builds back (N-2) to N, with the same checks.
3. **Interrupted install:** reboot during the download, then during the install.
   The device stays on the old slot, and a retry succeeds.
   This relies on A/B fallback; Virtual A/B is the current design ([A/B updates][aosp-ab]).
4. **Anti-rollback:** offer build N-1 to a device on N.
   The update is refused.
5. **Clean install** from the factory or recovery package, then the first OTA.

Keep the signed target-files and OTA packages for N-1 and N-2 in release storage.
Without them, you can't build incremental updates or run these tests.

## Sources

- AOSP: [Cuttlefish: get started][cf-start], [Cuttlefish: run CTS][cf-cts], [atest][atest], [CTS][cts], [CTS downloads][cts-downloads], [A/B updates][aosp-ab], [OTA tools][aosp-ota-tools], [Tradefed sharding][tf-sharding], [sharded results][tf-sharded-runner].
- LineageOS: [emulator page][lineage-emulator], [build page for shiba][lineage-shiba-build], [AndroidProducts.mk][lineage-products], [lineage_cf_phone_x86_64.mk][lineage-cf-mk], [device support requirements][lineage-charter].
- Google: [android-cuttlefish on GitHub][cf-github].
- GrapheneOS: [build guide][graphene-build] (emulator, CTS, channels).

[aosp-ab]: https://source.android.com/docs/core/ota/ab
[aosp-ota-tools]: https://source.android.com/docs/core/ota/tools
[atest]: https://source.android.com/docs/core/tests/development/atest
[cf-cts]: https://source.android.com/docs/devices/cuttlefish/cts
[cf-github]: https://github.com/google/android-cuttlefish
[cf-start]: https://source.android.com/docs/devices/cuttlefish/get-started
[cts]: https://source.android.com/docs/compatibility/cts
[cts-downloads]: https://source.android.com/docs/compatibility/cts/downloads
[graphene-build]: https://grapheneos.org/build
[lineage-cf-mk]: https://github.com/LineageOS/android_vendor_lineage/blob/lineage-24.0/build/target/product/lineage_cf_phone_x86_64.mk
[lineage-charter]: https://github.com/LineageOS/charter/blob/main/device-support-requirements.md
[lineage-emulator]: https://wiki.lineageos.org/emulator
[lineage-products]: https://github.com/LineageOS/android_vendor_lineage/blob/lineage-24.0/build/target/product/AndroidProducts.mk
[lineage-shiba-build]: https://wiki.lineageos.org/devices/shiba/build/
[tf-sharded-runner]: https://source.android.com/docs/core/tests/tradefed/testing/through-tf/sharded-runner
[tf-sharding]: https://source.android.com/docs/core/tests/tradefed/architecture/advanced/sharding
