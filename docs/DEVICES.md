# FoxieOS devices

**Status: no supported devices yet.**
Device #1 is roadmap decision D1, needed from task T7.
Until then, builds and tests run on the Cuttlefish virtual device ([TESTING.md](TESTING.md#virtual-devices)).
Sources are in [FEASIBILITY.md](FEASIBILITY.md#sources).

## Supported devices

| Codename | Device | Since | Relockable with a custom key | Kernel | Firmware end of life | FoxieOS end of life | Maintainer |
|---|---|---|---|---|---|---|---|
| — | — | — | — | — | — | — | — |

## Selection criteria

A device is added only if **all** of these hold (the reasoning is in [FEASIBILITY.md](FEASIBILITY.md#device-selection)):

- Its bootloader can be unlocked officially.
  This rules out Samsung phones on One UI 8 or later and most Xiaomi phones.
  A bootloader that can be relocked with a custom verified-boot (AVB) key is preferred: Pixels and the Fairphone 4 can; ⚠ the Fairphone 5 and 6 are unreliable.
- LineageOS 24.0 supports it officially and it has an active LineageOS maintainer, or it is a Treble device with a GKI kernel, for the GSI track.
- It runs a 5.15 GKI kernel or newer, preferably.
  5.10 loses support at Android 17 QPR1, and 4.4 and 4.9 stop at LineageOS 22.2.
- Its manufacturer still ships firmware and security updates.
- A FoxieOS maintainer owns one.

## Device charter

Every supported device must meet this charter, adapted from LineageOS's device support requirements:

- A FoxieOS maintainer owns the device.
- SELinux is enforcing, and there is no `su`.
- Storage encryption is hardware-backed wherever the stock firmware had it.
- `extract-files` works, and the kernel is built from source (on GKI devices, every module that can be).
- Play Integrity is never tampered with.
- An install page gives exact steps and a documented end-of-life date.
- Recovery and the OTA path are verified for each release.
- There is no abnormal battery drain.
- The device passes test layers L3–L7 in [TESTING.md](TESTING.md) for each release.

## Candidates for device #1

Checked on 2026-11-20 against each device's page on `wiki.lineageos.org` (site generated 2026-11-19).
Every device in the table runs official LineageOS **24.0**.
Google counts its update window from availability in the US Google Store; the dates below use the wiki's release dates, so they are approximate until checked for the chosen phone (roadmap check C6).

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

"Relockable" means the bootloader can be relocked with a custom AVB key.

Notes:

- The same LineageOS maintainer is listed on every Pixel, so the Pixel line has a bus factor of one or two.
- GKI branch end of life: `android14-6.1` on 2029-07-01, `android15-6.6` on 2028-07-01.
  After that, kernel fixes for a phone come only from its manufacturer's kernel releases.
- Pixel kernels are built from source in a separate Kleaf workspace (`LineageOS/android_kernel_google_gs-6.1_manifest`, or `gs-6.6` for the Pixel 10, 10 Pro and 10 Pro XL), with a `build_<family>.sh` script per device family.
  The device's `*-kernels` repository git-ignores the binaries, so a Pixel build has a kernel step before `brunch` (roadmap check C7).
  The gs-6.1 manifest currently pins the GKI tag `android14-6.1-2026-03_r25`.
- Ruled out:
  - The Pixel 6 and 7 families: their five-year windows end about Oct 2026 (6 and 6 Pro, already past), Jul 2027 (6a), Oct 2027 (7 and 7 Pro) and May 2028 (7a).
  - Motorola edge 2024: kernel 5.10.
  - Fairphone 5: kernel 5.4, and ⚠ relocking is unreliable.
  - Fairphone 6, Nothing Phone (2) and OnePlus Nord 5: still on LineageOS 23.2.
    The Nothing Phone (2) also runs kernel 5.10.

## End-of-life policy

- Announce at least 90 days before dropping a device.
- Record the date in the table above and in the release notes.
- When a device's firmware is no longer updated by its manufacturer, every release note from then on marks it "firmware end of life".
