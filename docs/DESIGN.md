# FoxieOS design

**Status: planning.**
This describes the intended design; nothing is built yet.
The research and sources behind each choice are in [FEASIBILITY.md](FEASIBILITY.md).

## Purpose

FoxieOS is an Android distribution with its own branding, privacy defaults, update server and release process.
It is built on LineageOS so that a very small team can keep a few phones patched.

It does **not**:

- support "any phone": devices are added one at a time, under the charter in [DEVICES.md](DEVICES.md);
- match GrapheneOS's hardening outside Pixels;
- ship Google apps, or make banking and other apps that depend on Play Integrity work.
  It never spoofs Play Integrity.

## Architecture

```
LineageOS, branch lineage-24.0
        │
        ▼
Build host (decision D2)
  - Android source tree, about 400 GB, outside this repository
  - .repo/local_manifests/foxie.xml, from the foxieos_android_manifest repository (task T5)
  - vendor/foxie: branding, properties, overlays, apps
  - carry patches (docs/PATCHES.md)
  - CI runner (task T6): test layers L0–L4, Cuttlefish boot and CTS
        │
        │  unsigned target-files and otatools.zip
        ▼
Signing host (decision D7), offline
  - release keys, encrypted
  - the maintainer signs, builds the OTA packages and verifies them (layer L6)
        │
        │  signed OTA packages and update metadata
        ▼
HTTPS update server (decision D4)
  - testing, beta and stable channels
        ▲
        │  JSON queries
LineageOS Updater on the phone
```

This repository holds the docs, scripts and test definitions.
The Android source, build output and CTS downloads stay on the build host.
Release keys exist only on the signing host and its offline backups.

## Key decisions

### Base: LineageOS 24.0 (Android 17)

- **Why:** LineageOS has the broadest maintained device support, and it absorbs Google's changes to AOSP: no more Pixel device trees, a read-only AOSP tree, and source drops only in Q2 and Q4.
- **Rejected:**
  - pure AOSP, which has no device trees for real phones;
  - a GrapheneOS fork, which is Pixel-only and needs heavy rebases;
  - a Treble GSI as the main product, which has no verified boot and per-device quirks.

### A soft fork

- **What:** keep LineageOS's `lineage_<codename>` products and add `vendor/foxie` to them through a single carry patch.
- **Why:** it keeps the rebase surface smallest for each six-month LineageOS cycle, and LineageOS's `breakfast` and `brunch` keep working.
- **Rejected:** separate `foxie_<codename>` products, which break LineageOS's tooling and make a larger diff.

### Identity

- **What:** FoxieOS branding and the properties `ro.foxie.version` and `ro.foxie.build.channel`; LineageOS is credited on the About page.
- **Why:** it is honest about the base and follows Google's rules for the "Android" trademark.
- **Rejected:** presenting LineageOS's work as FoxieOS's own.

### Few devices

- **What:** one device at launch, at most four.
- **Why:** each device is ongoing maintenance, and each needs an owner who tests it.
- **Rejected:** a broad device list.

### Release keys offline and encrypted

- **What:** release keys encrypted with scrypt and AES-256, kept offline, and handled only by the maintainer.
  Coding agents never touch them.
- **Why:** losing the keys, or having them stolen, is the worst risk the project faces.
- **Rejected:** keys on the build host; LineageOS's unencrypted template keys for releases.

### Updates through the LineageOS Updater

- **What:** the LineageOS Updater, pointed at a FoxieOS HTTPS server with `testing`, `beta` and `stable` channels.
- **Why:** a proven model; GrapheneOS uses the same three channels.
- **Rejected:** writing a new updater app.

### Play Integrity left alone

- **What:** FoxieOS never alters Play Integrity verdicts.
- **Why:** the LineageOS charter has the same rule, and spoofing starts an arms race.
- **Rejected:** spoofing.

### Virtual first

Decided 2026-11-20.

- **What:** tasks T2–T6 build and test LineageOS's Cuttlefish target, `lineage_cf_phone_x86_64`.
  A phone (decision D1) is needed only from task T7.
- **Why:** build, branding, CI, signing and CTS work can start before a phone is chosen, and AOSP's `cts-virtual-device-stable` plan gives a ready-made CTS gate on Cuttlefish.
- **Rejected:** getting device #1 first; the goldfish emulator as the CI target, because AOSP documents its stable CTS plan for Cuttlefish.

### Hosting on GitHub

Decided 2026-11-20 (decision D3).

- **What:** the code lives in the `alopex-org` organization on GitHub, in repositories whose names start with `foxieos`.
  CI is planned on GitHub Actions with a self-hosted runner (task T6).
- **Why:** FoxieOS is a project of Alopex, which owns the organization.
- **Rejected:** a self-hosted Gitea; Gerrit, deferred until there are three or more contributors.

### Testing in layers, against a CTS baseline

- **What:** test layers L0–L8 ([TESTING.md](TESTING.md)), with CTS results compared to a baseline taken from stock LineageOS.
- **Why:** LineageOS itself doesn't pass all of CTS (unsourced), so "no new failures" is the gate that means something.
- **Rejected:** requiring a full CTS pass, which can't be achieved; no CTS at all.

## Constraints

- **Build host memory.**
  Android 17's build-graph step runs as a single process and has been reported above 55 GiB.
  That takes 64 GB of RAM plus zram, or 96 GB or more.
  Soong enforces no minimum: the step fails only when it doesn't fit in RAM plus swap, so zram can cover part of it.
  More machines can't stand in for that RAM; they can only take over compiling or tests ([FEASIBILITY.md](FEASIBILITY.md#spreading-the-work-over-several-machines)).
- **Build host disk and virtualisation.**
  About 400 GB per source tree (plan for a 1 TB NVMe drive), and KVM for Cuttlefish and the emulator.
- **Virtual devices can't test hardware.**
  Verified-boot relocking, the modem, cameras, sensors and the battery need the device #1 phone (layers L5 and L7).
- **Upstream:**
  - AOSP publishes source only in Q2 and Q4.
  - Monthly security bulletins carry only high-risk fixes, and their source is not always published.
  - LineageOS ships a major version about every six months.
  - The 5.10 GKI kernels lose support at Android 17 QPR1.
- **Devices:**
  - Samsung (One UI 8) and Xiaomi (HyperOS) have largely closed bootloader unlocking.
  - Relocking with a custom key is proven only on Pixels and the Fairphone 4.
- **Apps:** builds signed with FoxieOS's own keys fail Play Integrity's *device* and *strong* verdicts.
- **Legal:** the GPL kernel source must be published; "Android" may be used only as a descriptor; the trademark search for "FoxieOS" is not done yet.

## Related repositories

None yet.
Later FoxieOS repositories (the manifest in task T5, and forks of upstream repositories) will live in the same GitHub organization.

## Operations (planned)

- **Builds and tests:** CI on the build host ([TESTING.md](TESTING.md)).
- **Releases:** signed offline and published through the channels ([RELEASING.md](RELEASING.md)).
- **Backups:** the release keys (offline copies, made by the maintainer), the release records, and the signed target-files of the last two releases.
- **Recovery:** a bad release is fixed forward with a newer build.
  Downgrades are impossible by design (anti-rollback).

## Open questions

The open decisions, the tasks and the claims still to check are in [ROADMAP.md](ROADMAP.md).
