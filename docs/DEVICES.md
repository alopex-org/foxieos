# FoxieOS devices

**Status: no supported phones yet.**
Choosing the first phone is roadmap decision D1, needed from task T7.
Until then, builds and tests run on Cuttlefish, a virtual phone ([TESTING.md](TESTING.md#virtual-phones)).
Sources are in [FEASIBILITY.md](FEASIBILITY.md#sources), and technical words in the [glossary](GLOSSARY.md).

## In short

- FoxieOS will support only a few phones, each owned and tested by a maintainer.
- A phone qualifies only if its owner can officially unlock it, LineageOS supports it, its kernel is recent, and its maker still updates it.
- The recommended first phone is a Google Pixel 8 or newer.

## Supported devices

The columns:

- **Codename:** the phone model's short internal name.
- **Relockable:** whether the bootloader can be locked again with FoxieOS's own key.
- **Kernel:** the kernel version the phone runs.
- **Firmware end of life:** when the maker stops updating the phone's firmware.
- **FoxieOS end of life:** when FoxieOS stops supporting the phone.
- **Maintainer:** the person who owns the phone and tests it.

| Codename | Device | Since | Relockable | Kernel | Firmware end of life | FoxieOS end of life | Maintainer |
|---|---|---|---|---|---|---|---|
| — | — | — | — | — | — | — | — |

## Rules for choosing a phone

A phone is added only if **all** of these are true (the reasons are in [FEASIBILITY.md](FEASIBILITY.md#device-selection)):

- **The owner can unlock it officially.**
  Without unlocking, FoxieOS can't be installed.
  This rules out Samsung phones on One UI 8 or later, and most Xiaomi phones.
  A phone that can be locked again with FoxieOS's own verified-boot (AVB) key is preferred: Pixels and the Fairphone 4 can; ⚠ on the Fairphone 5 and 6 it is unreliable.
- **LineageOS supports it.**
  LineageOS 24.0 supports it officially and it has an active LineageOS maintainer.
  The exception is a phone for the generic-image (GSI) track: a Treble phone with a GKI kernel.
- **Its kernel is recent,** preferably GKI 5.15 or newer.
  5.10 loses support at Android 17 QPR1, and 4.4 and 4.9 stopped at LineageOS 22.2.
- **Its maker still sends updates** for its firmware and security.
- **A FoxieOS maintainer owns one.**

A device from the separate hardware project is decided by roadmap decision [D9](ROADMAP.md#d9-devices-from-the-hardware-project), not by these rules alone.

## What every supported phone must meet

Every supported phone must meet these requirements, adapted from LineageOS's own rules for phones:

- A FoxieOS maintainer owns the phone.
- Android's security rules (SELinux) are switched on, and there is no root access (`su`).
- Storage is encrypted with the phone's security hardware wherever the original software did so.
- The maker's files can be copied from the phone with LineageOS's `extract-files` script, and the kernel is built from source code (on GKI phones, every module that can be).
- Play Integrity is never tampered with.
- An install page gives exact steps and a published end-of-life date.
- Recovery mode and updates are checked for each release.
- The battery doesn't drain unusually fast.
- The phone passes test layers L3–L7 in [TESTING.md](TESTING.md) for each release.

## Candidates for the first phone

Checked on 2026-11-20 against each phone's page on `wiki.lineageos.org` (site generated 2026-11-19).
Every phone in the table runs official LineageOS **24.0**.
Google counts its update period from when a phone went on sale in its US store.
The dates below use the wiki's release dates instead, so they are approximate until checked for the chosen phone (roadmap check C6).

The columns: **Relockable** means the bootloader can be locked again with FoxieOS's own key; **Google updates until** is the end of the maker's update period; **LineageOS maintainers** is how many LineageOS volunteers look after the phone.

| Device | Codename | Kernel | Relockable | Google updates until | On LineageOS since | LineageOS maintainers |
|---|---|---|---|---|---|---|
| Pixel 8 / 8 Pro | `shiba` / `husky` | 6.1 GKI | Yes | about Oct 2030 | 21 | 2 |
| Pixel 8a | `akita` | 6.1 GKI | Yes | about May 2031 | 21 | 1 |
| Pixel 9 / 9 Pro / 9 Pro XL | `tokay` / `caiman` / `komodo` | 6.1 GKI | Yes | about Aug 2031 | 22.1 | 1 |
| Pixel 9a | `tegu` | 6.1 GKI | Yes | about Apr 2032 | 23.0 | 2 |
| Pixel 10 / 10 Pro / 10 Pro XL | `frankel` / `blazer` / `mustang` | 6.6 GKI | Yes | about Aug 2032 | 24.0 (new) | 1 |
| Pixel 10a | `stallion` | 6.1 GKI | Yes | about Feb 2033 | 24.0 (new) | 1 |
| OnePlus 13 | `dodge` | 6.6 GKI | ⚠ not documented | set by OnePlus | 23.0 | 4 |
| Sony Xperia 10 VII | `pdx257` | 6.6 GKI | ⚠ not documented | set by Sony | 23.2 | 2 |
| Fairphone 4 | `FP4` | 4.19, not GKI | Yes | ⚠ not checked | 20 | 1 |

What else matters:

- **Few people behind the Pixels.**
  The same LineageOS volunteer looks after every Pixel, so the Pixels depend on one or two people.
- **Kernel support ends earlier than the phones'.**
  Google's GKI kernels get fixes until a fixed date: `android14-6.1` until 2029-07-01, `android15-6.6` until 2028-07-01.
  After that, kernel fixes for a phone come only from its maker's own releases.
- **Pixel kernels need an extra build step.**
  They are built from source in a separate workspace (Kleaf), from `LineageOS/android_kernel_google_gs-6.1_manifest`, or `gs-6.6` for the Pixel 10, 10 Pro and 10 Pro XL, with a `build_<family>.sh` script for each family of phones.
  The phone's `*-kernels` repository doesn't store the finished kernel, so a Pixel build has a kernel step before `brunch` (roadmap check C7).
  The gs-6.1 manifest currently uses the GKI version `android14-6.1-2026-03_r25`.
- **Ruled out:**
  - The Pixel 6 and 7 families: their five-year update periods end about Oct 2026 (6 and 6 Pro, already past), Jul 2027 (6a), Oct 2027 (7 and 7 Pro) and May 2028 (7a).
  - Motorola edge 2024: kernel 5.10.
  - Fairphone 5: kernel 5.4, and ⚠ relocking is unreliable.
  - Fairphone 6, Nothing Phone (2) and OnePlus Nord 5: still on LineageOS 23.2.
    The Nothing Phone (2) also runs kernel 5.10.

## Ending support for a phone

- Announce it at least 90 days before dropping the phone.
- Record the date in the table above and in the release notes.
- Once the maker stops updating a phone's firmware, every release note from then on marks it "firmware end of life".
