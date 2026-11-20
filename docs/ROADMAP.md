# FoxieOS roadmap

What is decided, what is still open, and the work in the order it should happen.
Background: [DESIGN.md](DESIGN.md) for the architecture, [FEASIBILITY.md](FEASIBILITY.md) for the research.

## Where things stand

- **Done:** task T0, the project skeleton (this repository and its docs), on 2026-11-20.
- **Next:** decision D2 (the build host), then task T1 (host readiness).
- **Virtual first** (decided 2026-11-20): tasks T2–T6 run on LineageOS's Cuttlefish virtual device, `lineage_cf_phone_x86_64`, so a phone (decision D1) is needed only from task T7.
  See [TESTING.md](TESTING.md#virtual-devices).

## How to read this file

- **Decisions (D1–D9)** are the maintainer's to make.
  Each one lists the options and a recommendation.
- **Tasks (T0–T13)** are the work, in order.
  Each one says what it needs, what to do, when it is done, and what to report.
- **Checks (C1–C13)** are claims to confirm before the task that depends on them.
  A ⚠ in the other docs usually points to one of them.
- Each task says who does it:
  - **Code:** a change to files, made in a pull request.
    Anyone can do it, including a coding agent.
  - **Hands-on:** runs on the build host or on a phone.
    The maintainer runs it, or approves each step.
  - **Maintainer only:** keys, accounts, purchases and publishing.

## Phases

1. **Setup:** the build host, a LineageOS 24.0 sync, and a stock build for Cuttlefish (T1–T3).
2. **Branding:** `vendor/foxie`, the boot animation, the About page and default apps (T4–T5).
3. **CI and tests:** presubmit checks, nightly Cuttlefish boot tests and the CTS baseline (T3, T6).
4. **Device #1:** bring-up and QA on a real phone (T7).
5. **Release infrastructure:** signing, OTA packages, the update server and channels, and the first alpha (T8–T10).
6. **Privacy features:** a small, useful set (T11).
7. **More devices, and later a GSI** (T12), with a rebase drill before each LineageOS major version (T13).

## Decisions

| ID | Question | Status | Needed by |
|---|---|---|---|
| [D1](#d1-device-1) | Which phone is device #1? | Open | T7 |
| [D2](#d2-build-host) | Which machine is the build host? | Open | T1 |
| [D3](#d3-code-and-ci-hosting) | Where are the code and CI hosted? | Decided: GitHub | T5, T6 |
| [D4](#d4-update-server-hosting) | Where is the update server hosted? | Open | T9 |
| [D5](#d5-microg) | Is microG shipped, optional, or absent? | Open | T11 |
| [D6](#d6-release-build-variant) | Are releases `userdebug` or `user` builds? | Open | T10 |
| [D7](#d7-signing-host) | Which machine is the signing host? | Open | T8 |
| [D8](#d8-security-contact) | What is the private security contact? | Open | T10 |
| [D9](#d9-devices-from-the-hardware-project) | Does FoxieOS support a device from the hardware project, and on what terms? | Open | T12 |

### D1: device #1

Open; needed by T7.

- **Recommendation:** a Pixel 8 or later.
  All of them run LineageOS 24.0, can be relocked with a custom verified-boot key, and get seven years of Google updates.
  Among them, the Pixel 9a (`tegu`) has two LineageOS maintainers and updates until about April 2032.
- **Options:** the candidates table in [DEVICES.md](DEVICES.md#candidates-for-device-1).

### D2: build host

Open; needed by T1.

The build host holds the source tree, runs the builds and, from T6, the CI runner.
It needs:

- x86-64 Linux with KVM, for Cuttlefish and the emulator;
- memory for Android 17's build-graph step, which runs as one process and has been reported above 55 GiB: 96 GB of RAM, or 32–64 GB plus zram sized at twice the RAM;
- about 400 GB of disk per source tree, so plan for a 1 TB NVMe drive;
- as many cores as possible: AOSP quotes about 40 minutes for a full build on 72 cores and about 6 hours on 6 cores, both with 64 GB of RAM.

Google's Cuttlefish packages are built for Debian; other distributions use its container images (C1).
The requirements and their sources are in [FEASIBILITY.md](FEASIBILITY.md#build-host).

| Option | Memory | Cost | Notes |
|---|---|---|---|
| Own hardware, 32 GB | 32 GB plus zram | Hardware only | Reported to work; the build-graph step is slower with zram |
| Own hardware, 64 GB or more | 64 GB plus zram, or 96 GB+ | RAM not priced | Less zram, or none at 96 GB |
| Rented: Hetzner EX63 | 64 GB plus zram | €149/month or €0.2388/hour, €21 setup | Core Ultra 7 265 (20 cores), 2 × 1 TB NVMe, Debian |
| Rented: Hetzner AX102 | 128 GB | €259/month or €0.415/hour, €129 setup | Ryzen 9 7950X3D (16 cores), 2 × 1.92 TB NVMe |

Hetzner prices exclude VAT and were checked on 2026-11-20.
A rented host needs an account, which the maintainer creates, and is never used as the signing host.

**Recommendation:** start with the smallest host that meets the requirements, with zram at twice the RAM and the tree on a disk with at least 400 GB free.
Task T2 measures the build-graph peak and the full build time (C2).
Then add RAM if the zram step is too slow, or move to more cores if full builds take too long.
Adding machines doesn't replace the RAM: only compiling and tests can be spread out ([FEASIBILITY.md](FEASIBILITY.md#spreading-the-work-over-several-machines)).
Extra machines fit better as Cuttlefish and CTS test hosts in T6.

### D3: code and CI hosting

**Decided 2026-11-20: GitHub.**

- The code lives in the [`alopex-org`](https://github.com/alopex-org) organization.
  This repository is `alopex-org/foxieos`, and every FoxieOS repository there starts with `foxieos`.
- CI is settled in T6.
  The recommendation is GitHub Actions on a self-hosted runner on the build host.
- No Gerrit until there are three or more contributors.
- Rejected: a self-hosted Gitea with Gitea Actions.

### D4: update server hosting

Open; needed by T9.

- **Recommendation:** a static HTTPS host on a domain the project controls.
  The LineageOS Updater accepts only HTTPS.

### D5: microG

Open; needed by T11.

- **Recommendation:** optional and off by default, once C13 confirms how LineageOS 24.0 handles signature spoofing.

### D6: release build variant

Open; needed by T10.

- `userdebug` is LineageOS's default; `user` is what CTS's security tests need.
- **Recommendation:** `userdebug` for alpha releases, and `user` before a release is advertised as stable.

### D7: signing host

Open; needed by T8.

- **Options:** an air-gapped machine, or the build host with keys decrypted only into memory (tmpfs).
- **Recommendation:** a separate machine.
  At a minimum, keys are decrypted into tmpfs and swap is off while signing.

### D8: security contact

Open; needed before the first public release (T10).

- **Recommendation:** a dedicated address or form for [SECURITY.md](../SECURITY.md), not a personal address.

### D9: devices from the hardware project

Open; needed before a device from the hardware project joins FoxieOS (T12).

[foxieos-hardware](https://github.com/alopex-org/foxieos-hardware) is a separate project that researches building a prototype device for enthusiasts; it sells nothing.
It doesn't follow FoxieOS's [selection criteria](DEVICES.md#selection-criteria).
A device from it would fail at least one of them: LineageOS wouldn't support it officially, at least at first.

- **Options:**
  - Treat it like any other device: it waits until LineageOS supports it, or joins the unofficial GSI track.
  - Make it a device FoxieOS maintains itself, with its own device tree, on these conditions:
    - a FoxieOS maintainer owns one;
    - its kernel is GKI 5.15 or newer, built from source;
    - firmware and security updates from the chip vendor and the device maker last at least until the FoxieOS end-of-life date announced for it;
    - it can be relocked with FoxieOS's own AVB key;
    - it meets the rest of the [device charter](DEVICES.md#device-charter).
  - Don't support it.
- **Whichever option is chosen:** FoxieOS signs its builds with its own keys and relocks the bootloader with its own AVB key (`avb_custom_key`).
  It never holds the device maker's secure-boot signing key, whose public-key hash is burned into the chip's fuses.
- **Recommendation:** the second option, decided once the hardware project has chosen a platform.
  Until then, nothing in FoxieOS changes for it.

## Tasks

Work in order unless the dependencies allow otherwise.

### T0: project skeleton

Done 2026-11-20: this repository, with its docs.

### T1: host readiness

**Code and hands-on.** Needs D2.

- Write `ci/check-host.sh`, which prints PASS or FAIL for each item:
  - Memory for the build-graph step: PASS at 96 GB of RAM or more; PASS with a warning when RAM plus zram or swap reaches 96 GB; FAIL below that.
    These thresholds are FoxieOS's own, taken from the reported setup of 32 GB plus zram at twice the RAM; Soong itself only warns.
    T2's measurement replaces them (C2).
  - At least 1 TB free on the source path.
  - `/dev/kvm` usable by the build user.
  - `repo`, `git-lfs`, `ccache`, and the Java and Python versions the build needs.
  - The Cuttlefish host tools: the `cuttlefish-base` package or a Docker or Podman image (C1).
- The maintainer runs the script on the build host.
- If memory is short, set zram to twice the RAM with zstd compression: `zram-size = ram * 2` and `compression-algorithm = zstd` in `/etc/systemd/zram-generator.conf`, the setting from the XDA report.
  Without `zram-size`, zram-generator creates only min(RAM ÷ 2, 4 GiB) ([zram-generator example][zram-example]).

**Done when** the script passes on the build host, or the maintainer accepts the gaps it lists.
**Report** the script's output.

### T2: sync and a stock virtual build

**Hands-on.** Needs T1.

- Sync in the background with `ci/sync.sh`, using the commands in [TESTING.md](TESTING.md#commands).
- Build stock LineageOS `lineage_cf_phone_x86_64-userdebug` and start it with `launch_cvd`.
- Log memory and swap use during the build, for example with `vmstat 5` written to the log.
- Run the build again with no changes, and see whether the build-graph step is skipped.

**Done when** the build exits 0, and Cuttlefish reaches `sys.boot_completed=1` and shows up in `adb devices`.
**Report** the build log, the boot time, peak memory and swap during the build-graph step, the full build time, and whether a rebuild with no changes skips the build-graph step (C2).

### T3: test harness and virtual baseline

**Code and hands-on.** Needs T2.

- Write `tests/smoke/run.sh`.
  It skips the FoxieOS-specific checks when the FoxieOS properties are absent, so it also runs on stock LineageOS.
- Download CTS 17 (C3).
- Run the `cts-virtual-device-stable` plan on stock LineageOS on Cuttlefish, and save the failures to `tests/cts/baseline-<lineage-tag>-cf_x86_64.txt`.

**Done when** the smoke suite passes on stock LineageOS (FoxieOS checks skipped) and the baseline is committed.
**Report** the smoke suite's TAP output and the CTS summary.

### T4: `vendor/foxie` and branding

**Code.** Needs T2.

- Write `vendor/foxie/config/common.mk`: properties, packages and overlays.
- Make the boot animation from `branding/foxieos-logo.png`, once the maintainer has confirmed the rights to the artwork.
- Add an About-page overlay and wallpapers.
- Add one carry patch to `vendor/lineage` that calls `inherit-product-if-exists vendor/foxie/config/common.mk` (C4), and record it in [PATCHES.md](PATCHES.md).

**Done when** the Cuttlefish build shows FoxieOS branding (a screenshot through its web view), the full smoke suite passes, and layer L4 shows no new failures.
**Report** the output of layers L0–L4.

### T5: manifest repository

**Code.** Needs T4 and D3.

- The maintainer creates `alopex-org/foxieos_android_manifest`.
- Add `local_manifests/foxie.xml`, which adds `vendor/foxie` and, later, any forked repositories.
- Pin the revisions for each release.

**Done when** a fresh sync into an empty directory reproduces the T4 build.
**Report** the sync and build logs.

### T6: CI

**Code and hands-on.** Needs T3–T5 and D3.

- Set up GitHub Actions with a self-hosted runner on the build host.
  - Self-hosted runners don't count against the plan's Actions minutes ([GitHub: self-hosted runners][gh-self-hosted]).
  - GitHub's standard hosted runners have far too little disk and memory for an Android build (unsourced).
  - GitHub advises against self-hosted runners for public repositories, because anyone can open a pull request whose workflow then runs on the runner ([GitHub: secure use][gh-hardening]).
    Keep pull requests from forks off the runner, for example by requiring approval for workflows from forks and limiting the runner group to FoxieOS repositories (unsourced).
- `ci/presubmit.sh` runs on pull requests: layers L0–L3, on Cuttlefish.
- `ci/nightly.sh` runs on a schedule: L1 builds, L3 and L4 on Cuttlefish; device builds join after T7.
- Keep logs and artifacts for 14 days, and send a notification on failure.
- Optionally, run Cuttlefish and CTS on a second host from copied images, so the build host can start the next build.
  With more than one test host, split CTS with Tradefed's sharding and merge the results in the script ([TESTING.md](TESTING.md#cts-strategy)).
  A test host needs KVM and enough RAM for its Cuttlefish instances; for a virtual machine, see C5.

**Done when** a deliberately broken pull request is blocked, and the nightly run passes twice in a row.
**Report** the CI run logs.

### T7: device #1 bring-up and QA

**Hands-on.** Needs T4, D1 with the phone at hand, and a go-ahead for each flash.

- Clear C6, C7 and C8 first.
- The maintainer unlocks the bootloader and installs stock LineageOS 24.0.
  This wipes the phone.
- Extract the vendor blobs.
- Build stock LineageOS for the device and record a device CTS baseline with `tests/cts/modules-device.txt`.
- Build FoxieOS for the device.
  The maintainer flashes it, or approves an agent doing so.
- Write `tests/qa/<codename>.md`, covering calls, SMS and MMS, mobile data and VoLTE, Wi-Fi, hotspot, Bluetooth audio, NFC, GPS, cameras, biometrics, sensors, audio, charging and overnight drain, encryption, recovery, and factory reset.
- Run the smoke suite on the device with `-s <serial>`.

**Done when** FoxieOS builds and boots on the device (and joins the nightly run once T6 exists), and the checklist is complete, with known issues filed.
**Report** the build log, the CTS baseline, the QA sheet and the smoke output.

### T8: signing workflow

**Code and maintainer only.** Needs T2 and D7.

- Write `release/sign.sh` and `release/verify.sh`.
- Write `docs/KEYS.md`, the procedure the maintainer follows: encrypted keys, RSA-4096 AVB and APEX keys, backups, and a rotation policy.
- Dry-run the whole flow with dev keys.

**Done when** a dev-signed build passes `verify.sh`, and the maintainer has reviewed `docs/KEYS.md`.
**Report** the output of `verify.sh`.

### T9: update server and Updater

**Code.** Needs T8 and D4.

- Clear C10 (the Updater's JSON schema) first.
- Write `release/publish-metadata.py`, which writes the JSON for each device and channel.
- Overlay `updater_server_url` (HTTPS, with `{device}`, `{type}` and `{incr}` placeholders) and add channel selection.

**Done when** Cuttlefish (if C11 passes) or the device finds a test update on a local HTTPS server and installs it.
**Report** OTA scenario 1 on a dev build.

### T10: release process and the first alpha

**Maintainer only, and hands-on.** Needs T6–T9, D6, D8, C12, and the maintainer's approval to publish.

- The maintainer signs release candidate 1 (RC1) offline.
- Run layers L5–L7.
- Publish to the `testing` channel only.
- Complete the release record.

**Done when** RC1 is on the testing channel and its release record is complete.
**Report** the output of every layer.

### T11: privacy features

**Code.** Needs T10 and D5.

- Write a short plan for each feature: a network permission toggle, a sensors toggle, the microG option, MAC randomisation defaults, and a minimal set of preinstalled apps.
- Give each feature tests in `TEST_MAPPING` and settings checks in the smoke suite.

**Done when** each feature passes layers L0–L4 and is documented.
**Report** the results for each feature.

### T12: more devices and a GSI track

**Code and hands-on.** Needs T10 on the stable channel.

- Apply the device charter in [DEVICES.md](DEVICES.md) to each new device.
- A device from the hardware project joins only once D9 is decided.
- Offer a GSI only as "unofficial".
  ⚠ First check the state of the community's Android 17 GSI patch sets.

**Done when** each new device passes the charter checklist.
**Report** the QA sheets.

### T13: rebase drill

**Code and hands-on.** Before each LineageOS major version.

- Rebase on the new LineageOS branch in a separate worktree.
- Run every test layer again.
- Refresh the CTS baselines.
- Review every carry patch again.

**Done when** the new branch passes layers L0–L7.
**Report** the output of every layer.

## Critical path

D2 → T1 → T2 → T3 → T4 → T5 and T8 in parallel → T6 → T7 and T9 → T10.

D1 only has to be settled, with the phone at hand, before T7.
If C11 passes, T9 can run on Cuttlefish before T7.

## Not planned

- **Spreading compiling over several machines** with Soong's remote execution ([FEASIBILITY.md](FEASIBILITY.md#spreading-the-work-over-several-machines)).
  Reconsider it only if T2 shows that compiling dominates the build time.
  Only the main host needs the build-graph RAM; workers just compile.
  lineage-24.0 builds with Siso, but its remote execution still defaults to reclient.
  A first build moves about 76 GB between the host and the workers, so they need a fast network between them.
- **Hardening beyond LineageOS** (Pixel only).
  Re-evaluate forking GrapheneOS against reimplementing selected features once FoxieOS is stable.
- **Designing or making hardware.**
  That is the work of the separate [foxieos-hardware](https://github.com/alopex-org/foxieos-hardware) project; D9 decides whether FoxieOS supports its devices.

## Checks

Each check is a short task.
Do it before the task that depends on it, then update the docs that carry the ⚠.

1. **C1, Cuttlefish host tools** (→ T1).
   Google's `cuttlefish-base` and `cuttlefish-user` packages (Debian) or its container images; the `kvm`, `cvdnetwork` and `render` groups; and how many instances the build host's RAM allows (AOSP's CTS example uses 8).
2. **C2, build-graph memory and build time** (→ T2).
   The peak memory of `soong_build` on lineage-24.0 (reported above 55 GiB on Android 17) and the full build time on the build host.
   Size zram or RAM from the measurement.
   Also check whether a rebuild with no `Android.bp` change skips that step (unsourced).
3. **C3, CTS 17** (→ T3).
   Whether the CTS 17 download includes the `cts-virtual-device-stable` plan (`list plans`); if not, build CTS from the tree as AOSP's Cuttlefish guide does.
   Also the module names for `tests/cts/modules-device.txt` (`list modules`).
4. **C4, the hook for `vendor/foxie`** (→ T4).
   Where to inherit `vendor/foxie` in `vendor/lineage/config/common.mk` on 24.0.
5. **C5, a virtual machine as test host** (→ T6, only if a test host is a VM).
   Nested virtualization must be enabled on the hypervisor, for example `nested=1` for the `kvm_intel` or `kvm_amd` module, with the host CPU model passed through (unsourced).
   Confirm that `launch_cvd` boots there and how many instances fit in the VM's RAM.
6. **C6, end-of-life date for device #1** (→ T7).
   Pixel 8 and later get seven years of updates from US Google Store availability, the Pixel 6 and 7 families five.
   Still to do: the exact date for the D1 phone, recorded in [DEVICES.md](DEVICES.md).
7. **C7, the Pixel kernel** (→ T7, Pixel only).
   How the kernel built from LineageOS's separate Kleaf workspace (`android_kernel_google_gs-6.1_manifest`, or `gs-6.6` for the Pixel 10, 10 Pro and 10 Pro XL) gets into `device/google/<family>-kernels/`, and whether a newer GKI tag than the pinned one exists.
8. **C8, blob extraction** (→ T7).
   LineageOS's wiki extracts blobs from a phone running LineageOS, with root over ADB.
   Check whether extracting from an image file works instead.
9. **C9, the signing APK list** (→ T8).
   The current `--extra_apks` and APEX list for 24.0 on `wiki.lineageos.org/signing_builds`.
   Copy it fresh for each release.
10. **C10, the Updater's JSON schema** (→ T9).
    The JSON schema of the LineageOS Updater and what its channel and `type` fields mean.
11. **C11, OTA tests on Cuttlefish** (→ T9).
    Whether Cuttlefish supports the Virtual A/B OTA tests through `update_engine`; if not, run them on the device only.
12. **C12, trademark search** (→ T10, maintainer only).
    Search the EUIPO and USPTO registers for "FoxieOS".
13. **C13, microG signature spoofing** (→ D5).
    Whether LineageOS 24.0 has built-in signature spoofing restricted to microG.

[zram-example]: https://github.com/systemd/zram-generator/blob/main/zram-generator.conf.example
[gh-self-hosted]: https://docs.github.com/en/actions/hosting-your-own-runners/managing-self-hosted-runners/about-self-hosted-runners
[gh-hardening]: https://docs.github.com/en/actions/security-for-github-actions/security-guides/security-hardening-for-github-actions
