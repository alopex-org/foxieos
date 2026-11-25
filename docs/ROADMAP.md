# FoxieOS roadmap

This page lists what is decided, what is still open, and the work in the order it should happen.
Background: [DESIGN.md](DESIGN.md) for what is decided or proposed, and why, [FEASIBILITY.md](FEASIBILITY.md) for the research.
Technical words are explained in the [glossary](GLOSSARY.md).

## Where things stand

- **Done:** task T0, setting up this repository and its docs, on 2026-11-20.
- **Decided at the founding meeting, 2026-11-24:** FoxieOS is the operating system for the Alopex cyber-deck, a user-serviceable, portable cyber-deck with LoRa and Wi-Fi, pocket-sized if possible, built on a Linux distribution for now, and is no longer a fork of AOSP or LineageOS for phones ([DESIGN.md](DESIGN.md#a-cyber-deck-not-an-android-fork)).
  Which distribution is open, and so is the rest of the software; the cyber-deck's main board and most parts are open in Alopex.
  Decisions D1, D5 and D6 applied only to Android, and are withdrawn; the tasks and checks are numbered afresh, and a maintainer closes the GitHub issues of the old ones.
- **Founding meeting, 2026-11-24:** the members chose the maintainer, and confirmed the direction above and decision D3 (GitHub); the other proposals in [DESIGN.md](DESIGN.md#key-decisions) stay proposals ([governance](https://github.com/alopex-org/.github/blob/main/GOVERNANCE.md#the-founding-meeting)).
- **Maintainers, 2026-11-26:** the maintainer chosen at the meeting appointed two more, @evansyrsiris and @Leandros64, as the meeting foresaw ([governance](https://github.com/alopex-org/.github/blob/main/GOVERNANCE.md#maintainers)).
- **Next:** task T1, FoxieOS's requirements.
  It needs no decision and no money.

## How to read this page

- **Decisions (D2–D12)** are questions the maintainers answer.
  Each one lists the options and a recommendation.
- **Tasks (T0–T13)** are the pieces of work, in order.
  Each one says what it needs first, what to do, when it is finished, and what to share afterwards.
  Tasks T3–T13 are an outline: their details depend on decision D10, and are written once it is taken.
- **Checks (C1–C4)** are facts to confirm before the task that relies on them.
  A ⚠ in the other docs usually points to one of them.
- **On GitHub,** each decision, task and check also has an issue, and each phase below is a [milestone](https://github.com/alopex-org/foxieos/milestones).
  This page is the plan; the issues track progress and discussion ([CONTRIBUTING.md](../CONTRIBUTING.md#issues-and-labels)).
- **Who does each task:**
  - **Code:** a change to files, made in a pull request.
    Anyone can do it.
  - **Hands-on:** runs on the build computer, a board or the cyber-deck.
    A maintainer runs it, or approves each step.
  - **Maintainer only:** keys, accounts, purchases and publishing.

## Phases

1. **Requirements and choices:** what FoxieOS must do, the distributions compared, and one chosen (T1, T2, decision D10).
2. **Setup:** the build computer, a first image on a development board, tests, branding and automatic checks (T3–T7).
3. **Releases and security:** signing, updates, and security on a test board (T8, T9, T11).
4. **The cyber-deck:** the interface, and FoxieOS on the Alopex prototype (T10, T12).
5. **The first test release** (T13).

## Decisions

| ID | Question | Status | Needed by |
|---|---|---|---|
| D1 | Which phone comes first? | Withdrawn: Android only | — |
| [D2](#d2-build-host) | Which computer builds FoxieOS? | Open | T3 |
| [D3](#d3-code-and-ci-hosting) | Where do the code and automatic checks live? | Decided: GitHub (confirmed 2026-11-24) | T7 |
| [D4](#d4-update-server-hosting) | Where is the update server hosted? | Open | T9 |
| D5 | Does FoxieOS include microG? | Withdrawn: Android only | — |
| D6 | Are releases `userdebug` or `user` builds? | Withdrawn: Android only | — |
| [D7](#d7-signing-host) | Which computer signs releases? | Open | T8 |
| [D8](#d8-security-contact) | How do people report security problems privately? | Open | T13 |
| [D9](#d9-devices-from-the-hardware-project) | On what terms does FoxieOS support a device from the hardware project? | Open | T11, T12 |
| [D10](#d10-base) | Which Linux distribution is FoxieOS built on? | Open | T3 |
| [D11](#d11-user-interface) | What interface does FoxieOS have? | Open | T10 |
| [D12](#d12-development-board) | Which board does FoxieOS develop on until the cyber-deck exists? | Open | T4 |

### D2: build host

Which computer builds FoxieOS.
Open; needed by task T3.

What it needs (disk, memory, processor) depends on the base chosen in decision D10.

**Recommendation:** decide after D10; start with a computer the project already has access to, and measure the build (check C1) before buying or renting anything.
A rented computer needs an account, which a maintainer creates, and is never used to sign releases.

### D3: code and CI hosting

Where the code and the automatic checks live.
**Decided 2026-11-20: GitHub; confirmed at the founding meeting on 2026-11-24.**

- The code lives in the [`alopex-org`](https://github.com/alopex-org) organization.
  This repository is `alopex-org/foxieos`, and FoxieOS's other repositories there start with `foxieos` too.
- The repositories are public.
  On GitHub's free plan, public repositories get protected branches (rulesets), code owners, secret scanning and private vulnerability reporting.
  A ruleset protects `main` ([CONTRIBUTING.md](../CONTRIBUTING.md#review)).
- How the automatic checks run is settled in task T7.
- No Gerrit (another review tool) until there are three or more contributors.
- Turned down: running our own code server (Gitea with Gitea Actions).

### D4: update server hosting

Where the update server, which devices download updates from, is hosted.
Open; needed by task T9.

How FoxieOS updates, and so whether it needs an update server of its own, depends on decision D10.

- **Recommendation:** decide after D10; if FoxieOS needs one, a simple secure (HTTPS) website on a domain the project controls.

### D7: signing host

Which computer signs releases.
Open; needed by task T8.

- **Options:** a computer that is never connected to a network, or the build host with the keys unlocked only in memory.
- **Recommendation:** a separate computer.

### D8: security contact

How people report security problems privately.
Open; needed before the first public release (task T13).

- Until D8 is decided, [SECURITY.md](../SECURITY.md) uses GitHub's private vulnerability reporting.
- **Recommendation:** keep private vulnerability reporting, and add a dedicated email address, not a personal one, for people without a GitHub account.

### D9: devices from the hardware project

On what terms FoxieOS supports a device from the hardware project.
Open; needed before secure boot is set up on any board (task T11) and before the cyber-deck joins (task T12).

[Alopex](https://github.com/alopex-org/alopex) works toward the cyber-deck, the device FoxieOS is for.
It builds a prototype first, then a product (its decision D5, decided 2026-11-24), and its parts are still open.
FoxieOS depends on it, and only in that direction: FoxieOS adapts to the hardware project's choices.
The conditions below are FoxieOS's own terms, not requirements on the hardware project.

- **Proposed terms:**
  - a FoxieOS maintainer owns one;
  - FoxieOS may ship everything the device needs to run, such as its drivers and firmware;
  - FoxieOS signs its own releases with its own keys, and never holds a key it would have to give up if the device changes hands.
- **Secure boot,** if the cyber-deck's main board has it: on many chips, a key's fingerprint is written into the chip for good, and that key decides what the device will ever start ([FEASIBILITY.md](FEASIBILITY.md#secure-boot)).
  Who holds it is part of these terms: the builder, the owner, or FoxieOS.
- **Recommendation:** settle the terms once Alopex has chosen the main board (its decision D1) and check C2 shows how its secure boot works.

### D10: base

Which Linux distribution FoxieOS is built on.
Open; needed by task T3.

Earlier, this decision was between LineageOS, plain AOSP and a base of FoxieOS's own.
Since the founding meeting on 2026-11-24, FoxieOS is no longer a fork of AOSP or LineageOS, and is built on a Linux distribution for now; which one is this decision.
[FEASIBILITY.md](FEASIBILITY.md#possible-bases) lists what is known about each.

- **Options found so far,** none of them preferred yet:
  - Debian, or a distribution based on it, such as Raspberry Pi OS;
  - Alpine Linux;
  - Nura (formerly postmarketOS), built on Alpine;
  - another distribution that task T2 finds.
- **Recommendation:** decide after task T2 has compared them against the requirements from task T1, and once Alopex has chosen the cyber-deck's main board (its decision D1), since the board's Linux support may narrow the choice.

### D11: user interface

What interface FoxieOS has.
Open; needed by task T10.

The interface depends on the cyber-deck's screen and controls, which Alopex hasn't chosen, and on what the base offers.

- **Recommendation:** decide after decision D10, when the screen and controls are known; prefer an existing interface over one of FoxieOS's own.

### D12: development board

Which board FoxieOS develops on until the cyber-deck exists.
Open; needed by task T4.

The cyber-deck's main board is Alopex's choice, still open ([Alopex decision D1](https://github.com/alopex-org/alopex/blob/main/docs/ROADMAP.md#d1-route-to-a-prototype)).
FoxieOS adapts to that choice.

- **Options** ([DEVICES.md](DEVICES.md#development-boards)):
  - the board Alopex chooses, or its maker's development kit, once Alopex has chosen;
  - until then, one of the candidates Alopex tries on the bench (its task T2).
- **Recommendation:** the board Alopex chooses, so the work carries over to the cyber-deck.
  One board per maintainer who tests releases, bought by the maintainers.

## Tasks

Work in this order, unless a task's needs allow another.

### T0: project skeleton

Done 2026-11-20: this repository, with its docs.

### T1: FoxieOS's requirements

What FoxieOS must do.
**Code.** Can start now.

- Write `docs/REQUIREMENTS.md` as a draft for the maintainers: what FoxieOS must do, each requirement with its reason and source.
  Where the members disagree, list the options instead of choosing one.
- Start from what is decided: a user-serviceable cyber-deck, with LoRa and Wi-Fi, on a Linux distribution.
- Work from Alopex's requirements for the cyber-deck ([its task T1](https://github.com/alopex-org/alopex/blob/main/docs/ROADMAP.md#t1-hardware-requirements)), and ask the questions Alopex leaves to the software, for example:
  - what user-serviceable means for the software: how the owner can reinstall, repair or change it;
  - what FoxieOS offers for the LoRa radio and Wi-Fi;
  - what people do with the cyber-deck, and which programs they need;
  - how updates reach it, and what happens if one fails;
  - how the data on it is protected, and who controls what it starts;
  - how long each release is supported.
- Propose any change Alopex's requirements would need as a pull request there, linked from this one; Alopex decides.

**Finished when** the list exists, every requirement gives its reason, and the maintainers have reviewed it.
**Share** the open questions the list raises.

### T2: comparing the options

Comparing the Linux distributions FoxieOS could be built on.
**Code.** Needs task T1; Alopex's decision D1 narrows it.

- For each distribution in [FEASIBILITY.md](FEASIBILITY.md#possible-bases), and any other task T1 suggests, write down against each requirement:
  - whether it runs on the candidate boards;
  - how it is updated, and how security fixes arrive;
  - what it offers for encryption and secure boot;
  - what interfaces it has;
  - how much work it would be for a small team to keep going.
- Mark every claim with its source, or as unsourced.

**Finished when** the comparison is in `docs/FEASIBILITY.md` and the maintainers can take decision D10 on it.
**Share** the comparison's summary.

### T3: host readiness

Getting the build computer ready.
**Code and hands-on.** Needs decisions D2 and D10.

- Write `ci/check-host.sh`, which prints PASS or FAIL for each thing the chosen base's build needs.
- A maintainer runs the script on the build host.

**Finished when** the script passes on the build host, or the maintainers accept the gaps it lists.
**Share** the script's output.

### T4: a first image

Building the chosen base, unchanged, and starting it.
**Code and hands-on.** Needs task T3 and decision D12, with the board at hand.

- Write `ci/build.sh`, which builds in the background and logs to `logs/`.
- Start the result on the development board, and on a virtual machine if the base allows.
- Record the build time, the disk used and the size of the result (check C1).

**Finished when** it starts on the board.
**Share** the build log, the start-up result and the measurements.

### T5: test harness

Writing the first automatic checks ([TESTING.md](TESTING.md)).
**Code.** Needs task T4.

**Finished when** the checks pass on the plain image.
**Share** the checks' output.

### T6: branding and identity

Adding FoxieOS's name, version and look, once the maintainers have confirmed the rights to the artwork.
**Code.** Needs task T4.

**Finished when** the board shows FoxieOS's name and version, and the checks pass.
**Share** the output of the checks.

### T7: CI

Setting up automatic checks on every change.
**Code and hands-on.** Needs tasks T5 and T6 and decision D3.

- Set up GitHub Actions.
  If the checks run on the project's own computer (a self-hosted runner), keep pull requests from forks off it: GitHub advises against running public repositories' checks on your own computer ([GitHub: secure use][gh-hardening]).

**Finished when** a deliberately broken pull request is blocked.
**Share** the logs of the automatic runs.

### T8: signing workflow

Writing the signing scripts and the procedure for the keys.
**Code and maintainer only.** Needs task T4 and decisions D7 and D10.

- Write `release/sign.sh` and `release/verify.sh` for whatever the base's releases are, and `docs/KEYS.md`, the procedure the maintainers follow.
- Practise the whole process with dev keys.

**Finished when** a release signed with dev keys passes `verify.sh`, and the maintainers have reviewed `docs/KEYS.md`.
**Share** the output of `verify.sh`.

### T9: updates

Making devices find and install FoxieOS updates, in the way decision D10 allows.
**Code and hands-on.** Needs task T8 and decision D4.

**Finished when** the update tests in [TESTING.md](TESTING.md#update-tests) pass on the development board.
**Share** the results of each test.

### T10: interface

Setting up the interface chosen in decision D11.
**Code.** Needs task T4 and decision D11.

**Finished when** a member who didn't build it can use the main functions from task T1's requirements.
**Share** screenshots and what the member found hard.

### T11: security on a test board

Practising the security features the requirements ask for, such as storage encryption and secure boot.
**Hands-on and maintainer only.** Needs task T9, decision D9, check C2, and a maintainer's go-ahead for each permanent step.

- Set up secure boot, if the board has it, only on a board bought for this, with a dev key.
- Record in `docs/SECURE-BOOT.md` which steps were permanent and what the owner of a device can still change.

**Finished when** what the requirements ask for works on the test board.
**Share** the record and the logs.

### T12: the cyber-deck

Getting FoxieOS running on the Alopex cyber-deck prototype.
**Hands-on.** Needs tasks T10 and T11, decision D9, a cyber-deck from Alopex, and a maintainer's go-ahead for each install.

- Support each of its parts that the requirements cover.
- Write `tests/qa/cyberdeck.md`, the device checklist ([TESTING.md](TESTING.md#device-checklist)).

**Finished when** every item on the checklist passes, or has an issue filed.
**Share** the checklist.

### T13: the first alpha

The first test release.
**Maintainer only, and hands-on.** Needs tasks T7–T9, decision D8, check C3, and the maintainers' approval to publish.

**Finished when** the release is on the testing channel and its release record is complete.
**Share** the output of every test.

## Order of the critical work

The longest chain of work, where each step waits for the one before:

T1 → T2 → D10 → D2 → T3 → T4 → T5 → T7 → T8 → T9 → T13.

- Alopex's decision D1 (the main board) is needed before D10 and D12.
- Tasks T11 and T12 wait on decision D9, and T12 on a cyber-deck from Alopex.

## Not planned

- **A fork of AOSP or LineageOS** (decided 2026-11-24; [DESIGN.md](DESIGN.md#a-cyber-deck-not-an-android-fork)).
- **Devices other than the cyber-deck** and its development boards ([DEVICES.md](DEVICES.md)).
- **Designing or making hardware.**
  That is the work of the separate hardware project, [Alopex](https://github.com/alopex-org/alopex), which FoxieOS depends on; decision D9 sets the terms.

## Checks

Each check is a short task to confirm a fact.
Do it before the task that relies on it (shown by →), then update the docs that carry the ⚠.

1. **C1, build size and time** (→ T3, T4).
   The disk, memory and time a full build of the chosen base needs.
2. **C2, the secure-boot key** (→ D9, T11).
   From the chosen board maker's security documentation: whether the board has secure boot, what exactly the key written into the chip signs, whether a second key can ever be added, and what an owner can still do with a fused board.
3. **C3, trademark search** (→ T13, maintainer only).
   Search the EU (EUIPO) and US (USPTO) trademark registers for "FoxieOS".
4. **C4, legal advice before any sale** (→ before FoxieOS, or a device with it, is sold; maintainers only).
   Whether selling a cyber-deck with FoxieOS makes the seller a manufacturer under the EU's Cyber Resilience Act and other product rules, and what that requires ([FEASIBILITY.md](FEASIBILITY.md#obligations-once-money-is-involved)).

[gh-hardening]: https://docs.github.com/en/actions/security-for-github-actions/security-guides/security-hardening-for-github-actions
