# FoxieOS roadmap

This page lists what is decided, what is still open, and the work in the order it should happen.
Background: [DESIGN.md](DESIGN.md) for how FoxieOS fits together, [FEASIBILITY.md](FEASIBILITY.md) for the research.
Technical words are explained in the [glossary](GLOSSARY.md).

## Where things stand

- **Done:** task T0, setting up this repository and its docs, on 2026-11-20.
- **Proposed 2026-11-23:** FoxieOS becomes a Linux system for the Alopex cyber-deck, instead of a version of Android built on LineageOS for phones ([DESIGN.md](DESIGN.md#an-operating-system-for-a-cyber-deck)).
  The decisions, tasks and checks below follow from that proposal.
  Decisions D1, D5 and D6 applied only to Android, and are withdrawn; the tasks and checks are numbered afresh, and the maintainer closes the GitHub issues of the old ones.
- **Founding meeting, 2026-11-24:** the members choose the maintainers, who confirm or change the direction above and everything else marked decided here, which the interim maintainer decided alone ([governance](https://github.com/alopex-org/.github/blob/main/GOVERNANCE.md#founding-maintainers)).
- **Next:** decision D10 (the Linux base) and decision D11 (the development board), then task T1 (getting the build computer ready).

## How to read this page

- **Decisions (D2–D12)** are questions the maintainers answer.
  Each one lists the options and a recommendation.
- **Tasks (T0–T13)** are the pieces of work, in order.
  Each one says what it needs first, what to do, when it is finished, and what to share afterwards.
- **Checks (C1–C8)** are facts to confirm before the task that relies on them.
  A ⚠ in the other docs usually points to one of them.
- **On GitHub,** each decision, task and check also has an issue, and each phase below is a [milestone](https://github.com/alopex-org/foxieos/milestones).
  This page is the plan; the issues track progress and discussion ([CONTRIBUTING.md](../CONTRIBUTING.md#issues-and-labels)).
- **Who does each task:**
  - **Code:** a change to files, made in a pull request.
    Anyone can do it.
  - **Hands-on:** runs on the build computer, a board or the cyber-deck.
    The maintainer runs it, or approves each step.
  - **Maintainer only:** keys, accounts, purchases and publishing.

## Phases

1. **Setup:** the build computer, and a first plain image that starts on a virtual machine and on a Raspberry Pi board (T1–T3).
2. **FoxieOS's own parts:** branding, the LoRa mesh service and the interface (T4, T5, T9).
3. **Automatic checks and tests:** checks on every change and nightly tests on the virtual machine (T3, T6).
4. **Updates and security:** signing, A/B updates, encryption and secure boot on a test board (T7, T8, T10).
5. **The cyber-deck:** FoxieOS on the Alopex prototype, with its knobs, gauges, batteries and switches (T11).
6. **Releases:** the first test release (alpha) (T12), then privacy features (T13).

## Decisions

| ID | Question | Status | Needed by |
|---|---|---|---|
| D1 | Which phone comes first? | Withdrawn: Android only | — |
| [D2](#d2-build-host) | Which computer builds FoxieOS? | Open | T1 |
| [D3](#d3-code-and-ci-hosting) | Where do the code and automatic checks live? | Decided: GitHub | T6 |
| [D4](#d4-update-server-hosting) | Where is the update server hosted? | Open | T8 |
| D5 | Does FoxieOS include microG? | Withdrawn: Android only | — |
| D6 | Are releases `userdebug` or `user` builds? | Withdrawn: Android only | — |
| [D7](#d7-signing-host) | Which computer signs releases? | Open | T7 |
| [D8](#d8-security-contact) | How do people report security problems privately? | Open | T12 |
| [D9](#d9-devices-from-the-hardware-project) | On what terms does FoxieOS support a device from the hardware project? | Open | T10, T11 |
| [D10](#d10-base) | Which Linux system is FoxieOS built on? | Open | T1, T2 |
| [D11](#d11-user-interface) | What interface does FoxieOS have? | Open | T9 |
| [D12](#d12-development-board) | Which board does FoxieOS develop on until the cyber-deck exists? | Open | T2 |

### D2: build host

Which computer builds FoxieOS.
Open; needed by task T1.

The build host builds the system image and, from task T6, runs the automatic checks.
It needs:

- Linux, with KVM to run virtual machines;
- enough disk for the base system's packages or sources and the build output; task T1 measures it once decision D10 is taken;
- either a normal PC (x86-64) that cross-compiles for 64-bit Arm, or a 64-bit Arm computer that builds natively (unsourced).

**Recommendation:** start with a computer the project already has access to, and measure the build in task T2 before buying or renting anything.
A rented computer needs an account, which the maintainer creates, and is never used to sign releases.

### D3: code and CI hosting

Where the code and the automatic checks live.
**Decided 2026-11-20: GitHub.**

- The code lives in the [`alopex-org`](https://github.com/alopex-org) organization.
  This repository is `alopex-org/foxieos`, and FoxieOS's other repositories there start with `foxieos` too.
- The repositories are public.
  On GitHub's free plan, public repositories get protected branches (rulesets), code owners, secret scanning and private vulnerability reporting.
  A ruleset protects `main` ([CONTRIBUTING.md](../CONTRIBUTING.md#review)).
- How the automatic checks run is settled in task T6.
- No Gerrit (another review tool) until there are three or more contributors.
- Turned down: running our own code server (Gitea with Gitea Actions).

### D4: update server hosting

Where the update server, which devices download updates from, is hosted.
Open; needed by task T8.

- **Recommendation:** a simple secure (HTTPS) website on a domain the project controls.

### D7: signing host

Which computer signs releases.
Open; needed by task T7.

- **Options:** a computer that is never connected to a network, or the build host with the keys unlocked only in memory (tmpfs).
- **Recommendation:** a separate computer.
  At the very least, the keys are unlocked only in memory, with swap switched off, while signing.

### D8: security contact

How people report security problems privately.
Open; needed before the first public release (task T12).

- Until D8 is decided, [SECURITY.md](../SECURITY.md) uses GitHub's private vulnerability reporting.
- **Recommendation:** keep private vulnerability reporting, and add a dedicated email address, not a personal one, for people without a GitHub account.

### D9: devices from the hardware project

On what terms FoxieOS supports a device from the hardware project.
Open; needed before secure boot is set up on any board (task T10) and before the cyber-deck joins (task T11).

[Alopex](https://github.com/alopex-org/alopex) designs the cyber-deck, the device FoxieOS is now proposed for.
Whether it stays a prototype or becomes a product is its own decision D5.
FoxieOS depends on it, and only in that direction: FoxieOS adapts to the hardware project's choices.
The conditions below are FoxieOS's own terms, not requirements on the hardware project.

- **Proposed terms:**
  - a FoxieOS maintainer owns one;
  - its kernel is built from source, from Raspberry Pi's kernel or the mainline kernel;
  - every part has a Linux driver FoxieOS may ship;
  - FoxieOS signs its own updates with its own keys, and never holds a key it would have to give up if the device changes hands.
- **Secure boot:** on the Raspberry Pi boards the cyber-deck is proposed around, the key whose fingerprint is written into the chip signs everything the board starts ([FEASIBILITY.md](FEASIBILITY.md#secure-boot-and-encryption)).
  Options:
  - devices leave the builder without secure boot, and the owner may turn it on with their own key;
  - FoxieOS's key is written into the devices the project keeps for testing only;
  - the builder writes its key into every device and signs FoxieOS's start-up files.
- **Recommendation:** support the cyber-deck as FoxieOS's main device on the terms above, and the first secure-boot option, once check C3 confirms how the key works.

### D10: base

Which Linux system FoxieOS is built on.
Open; needed by tasks T1 and T2.

Earlier, this decision was between LineageOS, plain AOSP and a base of FoxieOS's own.
With the move to a cyber-deck, the options are Linux systems ([FEASIBILITY.md](FEASIBILITY.md#choosing-a-base)).

- **Options:**
  - **Debian,** as Raspberry Pi OS is: closest to what Raspberry Pi supports.
  - **Alpine Linux, or Nura** (formerly postmarketOS), built on it: smaller, with mobile interfaces ready.
  - **Buildroot or Yocto:** a system built entirely from source, with the most control and the most work.
- **Whichever is chosen,** FoxieOS ships it as a whole image with A/B updates, not as packages updated one by one ([DESIGN.md](DESIGN.md#the-whole-system-updated-in-one-piece)).
- **Recommendation:** try Debian and Alpine on the development board in task T2, and choose the one that starts, encrypts and updates with the least work of FoxieOS's own.

### D11: user interface

What interface FoxieOS has.
Open; needed by task T9.

The cyber-deck is used upright with the touchscreen alone, and sideways with the screen slid out over the keyboard.
It also has knobs on its side, and signal gauges on its top that FoxieOS drives.

- **Options:**
  - an existing mobile interface, such as Phosh or Sxmo;
  - a tiling window manager such as Sway, with FoxieOS's own panels;
  - one full-screen app of FoxieOS's own for the mesh, messages and settings, with a terminal behind it.
- **Recommendation:** decide after task T2 shows which interfaces the chosen base offers; prefer an existing one over FoxieOS's own.

### D12: development board

Which board FoxieOS develops on until the cyber-deck exists.
Open; needed by task T2.

- **Options** ([DEVICES.md](DEVICES.md#development-boards)):
  - a Raspberry Pi Compute Module 5 on Raspberry Pi's IO board, the module the cyber-deck is proposed around;
  - a Raspberry Pi 5, the same chip on a ready board.
- **Recommendation:** the CM5 on its IO board, so the work carries over to the cyber-deck; one board per maintainer who tests releases, bought by the maintainer.

## Tasks

Work in this order, unless a task's needs allow another.

### T0: project skeleton

Done 2026-11-20: this repository, with its docs.

### T1: host readiness

Getting the build computer ready.
**Code and hands-on.** Needs decisions D2 and D10.

- Write `ci/check-host.sh`, which prints PASS or FAIL for each item:
  - free disk where the build goes;
  - KVM (`/dev/kvm`) usable by the account that builds;
  - the tools the chosen base's build needs;
  - QEMU, to start a 64-bit Arm virtual machine.
- The maintainer runs the script on the build host.

**Finished when** the script passes on the build host, or the maintainer accepts the gaps it lists.
**Share** the script's output.

### T2: a first plain image

Building the chosen base, unchanged, and starting it.
**Code and hands-on.** Needs task T1 and decision D12, with the board at hand.

- Write `ci/build.sh`, which builds the image in the background and logs to `logs/`.
- Start the image on a 64-bit Arm virtual machine with QEMU, and on the development board.
- Record the build time, the disk used and the image size.

**Finished when** the image starts on both, and reaches a login over the serial console or SSH.
**Share** the build log, the start-up time on each, and the measurements.

### T3: test harness

Writing the quick checks.
**Code.** Needs task T2.

- Write `tests/smoke/run.sh`, which checks over SSH that the system started, its services are running and its version is reported.
  It skips the FoxieOS-specific checks when the FoxieOS version is missing, so it also runs on the plain image.

**Finished when** the quick checks pass on the plain image, on the virtual machine and on the board.
**Share** the quick checks' output (TAP).

### T4: branding and identity

Adding FoxieOS's name and look.
**Code.** Needs task T2.

- Set FoxieOS's name, version and update channel in `/etc/os-release` (unsourced).
- Make a start-up screen and wallpapers from `branding/foxieos-logo.png`, once the maintainer has confirmed the rights to the artwork.
- Record any change to the base's own files in [PATCHES.md](PATCHES.md).

**Finished when** the virtual machine shows FoxieOS's name and version, and all the quick checks pass.
**Share** the output of test layers L0–L3.

### T5: LoRa mesh service

Building Meshtastic into FoxieOS.
**Code and hands-on.** Needs task T2, check C5, and an SX1262 LoRa board for the development board.

- Ship `meshtasticd`, set to the EU_868 region by default, and refuse to start without a region set.
- Use the same wiring and settings as Alopex's bench build of the radio.
- Send and receive messages with another Meshtastic device, with the antenna always connected.

**Finished when** messages pass both ways on the development board, and the quick checks cover the service.
**Share** the settings, a log of messages passed, and anything that didn't work.

### T6: CI

Setting up automatic checks on every change and every night.
**Code and hands-on.** Needs tasks T3–T5 and decision D3.

- Set up GitHub Actions.
  If the checks run on the project's own computer (a self-hosted runner), keep pull requests from forks off it: GitHub advises against running public repositories' checks on your own computer ([GitHub: secure use][gh-hardening]).
- `ci/presubmit.sh` runs on pull requests: test layers L0–L3, on the virtual machine.
- `ci/nightly.sh` runs every night: a full build and L3.
- Keep logs and results for 14 days, and send a notification when something fails.

**Finished when** a deliberately broken pull request is blocked, and the nightly run passes twice in a row.
**Share** the logs of the automatic runs.

### T7: signing workflow

Writing the signing scripts and the procedure for the keys.
**Code and maintainer only.** Needs task T2 and decision D7.

- Write `release/sign.sh` and `release/verify.sh`, which sign and check RAUC bundles.
- Write `docs/KEYS.md`, the procedure the maintainer follows: encrypted keys, a development key separate from the release key, backups, and when to change keys.
- Practise the whole process with dev keys.

**Finished when** a bundle signed with dev keys passes `verify.sh`, a device that trusts only the release key refuses it, and the maintainer has reviewed `docs/KEYS.md`.
**Share** the output of `verify.sh` and of the refused install.

### T8: A/B updates and the update server

Making devices find and install FoxieOS updates.
**Code and hands-on.** Needs task T7, decision D4 and check C1.

- Lay out the image with two system slots and a data partition.
- Install updates with RAUC into the slot not running, start it with the board's tryboot feature, and mark it good only after the quick checks pass on the device.
- Write `release/publish-metadata.py`, which writes the update descriptions for each channel, and a small service on the device that checks for updates.

**Finished when** update scenarios 1–3 in [TESTING.md](TESTING.md#update-tests) pass on the development board.
**Share** the results of each scenario.

### T9: interface

The interface for the touchscreen and the keyboard.
**Code.** Needs task T2 and decision D11.

- Set up the chosen interface, with the mesh, messages, Wi-Fi, the battery state and settings reachable from it.
- Make it work upright on the touchscreen and sideways with the keyboard, and switch between them when the screen slides (task T11 adds the sensor that tells).

**Finished when** a member who didn't build it can send a mesh message, join a Wi-Fi network and check the battery, both upright and sideways.
**Share** screenshots and what the member found hard.

### T10: encryption and secure boot on a test board

Practising encryption and secure boot.
**Hands-on and maintainer only.** Needs task T8, decision D9, check C3, and the maintainer's go-ahead for each permanent step.

- Encrypt the data partition with LUKS, and ask for the passphrase at start-up.
- On a board bought only for this, set up secure boot with a dev key through Raspberry Pi's provisioner, and check that an unsigned image no longer starts.
- Record in `docs/SECURE-BOOT.md` which steps were permanent and what the owner of a device can still change.

**Finished when** the encrypted board updates through both slots, and the fused board starts only signed images.
**Share** the record and the logs.

### T11: the cyber-deck

Getting FoxieOS running on the Alopex cyber-deck prototype.
**Hands-on.** Needs tasks T5 and T9, decision D9, a cyber-deck from Alopex, and the maintainer's go-ahead for each install.

- Support its screen, keyboard, knobs and the sensor that tells whether the screen is slid out.
- Drive the RSSI and SNR gauges from the LoRa radio's reception.
- Show the state of the hardware switches and of each battery bay, and warn before the last battery is pulled.
- Write `tests/qa/cyberdeck.md`, the device checklist ([TESTING.md](TESTING.md#l7-device-checklist)).

**Finished when** every item on the checklist passes, or has an issue filed.
**Share** the checklist and the quick checks' output.

### T12: release process and the first alpha

The first test release.
**Maintainer only, and hands-on.** Needs tasks T6–T8, decision D8, check C6, and the maintainer's approval to publish.

- The maintainer signs release candidate 1 (RC1) offline.
- Run test layers L4–L7.
- Publish to the `testing` channel only.
- Complete the release record.

**Finished when** RC1 is on the testing channel and its release record is complete.
**Share** the output of every test layer.

### T13: privacy features

**Code.** Needs task T12.

- Write a short plan for each feature: a new random Wi-Fi address (MAC address) for every network, Tor for internet messaging, a choice of preinstalled messaging apps, and switching off services whose hardware switch is off.
- Give each feature automatic tests and checks in the quick checks.

**Finished when** each feature passes test layers L0–L4 and is documented.
**Share** the results for each feature.

## Order of the critical work

The longest chain of work, where each step waits for the one before:

D2 and D10 → T1 → T2 → T3 → T4 and T5 → T6 → T7 → T8 → T12.

- Decision D12 and the board are needed before task T2.
- Task T9 runs alongside, from task T2.
- Tasks T10 and T11 wait on decision D9, and T11 on a cyber-deck from Alopex.

## Not planned

- **Android, or Android apps.**
  Reconsider only if a board the cyber-deck uses gets an Android build with its security rules on and encryption working ([FEASIBILITY.md](FEASIBILITY.md#android)).
- **Phones, or other devices** than the cyber-deck and its development boards ([DEVICES.md](DEVICES.md)).
- **Designing or making hardware.**
  That is the work of the separate hardware project, [Alopex](https://github.com/alopex-org/alopex), which FoxieOS depends on; decision D9 sets the terms.

## Checks

Each check is a short task to confirm a fact.
Do it before the task that relies on it (shown by →), then update the docs that carry the ⚠.

1. **C1, A/B updates on a CM5** (→ T8).
   Whether RAUC with the tryboot feature works on a CM5 as Home Assistant OS describes for the Pi 5, and whether a restart that isn't `systemctl reboot` starts the old slot.
2. **C2, build size and time** (→ T2).
   The disk, memory and time a full build of the chosen base needs on the build host.
3. **C3, the secure-boot key** (→ D9, T10).
   From Raspberry Pi's security documentation: what exactly the key written into the chip signs, whether a second key can ever be added, and what an owner can still do with a fused board.
4. **C4, GNSS position over the mesh** (→ T5).
   Whether `meshtasticd` can read a GNSS receiver and share its position (the same as Alopex check C14).
5. **C5, Meshtastic's region setting** (→ T5).
   How `meshtasticd` is given its region in its settings file, and what it does without one.
6. **C6, trademark search** (→ T12, maintainer only).
   Search the EU (EUIPO) and US (USPTO) trademark registers for "FoxieOS".
7. **C7, legal advice before any sale** (→ before FoxieOS, or a device with it, is sold; maintainers only).
   Whether selling a cyber-deck with FoxieOS makes the seller a manufacturer under the EU's Cyber Resilience Act, radio-equipment rules and ecodesign rules, and what that requires ([FEASIBILITY.md](FEASIBILITY.md#obligations-once-money-is-involved)).
8. **C8, Nura on a Raspberry Pi 5** (→ D10).
   Whether Nura (formerly postmarketOS) supports the Pi 5 and the CM5, and which of its interfaces work there.

[gh-hardening]: https://docs.github.com/en/actions/security-for-github-actions/security-guides/security-hardening-for-github-actions
