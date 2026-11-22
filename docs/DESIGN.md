# FoxieOS design

**Status: planning.**
This page describes how FoxieOS is meant to work; nothing is built yet.
The research and sources behind each choice are in [FEASIBILITY.md](FEASIBILITY.md).
Technical words are explained in the [glossary](GLOSSARY.md).

## In short

- FoxieOS takes LineageOS, a free version of Android, and adds its own name, look, privacy settings and update service.
- It supports only a few phones, so a small team can keep them safe and up to date.
- A powerful computer, the build host, turns the source code into FoxieOS.
- A separate offline computer, the signing host, signs each release with secret keys, so phones accept only real FoxieOS updates.
- A website, the update server, delivers the signed updates to phones.
- Everything is tested on a virtual phone first, and on real phones before each release.

## Purpose

FoxieOS is a version of Android with its own branding, privacy settings, update server and release process.
It is built on LineageOS so that a very small team can keep a few phones up to date with security fixes.

FoxieOS does **not**:

- support "any phone": phones are added one at a time, under the rules in [DEVICES.md](DEVICES.md);
- match GrapheneOS's security on phones other than Pixels;
- design or make hardware: for its own device it depends on a separate project ([Related repositories](#related-repositories));
- include Google's apps, or make banking and other apps that rely on Google's Play Integrity check work.
  It never fakes a Play Integrity result.

## How the pieces fit together

The picture shows the path from LineageOS's code to an update on a phone.
The decision codes (D2, D4, D7) and task codes (T5, T6) refer to [ROADMAP.md](ROADMAP.md); the test layers (L0–L6) to [TESTING.md](TESTING.md).

```
LineageOS code, branch lineage-24.0
        │
        ▼
Build host: the computer that builds FoxieOS (decision D2)
  - the Android source code, about 400 GB, kept outside this repository
  - the list of FoxieOS's extra parts (.repo/local_manifests/foxie.xml),
    from the foxieos_android_manifest repository (task T5)
  - vendor/foxie: FoxieOS's branding, settings and apps
  - carry patches: FoxieOS's changes to LineageOS (docs/PATCHES.md)
  - automatic checks (task T6): test layers L0–L4 on a virtual phone
        │
        │  unsigned build files (target-files and otatools.zip)
        ▼
Signing host: a separate, offline computer (decision D7)
  - the release keys, encrypted
  - the maintainer signs the release, makes the update packages
    and checks them (test layer L6)
        │
        │  signed update packages and their descriptions
        ▼
Update server on a secure HTTPS website (decision D4)
  - testing, beta and stable channels
        ▲
        │  "is there an update for me?"
LineageOS Updater app on the phone
```

This repository holds the docs, scripts and test lists.
The Android source code, the build results and Google's test downloads stay on the build host.
The release keys exist only on the signing host and its offline backups.

## Key decisions

The interim maintainer wrote these choices before the founding meeting on 2026-11-24.
They are proposals: the maintainers chosen at the meeting confirm or change them ([governance](https://github.com/alopex-org/.github/blob/main/GOVERNANCE.md#founding-maintainers)).

Each decision says what was chosen, why, and what was turned down.

### Base: LineageOS 24.0 (Android 17)

- **What:** build FoxieOS on LineageOS 24.0, which is based on Android 17.
- **Why:** LineageOS supports more phones than any other free version of Android, and keeps up with Google's changes to Android for its users.
  Those changes make other routes harder: Google no longer publishes the files for its own Pixel phones, its public code is now read-only, and it publishes new code only twice a year (Q2 and Q4).
- **Turned down:**
  - plain AOSP, which has no support for real phones;
  - a copy of GrapheneOS, which runs only on Pixels and is a lot of work to keep up to date;
  - one generic image for many phones (a Treble GSI) as the main product, which can't use verified boot and behaves differently on each phone.

### Stay close to LineageOS (a soft fork)

- **What:** keep LineageOS's own build for each phone (`lineage_<codename>`) and add FoxieOS's `vendor/foxie` to it through one small change.
- **Why:** LineageOS releases a new major version about every six months.
  The fewer changes FoxieOS makes, the less work each of those updates is, and LineageOS's own build commands (`breakfast` and `brunch`) keep working.
- **Turned down:** separate FoxieOS builds for each phone (`foxie_<codename>`), which would break LineageOS's tools and mean more changes to carry.

### Identity

- **What:** FoxieOS's own branding, and two built-in values that say which FoxieOS version and channel a phone runs (`ro.foxie.version` and `ro.foxie.build.channel`).
  The About page credits LineageOS.
- **Why:** it is honest about what FoxieOS is built on, and it follows Google's rules for the "Android" trademark.
- **Turned down:** presenting LineageOS's work as FoxieOS's own.

### Few phones

- **What:** one phone at launch, at most four.
- **Why:** each phone is ongoing work, and each needs an owner who tests every release on it.
- **Turned down:** a long list of phones.

### Release keys offline and encrypted

- **What:** the release keys are encrypted (with scrypt and AES-256), kept offline, and handled only by the maintainer.
- **Why:** losing the keys, or having them stolen, is the worst thing that could happen to the project: whoever holds them could send fake updates to every phone.
- **Turned down:** keeping the keys on the build host; using LineageOS's unencrypted example keys for releases.

### Updates through the LineageOS Updater

- **What:** the phones use LineageOS's own Updater app, pointed at a FoxieOS update server on a secure (HTTPS) website, with `testing`, `beta` and `stable` channels.
- **Why:** it is proven; GrapheneOS uses the same three channels.
- **Turned down:** writing a new update app.

### Play Integrity left alone

- **What:** FoxieOS never fakes the result of Google's Play Integrity check.
- **Why:** LineageOS has the same rule, and faking it starts an endless race with Google.
- **Turned down:** faking it.

### Virtual phone first

Decided 2026-11-20.

- **What:** tasks T2–T6 build and test FoxieOS on Cuttlefish, Google's virtual phone, in LineageOS's version `lineage_cf_phone_x86_64`.
  A real phone (decision D1) is needed only from task T7.
- **Why:** the build, branding, automatic checks, signing and compatibility tests can start before a phone is chosen.
  Google also provides a ready-made set of compatibility tests for Cuttlefish (`cts-virtual-device-stable`).
- **Turned down:** getting the first phone before anything else; using the other virtual phone, the goldfish emulator, for automatic tests, because Google's stable test set is made for Cuttlefish.

### Hosting on GitHub

Decided 2026-11-20 (decision D3).

- **What:** the code lives in the `alopex-org` organization on GitHub, in repositories whose names start with `foxieos`.
  Automatic checks are planned on GitHub Actions, running on the project's own computer (task T6).
- **Why:** FoxieOS is a project of Alopex, which owns the organization.
- **Turned down:** running our own code server (Gitea); Gerrit, a review tool, put off until there are three or more contributors.

### Testing in layers, against a baseline

- **What:** tests in layers L0–L8 ([TESTING.md](TESTING.md)).
  Google's compatibility test results are compared with a baseline: the results of plain LineageOS.
- **Why:** LineageOS itself doesn't pass every compatibility test (unsourced), so the useful rule is "no new failures".
- **Turned down:** requiring every test to pass, which can't be done; skipping the compatibility tests.

## Limits FoxieOS has to live with

- **The build host needs a lot of memory.**
  One step of Android 17's build reads the whole source tree in a single program, and has been reported to use more than 55 GiB of memory.
  That takes 64 GB of RAM plus zram (compressed memory), or 96 GB or more.
  The build system (Soong) sets no minimum: the step fails only when it doesn't fit in RAM plus swap, so zram can cover part of it.
  More computers can't replace that RAM; they can only take over compiling or tests ([FEASIBILITY.md](FEASIBILITY.md#spreading-the-work-over-several-machines)).
- **The build host needs disk space and virtualisation.**
  About 400 GB for each copy of the source code (plan for a 1 TB NVMe drive), and KVM to run virtual phones.
- **Virtual phones can't test hardware.**
  Relocking the bootloader, the mobile network, cameras, sensors and the battery need the first real phone (test layers L5 and L7).
- **Upstream sets the pace:**
  - Google publishes Android's source code only in Q2 and Q4.
  - Google's monthly security bulletins include only the most serious fixes, and their source code isn't always published.
  - LineageOS releases a major version about every six months.
  - Phones on the 5.10 GKI kernel lose support at Android 17 QPR1.
- **Phones:**
  - Samsung (One UI 8) and Xiaomi (HyperOS) have mostly stopped letting owners unlock the bootloader.
  - Relocking with your own key is proven only on Pixels and the Fairphone 4.
- **Apps:** builds signed with FoxieOS's own keys fail Play Integrity's *device* and *strong* levels, so many banking apps won't work.
- **Legal:** the kernel's source code must be published (GPL); "Android" may only be used to describe FoxieOS; the trademark search for the name "FoxieOS" isn't done yet.

## Related repositories

- [alopex](https://github.com/alopex-org/alopex) researches building a phone, or a similar device, for an Android-based operating system.
  Whether that stays a prototype or becomes a product is its decision D5.
  FoxieOS depends on it for a device of its own, and only in that direction: the hardware project doesn't follow FoxieOS's rules for phones, and FoxieOS adapts to its choices.
  Whether FoxieOS supports a device from it, and on what terms, is roadmap decision [D9](ROADMAP.md#d9-devices-from-the-hardware-project).

Later FoxieOS repositories (the manifest in task T5, and copies of upstream repositories) will live in the same GitHub organization.

## Running the project (planned)

- **Builds and tests:** automatic checks on the build host ([TESTING.md](TESTING.md)).
- **Releases:** signed offline and published through the update channels ([RELEASING.md](RELEASING.md)).
- **Backups:** offline copies of the release keys (made by the maintainer), the release records, and the signed build files of the last two releases.
- **Fixing a bad release:** release a newer, fixed version.
  Going back to an older version is impossible by design (anti-rollback).

## Open questions

The open decisions, the work still to do and the facts still to check are in [ROADMAP.md](ROADMAP.md).
