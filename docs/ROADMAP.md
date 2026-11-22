# FoxieOS roadmap

This page lists what is decided, what is still open, and the work in the order it should happen.
Background: [DESIGN.md](DESIGN.md) for how FoxieOS fits together, [FEASIBILITY.md](FEASIBILITY.md) for the research.
Technical words are explained in the [glossary](GLOSSARY.md).

## Where things stand

- **Done:** task T0, setting up this repository and its docs, on 2026-11-20.
- **Next:** decision D2 (which computer builds FoxieOS), then task T1 (getting that computer ready).
- **Virtual phone first** (decided 2026-11-20): tasks T2–T6 run on Cuttlefish, a virtual phone (LineageOS's `lineage_cf_phone_x86_64`).
  A real phone (decision D1) is needed only from task T7.
  See [TESTING.md](TESTING.md#virtual-phones).
- **Proposals, not yet confirmed:** everything marked decided here was decided by the interim maintainer alone, before the founding meeting on 2026-11-24.
  The maintainers chosen there confirm or change it ([governance](https://github.com/alopex-org/.github/blob/main/GOVERNANCE.md#founding-maintainers)).

## How to read this page

- **Decisions (D1–D10)** are questions the maintainers answer.
  Each one lists the options and a recommendation.
- **Tasks (T0–T13)** are the pieces of work, in order.
  Each one says what it needs first, what to do, when it is finished, and what to share afterwards.
- **Checks (C1–C14)** are facts to confirm before the task that relies on them.
  A ⚠ in the other docs usually points to one of them.
- **On GitHub,** each decision, task and check also has an issue, and each phase below is a [milestone](https://github.com/alopex-org/foxieos/milestones).
  This page is the plan; the issues track progress and discussion ([CONTRIBUTING.md](../CONTRIBUTING.md#issues-and-labels)).
- **Who does each task:**
  - **Code:** a change to files, made in a pull request.
    Anyone can do it.
  - **Hands-on:** runs on the build computer or on a phone.
    The maintainer runs it, or approves each step.
  - **Maintainer only:** keys, accounts, purchases and publishing.

## Phases

1. **Setup:** the build computer, downloading LineageOS 24.0, and a first plain build for the virtual phone (T1–T3).
2. **Branding:** FoxieOS's own folder (`vendor/foxie`), the start-up animation, the About page and the default apps (T4–T5).
3. **Automatic checks and tests:** checks on every change, nightly tests on the virtual phone, and the compatibility baseline (T3, T6).
4. **The first phone:** getting FoxieOS running and tested on a real phone (T7).
5. **Releases:** signing, update packages, the update server and channels, and the first test release (alpha) (T8–T10).
6. **Privacy features:** a small, useful set (T11).
7. **More phones, and later a generic image (GSI)** (T12), with a practice run before each new LineageOS version (T13).

## Decisions

| ID | Question | Status | Needed by |
|---|---|---|---|
| [D1](#d1-device-1) | Which phone comes first? | Open | T7 |
| [D2](#d2-build-host) | Which computer builds FoxieOS? | Open | T1 |
| [D3](#d3-code-and-ci-hosting) | Where do the code and automatic checks live? | Decided: GitHub | T5, T6 |
| [D4](#d4-update-server-hosting) | Where is the update server hosted? | Open | T9 |
| [D5](#d5-microg) | Does FoxieOS include microG, offer it, or leave it out? | Open | T11 |
| [D6](#d6-release-build-variant) | Are releases `userdebug` or `user` builds? | Open | T10 |
| [D7](#d7-signing-host) | Which computer signs releases? | Open | T8 |
| [D8](#d8-security-contact) | How do people report security problems privately? | Open | T10 |
| [D9](#d9-devices-from-the-hardware-project) | Does FoxieOS support a device from the hardware project, and on what terms? | Open | T12 |
| [D10](#d10-base) | What is FoxieOS built on: LineageOS, plain AOSP, or something of its own? | Open | T2 |

### D1: device #1

Which phone FoxieOS supports first.
Open; needed by task T7.

- **Recommendation:** a Google Pixel 8 or later.
  All of them run LineageOS 24.0, can be locked again with FoxieOS's own key, and get seven years of updates from Google.
  Among them, the Pixel 9a (`tegu`) has two LineageOS volunteers looking after it and gets updates until about April 2032.
- **Options:** the table of candidates in [DEVICES.md](DEVICES.md#candidates-for-the-first-phone).

### D2: build host

Which computer builds FoxieOS.
Open; needed by task T1.

The build host holds the source code, runs the builds and, from task T6, the automatic checks.
It needs:

- Linux on a normal PC processor (x86-64), with KVM to run virtual phones;
- a lot of memory for one step of Android 17's build, which runs as a single program and has been reported to use more than 55 GiB: either 96 GB of RAM, or 32–64 GB plus zram (compressed memory) twice the size of the RAM;
- about 400 GB of disk for each copy of the source code, so plan for a 1 TB NVMe drive;
- as many processor cores as possible: AOSP quotes about 40 minutes for a full build on 72 cores and about 6 hours on 6 cores, both with 64 GB of RAM.

Google's Cuttlefish packages are made for Debian Linux; other Linux systems use its container images (check C1).
The requirements and their sources are in [FEASIBILITY.md](FEASIBILITY.md#build-host).

| Option | Memory | Cost | Notes |
|---|---|---|---|
| Own computer, 32 GB | 32 GB plus zram | Hardware only | Reported to work; the big build step is slower with zram |
| Own computer, 64 GB or more | 64 GB plus zram, or 96 GB+ | RAM not priced | Less zram, or none at 96 GB |
| Rented: Hetzner EX63 | 64 GB plus zram | €149/month or €0.2388/hour, €21 setup | Core Ultra 7 265 (20 cores), 2 × 1 TB NVMe, Debian |
| Rented: Hetzner AX102 | 128 GB | €259/month or €0.415/hour, €129 setup | Ryzen 9 7950X3D (16 cores), 2 × 1.92 TB NVMe |

Hetzner prices exclude VAT and were checked on 2026-11-20.
A rented computer needs an account, which the maintainer creates, and is never used to sign releases.

**Recommendation:** start with the smallest computer that meets the requirements, with zram twice the size of the RAM and at least 400 GB of free disk for the source code.
Task T2 measures the memory peak and the full build time (check C2).
Then add RAM if the step with zram is too slow, or move to more cores if full builds take too long.
Adding computers doesn't replace the RAM: only compiling and testing can be spread out ([FEASIBILITY.md](FEASIBILITY.md#spreading-the-work-over-several-machines)).
Extra computers fit better as test computers for the virtual phones and compatibility tests in task T6.

### D3: code and CI hosting

Where the code and the automatic checks live.
**Decided 2026-11-20: GitHub.**

- The code lives in the [`alopex-org`](https://github.com/alopex-org) organization.
  This repository is `alopex-org/foxieos`, and every FoxieOS repository there starts with `foxieos`.
- The repositories are public.
  On GitHub's free plan, public repositories get protected branches (rulesets), code owners, secret scanning and private vulnerability reporting.
  A ruleset protects `main` ([CONTRIBUTING.md](../CONTRIBUTING.md#review)).
- How the automatic checks run is settled in task T6.
  The recommendation is GitHub Actions, running on the build host (a self-hosted runner).
- No Gerrit (another review tool) until there are three or more contributors.
- Turned down: running our own code server (Gitea with Gitea Actions).

### D4: update server hosting

Where the update server, which phones download updates from, is hosted.
Open; needed by task T9.

- **Recommendation:** a simple secure (HTTPS) website on a domain the project controls.
  The LineageOS Updater only accepts HTTPS.

### D5: microG

Whether FoxieOS includes microG, a free replacement for some Google services.
Open; needed by task T11.

- **Recommendation:** offer it, switched off by default, once check C13 confirms how LineageOS 24.0 lets microG stand in for Google's services (signature spoofing).

### D6: release build variant

Whether releases are `userdebug` builds, which keep some developer tools, or `user` builds, like normal phones.
Open; needed by task T10.

- `userdebug` is LineageOS's default; `user` is what Google's security tests need.
- **Recommendation:** `userdebug` for early test releases (alpha), and `user` before a release is called stable.

### D7: signing host

Which computer signs releases.
Open; needed by task T8.

- **Options:** a computer that is never connected to a network, or the build host with the keys unlocked only in memory (tmpfs).
- **Recommendation:** a separate computer.
  At the very least, the keys are unlocked only in memory, with swap switched off, while signing.

### D8: security contact

How people report security problems privately.
Open; needed before the first public release (task T10).

- Until D8 is decided, [SECURITY.md](../SECURITY.md) uses GitHub's private vulnerability reporting.
- **Recommendation:** keep private vulnerability reporting, and add a dedicated email address, not a personal one, for people without a GitHub account.

### D9: devices from the hardware project

Whether FoxieOS supports a device from the separate hardware project, and on what terms.
Open; needed before such a device joins FoxieOS (task T12).

[alopex](https://github.com/alopex-org/alopex) is a separate project that researches building a device.
Whether that stays a prototype or becomes a product is its own decision D5.
FoxieOS depends on it for a device of its own, and only in that direction: FoxieOS adapts to the hardware project's choices, or doesn't support the device.
The hardware project doesn't follow FoxieOS's [rules for choosing a phone](DEVICES.md#rules-for-choosing-a-phone), and a device from it would break at least one of them: LineageOS wouldn't support it officially, at least at first.
The conditions below are FoxieOS's own terms, not requirements on the hardware project.

- **Options:**
  - Treat it like any other phone: it waits until LineageOS supports it, or joins the unofficial generic-image (GSI) track.
  - Make it a device FoxieOS looks after itself, with its own device tree, on these conditions:
    - a FoxieOS maintainer owns one;
    - its kernel is GKI 5.15 or newer, built from source;
    - firmware and security updates from the chip maker and the device maker last at least until the end-of-life date FoxieOS announces for it;
    - its bootloader can be locked again with FoxieOS's own verified-boot (AVB) key;
    - it meets the rest of [what every supported phone must meet](DEVICES.md#what-every-supported-phone-must-meet).
  - Don't support it.
- **Whichever option is chosen:** FoxieOS signs its builds with its own keys and locks the bootloader with its own AVB key (`avb_custom_key`).
  It never holds the device maker's secure-boot signing key, the one whose fingerprint is burned permanently into the chip.
- **Recommendation:** the second option, decided once the hardware project has chosen its platform.
  Until then, nothing in FoxieOS changes for it.

### D10: base

What FoxieOS is built on.
Open; the maintainers decide it after the founding meeting on 2026-11-24, and it is needed before the source code is downloaded (task T2).

The answer depends on what the meeting decides about hardware.
If FoxieOS runs on phones other companies make, it needs a base that already supports them; if it waits for a device from the [hardware project](https://github.com/alopex-org/foxieos-hardware), that device's chip and software package (BSP) set what is possible.
The docs describe a LineageOS base throughout, because that is the current proposal ([DESIGN.md](DESIGN.md#base-lineageos-240-android-17)).

- **Options:**
  - **LineageOS:** FoxieOS stays close to LineageOS and takes its support for phones and its security fixes.
    The least work for a small team, but only for phones LineageOS supports.
  - **Plain AOSP:** FoxieOS builds on Google's own Android code, which has no support for real phones, so the team adds the support for each device itself ([FEASIBILITY.md](FEASIBILITY.md#plain-aosp)).
  - **Something of its own:** a base built around one device, such as one from the hardware project, starting from that device's software package.
- **If the base isn't LineageOS:** the LineageOS-specific docs ([TESTING.md](TESTING.md), [RELEASING.md](RELEASING.md), [DEVICES.md](DEVICES.md)) and tasks T1–T13 are rewritten before task T2.
- **Recommendation:** LineageOS, unless the meeting chooses a device of the project's own as the first target.

## Tasks

Work in this order, unless a task's needs allow another.

### T0: project skeleton

Done 2026-11-20: this repository, with its docs.

### T1: host readiness

Getting the build computer ready.
**Code and hands-on.** Needs decision D2.

- Write `ci/check-host.sh`, which prints PASS or FAIL for each item:
  - Memory for the big build step: PASS at 96 GB of RAM or more; PASS with a warning when RAM plus zram or swap reaches 96 GB; FAIL below that.
    These limits are FoxieOS's own, based on the reported setup of 32 GB plus zram twice the size of the RAM; the build system itself only warns.
    Task T2's measurement replaces them (check C2).
  - At least 1 TB free where the source code goes.
  - KVM (`/dev/kvm`) usable by the account that builds.
  - The tools `repo`, `git-lfs` and `ccache`, and the Java and Python versions the build needs.
  - The Cuttlefish tools: the `cuttlefish-base` package, or a Docker or Podman image (check C1).
- The maintainer runs the script on the build host.
- If memory is short, set zram to twice the RAM with zstd compression: `zram-size = ram * 2` and `compression-algorithm = zstd` in `/etc/systemd/zram-generator.conf`, the setting from the XDA report.
  Without `zram-size`, zram-generator makes only the smaller of RAM ÷ 2 and 4 GiB ([zram-generator example][zram-example]).

**Finished when** the script passes on the build host, or the maintainer accepts the gaps it lists.
**Share** the script's output.

### T2: sync and a stock virtual build

Downloading LineageOS and building it, unchanged, for the virtual phone.
**Hands-on.** Needs task T1.

- Download the source code in the background with `ci/sync.sh`, using the commands in [TESTING.md](TESTING.md#commands).
- Build plain LineageOS for the virtual phone (`lineage_cf_phone_x86_64-userdebug`) and start it with `launch_cvd`.
- Record memory and swap use during the build, for example with `vmstat 5` written to the log.
- Build again with no changes, and see whether the big memory step is skipped.

**Finished when** the build succeeds, and the virtual phone finishes starting (`sys.boot_completed=1`) and shows up in `adb devices`.
**Share** the build log, the start-up time, the peak memory and swap during the big build step, the full build time, and whether a rebuild with no changes skips that step (check C2).

### T3: test harness and virtual baseline

Writing the quick checks and recording which compatibility tests already fail on plain LineageOS.
**Code and hands-on.** Needs task T2.

- Write `tests/smoke/run.sh`.
  It skips the FoxieOS-specific checks when the FoxieOS version values are missing, so it also runs on plain LineageOS.
- Download Google's compatibility tests, CTS 17 (check C3).
- Run the `cts-virtual-device-stable` test set on plain LineageOS on the virtual phone, and save the failures to `tests/cts/baseline-<lineage-tag>-cf_x86_64.txt`.

**Finished when** the quick checks pass on plain LineageOS (with the FoxieOS checks skipped) and the baseline is committed.
**Share** the quick checks' output (TAP) and the CTS summary.

### T4: `vendor/foxie` and branding

Adding FoxieOS's own folder, name and look.
**Code.** Needs task T2.

- Write `vendor/foxie/config/common.mk`: FoxieOS's built-in values, apps and overlays.
- Make the start-up animation from `branding/foxieos-logo.png`, once the maintainer has confirmed the rights to the artwork.
- Add an About-page overlay and wallpapers.
- Add one carry patch to `vendor/lineage` that brings in FoxieOS's folder (`inherit-product-if-exists vendor/foxie/config/common.mk`, check C4), and record it in [PATCHES.md](PATCHES.md).

**Finished when** the virtual phone shows FoxieOS branding (a screenshot through its web view), all the quick checks pass, and test layer L4 shows no new failures.
**Share** the output of test layers L0–L4.

### T5: manifest repository

Creating the list of FoxieOS's own code that is added to LineageOS's.
**Code.** Needs task T4 and decision D3.

- The maintainer creates the repository `alopex-org/foxieos_android_manifest`.
- Add `local_manifests/foxie.xml`, which adds `vendor/foxie` and, later, any copied upstream repositories.
- Fix the exact versions for each release.

**Finished when** downloading into an empty folder gives the same build as task T4.
**Share** the download and build logs.

### T6: CI

Setting up automatic checks on every change and every night.
**Code and hands-on.** Needs tasks T3–T5 and decision D3.

- Set up GitHub Actions to run on the build host (a self-hosted runner).
  - Running on our own computer doesn't use up the free plan's Actions minutes ([GitHub: self-hosted runners][gh-self-hosted]).
  - GitHub's own computers for Actions have far too little disk and memory for an Android build (unsourced).
  - GitHub advises against running public repositories' checks on your own computer, because anyone can open a pull request whose checks then run there ([GitHub: secure use][gh-hardening]).
    Keep pull requests from forks off the build host: allow the runner only for FoxieOS repositories (unsourced).
    The organization already requires approval before checks from outside contributors run.
- `ci/presubmit.sh` runs on pull requests: test layers L0–L3, on the virtual phone.
- `ci/nightly.sh` runs every night: L1 builds, and L3 and L4 on the virtual phone; builds for real phones join after task T7.
- Keep logs and results for 14 days, and send a notification when something fails.
- Optionally, run the virtual phones and compatibility tests on a second computer from copied images, so the build host can start the next build.
  With more than one test computer, split the compatibility tests between them (Tradefed's sharding) and combine the results in the script ([TESTING.md](TESTING.md#compatibility-tests-cts)).
  A test computer needs KVM and enough RAM for its virtual phones; for a virtual machine, see check C5.

**Finished when** a deliberately broken pull request is blocked, and the nightly run passes twice in a row.
**Share** the logs of the automatic runs.

### T7: device #1 bring-up and QA

Getting FoxieOS running and tested on the first real phone.
**Hands-on.** Needs task T4, decision D1 with the phone at hand, and the maintainer's go-ahead for each install on the phone.

- Clear checks C6, C7 and C8 first.
- The maintainer unlocks the bootloader and installs plain LineageOS 24.0.
  This wipes the phone.
- Copy the maker's files from the phone (the vendor blobs).
- Build plain LineageOS for the phone, and record its compatibility baseline with `tests/cts/modules-device.txt`.
- Build FoxieOS for the phone.
  The maintainer installs it, or approves each install.
- Write `tests/qa/<codename>.md`, the phone checklist, covering calls, SMS and MMS, mobile data and VoLTE, Wi-Fi, hotspot, Bluetooth audio, NFC, GPS, cameras, fingerprint and face unlock, sensors, audio, charging and overnight battery drain, encryption, recovery mode, and factory reset.
- Run the quick checks on the phone with `-s <serial>`.

**Finished when** FoxieOS builds and starts on the phone (and joins the nightly run once task T6 exists), and the checklist is complete, with known problems filed as issues.
**Share** the build log, the compatibility baseline, the checklist and the quick checks' output.

### T8: signing workflow

Writing the signing scripts and the procedure for the keys.
**Code and maintainer only.** Needs task T2 and decision D7.

- Write `release/sign.sh` and `release/verify.sh`.
- Write `docs/KEYS.md`, the procedure the maintainer follows: encrypted keys, RSA-4096 verified-boot (AVB) and APEX keys, backups, and when to change keys.
- Practise the whole process with dev keys.

**Finished when** a build signed with dev keys passes `verify.sh`, and the maintainer has reviewed `docs/KEYS.md`.
**Share** the output of `verify.sh`.

### T9: update server and Updater

Making phones find and install FoxieOS updates.
**Code.** Needs task T8 and decision D4.

- Clear check C10 (the format of the Updater's server answers) first.
- Write `release/publish-metadata.py`, which writes the update descriptions (JSON) for each phone and channel.
- Point the Updater at the server with an overlay of `updater_server_url` (HTTPS, with `{device}`, `{type}` and `{incr}` placeholders) and add a way to choose the channel.

**Finished when** the virtual phone (if check C11 passes) or the real phone finds a test update on a local HTTPS server and installs it.
**Share** the result of update scenario 1 on a dev build.

### T10: release process and the first alpha

The first test release.
**Maintainer only, and hands-on.** Needs tasks T6–T9, decisions D6 and D8, check C12, and the maintainer's approval to publish.

- The maintainer signs release candidate 1 (RC1) offline.
- Run test layers L5–L7.
- Publish to the `testing` channel only.
- Complete the release record.

**Finished when** RC1 is on the testing channel and its release record is complete.
**Share** the output of every test layer.

### T11: privacy features

**Code.** Needs task T10 and decision D5.

- Write a short plan for each feature: a switch for an app's network access, a switch for sensors, the microG option, random Wi-Fi addresses (MAC randomisation) by default, and a small set of preinstalled apps.
- Give each feature automatic tests (in `TEST_MAPPING`) and settings checks in the quick checks.

**Finished when** each feature passes test layers L0–L4 and is documented.
**Share** the results for each feature.

### T12: more devices and a GSI track

More phones, and later a generic image for many phones.
**Code and hands-on.** Needs task T10 on the stable channel.

- Check each new phone against [DEVICES.md](DEVICES.md).
- A device from the hardware project joins only once decision D9 is taken.
- Offer a generic image (GSI) only as "unofficial".
  ⚠ First check how far the community's Android 17 GSI work has got.

**Finished when** each new phone meets every requirement on its checklist.
**Share** the phone checklists.

### T13: rebase drill

A practice run before each new LineageOS major version.
**Code and hands-on.** Before each LineageOS major version.

- Move FoxieOS onto the new LineageOS version in a separate copy (worktree).
- Run every test layer again.
- Make new compatibility baselines.
- Review every carry patch again.

**Finished when** the new version passes test layers L0–L7.
**Share** the output of every test layer.

## Order of the critical work

The longest chain of work, where each step waits for the one before:

D2 → T1 → T2 → T3 → T4 → T5 and T8 at the same time → T6 → T7 and T9 → T10.

Decision D1 only has to be taken, with the phone at hand, before task T7.
If check C11 passes, task T9 can run on the virtual phone before T7.

## Not planned

- **Spreading compiling over several computers** with the build system's remote execution ([FEASIBILITY.md](FEASIBILITY.md#spreading-the-work-over-several-machines)).
  Reconsider it only if task T2 shows that compiling takes most of the build time.
  Only the main computer needs the big memory; the others just compile.
  lineage-24.0 builds with Siso, but its remote execution still uses reclient by default.
  A first build moves about 76 GB between the computers, so they need a fast network between them.
- **Security changes beyond LineageOS's** (Pixel only).
  Once FoxieOS is stable, weigh copying GrapheneOS against rebuilding selected features.
- **Designing or making hardware.**
  That is the work of the separate [alopex](https://github.com/alopex-org/alopex) project, which FoxieOS depends on for a device of its own; decision D9 settles whether and on what terms FoxieOS supports its devices.

## Checks

Each check is a short task to confirm a fact.
Do it before the task that relies on it (shown by →), then update the docs that carry the ⚠.

1. **C1, Cuttlefish tools** (→ T1).
   Google's `cuttlefish-base` and `cuttlefish-user` packages (Debian) or its container images; the `kvm`, `cvdnetwork` and `render` user groups; and how many virtual phones the build host's RAM allows (AOSP's compatibility-test example uses 8).
2. **C2, memory and build time** (→ T2).
   The peak memory of the big build step (`soong_build`) on lineage-24.0, reported above 55 GiB on Android 17, and the full build time on the build host.
   Size zram or RAM from the measurement.
   Also check whether a rebuild with no change to the build files (`Android.bp`) skips that step (unsourced).
3. **C3, CTS 17** (→ T3).
   Whether the CTS 17 download includes the `cts-virtual-device-stable` test set (`list plans`); if not, build CTS from the source code as AOSP's Cuttlefish guide does.
   Also the names of the test groups for `tests/cts/modules-device.txt` (`list modules`).
4. **C4, where to add `vendor/foxie`** (→ T4).
   Where in `vendor/lineage/config/common.mk` on 24.0 to bring in FoxieOS's folder.
5. **C5, a virtual machine as test computer** (→ T6, only if a test computer is a virtual machine).
   Nested virtualisation must be switched on, for example `nested=1` for the `kvm_intel` or `kvm_amd` module, with the real processor model passed through (unsourced).
   Confirm that `launch_cvd` starts there and how many virtual phones fit in the virtual machine's RAM.
6. **C6, end-of-life date for the first phone** (→ T7).
   Pixel 8 and later get seven years of updates from when they went on sale in Google's US store, the Pixel 6 and 7 families five.
   Still to do: the exact date for the phone chosen in D1, recorded in [DEVICES.md](DEVICES.md).
7. **C7, the Pixel kernel** (→ T7, Pixel only).
   How the kernel built in LineageOS's separate Kleaf workspace (`android_kernel_google_gs-6.1_manifest`, or `gs-6.6` for the Pixel 10, 10 Pro and 10 Pro XL) gets into `device/google/<family>-kernels/`, and whether a newer GKI version than the one it uses exists.
8. **C8, copying the maker's files** (→ T7).
   LineageOS's wiki copies the vendor blobs from a phone running LineageOS, with root access over adb.
   Check whether copying them from an image file works instead.
9. **C9, the list of apps to sign** (→ T8).
   The current `--extra_apks` and APEX list for 24.0 on `wiki.lineageos.org/signing_builds`.
   Copy it fresh for each release.
10. **C10, the Updater's answer format** (→ T9).
    The JSON format the LineageOS Updater expects from the server, and what its channel and `type` fields mean.
11. **C11, update tests on the virtual phone** (→ T9).
    Whether Cuttlefish supports the Virtual A/B update tests through `update_engine`; if not, run them on the real phone only.
12. **C12, trademark search** (→ T10, maintainer only).
    Search the EU (EUIPO) and US (USPTO) trademark registers for "FoxieOS".
13. **C13, microG signature spoofing** (→ D5).
    Whether LineageOS 24.0 has a built-in way for microG, and only microG, to stand in for Google's services.
14. **C14, legal advice before any sale** (→ before FoxieOS, or a phone with it, is sold; maintainers only).
    Whether selling FoxieOS, or another maker's phone with FoxieOS installed, makes the seller a manufacturer under the EU's Cyber Resilience Act, radio-equipment rules and ecodesign rules, and what that requires ([FEASIBILITY.md](FEASIBILITY.md#obligations-once-money-is-involved)).

[zram-example]: https://github.com/systemd/zram-generator/blob/main/zram-generator.conf.example
[gh-self-hosted]: https://docs.github.com/en/actions/hosting-your-own-runners/managing-self-hosted-runners/about-self-hosted-runners
[gh-hardening]: https://docs.github.com/en/actions/security-for-github-actions/security-guides/security-hardening-for-github-actions
