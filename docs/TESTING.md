# FoxieOS testing

**Status: planned.**
None of the scripts below exist yet; roadmap tasks T3, T6 and T7 build them.
Until the first phone arrives (roadmap decision D1, task T7), layers L1–L4 run on Cuttlefish, a virtual phone ([Virtual phones](#virtual-phones)); layers L5 and L7 need the real phone.

How builds are signed and shipped is in [RELEASING.md](RELEASING.md).
Sources are listed at the [end of this file](#sources) and in [FEASIBILITY.md](FEASIBILITY.md#sources).
Technical words are explained in the [glossary](GLOSSARY.md).

## In short

- Every change, every night's build and every release goes through a series of tests, called layers, numbered L0 to L8.
- The early layers are quick and automatic: they check the files, build FoxieOS, and start it on a virtual phone.
- The later layers are slower: Google's compatibility tests, update tests, signature checks, a checklist on each real phone, and finally testers using it day to day.
- If any layer fails, the process stops until the problem is fixed.

## The order of the tests

```
Every change:
  L0 file checks → L1 build and L2 unit tests → review → merge

Every night:
  L1 full builds → L3 start-up and quick checks on the virtual phone
  → L4 compatibility tests, compared with the baseline

Every release candidate:
  build → sign offline → L6 signature checks → L5 update tests → L7 checklist on each phone
  → testing channel (48 hours or more) → beta (7 days or more) → stable
```

A failure at any layer stops everything after it.
Fix the problem with a new change rather than going back, and never skip a layer for a stable release.
A security emergency fix may shorten L8 to 24 hours on testing and 48 hours on beta, with a note in the release notes.

## Test layers

| Layer | Runs | On | Passes when |
|---|---|---|---|
| [L0 file checks](#l0-file-checks) | every commit | any computer | nothing is found |
| [L1 build](#l1-build) | every pull request; nightly | build host | the build succeeds |
| [L2 unit tests](#l2-unit-tests) | every pull request | build host | all tests pass |
| [L3 start-up and quick checks](#l3-start-up-and-quick-checks) | pull requests that change the system; nightly | Cuttlefish | it starts and the checks pass |
| [L4 compatibility](#l4-compatibility-tests) | nightly; every release candidate | Cuttlefish; phones | no failures beyond the baseline |
| [L5 updates](#l5-update-tests) | every release candidate | phone | every scenario passes |
| [L6 signatures](#l6-signature-checks) | every release candidate | signing host | only release keys |
| [L7 phone checklist](#l7-phone-checklist) | every release candidate | each phone | checklist complete |
| [L8 everyday use](#l8-everyday-use) | after L7 | testers | no serious new problems |

### L0: file checks

Quick checks of the files themselves, before anything is built.

- **When:** every commit, on your computer (a pre-commit hook) and, later, on GitHub.
- **What:**
  - `gitleaks`, which blocks keys and secrets;
  - `shellcheck` and `yamllint`, which check scripts and settings files;
  - `xmllint --noout`, which checks overlays and manifests;
  - `bpfmt -d`, which checks the formatting of build files (`Android.bp`) (unsourced);
  - a check that commit messages follow `scope: description`;
  - a check that every commit has a sign-off ([CONTRIBUTING.md](../CONTRIBUTING.md#sign-off)).
- **Passes when** nothing is found.
- **Time limit:** under 2 minutes.
- **Already in place:** the pre-commit hooks in `.pre-commit-config.yaml`, set up as [CONTRIBUTING.md](../CONTRIBUTING.md#keys-secrets-and-personal-details) describes.
  - `gitleaks` v8.30.1 scans the changes you are about to commit.
  - Two hooks block key files (the "Key material" patterns in `.gitignore`) and `*.local.md` notes by name, because scanning a file's contents can't recognise a binary key such as a `.pk8`.
  - A hook refuses a commit without a `Signed-off-by:` line, and the DCO workflow on GitHub checks that each pull request's commits have one that matches the author.
- **Planned:** the other checks above, and L0 on GitHub (task T6).
  The gitleaks hook only scans what you are committing, so on GitHub it will scan a pull request's commits with `gitleaks git --log-opts="<base>..<head>"` ([gitleaks README][gitleaks-readme]).

### L1: build

Building FoxieOS from the source code.

- **When:** every pull request (a quick rebuild of the virtual phone, reusing earlier results) and every night (fresh builds of the virtual phone and of every supported phone as `userdebug`; there are no phones until T7).
- **Where:** the build host, with 50–100 GB set aside for earlier build results (ccache).
- **Passes when** the build finishes without errors, and the build system (Soong or Kati) reports no new errors.
- **Time limit:** under 60 minutes for a quick rebuild; nightly builds take hours.

### L2: unit tests

Small automatic tests of individual parts.

- **When:** every pull request.
- **What:** the tests that each changed part lists for this purpose (the `atest` presubmit group in its `TEST_MAPPING` file); tests that run on the computer itself use `--host`.
- **Passes when** all tests pass, and every part FoxieOS owns lists its tests in a `TEST_MAPPING` file.
- **Time limit:** under 30 minutes.

### L3: start-up and quick checks

Starting FoxieOS and checking the basics.

- **When:** every pull request that changes the system, and every night.
- **Where:** Cuttlefish, which needs KVM; and on each real phone as part of L7.
- **What:** start the phone, then run the quick checks in `tests/smoke/run.sh` ([Quick checks](#quick-checks)).
- **Passes when** the phone reports that it has finished starting (`sys.boot_completed`) within 5 minutes, and every quick check passes.
- **Time limit:** under 15 minutes.

### L4: compatibility tests

Google's compatibility tests (CTS), which check that FoxieOS behaves like Android should.

- **When:** every night on Cuttlefish; on phones for every release candidate; a full run on a phone before each stable release.
- **Where:** Cuttlefish, on the build host or a second test computer; real phones.
- **What:** `cts-tradefed`, with Google's `cts-virtual-device-stable` test set on Cuttlefish, and the parts listed in `tests/cts/modules-device.txt` on phones.
- **Passes when** no test fails that didn't also fail on plain LineageOS for the same phone or virtual phone ([Compatibility tests](#compatibility-tests-cts)).
- **Time limit:** under 3 hours each night.

### L5: update tests

Installing updates the way users will.

- **When:** every release candidate.
- **Where:** the real phone; also Cuttlefish if roadmap check C11 shows that it works there.
- **What:** the [update scenarios](#update-tests): full and incremental updates, updating from two versions back, an interrupted install, and refusing an older version.
- **Passes when** every scenario passes and the user's data is intact.
- **Time limit:** about half a day.

### L6: signature checks

Checking that the release is signed correctly.

- **When:** every release candidate, after signing.
- **Where:** the signing host.
- **What:** the checks in [RELEASING.md](RELEASING.md#checking-a-signed-release).
- **Passes when** every file is signed with release keys, and nothing carries test keys.
- **Time limit:** under 30 minutes.

### L7: phone checklist

A person checks each phone by hand.

- **When:** every release candidate.
- **Where:** each supported phone.
- **What:** the checklist in `tests/qa/<codename>.md`, plus the quick checks on the phone (`-s <serial>`).
- **Passes when** every item is ticked, or has a known problem filed as an issue.
- **Time limit:** about 2 hours per phone.

### L8: everyday use

Testers use the release in daily life.

- **When:** after L7.
- **Who:** testers on the update channels: `testing` for at least 48 hours, then `beta` for at least 7 days, then `stable`.
- **Passes when** nobody reports a phone that keeps restarting, lost data, or new problems with calls or mobile data.

## Commands

These are the commands for downloading the code, building and starting the virtual phone.
Check the ⚠ ones the first time you use them, then remove the marker.

```bash
# Download the source code (task T2). Options from LineageOS's build page for lineage-24.0, checked 2026-11-20.
repo init -u https://github.com/LineageOS/android.git -b lineage-24.0 --git-lfs --no-clone-bundle
repo sync    # LineageOS's manifest already sets -c and -j4; the wiki asks for no extra options

# Build environment
source build/envsetup.sh
breakfast <codename>                # choose a phone to build for
brunch <codename>                   # build everything for that phone
mka target-files-package otatools   # the files the signing host needs

# Virtual phone (tasks T2–T6), from the same source code
lunch lineage_cf_phone_x86_64-userdebug
mka
launch_cvd --daemon                 # needs the Cuttlefish host tools (⚠ roadmap check C1)
adb devices                         # expect 127.0.0.1:6520
stop_cvd
```

Sources: [LineageOS build page for shiba][lineage-shiba-build], [LineageOS emulator page][lineage-emulator], [Cuttlefish: get started][cf-start].

## Virtual phones

A virtual phone runs on the build host and behaves like a phone, so most testing can happen before a real phone is chosen.
There are two kinds.

**Cuttlefish is the one for automatic tests** (decided 2026-11-20, "virtual first" in [DESIGN.md](DESIGN.md#virtual-phone-first)).
The goldfish emulator stays available for trying things by hand.
Both are built from the same LineageOS 24.0 source code; no separate copy of AOSP is needed.
Checked on 2026-11-20 in `vendor/lineage/build/target/product/AndroidProducts.mk` on lineage-24.0 ([AndroidProducts.mk][lineage-products]) and on the LineageOS wiki.

- **Emulator (goldfish):** `lineage_sdk_phone_x86_64-userdebug` is one of the build choices.
  The wiki builds it with `breakfast sdk_phone_x86_64 eng` (or `userdebug`) and then `mka`, and `mka emu_img_zip` packs it for Android Studio.
  LineageOS 24.0 is on the wiki's list of tested versions.
  Use the x86_64 version, so it runs at full speed with KVM.
  ([LineageOS emulator page][lineage-emulator])
- **Cuttlefish:** `lineage_cf_phone_x86_64-userdebug` is one of the build choices, as is `lineage_cf_phone_arm64`.
  It builds on AOSP's `aosp_cf.mk` plus LineageOS's generic settings, and uses Cuttlefish's ready-made kernel ([lineage_cf_phone_x86_64.mk][lineage-cf-mk]).
  LineageOS's manifest includes AOSP's `device/google/cuttlefish`.
  It is the virtual phone Google itself tests Android on, with its own compatibility test set, `cts-virtual-device-stable` ([Compatibility tests](#compatibility-tests-cts)).
  The computer needs KVM and Google's `cuttlefish-base` and `cuttlefish-user` Debian packages, or their Docker or Podman container images on other Linux systems ([Cuttlefish: get started][cf-start], [google/android-cuttlefish][cf-github]).
  ⚠ Whether update tests work on it is roadmap check C11; AOSP made it a Virtual A/B device (unsourced).
- **Neither is a "virtual Pixel":** Android Studio's Pixel profiles only set the screen size and frame around a generic system (unsourced).
  Hardware tests (relocking the bootloader, the mobile network, cameras, sensors, the battery) need the real phone from decision D1.
- **Virtual phones are safe to experiment on.**
  Cuttlefish phones on the build host can be started, wiped and reinstalled freely.
  Installing on a real phone is different: a mistake can make it unusable, so the maintainer does it or approves each step.
- **Running the emulator without a screen:** `emulator -no-window -no-audio -no-snapshot -gpu swiftshader_indirect` (unsourced).
  The emulator needs KVM and doesn't work under Wayland, so run it without a screen for automatic tests, or under X ([GrapheneOS build guide][graphene-build]).

## Quick checks

The quick checks: `tests/smoke/run.sh [-s SERIAL]` runs them against Cuttlefish, the emulator or a real phone, and prints the results in the TAP format.

| Check | Command (sketch) | Expected |
|---|---|---|
| Start-up finishes | `adb wait-for-device`, then keep asking `getprop sys.boot_completed` until a time limit | `1` within 300 s |
| Security rules on | `adb shell getenforce` | `Enforcing` (a LineageOS rule) |
| No root access | `adb shell 'command -v su'` | empty (a LineageOS rule) |
| FoxieOS version values | `getprop ro.foxie.version` and `ro.foxie.build.channel` | not empty, and matching the build |
| Security patch level | `getprop ro.build.version.security_patch` | the value in the release notes |
| Signed with the right keys | `getprop ro.build.tags` | `release-keys` on release candidates; `test-keys` only in automatic tests |
| Developer access | `getprop ro.debuggable` | matches the build variant (`0` on `user`) |
| Encryption | `getprop ro.crypto.state` and `ro.crypto.type` | `encrypted` and `file` (unsourced) |
| No crash loop | `adb logcat -b crash -d` after 5 minutes of doing nothing; compare the `system_server` process number | empty; same number |
| Installed apps | `adb shell pm list packages` against `tests/smoke/packages-{required,forbidden}.txt` | all required apps present, no forbidden ones |
| Update server address | `getprop lineage.updater.uri`, or the overlay value | the FoxieOS address for the channel |
| Privacy settings | `settings get <namespace> <key>` for each setting in `tests/smoke/settings.txt` | matches |
| Web browser present | `pm list packages` | the included browser is installed |

FoxieOS keeps a web browser because LineageOS requires one in its official builds ([LineageOS charter][lineage-charter]).

## Compatibility tests (CTS)

How FoxieOS uses Google's compatibility tests (CTS).

- **Getting CTS:** it can be downloaded publicly as `android-cts-17_rN-linux_x86-{arm,x86}.zip` from `dl.google.com`.
  Run it with `./android-cts/tools/cts-tradefed`, then `run cts --plan …` and `run retry --retry N` ([CTS downloads][cts-downloads]).
- **The computer that runs it** needs at least 32 GB of RAM and 256 GB of disk, JDK 11 or later, `adb`, `aapt2`, and FFmpeg 5.1.3 or later.
  Keep the unzipped folder's name unchanged ([CTS][cts]).
- **Comparing with a baseline.**
  LineageOS itself doesn't pass all of CTS (unsourced), and not all of CTS passes on Cuttlefish ([Cuttlefish: run CTS][cf-cts]).
  So FoxieOS compares its results with plain LineageOS:
  1. Run the same tests on plain lineage-24.0, built from the same snapshot of the source code, for the same phone or virtual phone.
  2. Save the failures to `tests/cts/baseline-<lineage-tag>-<target>.txt`: `cf_x86_64` in task T3, `<codename>` in task T7.
  3. FoxieOS passes if no test fails that isn't already in the baseline.
  4. Make new baselines whenever FoxieOS moves to a new LineageOS version.
- **Every night on Cuttlefish:** the `cts-virtual-device-stable` test set, the part of CTS that runs reliably on virtual phones.
  ⚠ Roadmap check C3 confirms that the CTS 17 download includes it; if not, build CTS from the source code as AOSP's Cuttlefish guide does.
  AOSP's example runs `cts-tradefed run cts-virtual-device-stable --no-enable-parameterized-modules --max-testcase-run-count 2 --retry-strategy RETRY_ANY_FAILURE --reboot-at-last-retry --shard-count 8` on 8 virtual phones: 184 test groups in about 22 minutes.
  Each virtual phone needs Wi-Fi switched on (`WifiUtil.apk`) ([Cuttlefish: run CTS][cf-cts]).
- **On phones,** for every release candidate: the test groups in `tests/cts/modules-device.txt`.
  ⚠ Confirm the names with `list modules` (roadmap check C3).
  The planned list: `CtsSecurityTestCases`, `CtsSecurityBulletinHostTestCases`, `CtsPermissionTestCases`, `CtsPermission3TestCases`, `CtsAppSecurityHostTestCases`, `CtsSelinuxTargetSdkCurrentTestCases`, `CtsOsTestCases`, `CtsNetTestCases`, `CtsKeystoreTestCases`, `CtsAppTestCases`.
- **Before every stable release:** a full CTS run on a real phone running a `user` build, which the security tests need.
  Prepare the phone as Google's CTS setup page describes: Wi-Fi with IPv6, SIM lock off, location on ([CTS][cts]).
- **CTS is not certification.**
  Passing it does **not** bring Google's approval or Play Integrity; never claim it does.
- **Optional tests:** VTS and CTS-on-GSI are useful only for the generic-image (GSI) track ([CTS][cts]).
- **More than one test computer** (planned, task T6).
  Cuttlefish and CTS can run on a second computer from copied images, so the build host can start the next build.
  To split one CTS run across computers, start the same test set on each with `--shard-count N --shard-index i`: every computer makes the same list of tests and runs its own share of it.
  Tradefed doesn't combine the results, so the nightly script does ([Tradefed sharding][tf-sharding], [sharded results][tf-sharded-runner]).
  A test computer needs KVM and enough RAM for its virtual phones; a virtual machine also needs nested virtualisation (roadmap check C5).

## Update tests

The update scenarios, kept in `tests/ota/`.
How the update packages are made is in [RELEASING.md](RELEASING.md#update-packages).

They run on the real phone, where the maintainer does or approves every install.
If roadmap check C11 passes, scenarios 1–4 run on Cuttlefish first.

In the scenarios, N is the new build, N-1 the one before it, and N-2 the one before that.

1. **Incremental update** from N-1 to N, through the Updater app on the `testing` channel.
   Afterwards the phone starts, it runs from the other system slot, the quick checks pass, and test data is still there: a contact, a file in `/sdcard`, an installed app with its data, and a saved Wi-Fi network.
2. **Full update** from N-2 to N, with the same checks.
3. **Interrupted install:** restart the phone during the download, then during the install.
   The phone stays on the old version, and trying again works.
   This relies on the A/B design, where the old version stays in place until the new one works; Virtual A/B is the current form of it ([A/B updates][aosp-ab]).
4. **Refusing an older version (anti-rollback):** offer build N-1 to a phone on N.
   The phone refuses it.
5. **Clean install** from the factory or recovery package, then the first update.

Keep the signed build files and update packages for N-1 and N-2 in the release storage.
Without them, you can't make incremental updates or run these tests.

## Sources

- AOSP: [Cuttlefish: get started][cf-start], [Cuttlefish: run CTS][cf-cts], [atest][atest], [CTS][cts], [CTS downloads][cts-downloads], [A/B updates][aosp-ab], [OTA tools][aosp-ota-tools], [Tradefed sharding][tf-sharding], [sharded results][tf-sharded-runner].
- LineageOS: [emulator page][lineage-emulator], [build page for shiba][lineage-shiba-build], [AndroidProducts.mk][lineage-products], [lineage_cf_phone_x86_64.mk][lineage-cf-mk], [device support requirements][lineage-charter].
- Google: [android-cuttlefish on GitHub][cf-github].
- GrapheneOS: [build guide][graphene-build] (emulator, CTS, channels).
- Tools: [gitleaks README][gitleaks-readme], with the [hooks it provides for pre-commit][gitleaks-hooks].

[aosp-ab]: https://source.android.com/docs/core/ota/ab
[aosp-ota-tools]: https://source.android.com/docs/core/ota/tools
[atest]: https://source.android.com/docs/core/tests/development/atest
[cf-cts]: https://source.android.com/docs/devices/cuttlefish/cts
[cf-github]: https://github.com/google/android-cuttlefish
[cf-start]: https://source.android.com/docs/devices/cuttlefish/get-started
[cts]: https://source.android.com/docs/compatibility/cts
[cts-downloads]: https://source.android.com/docs/compatibility/cts/downloads
[gitleaks-hooks]: https://github.com/gitleaks/gitleaks/blob/v8.30.1/.pre-commit-hooks.yaml
[gitleaks-readme]: https://github.com/gitleaks/gitleaks/blob/v8.30.1/README.md
[graphene-build]: https://grapheneos.org/build
[lineage-cf-mk]: https://github.com/LineageOS/android_vendor_lineage/blob/lineage-24.0/build/target/product/lineage_cf_phone_x86_64.mk
[lineage-charter]: https://github.com/LineageOS/charter/blob/main/device-support-requirements.md
[lineage-emulator]: https://wiki.lineageos.org/emulator
[lineage-products]: https://github.com/LineageOS/android_vendor_lineage/blob/lineage-24.0/build/target/product/AndroidProducts.mk
[lineage-shiba-build]: https://wiki.lineageos.org/devices/shiba/build/
[tf-sharded-runner]: https://source.android.com/docs/core/tests/tradefed/testing/through-tf/sharded-runner
[tf-sharding]: https://source.android.com/docs/core/tests/tradefed/architecture/advanced/sharding
