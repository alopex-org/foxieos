# FoxieOS design

**Status: planning.**
This page describes how FoxieOS is meant to work; nothing is built yet.
The research and sources behind each choice are in [FEASIBILITY.md](FEASIBILITY.md).
Technical words are explained in the [glossary](GLOSSARY.md).

## In short

- FoxieOS is a small Linux system for one device: the Alopex cyber-deck, a rugged hand-held computer with a slide-out keyboard and a LoRa mesh radio.
- Until the cyber-deck exists, it runs on the Raspberry Pi boards the cyber-deck is built around, and on a virtual machine for automatic tests.
- A build host turns the source code into a complete system image.
- A separate offline computer, the signing host, signs each release, so devices accept only real FoxieOS updates.
- A website, the update server, delivers the signed updates; the device installs each one beside the running system and falls back if it fails.
- Everything is tested on a virtual machine first, then on a board, and on the cyber-deck before each release.

## Purpose

FoxieOS is the operating system for the Alopex cyber-deck.
It gives the device's hardware a purpose: private messaging over a LoRa mesh without any network, and over the internet when there is one, on a device its owner controls.

FoxieOS does **not**:

- run Android, Android apps or Google's services;
- support phones, or any device without a maintainer who owns one ([DEVICES.md](DEVICES.md));
- design or make hardware: the cyber-deck comes from Alopex, a separate project ([Related repositories](#related-repositories));
- write its own encryption: it uses existing, reviewed tools such as LUKS and Meshtastic's encryption.

## How the pieces fit together

The picture shows the path from the source code to an update on a device.
The decision codes (D2, D4, D7, D10) and task codes refer to [ROADMAP.md](ROADMAP.md); the test layers (L0–L8) to [TESTING.md](TESTING.md).

```
The base Linux system (decision D10) and FoxieOS's own parts
        │
        ▼
Build host: the computer that builds FoxieOS (decision D2)
  - builds a complete system image for 64-bit Arm (arm64)
  - FoxieOS's own parts: branding, settings, the mesh-radio service,
    the user interface for touchscreen and keyboard
  - automatic checks (task T6): test layers L0–L3 on a virtual machine
        │
        │  unsigned system image
        ▼
Signing host: a separate, offline computer (decision D7)
  - the release keys, encrypted
  - the maintainer signs the update file (a RAUC bundle)
    and checks it (test layer L6)
        │
        │  signed update files and their descriptions
        ▼
Update server on a secure HTTPS website (decision D4)
  - testing, beta and stable channels
        ▲
        │  "is there an update for me?"
The cyber-deck: two system slots, A and B
  - installs the update into the slot it isn't running
  - starts the new slot once, and keeps it only if it starts properly
```

This repository holds the docs, scripts and test lists.
Build output and downloads stay on the build host.
The release keys exist only on the signing host and its offline backups.

## Key decisions

The interim maintainer wrote these choices before the founding meeting on 2026-11-24.
They are proposals: the maintainers chosen at the meeting confirm or change them ([governance](https://github.com/alopex-org/.github/blob/main/GOVERNANCE.md#founding-maintainers)).

Each decision says what was chosen, why, and what was turned down.

### An operating system for a cyber-deck

Proposed 2026-11-23, for the founding meeting to confirm.

- **What:** FoxieOS is a Linux system for the Alopex cyber-deck, no longer a version of Android built on LineageOS for phones.
- **Why:**
  - The cyber-deck is the device the project wants to build, and Alopex already proposes a Raspberry Pi hand-held running Linux as its first prototype.
  - The tools it needs run on Linux today: Meshtastic's Linux service for the LoRa radio, LUKS for encrypting the storage, and messaging apps such as Session ([FEASIBILITY.md](FEASIBILITY.md#what-the-cyber-deck-needs-from-its-software)).
  - Android on a Raspberry Pi exists only as a community build, with its security rules switched off and no encryption of user data.
  - A Linux system for one device is far less work than an Android version: no 400 GB source tree, no build computer with 64 GB of memory or more, and no dependence on Google's release schedule (unsourced estimate; task T1 measures it).
- **Turned down:**
  - staying a version of Android on LineageOS for phones, which serves a different device and couldn't run on the cyber-deck;
  - Android on the cyber-deck, until a board supports it with its security rules on and encryption working;
  - writing an operating system from scratch.

### Base: an existing Linux system

Open (roadmap decision [D10](ROADMAP.md#d10-base)).

- **What:** start from an existing Linux system and add FoxieOS's parts to it, rather than assembling every package by hand.
- **Options:** Debian, as Raspberry Pi OS is; Alpine Linux, or Nura (formerly postmarketOS), which is built on it; or a system built entirely from source with Buildroot or Yocto ([FEASIBILITY.md](FEASIBILITY.md#choosing-a-base)).
- **Why it matters:** the base sets how security fixes arrive, how large the system is, and how much work each update is.

### Few devices

- **What:** the Alopex cyber-deck, plus the Raspberry Pi boards it is built around while it doesn't exist yet ([DEVICES.md](DEVICES.md)).
- **Why:** each device is ongoing work, and each needs an owner who tests every release on it.
- **Turned down:** a general Linux system for many devices; plenty already exist.

### The whole system updated in one piece

- **What:** FoxieOS is a system image with two slots, A and B.
  An update, a signed RAUC bundle, is installed into the slot that isn't running; the device starts the new slot, and goes back to the old one if the new one doesn't confirm a good start.
  On a Raspberry Pi 5 this uses the board's "tryboot" feature, as Home Assistant OS does ([FEASIBILITY.md](FEASIBILITY.md#updates)).
- **Why:** a device in the field must never be left unable to start, and an update installed as one piece behaves the same on every device.
- **Turned down:** updating package by package (`apt`, `apk`), which can stop halfway and leaves each device a little different; writing a new update tool.

### Release keys offline and encrypted

- **What:** the release keys are encrypted, kept offline, and handled only by the maintainer.
  Development devices trust a separate development key, which never signs a release ([RELEASING.md](RELEASING.md#keys)).
- **Why:** whoever holds the keys could send fake updates to every device.
- **Turned down:** keeping the keys on the build host; one key for both development and releases.

### Encrypted storage, and secure boot left to the owner

- **What:** the whole storage is encrypted with LUKS.
  Secure boot, which makes the board start only a signed system, is set up only on devices the project keeps for testing, until decision D9 settles who holds the key ([FEASIBILITY.md](FEASIBILITY.md#secure-boot-and-encryption)).
- **Why:** on a Raspberry Pi, turning on secure boot writes the fingerprint of one signing key into the chip for good.
  Whoever holds that key decides what the device will ever start, so it is not a choice FoxieOS makes for an owner.
- **Turned down:** shipping devices locked to FoxieOS's key; no encryption.

### LoRa mesh radio through Meshtastic

- **What:** FoxieOS runs Meshtastic's Linux service, `meshtasticd`, for the cyber-deck's LoRa radio, set to the band of the country it is used in (EU_868 in Greece), and shows the mesh in its own interface.
- **Why:** Alopex recommends Meshtastic as the default mesh network, its encryption is already reviewed by its users, and its devices can talk to the many Meshtastic devices already in use ([FEASIBILITY.md](FEASIBILITY.md#the-lora-mesh-radio)).
- **Turned down:** encryption of FoxieOS's own on top of LoRa; a separate radio connected over Bluetooth.

### An interface for a touchscreen and a keyboard

Open (roadmap decision [D11](ROADMAP.md#d11-user-interface)).

- **What:** the cyber-deck is used in two ways: upright, with the touchscreen alone, and sideways with the screen slid out over the keyboard.
  The interface has to work both ways, and with the knobs on the side.
- **Options:** an existing mobile interface such as Phosh or Sxmo; a tiling window manager such as Sway with FoxieOS's own panels; or a single full-screen app of FoxieOS's own.

### Testing on a virtual machine first

- **What:** the automatic checks start FoxieOS on a virtual 64-bit Arm machine on the build host; a Raspberry Pi board is needed from task T2, the cyber-deck from task T11.
- **Why:** the build, branding, automatic checks and signing can start before any hardware is bought.
- **Turned down:** waiting for the cyber-deck before anything else.

### Hosting on GitHub

Decided 2026-11-20 (decision D3).

- **What:** the code lives in the `alopex-org` organization on GitHub, in repositories named after each project (`foxieos` and its related repositories, and `alopex` for the hardware project).
  Automatic checks are planned on GitHub Actions ([ROADMAP.md](ROADMAP.md#d3-code-and-ci-hosting)).
- **Why:** FoxieOS is a project of the Alopex student organization, which owns the GitHub organization.
- **Turned down:** running our own code server (Gitea); Gerrit, a review tool, put off until there are three or more contributors.

## Limits FoxieOS has to live with

- **The hardware isn't built yet.**
  Until Alopex has a cyber-deck, the touchscreen, keyboard, knobs, gauges, switches and battery bays can only be tried on a board with parts wired to it.
- **A virtual machine can't test hardware.**
  The LoRa radio, the switches, the batteries and secure boot need a real board (test layers L4 and L7).
- **Secure boot on a Raspberry Pi is permanent.**
  Once a key's fingerprint is written into a board's one-time-programmable memory, it can't be changed, and losing the key means the board can no longer be updated with trusted start-up files ([FEASIBILITY.md](FEASIBILITY.md#secure-boot-and-encryption)).
- **The LoRa band is narrow in Europe.**
  Meshtastic's EU_868 setting uses 869.4–869.65 MHz with a 10% limit on transmitting time, so messages are short and slow ([FEASIBILITY.md](FEASIBILITY.md#the-lora-mesh-radio)).
- **No mainstream apps.**
  Banking apps, WhatsApp, Instagram and Google's services don't run on it.
- **Legal:** the kernel's source code must be published (GPL); the trademark search for the name "FoxieOS" isn't done yet.

## Related repositories

- [Alopex](https://github.com/alopex-org/alopex) designs the cyber-deck that FoxieOS runs on.
  Whether that stays a prototype or becomes a product is its decision D5.
  FoxieOS depends on it, and only in that direction: the hardware project doesn't follow FoxieOS's rules, and FoxieOS adapts to its choices.
  The terms on which FoxieOS supports its devices are roadmap decision [D9](ROADMAP.md#d9-devices-from-the-hardware-project).

Later FoxieOS repositories, such as one holding the build recipe for the system image, will live in the same GitHub organization.

## Running the project (planned)

- **Builds and tests:** automatic checks on the build host ([TESTING.md](TESTING.md)).
- **Releases:** signed offline and published through the update channels ([RELEASING.md](RELEASING.md)).
- **Backups:** offline copies of the release keys (made by the maintainer), the release records, and the system images of the last two releases.
- **Fixing a bad release:** release a newer, fixed version.
  A device that can't start a new version goes back to the one before by itself.

## Open questions

The open decisions, the work still to do and the facts still to check are in [ROADMAP.md](ROADMAP.md).
