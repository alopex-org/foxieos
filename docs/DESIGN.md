# FoxieOS design

**Status: planning.**
This page says what is proposed for FoxieOS, what is still open, and why; nothing is built yet.
The research behind it is in [FEASIBILITY.md](FEASIBILITY.md).
Technical words are explained in the [glossary](GLOSSARY.md).

## In short

- FoxieOS is proposed as the operating system for a cyber-deck that the Alopex hardware project works toward, and no longer as a fork of AOSP or LineageOS for phones.
- Nothing else about the software is decided: what it is built on, how it updates, how it is secured, and what it looks like are open.
- The cyber-deck itself is mostly undecided too: apart from a built-in LoRa mesh radio, which Alopex has decided, its purpose, form, parts and main board are Alopex's open decisions, and FoxieOS adapts to them.
- The first steps are requirements, then a comparison of the options, then a choice of base (roadmap decision D10).
- Some ways of working carry over from the earlier plan, for the maintainers to confirm: few devices, each with an owner who tests it; release keys kept offline by the maintainer; testing before every release; GitHub for the code.

## Purpose

FoxieOS is the operating system for the Alopex cyber-deck.
What it has to do depends on what the cyber-deck is for, which is still open in both projects.

FoxieOS does **not**:

- fork AOSP or LineageOS, as the earlier plan did (proposed; [A cyber-deck, not an Android fork](#a-cyber-deck-not-an-android-fork));
- support devices without a maintainer who owns one ([DEVICES.md](DEVICES.md));
- design or make hardware: the cyber-deck comes from Alopex, a separate project ([Related repositories](#related-repositories)).

## What is proposed and what is open

| Question | Status | Where |
|---|---|---|
| Which device is FoxieOS for? | Proposed: the Alopex cyber-deck | [Below](#a-cyber-deck-not-an-android-fork) |
| Is FoxieOS a fork of AOSP or LineageOS? | Proposed: no | [Below](#a-cyber-deck-not-an-android-fork) |
| What must FoxieOS do? | Open | Task T1 |
| What is FoxieOS built on? | Open | Decision D10 |
| How does it update, and how are updates delivered? | Open | Decision D10, then D4 |
| How is it secured: encryption, secure boot and who holds the keys? | Open | Task T1, decisions D9 and D10 |
| What interface does it have? | Open | Decision D11 |
| Which board is it developed on until the cyber-deck exists? | Open | Decision D12 |
| Where do the code and automatic checks live? | Decided 2026-11-20: GitHub | Decision D3 |

## Key decisions

The interim maintainer wrote these before the founding meeting on 2026-11-24.
Those marked proposed are for the maintainers chosen at the meeting to confirm or change ([governance](https://github.com/alopex-org/.github/blob/main/GOVERNANCE.md#founding-maintainers)).

Each decision says what was chosen, why, and what was turned down.

### A cyber-deck, not an Android fork

Proposed, for the founding meeting to confirm.

- **What:** FoxieOS is the operating system for the Alopex cyber-deck, and is no longer a fork of AOSP or LineageOS for phones.
  What it is built on instead is open (decision [D10](ROADMAP.md#d10-base)).
- **Why:** the direction proposed for the maintainers; the meeting records its reasons when it decides.
- **Turned down:** staying a version of Android built on LineageOS, for phones.

### Requirements before choices

Proposed.

- **What:** write down what FoxieOS must do (task T1), alongside Alopex's requirements for the cyber-deck, and compare the options against them (task T2) before choosing a base.
- **Why:** the base decides almost everything else: how FoxieOS updates, how it is secured, what interface it can have, and how much work it is to keep going.
  Choosing it before the cyber-deck's purpose and parts are known would be a guess.
- **Turned down:** choosing a base first.

### Few devices

Proposed, carried over from the earlier plan.

- **What:** the Alopex cyber-deck, plus a development board until it exists ([DEVICES.md](DEVICES.md)).
- **Why:** each device is ongoing work, and each needs an owner who tests every release on it.
- **Turned down:** supporting many devices.

### Release keys offline and encrypted

Proposed, carried over from the earlier plan.

- **What:** whatever FoxieOS is built on, its releases are signed; the release keys are encrypted, kept offline, and handled only by the maintainer.
  Development uses separate keys that never sign a release ([RELEASING.md](RELEASING.md#keys)).
- **Why:** whoever holds the keys could send fake updates to every device.
- **Turned down:** keeping the keys on the build host; one key for both development and releases.

### Hosting on GitHub

Decided 2026-11-20 (decision D3).

- **What:** the code lives in the `alopex-org` organization on GitHub, in repositories named after each project (`foxieos` and its related repositories, and `alopex` for the hardware project).
  Automatic checks are planned on GitHub Actions ([ROADMAP.md](ROADMAP.md#d3-code-and-ci-hosting)).
- **Why:** FoxieOS is a project of the Alopex student organization, which owns the GitHub organization.
- **Turned down:** running our own code server (Gitea); Gerrit, a review tool, put off until there are three or more contributors.

## Limits FoxieOS has to live with

- **The hardware isn't decided.**
  Until Alopex has chosen the cyber-deck's parts, FoxieOS can only be tried on development boards and, where its base allows, a virtual machine.
- **Secure boot is often permanent.**
  On many chips, turning secure boot on writes a key's fingerprint into the chip for good, so who holds that key has to be settled before any device is set up (decision D9, [FEASIBILITY.md](FEASIBILITY.md#secure-boot)).
- **Legal:** FoxieOS must follow the licences of everything it ships, and the trademark search for the name "FoxieOS" isn't done yet.

## Related repositories

- [Alopex](https://github.com/alopex-org/alopex) works toward the cyber-deck that FoxieOS is proposed for.
  Whether that stays a prototype or becomes a product is its decision D5, and what the cyber-deck runs is its decision D6.
  FoxieOS depends on it, and only in that direction: the hardware project doesn't follow FoxieOS's rules, and FoxieOS adapts to its choices.
  The terms on which FoxieOS supports its devices are roadmap decision [D9](ROADMAP.md#d9-devices-from-the-hardware-project).

Later FoxieOS repositories will live in the same GitHub organization.

## Running the project (planned)

- **Builds and tests:** automatic checks on a build computer ([TESTING.md](TESTING.md)).
- **Releases:** signed offline by the maintainer ([RELEASING.md](RELEASING.md)).
- **Backups:** offline copies of the release keys (made by the maintainer), and the release records.

How releases reach devices, and how a bad release is undone, depend on the base (decision D10).

## Open questions

The open decisions, the work still to do and the facts still to check are in [ROADMAP.md](ROADMAP.md).
