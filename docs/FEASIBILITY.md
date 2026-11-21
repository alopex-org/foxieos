# FoxieOS feasibility study

The research behind the plan: whether a small team can build and maintain FoxieOS, which base to build it on, and what that takes.
The plan built on it is in [ROADMAP.md](ROADMAP.md) and [DESIGN.md](DESIGN.md).

Sources were checked on 2026-11-20.
Each section ends with the sources behind it, and the [Sources](#sources) section lists every source with what it supports.
⚠ marks a claim that is unconfirmed or disputed; check it before relying on it.
"(unsourced)" marks a statement from general knowledge that was not checked against a source.

## Summary

| Goal | Feasible? |
|---|---|
| A branded LineageOS-based build on 1–3 devices | Yes |
| Support for phones from many manufacturers | Partly, and less each year |
| GrapheneOS-level security on those phones | No |
| Banking and other apps that depend on Play Integrity | Mostly no |
| Sustainable for one person or a small team | Yes, if the scope stays narrow |

- **A branded build on 1–3 devices** takes weeks for one person with a strong build host ([Build host](#build-host)).
- **Phones from many manufacturers** are reachable only through LineageOS device trees or Treble GSIs.
  Samsung and Xiaomi have largely closed bootloader unlocking, and every extra device is ongoing maintenance.
- **GrapheneOS-level security** needs a bootloader that relocks with a custom key, current vendor firmware, and hardware features such as MTE and a secure element.
  Pixels qualify and the Fairphone 4 relocks; most other phones don't.
- **Play Integrity:** since May 2025 the *device* verdict needs a hardware-backed, positive verified-boot result, and the *strong* verdict also needs a security patch from the last 12 months.
  Builds signed with FoxieOS's own keys fail both.
- **Sustainability:** the recurring cost is merging upstream security fixes and rebasing on AOSP's twice-yearly source drops ([Upstream security updates](#upstream-security-updates)).

**Recommendation:** a soft fork of LineageOS 24.0 (Android 17) for a short, explicit list of 2–4 devices that the maintainer owns, with FoxieOS branding, a curated set of apps and privacy defaults.
A Treble GSI can follow later as an "unofficial, best-effort, no verified boot" build.
Don't try to reproduce GrapheneOS's hardening across arbitrary phones.

## Choosing a base

| Base | Devices | Effort | Security ceiling |
|---|---|---|---|
| [Pure AOSP](#pure-aosp) | Cuttlefish, emulator, GSIs | High | High on Pixels |
| [LineageOS](#lineageos) (chosen) | About 150 | Medium | Medium |
| [GrapheneOS](#grapheneos) | Pixels | High | Highest |
| [CalyxOS, /e/OS, crDroid, iodéOS](#other-lineageos-derivatives) | Varies | Medium | Medium |
| [Treble GSI](#treble-gsi) | Most Treble devices | Low to medium | Low |

### Pure AOSP

- Runs on Cuttlefish, the emulator and GSIs, and on Pixels only with device trees you write yourself.
- Since Android 16 (June 2025), Google no longer publishes Pixel device trees or new driver binaries, and Pixel kernel source ships as squashed snapshots.
- Cuttlefish is Google's reference target.
- From 2026, AOSP source is published only in Q2 and Q4.
- From Android 17 the AOSP tree is read-only, and builders should use the `android-latest-release` manifest branch.

Sources: [9to5Google on Pixel source][9to5-pixel-source], [AOSP Android 17 release notes][aosp-17-notes], [Android Authority on the AOSP schedule][aa-aosp-schedule], [PiunikaWeb][piunika-aosp].

### LineageOS

- About 150 devices on LineageOS 23.2; 24.0 is rolling out.
  It is the best route to supporting a range of devices.
- The current branch is `lineage-24.0` (Android 17), released on 2026-10-11 with a WebUSB flasher.
  The previous one, 23.2, is Android 16 QPR2, from February 2026 (one outlet says QPR1).
- LineageOS now ships a major version about every six months.
- Devices on kernels 4.4 and 4.9 are supported officially only up to LineageOS 22.2.
- Most devices can't be relocked, which caps the security it can offer.

Sources: [9to5Google on LineageOS 24][9to5-lineage24], [heise][heise-lineage24], [CyberInsider][cyberinsider-lineage24], [Android Authority on 23.2][aa-lineage232].

### GrapheneOS

- Supports the Pixel 6 to the Pixel 10a.
  A Motorola partner device is expected in 2027, announced at MWC in March 2026; ⚠ only one source names it ("Motorola Signature 27").
- The code is mostly MIT or Apache-2.0, with some GPL-2.0, so it can be forked; its name and branding can't be used.
- Its build guide generates Pixel vendor files with `adevtool`.
- Rebasing its changes every release is heavy work, and upstream help can't be expected.

Sources: [9to5Google on Motorola][9to5-graphene-moto], [Android Authority on Motorola][aa-graphene-moto], [GSMArena on Motorola][gsmarena-graphene-moto], [Wikipedia on GrapheneOS][wikipedia-graphene], [GrapheneOS build guide][graphene-build].

### Other LineageOS derivatives

- CalyxOS, /e/OS, crDroid or iodéOS could serve as a base, but each adds another upstream layer between FoxieOS and AOSP.
- iodéOS is the reference for flashing a custom AVB key on Fairphones.

Sources: [iodé forum on the Fairphone 5][iode-fp5].

### Treble GSI

- One image for most Treble devices, those launched with Android 9 or later (unsourced).
- Per-device quirks, no relocking with a custom key, and stale vendor firmware.
- Google published Android 16 GSI binaries in February 2026.
  Community Android 16 QPR2 GSIs exist, such as a crDroid GSI and an unofficial LineageOS GSI (unsourced).
- ⚠ The Android 17 status of TrebleDroid (phhusson's GSI) is unknown.

Sources: [Android 16 GSI release notes][gsi16].

## Technical constraints

### Bootloader unlocking

Unlocking is required, which rules out:

- **Samsung:** One UI 8 (mid-2025) removed the OEM-unlock option on new firmware, reportedly in all regions; US models were already locked.
  The reports date from July 2025, and no official Samsung statement was found.
- **Xiaomi:** HyperOS needs a forum-approved unlock, allows one unlocked device per year (since 2025), is stricter in China, and unlocked devices lose official OTA updates.
- Carrier-locked phones, and Huawei (unsourced).

Sources: [SamMobile][sammobile-oneui8], [GSMArena on Samsung][gsmarena-oneui8], [Android Authority on Xiaomi][aa-xiaomi], [GSMArena on Xiaomi][gsmarena-xiaomi].

### Relocking with a custom key

Relocking the bootloader with a custom verified-boot key (`avb_custom_key`):

- **Pixels:** supported on every Pixel with an unlockable bootloader since the Pixel 2.
  Relocking fails if the build isn't signed with the flashed key.
- **Fairphone 4:** confirmed by Fairphone support.
- **Fairphone 5 and 6:** ⚠ forum reports of failures and bricks.
  On the Fairphone 6, a self-signed key passes the custom-key screen, but the phone drops to the bootloader when locked.
- **Stock LineageOS** builds can be relocked only when signed with your own AVB key (`WITH_AVB := true` plus flashing `avb_custom_key.bin`).
- **Everywhere else** the device stays unlocked: it is weaker against physical attacks, shows a warning at every boot, and gets no Play Integrity *device* verdict.

Sources: [AOSP device state][aosp-device-state], [avbroot][avbroot], [Fairphone forum on the Fairphone 4][fp4-forum], [iodé forum on the Fairphone 5][iode-fp5], [Fairphone forum on the Fairphone 6][fp6-forum], [LineageOS signing builds][lineage-signing].

### Vendor firmware

The modem, TEE and GPU driver depend on the manufacturer's firmware for their security.
When the manufacturer stops updating it, FoxieOS can only patch the AOSP layers, so every device gets a published end-of-life date.
Pixel 8 and later get seven years of OS and security updates, counted from availability in the US Google Store; the Pixel 6 and 7 families and the Pixel Fold get five.

Sources: [Pixel update policy][pixel-updates].

### Kernel

- Devices that launch with kernel 5.10 or later (Android 12 or later) must ship Google's Generic Kernel Image (GKI 2.0), and vendor modules use a stable kernel module interface.
- `android12-5.10` and `android13-5.10` lose support from Android 17 QPR1, so prefer devices on 5.15 or newer.
- Older devices without GKI need kernel backports, one device at a time.
- End of life of the newer GKI branches: `android13-5.15` and `android14-5.15` on 2028-07-01, `android14-6.1` on 2029-07-01, `android15-6.6` on 2028-07-01, `android16-6.12` on 2029-07-01, `android17-6.18` on 2030-07-01.

Sources: [AOSP GKI][aosp-gki], [Android common kernels][aosp-common-kernels].

### Play Integrity

- Since May 2025, every verdict uses hardware-backed signals on Android 13 and later.
  The *device* verdict needs a positive verified-boot result; the *strong* verdict needs a security patch less than 12 months old.
- Banking apps, Google Wallet tap-to-pay and some DRM apps will break.
- The LineageOS charter forbids altering Play Integrity responses, and FoxieOS adopts the same rule ([DEVICES.md](DEVICES.md#device-charter)).

Sources: [Android Developers][play-integrity], [Android Authority on hardware attestation][aa-play-integrity], [LineageOS charter][lineage-charter].

### Google apps

They can't be shipped without a licence for Google Mobile Services. The options:

- None (de-Googled).
- microG.
  ⚠ LineageOS reportedly added built-in signature spoofing, restricted to microG, in February 2024; only community sources say so.
  Confirm it on the 24.0 branch (roadmap check C13).
- A sandboxed Google Play compatibility layer like GrapheneOS's.
  It exists there, but porting it is a large project.

Sources: [microG wiki][microg-spoofing].

### Upstream security updates

- Since mid-2025, Google's Risk-Based Update System puts only high-risk fixes in the monthly bulletins and bundles the rest into quarterly releases (March, June, September and December).
- Some monthly bulletins are now empty (July 2025, February 2026).
- The source for the monthly fixes is no longer reliably published to AOSP when the bulletin comes out, and full platform source is published only in Q2 and Q4.
- So FoxieOS gets most of its security fixes through LineageOS and the twice-yearly AOSP drops, not monthly.
- The security patch level must be reported honestly; Play Integrity's *strong* verdict depends on it too.

Sources: [heise on the new patch strategy][heise-rbus], [Android Authority on risk-based updates][aa-rbus], [Android Authority on the AOSP schedule][aa-aosp-schedule].

## Build host

### Requirements

- **AOSP:** 64-bit x86 Linux, at least 64 GB of RAM, and about 400 GB of free disk (250 GB for the checkout, 150 GB for the build).
  A full build takes about 40 minutes on 72 cores with 64 GB, and about 6 hours on 6 cores with 64 GB.
- **GrapheneOS:** at least 32 GiB of RAM, 136 GiB for the sync, and 100 GiB or more for the build.
- **LineageOS:** its device build pages list 400 GB of disk and 64 GB of RAM for lineage-21 and later.
- **FoxieOS plans for** 64 GB of RAM plus zram (or 96 GB or more without), 16 or more cores, and a 1 TB NVMe drive: room for two branches, a ccache of 50–100 GB, and CTS.
  The candidate hosts are in [ROADMAP.md](ROADMAP.md#d2-build-host).
- Incremental builds with ccache are what make CI practical.
- KVM, for Cuttlefish and the emulator.

Sources: [AOSP hardware requirements][aosp-requirements], [AOSP build times][aosp-start-requirements], [GrapheneOS build guide][graphene-build], [LineageOS build page for shiba][lineage-shiba-build], [Cuttlefish: get started][cf-start].

### Android 17's memory floor

Before anything compiles, `soong_build` reads every `Android.bp` file and holds the whole module graph in one process.
There is no official figure for its memory use, only reports:

- Emteria (June 2026): 53.6 GiB on Android 17, still rising when the kernel killed it.
- A user on XDA building LineageOS 24 with 32 GB of RAM: 35.8 GB went to zram (zstd, sized at twice the RAM) during that step, compressed to 5.7 GB.
  The post gives no build times.

So fewer parallel jobs (`-j`) don't lower this peak, and RAM doesn't add up across machines.
Cover it with 96 GB of RAM or more, or with zram sized at twice the RAM on a 32 or 64 GB host.
Roadmap task T2 measures the real peak (check C2).

Sources: [Emteria][emteria], [XDA][xda-memory].

### How strict the memory floor is

From Soong's source on the `lineage-24.0` branch, read on 2026-11-20 (line numbers can drift):

- Soong enforces no minimum.
  Its only memory check, `checkRAM`, prints a warning at 16 GB or less, or when `-j` is higher than the RAM in GB, and then builds anyway.
  The 64 GB that AOSP and LineageOS give is a recommendation ([build.go][soong-checkram]).
- The hard limit is RAM plus swap.
  If `soong_build` doesn't fit, the kernel kills it and the build stops, as in Emteria's run.
  zram counts as swap and trades CPU time for RAM.
  Disk swap also avoids the kill, but is likely much slower, because Go's garbage collector keeps walking the whole heap (unsourced).
- The peak comes only when Soong re-analyses the tree: the first build, a sync that changes `Android.bp` files, or a change of product or environment.
  A rebuild after editing sources reuses the graph (unsourced; roadmap check C2).
- `-j` matters in the compile phase that follows.
  Soong already limits its high-memory jobs to 1 at 16 GB or less, 2 at 32 GB or less, and otherwise to the lower of RAM ÷ 8 GB and `-j`; `NINJA_HIGHMEM_NUM_JOBS` overrides it ([config.go][soong-highmem]).
- Go's memory settings (`GOGC`, `GOMEMLIMIT`) can't be set from the shell: the step that runs `soong_build` gets an environment holding only `TOP` and `PATH` (plus `SISO_EXPERIMENTS` under Siso).
  Changing that would take a carry patch to `build/soong` ([soong.go][soong-env]).
- zram-generator's default device is min(RAM ÷ 2, 4 GiB), and it recommends 0.1–0.5 × RAM for general use, so the build host needs `zram-size` set explicitly ([zram-generator example][zram-example]).

### Spreading the work over several machines

Not planned yet.

- The build-graph step, and every action not sent to a worker, runs on the machine that holds the source tree.
  Extra machines can't stand in for its RAM.
- Compiling can be spread.
  Soong has remote execution built in (`USE_RBE`), with a local or remote strategy for each action type, covering C++, javac, r8 and d8.
  Its client (`reproxy`, `rewrapper`) is in `prebuilts/remoteexecution-client`, which the lineage-24.0 manifest syncs.
  The server can be any Remote Execution API service, such as a self-hosted Buildbarn.
- A community guide (AOSP 15, Buildbarn on two hosts) reports a first build of 3 h 42 min, with about 76 GB of network traffic and a 71 GB cache, and 1 h 42 min for a rebuild served entirely from the cache.
  The local steps above remain.
- Chromium announced in July 2025 that it would remove that client (reclient) at the end of September 2025 and move to Siso.
  ⚠ Its upkeep outside Google is uncertain; nothing was found on Android's plans for it.
- lineage-24.0's Soong already runs builds with Siso by default (`NINJA_DEFAULT`).
  With `USE_RBE=true`, remote execution still goes through reclient (`rewrapper`) unless `USE_REWRAPPER=false` selects the native Remote Execution API path, which only Siso offers and which the source says is not the default yet.
  ⚠ Whether that path works with a self-hosted server is unchecked.
- Reconsider remote execution only if task T2 shows that compiling dominates the build time.
- Tests spread easily.
  Cuttlefish and CTS can run on a second host from copied images, and one CTS run can be split across hosts with Tradefed's distributed sharding (`--shard-count N --shard-index i`): every host builds the same test list and runs a disjoint slice of it.
  Tradefed doesn't merge sharded results, so the CI script has to.

Sources: [Soong rbe.md][soong-rbe], [LineageOS manifest][lineage-manifest], [Buildbarn for AOSP][buildbarn], [Chromium PSA on reclient][chromium-reclient], [Soong config.go][soong-config], [Tradefed sharding][tf-sharding], [sharded results][tf-sharded-runner].

### Test hosts and bandwidth

- A CTS host needs at least 32 GB of RAM and 256 GB of disk, JDK 11 or later, `adb`, `aapt2`, and FFmpeg 5.1.3 or later.
  It can be the build host ([CTS][cts]).
- Release bandwidth: roughly 1–2 GB per full update per device, plus incremental updates (unsourced).
  That needs a mirror or CDN over HTTPS; the LineageOS Updater rejects URLs that aren't HTTPS ([Updater README][updater-readme]).

## Signing and updates

### Keys a release needs

- Platform keys: `releasekey`, `platform`, `shared`, `media`, `networkstack`, `bluetooth`, `nfc` and `sdk_sandbox`.
  LineageOS also generates `cyngn-app`, `testcert` and `verity`.
- About 70 APEX keys (SHA256_RSA4096).
- An AVB key (RSA-4096).
- LineageOS ships `lineage-priv-template/keys.sh`, which generates all of them, but without passwords; its `check_keys.py` checks a signed build.
  GrapheneOS encrypts its keys with scrypt and AES-256, with one passphrase per device.
- Keep the keys offline.
  Changing keys later forces users to migrate or wipe their phones.

Sources: [LineageOS signing builds][lineage-signing], [AOSP signing builds][aosp-sign], [GrapheneOS build guide][graphene-build].

### Update server

- A static HTTPS host is enough; GrapheneOS works this way.
- The LineageOS Updater instead queries a JSON API, configured with `updater_server_url` (a resource) or `lineage.updater.uri` (a property), with `{device}`, `{type}` and `{incr}` placeholders.
  ⚠ The full JSON schema still has to be read from the Updater's README (roadmap check C10).

Sources: [GrapheneOS build guide][graphene-build], [Updater README (/e/OS fork)][updater-readme].

## Device selection

Include a device only if **all** of these hold:

- Its bootloader can be unlocked officially, which rules out Samsung on One UI 8 or later and most Xiaomi phones.
  Relocking with a custom AVB key is preferred.
- LineageOS 24.0 supports it officially and has an active maintainer for it, or it is a Treble device with a GKI kernel, for the GSI track.
- Preferably a 5.15 GKI kernel or newer: 5.10 drops out at Android 17 QPR1, and 4.4 and 4.9 stop at LineageOS 22.2.
- The manufacturer still ships firmware and security updates.
- A FoxieOS maintainer owns one; the LineageOS charter has the same rule.

One maintainer can sustain about 2–4 devices on a LineageOS base (unsourced estimate).

First-tier candidates, checked on 2026-11-20 (the full table is in [DEVICES.md](DEVICES.md#candidates-for-device-1)):

- **Pixel 8 to Pixel 10a:** all on LineageOS 24.0, relockable, with Google's seven-year window; GrapheneOS shows they can be built.
- **Fairphone 4:** on 24.0 and relockable, but its kernel is 4.19, not GKI.
- **OnePlus 13 and Sony Xperia 10 VII:** on 24.0 with kernel 6.6, but ⚠ no documented custom-key relocking.

Second tier: anything through a GSI, labelled "unofficial".

Sources: [LineageOS devices][lineage-devices], [Pixel update policy][pixel-updates], [LineageOS charter][lineage-charter].

## Project and legal checklist

- [ ] **Name:** a web search found no existing "FoxieOS".
  The EUIPO and USPTO trademark searches are still to do before a public launch (roadmap check C12).
- [ ] **Logo:** confirm that the maintainer holds the rights to the fox artwork, then make an SVG master plus adaptive-icon and boot-animation variants.
- [ ] **"Android" trademark:** use it only as a descriptor followed by a generic term ("an operating system based on Android"), never as the product name.
  Add the attribution "Android is a trademark of Google LLC."
  Don't use the Android wordmark typeface or anything derived from the robot logo ([Android brand guidelines][android-brand]).
- [ ] **Licences:** keep the Apache-2.0 notices, and publish the GPL-2.0 source for every shipped kernel; the LineageOS charter also requires GPLv2 kernel contributions.
  Credit cherry-picks from GrapheneOS and CalyxOS, whose code is MIT or Apache ([LineageOS charter][lineage-charter], [Wikipedia on GrapheneOS][wikipedia-graphene]).
- [ ] **Vendor blobs:** follow the extract-files model, as the LineageOS charter requires a working extraction script, and don't redistribute blobs beyond what upstream already does ([LineageOS charter][lineage-charter]).

## Risks

| Risk | Impact | Mitigation |
|---|---|---|
| Google keeps reducing how open AOSP is | High | Build on LineageOS, which absorbs much of it; budget for the Q2 and Q4 rebases |
| Manufacturers closing their bootloaders | High for broad device support | Keep the device list narrow; prefer Pixels and Fairphones |
| Maintainer burnout, missed patches | High | Few devices; automated builds and tests; published end-of-life dates |
| Release keys stolen or lost | Critical | Offline, encrypted keys with backups; agents never handle them |
| Apps that need Play Integrity | Medium to high | Document it clearly; never promise banking support; never tamper with verdicts |
| Bricked phones, especially from relocking | Medium to high | An install guide per device; never advise relocking unproven devices; staged rollout |

## Further reading

- source.android.com: requirements, Cuttlefish, atest, CTS, OTA updates, signing.
- wiki.lineageos.org: device build pages, `signing_builds`, `emulator`.
- github.com/LineageOS/charter: the device support requirements.
- grapheneos.org/build: signing, reproducible builds, the update server and channels.
- github.com/alopex-org/foxieos-hardware: the separate research into building a prototype device for enthusiasts.

## Sources

All checked on 2026-11-20.

### AOSP and Google

- [AOSP hardware requirements][aosp-requirements]: at least 64 GB of RAM and about 400 GB of disk.
- [AOSP build times][aosp-start-requirements]: about 40 minutes on 72 cores and 6 hours on 6 cores, with 64 GB.
- [AOSP Android 17 release notes][aosp-17-notes]: the read-only tree and the `android-latest-release` branch.
- [AOSP GKI][aosp-gki]: GKI 2.0 for devices launching on 5.10 or later; 5.10 unsupported from Android 17 QPR1.
- [Android common kernels][aosp-common-kernels]: end-of-life dates of the GKI branches.
- [AOSP device state][aosp-device-state]: `avb_custom_key` on Pixels.
- [AOSP signing builds][aosp-sign]: the keys a release needs.
- [Cuttlefish: get started][cf-start] and [google/android-cuttlefish][cf-github]: host requirements, Debian packages and container images.
- [Cuttlefish: run CTS][cf-cts]: the `cts-virtual-device-stable` plan; not all of CTS passes on Cuttlefish.
- [CTS][cts]: host requirements and device setup.
- [Tradefed sharding][tf-sharding] and [sharded results][tf-sharded-runner]: distributed sharding; results are not aggregated.
- [Soong rbe.md][soong-rbe]: remote execution with `USE_RBE`.
- [Android 16 GSI release notes][gsi16]: Google's Android 16 GSI binaries (February 2026).
- [Pixel update policy][pixel-updates]: seven years for Pixel 8 and later, five for the Pixel 6 and 7 families and the Pixel Fold.
- [Play Integrity improvements][play-integrity]: the May 2025 verdict changes.
- [Android brand guidelines][android-brand]: how "Android" may be used.
- [Chromium PSA on reclient][chromium-reclient]: reclient to be removed at the end of September 2025, moving to Siso.

### LineageOS

- [LineageOS devices][lineage-devices] and each device's page: which devices run 24.0, their kernels and maintainers.
- [Build page for shiba][lineage-shiba-build]: the `repo init` flags for 24.0; 64 GB of RAM and 400 GB of disk.
- [Emulator page][lineage-emulator]: the emulator build; the manifest sets `-c` and `-j4` for `repo sync`.
- [AndroidProducts.mk][lineage-products] and [lineage_cf_phone_x86_64.mk][lineage-cf-mk]: the virtual targets on 24.0.
- [LineageOS manifest][lineage-manifest]: syncs `prebuilts/remoteexecution-client`.
- [Signing builds][lineage-signing]: the key list, `keys.sh` (no passwords) and `check_keys.py`.
- [Device support requirements][lineage-charter]: the charter FoxieOS's device charter is adapted from.
- [gs-6.1 kernel manifest][gs61-manifest] and [shusky-kernels][shusky-kernels]: Pixel kernels built in a separate Kleaf workspace, pinned to `android14-6.1-2026-03_r25`.
- Soong on lineage-24.0: [`checkRAM` in build.go][soong-checkram], [`HighmemParallel` in config.go][soong-highmem], [the `soong_build` environment in soong.go][soong-env], [Siso and remote execution in config.go][soong-config].

### News and community reports

- [Android Authority on the AOSP schedule][aa-aosp-schedule] and [PiunikaWeb][piunika-aosp]: AOSP source only in Q2 and Q4 from 2026.
- [9to5Google on Pixel source][9to5-pixel-source]: no Pixel device trees from Android 16; squashed kernel history.
- [9to5Google][9to5-lineage24], [heise][heise-lineage24] and [CyberInsider][cyberinsider-lineage24]: LineageOS 24.0, released 2026-10-11.
- [Android Authority on LineageOS 23.2][aa-lineage232]: 23.2 is Android 16 QPR2.
- [heise][heise-rbus] and [Android Authority][aa-rbus]: Google's risk-based security updates.
- [SamMobile][sammobile-oneui8] and [GSMArena][gsmarena-oneui8]: One UI 8 removed OEM unlocking.
- [Android Authority][aa-xiaomi] and [GSMArena][gsmarena-xiaomi]: Xiaomi's unlock policy.
- [Android Authority on Play Integrity][aa-play-integrity]: hardware-backed attestation.
- [9to5Google][9to5-graphene-moto], [Android Authority][aa-graphene-moto] and [GSMArena][gsmarena-graphene-moto]: GrapheneOS's Motorola partnership.
- [Wikipedia on GrapheneOS][wikipedia-graphene]: its licences.
- [Fairphone forum on the Fairphone 4][fp4-forum]: custom-key relocking works.
- [iodé forum on the Fairphone 5][iode-fp5] and [Fairphone forum on the Fairphone 6][fp6-forum]: ⚠ relocking failures.
- [avbroot][avbroot]: relocking fails unless the build is signed with the flashed key.
- [microG wiki][microg-spoofing]: ⚠ LineageOS's built-in signature spoofing.
- [/e/OS fork of the Updater, README][updater-readme]: the Updater's server URL and HTTPS requirement.
- [Emteria][emteria] and [XDA][xda-memory]: memory use of Android 17's build-graph step.
- [Buildbarn for AOSP][buildbarn]: a remote-execution setup with timings.
- [zram-generator example config][zram-example]: the default zram size.
- [GrapheneOS build guide][graphene-build]: build requirements, encrypted keys, `adevtool`, the update server and channels.

### Hosting and CI

- [GitHub's plans][gh-plans] and [about protected branches][gh-protected]: code owners and protected branches are included for public repositories on every plan.
- [About self-hosted runners][gh-self-hosted] and [billing for Actions][gh-billing]: self-hosted runners don't use the plan's included Actions minutes.
- [Secure use reference][gh-hardening]: GitHub advises against self-hosted runners for public repositories, because pull requests can run code on them.
- [Hetzner EX63][hetzner-ex63] and [Hetzner AX102][hetzner-ax102]: rented build-host prices.

[9to5-graphene-moto]: https://9to5google.com/2026/03/01/motorola-confirms-grapheneos-partnership-for-a-future-smartphone-porting-features/
[9to5-lineage24]: https://9to5google.com/2026/10/12/lineageos-24-launches-based-on-android-17-with-app-redesigns-and-simple-flash-tool/
[9to5-pixel-source]: https://9to5google.com/2025/06/12/android-open-source-project-pixel-change/
[aa-aosp-schedule]: https://www.androidauthority.com/aosp-source-code-schedule-3630018/
[aa-graphene-moto]: https://www.androidauthority.com/grapheneos-motorola-partnership-announced-3645710/
[aa-lineage232]: https://www.androidauthority.com/lineageos-23-2-released-3638860/
[aa-play-integrity]: https://www.androidauthority.com/google-play-integrity-hardware-attestation-3561592/
[aa-rbus]: https://www.androidauthority.com/android-risk-based-security-updates-3597466/
[aa-xiaomi]: https://androidauthority.com/xiaomi-hyperos-bootloader-unlock-3383687
[android-brand]: https://developer.android.com/distribute/tools/promote/brand
[aosp-17-notes]: https://source.android.com/docs/whatsnew/android-17-release
[aosp-common-kernels]: https://source.android.com/docs/core/architecture/kernel/android-common
[aosp-device-state]: https://source.android.com/docs/security/features/verifiedboot/device-state
[aosp-gki]: https://source.android.com/docs/core/architecture/kernel/generic-kernel-image
[aosp-requirements]: https://source.android.com/docs/setup/requirements
[aosp-sign]: https://source.android.com/docs/core/ota/sign_builds
[aosp-start-requirements]: https://source.android.com/docs/setup/start/requirements
[avbroot]: https://www.github.com/chenxiaolong/avbroot
[buildbarn]: https://www.maksonlee.com/setting-up-a-buildbarn-rbe-cluster-for-aosp-ubuntu-24-04-from-source/
[cf-cts]: https://source.android.com/docs/devices/cuttlefish/cts
[cf-github]: https://github.com/google/android-cuttlefish
[cf-start]: https://source.android.com/docs/devices/cuttlefish/get-started
[chromium-reclient]: https://groups.google.com/a/chromium.org/g/chromium-dev/c/v-WOvWUtOpg/m/2HlNqp-6BgAJ
[cts]: https://source.android.com/docs/compatibility/cts
[cyberinsider-lineage24]: https://cyberinsider.com/lineageos-24-lands-with-android-17-and-upgrade-limits-for-older-devices/
[emteria]: https://emteria.com/blog/android-17-ram-build-requirement
[fp4-forum]: https://forum.fairphone.com/t/bootloader-avb-keys-used-in-roms-for-fairphone-3-4/83448
[fp6-forum]: https://forum.fairphone.com/t/official-lineageos-23-for-the-fairphone-gen-6/132450?page=4
[gh-billing]: https://docs.github.com/en/billing/managing-billing-for-your-products/managing-billing-for-github-actions/about-billing-for-github-actions
[gh-hardening]: https://docs.github.com/en/actions/security-for-github-actions/security-guides/security-hardening-for-github-actions
[gh-plans]: https://docs.github.com/en/get-started/learning-about-github/githubs-plans
[gh-protected]: https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches/about-protected-branches
[gh-self-hosted]: https://docs.github.com/en/actions/hosting-your-own-runners/managing-self-hosted-runners/about-self-hosted-runners
[graphene-build]: https://grapheneos.org/build
[gs61-manifest]: https://github.com/LineageOS/android_kernel_google_gs-6.1_manifest
[gsi16]: https://developer.android.com/about/versions/16/gsi-release-notes
[gsmarena-graphene-moto]: https://www.gsmarena.com/grapheneos_confirms_the_first_motorola_to_support_the_privacyfocused_android_fork-news-74750.php
[gsmarena-oneui8]: https://m.gsmarena.com/samsung_restricts_bootloader_unlocking_on_one_ui_8_devices-news-68788.php
[gsmarena-xiaomi]: https://m.gsmarena.com/xiaomi_phones_with_unlocked_bootloader_wont_get_hyperos_updates-news-60521.php
[heise-lineage24]: https://www.heise.de/en/news/LineageOS-24-is-ready-Android-17-for-many-phones-11492492.html
[heise-rbus]: https://www.heise.de/en/news/Bad-news-for-custom-ROMs-Google-changes-Android-security-patch-strategy-10645674.html
[hetzner-ax102]: https://www.hetzner.com/dedicated-rootserver/ax102/
[hetzner-ex63]: https://www.hetzner.com/dedicated-rootserver/ex63/
[iode-fp5]: https://community.iode.tech/t/booloader-relock-limbo-on-fairphone-5/7394
[lineage-cf-mk]: https://github.com/LineageOS/android_vendor_lineage/blob/lineage-24.0/build/target/product/lineage_cf_phone_x86_64.mk
[lineage-charter]: https://github.com/LineageOS/charter/blob/main/device-support-requirements.md
[lineage-devices]: https://wiki.lineageos.org/devices/
[lineage-emulator]: https://wiki.lineageos.org/emulator
[lineage-manifest]: https://github.com/LineageOS/android/blob/lineage-24.0/default.xml
[lineage-products]: https://github.com/LineageOS/android_vendor_lineage/blob/lineage-24.0/build/target/product/AndroidProducts.mk
[lineage-shiba-build]: https://wiki.lineageos.org/devices/shiba/build/
[lineage-signing]: https://wiki.lineageos.org/signing_builds
[microg-spoofing]: https://www.github.com/microg/GmsCore/wiki/Signature-Spoofing
[piunika-aosp]: https://piunikaweb.com/2026/01/07/android-aosp-source-code-q2-and-q4-pixel-monthly-security-patches-unchanged/
[pixel-updates]: https://support.google.com/nexus/answer/4457705?hl=en
[play-integrity]: https://developer.android.com/google/play/integrity/improvements
[sammobile-oneui8]: https://www.sammobile.com/news/say-goodbye-to-your-custom-roms-as-one-ui-8-kills-bootloader-unlock/
[shusky-kernels]: https://github.com/LineageOS/android_device_google_shusky-kernels/tree/lineage-24.0
[soong-checkram]: https://github.com/LineageOS/android_build_soong/blob/lineage-24.0/ui/build/build.go#L203-L225
[soong-config]: https://github.com/LineageOS/android_build_soong/blob/lineage-24.0/ui/build/config.go
[soong-env]: https://github.com/LineageOS/android_build_soong/blob/lineage-24.0/ui/build/soong.go#L655-L756
[soong-highmem]: https://github.com/LineageOS/android_build_soong/blob/lineage-24.0/ui/build/config.go#L1588-L1616
[soong-rbe]: https://android.googlesource.com/platform/build/soong/+/refs/heads/main/docs/rbe.md
[tf-sharded-runner]: https://source.android.com/docs/core/tests/tradefed/testing/through-tf/sharded-runner
[tf-sharding]: https://source.android.com/docs/core/tests/tradefed/architecture/advanced/sharding
[updater-readme]: https://gitlab.e.foundation/e/os/android_packages_apps_Updater/-/raw/a14/README.md
[wikipedia-graphene]: https://en.wikipedia.org/wiki/GrapheneOS
[xda-memory]: https://xdaforums.com/t/guide-memory-usage-while-building-an-android-17-based-custom-rom.4801562/
[zram-example]: https://github.com/systemd/zram-generator/blob/main/zram-generator.conf.example
