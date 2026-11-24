# FoxieOS design

**Status: planning.**
This page says what is decided for FoxieOS, what is proposed, what is still open, and why; nothing is built yet.
The research behind it is in [FEASIBILITY.md](FEASIBILITY.md).
Technical words are explained in the [glossary](GLOSSARY.md).

## In short

- FoxieOS is the operating system for the Alopex cyber-deck, a user-serviceable, portable cyber-deck with LoRa and Wi-Fi, pocket-sized if possible, and no longer a fork of AOSP or LineageOS for phones (decided at the founding meeting on 2026-11-24).
- For now, it is built on a Linux distribution; which one is open (roadmap decision D10), and so are how it updates, how it is secured, and what it looks like.
- The cyber-deck's main board, screen and controls, power and case are Alopex's open decisions, and FoxieOS adapts to them.
- The first steps are requirements, then a comparison of the distributions, then a choice (decision D10).
- Some ways of working carry over from the earlier plan as proposals, for the maintainers to decide: few devices, each with an owner who tests it; release keys kept offline by the maintainer; testing before every release.
  GitHub for the code is decided (decision D3).

## Purpose

FoxieOS is the operating system for the Alopex cyber-deck, a user-serviceable, portable cyber-deck with LoRa and Wi-Fi, pocket-sized if possible.
Whatever else it does, it runs the cyber-deck's LoRa radio and Wi-Fi, and lets the owner service the device, software included; what that means in detail is task T1.

FoxieOS does **not**:

- fork AOSP or LineageOS, as the earlier plan did (decided 2026-11-24; [A cyber-deck, not an Android fork](#a-cyber-deck-not-an-android-fork));
- support devices without a maintainer who owns one ([DEVICES.md](DEVICES.md));
- design or make hardware: the cyber-deck comes from Alopex, a separate project ([Related repositories](#related-repositories)).

## What is decided, proposed and open

| Question | Status | Where |
|---|---|---|
| Which device is FoxieOS for? | Decided 2026-11-24: the Alopex cyber-deck | [Below](#a-cyber-deck-not-an-android-fork) |
| Is FoxieOS a fork of AOSP or LineageOS? | Decided 2026-11-24: no | [Below](#a-cyber-deck-not-an-android-fork) |
| What must FoxieOS do? | Open | Task T1 |
| What is FoxieOS built on? | Decided 2026-11-24: a Linux distribution, for now | [Below](#a-cyber-deck-not-an-android-fork) |
| Which Linux distribution? | Open | Decision D10 |
| How does it update, and how are updates delivered? | Open | Decision D10, then D4 |
| How is it secured: encryption, secure boot and who holds the keys? | Open | Task T1, decisions D9 and D10 |
| What interface does it have? | Open | Decision D11 |
| Which board is it developed on until the cyber-deck exists? | Open | Decision D12 |
| Where do the code and automatic checks live? | Decided 2026-11-20, confirmed 2026-11-24: GitHub | Decision D3 |

## Key decisions

The maintainer wrote these before the founding meeting on 2026-11-24.
The meeting confirmed those marked decided; those marked proposed are still for the maintainers to decide ([governance](https://github.com/alopex-org/.github/blob/main/GOVERNANCE.md#the-founding-meeting)).

Each decision says what was chosen, why, and what was turned down.

### A cyber-deck, not an Android fork

Decided at the founding meeting, 2026-11-24.

- **What:** FoxieOS is the operating system for the Alopex cyber-deck, a user-serviceable, portable cyber-deck with LoRa and Wi-Fi, pocket-sized if possible, and is no longer a fork of AOSP or LineageOS for phones.
  For now, it is built on a Linux distribution; which one is open (decision [D10](ROADMAP.md#d10-base)).
  "For now" leaves room to revisit the choice of Linux later.
- **Why:** the members confirmed it at the founding meeting; its reasons aren't written down here yet.
- **Turned down:** staying a version of Android built on LineageOS, for phones.

### Requirements before choices

Proposed.

- **What:** write down what FoxieOS must do (task T1), alongside Alopex's requirements for the cyber-deck, and compare the distributions against them (task T2) before choosing one.
- **Why:** the distribution decides much of the rest: how FoxieOS updates, how it is secured, what interface it can have, and how much work it is to keep going.
  Choosing it before the cyber-deck's main board and parts are known would be a guess.
- **Turned down:** choosing a distribution first.

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

Decided 2026-11-20 (decision D3), and confirmed at the founding meeting on 2026-11-24.

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

- [Alopex](https://github.com/alopex-org/alopex) works toward the cyber-deck that FoxieOS is for.
  It builds a prototype first, then a product (its decision D5, decided 2026-11-24), and the cyber-deck runs a Linux distribution for now (its decision D6).
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
