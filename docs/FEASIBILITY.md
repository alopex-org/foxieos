# FoxieOS feasibility study

This is the research behind the plan.
It asks whether a small team can build and maintain FoxieOS, what to build it on, and what that takes.
The plan that follows from it is in [ROADMAP.md](ROADMAP.md) and [DESIGN.md](DESIGN.md).
Technical words are explained in the [glossary](GLOSSARY.md).

**How to read it:**

- Sources were checked on 2026-11-20, except those for the [business model](#business-model), checked on 2026-11-22.
- Each section ends with the sources behind it, and the [Sources](#sources) section lists every source with what it supports.
- ⚠ marks a claim that isn't confirmed, or that sources disagree on; check it before relying on it.
- "(unsourced)" marks a statement from general knowledge that wasn't checked against a source.

## Summary

| Goal | Possible? |
|---|---|
| A FoxieOS-branded version of LineageOS on 1–3 phones | Yes |
| Support for phones from many makers | Partly, and less each year |
| Security as strong as GrapheneOS's on those phones | No |
| Banking and other apps that rely on Play Integrity | Mostly no |
| Manageable for one person or a small team | Yes, if it stays small |
| Earning money from it | Not as planned; an open question |

- **A branded version on 1–3 phones** takes one person a few weeks, with a powerful build computer ([Build host](#build-host)).
- **Phones from many makers** can only be reached through LineageOS's support for them, or through generic images (Treble GSIs).
  Samsung and Xiaomi have mostly stopped letting owners unlock their phones, and every extra phone is ongoing work.
- **GrapheneOS-level security** needs a phone that can be locked again with your own key, up-to-date firmware from the maker, and hardware security features such as MTE and a secure element.
  Pixels have all of this and the Fairphone 4 can be locked again; most other phones can't.
- **Play Integrity:** since May 2025, Google's *device* level needs the phone's security hardware to confirm an unmodified, verified start-up, and the *strong* level also needs a security patch from the last 12 months.
  Builds signed with FoxieOS's own keys fail both.
- **Keeping it going:** the regular work is taking in security fixes from upstream, and moving to Google's new code twice a year ([Upstream security updates](#upstream-security-updates)).
- **Earning money:** free alternatives run on the same phones, and selling FoxieOS or phones with it would bring EU legal duties the plan doesn't allow for ([Business model](#business-model)).

**Recommendation:** a soft fork of LineageOS 24.0 (Android 17) for a short, fixed list of 2–4 phones that the maintainers own, with FoxieOS branding, a chosen set of apps and privacy settings.
A generic image (Treble GSI) can follow later, labelled "unofficial, best effort, no verified boot".
Don't try to copy GrapheneOS's security onto any phone.

## Choosing a base

What FoxieOS could be built on, and what each choice means.
"Security ceiling" is the best security each base can reach.

| Base | Phones | Effort | Security ceiling |
|---|---|---|---|
| [Plain AOSP](#plain-aosp) | Virtual phones and generic images | High | High on Pixels |
| [LineageOS](#lineageos) (proposed) | About 150 | Medium | Medium |
| [GrapheneOS](#grapheneos) | Pixels | High | Highest |
| [CalyxOS, /e/OS, crDroid, iodéOS](#other-lineageos-derivatives) | Varies | Medium | Medium |
| [Generic image (Treble GSI)](#treble-gsi) | Most Treble phones | Low to medium | Low |

### Plain AOSP

Google's public Android code, on its own.

- It runs on Google's virtual phones (Cuttlefish and the emulator) and as a generic image; on Pixels only with phone files you write yourself.
- Since Android 16 (June 2025), Google no longer publishes the files for its Pixel phones or new driver files, and it publishes the Pixel kernel code without its history.
- Cuttlefish is Google's reference virtual phone.
- From 2026, Google publishes AOSP's code only in Q2 and Q4.
- From Android 17 Google's public code is read-only, and builders should use the `android-latest-release` branch.

Sources: [9to5Google on Pixel source][9to5-pixel-source], [AOSP Android 17 release notes][aosp-17-notes], [Android Authority on the AOSP schedule][aa-aosp-schedule], [PiunikaWeb][piunika-aosp].

### LineageOS

The best-known free version of Android, for many phones.

- About 150 phones on LineageOS 23.2; 24.0 is rolling out.
  It is the best way to support a range of phones.
- The current version is `lineage-24.0` (Android 17), released on 2026-10-11 with a tool for installing it from a web browser (WebUSB).
  The previous one, 23.2, is Android 16 QPR2, from February 2026 (one news site says QPR1).
- LineageOS now releases a major version about every six months.
- Phones with the old kernels 4.4 and 4.9 are officially supported only up to LineageOS 22.2.
- Most phones can't be locked again after installing it, which limits the security it can offer.

Sources: [9to5Google on LineageOS 24][9to5-lineage24], [heise][heise-lineage24], [CyberInsider][cyberinsider-lineage24], [Android Authority on 23.2][aa-lineage232].

### GrapheneOS

A version of Android focused on security, for Pixels.

- It supports the Pixel 6 to the Pixel 10a.
  A Motorola phone made with GrapheneOS is expected in 2027, announced at MWC in March 2026; ⚠ only one source names it ("Motorola Signature 27").
- Its code is mostly under the MIT or Apache-2.0 licences, with some GPL-2.0, so it can be copied and changed; its name and branding can't be used.
- Its build guide makes the Pixel's vendor files with a tool called `adevtool`.
- Moving its changes onto every new version is heavy work, and GrapheneOS can't be expected to help.

Sources: [9to5Google on Motorola][9to5-graphene-moto], [Android Authority on Motorola][aa-graphene-moto], [GSMArena on Motorola][gsmarena-graphene-moto], [Wikipedia on GrapheneOS][wikipedia-graphene], [GrapheneOS build guide][graphene-build].

### Other LineageOS derivatives

- CalyxOS, /e/OS, crDroid or iodéOS could serve as a base, but each adds another layer between FoxieOS and Google's code.
- iodéOS is the example to follow for installing your own verified-boot key on Fairphones.

Sources: [iodé forum on the Fairphone 5][iode-fp5].

### Treble GSI

One generic system image for many phones.

- One image works on most Treble phones, those that launched with Android 9 or later (unsourced).
- But it behaves differently on each phone, can't be locked with your own key, and uses old firmware from the maker.
- Google published Android 16 generic images in February 2026.
  Volunteer-made Android 16 QPR2 generic images exist, such as a crDroid GSI and an unofficial LineageOS GSI (unsourced).
- ⚠ Whether TrebleDroid (phhusson's GSI) supports Android 17 is unknown.

Sources: [Android 16 GSI release notes][gsi16].

## Technical constraints

### Bootloader unlocking

Installing FoxieOS needs an unlocked bootloader, which rules out:

- **Samsung:** One UI 8 (mid-2025) removed the unlock option on new software, reportedly in all regions; US models were already locked.
  The reports date from July 2025, and no official Samsung statement was found.
- **Xiaomi:** HyperOS needs unlock approval through Xiaomi's forum, allows one unlocked phone per year (since 2025), is stricter in China, and unlocked phones stop getting Xiaomi's updates.
- Phones locked by a mobile network, and Huawei phones (unsourced).

Sources: [SamMobile][sammobile-oneui8], [GSMArena on Samsung][gsmarena-oneui8], [Android Authority on Xiaomi][aa-xiaomi], [GSMArena on Xiaomi][gsmarena-xiaomi].

### Relocking with a custom key

Locking the bootloader again with your own verified-boot key (`avb_custom_key`) makes a phone much safer, but only some phones allow it:

- **Pixels:** supported on every Pixel with an unlockable bootloader since the Pixel 2.
  Locking fails if the system isn't signed with the key you stored.
- **Fairphone 4:** confirmed by Fairphone support.
- **Fairphone 5 and 6:** ⚠ forum reports of failures and phones made unusable (bricked).
  On the Fairphone 6, your own key passes the custom-key screen, but the phone falls back to the bootloader when locked.
- **Plain LineageOS** can be locked again only when it is signed with your own verified-boot key (`WITH_AVB := true`, plus storing `avb_custom_key.bin` on the phone).
- **Everywhere else** the phone stays unlocked: it is easier to attack for someone who holds it, shows a warning at every start-up, and fails Play Integrity's *device* level.

Sources: [AOSP device state][aosp-device-state], [avbroot][avbroot], [Fairphone forum on the Fairphone 4][fp4-forum], [iodé forum on the Fairphone 5][iode-fp5], [Fairphone forum on the Fairphone 6][fp6-forum], [LineageOS signing builds][lineage-signing].

### Vendor firmware

The modem, the secure area of the processor (TEE) and the graphics driver depend on the maker's firmware for their security.
When the maker stops updating it, FoxieOS can only fix the Android parts, so every phone gets a published end-of-life date.
Pixel 8 and later get seven years of system and security updates, counted from when they went on sale in Google's US store; the Pixel 6 and 7 families and the Pixel Fold get five.

Sources: [Pixel update policy][pixel-updates].

### Kernel

- Phones that launch with kernel 5.10 or later (Android 12 or later) must use Google's shared kernel (GKI 2.0), and the maker's add-ons must use a stable interface to it.
- `android12-5.10` and `android13-5.10` lose support from Android 17 QPR1, so prefer phones on 5.15 or newer.
- Older phones without GKI need fixes copied back into their kernels, one phone at a time.
- End-of-support dates of the newer GKI versions: `android13-5.15` and `android14-5.15` on 2028-07-01, `android14-6.1` on 2029-07-01, `android15-6.6` on 2028-07-01, `android16-6.12` on 2029-07-01, `android17-6.18` on 2030-07-01.

Sources: [AOSP GKI][aosp-gki], [Android common kernels][aosp-common-kernels].

### Play Integrity

Google's check that apps use to decide whether they trust a phone.

- Since May 2025, every level of the check uses signals from the phone's security hardware on Android 13 and later.
  The *device* level needs a confirmed, unmodified start-up; the *strong* level also needs a security patch less than 12 months old.
- Banking apps, Google Wallet's tap-to-pay and some video apps that protect their content will stop working.
- LineageOS's rules forbid faking Play Integrity results, and FoxieOS adopts the same rule ([DEVICES.md](DEVICES.md#what-every-supported-phone-must-meet)).

Sources: [Android Developers][play-integrity], [Android Authority on hardware attestation][aa-play-integrity], [LineageOS charter][lineage-charter].

### Google apps

Google's apps can't be included without a licence for Google Mobile Services.
The options:

- None (a phone without Google).
- microG, a free replacement for some Google services.
  ⚠ LineageOS reportedly added a built-in way, in February 2024, for microG alone to stand in for Google's services (signature spoofing); only community sources say so.
  Confirm it on the 24.0 version (roadmap check C13).
- A compatibility layer that runs Google Play inside a sandbox, like GrapheneOS's.
  It exists there, but bringing it over would be a large project.

Sources: [microG wiki][microg-spoofing].

### Upstream security updates

How security fixes reach FoxieOS.

- Since mid-2025, Google puts only the most serious fixes in its monthly security bulletins, and bundles the rest into quarterly releases (March, June, September and December).
  Google calls this its Risk-Based Update System.
- Some monthly bulletins are now empty (July 2025, February 2026).
- The source code for the monthly fixes no longer reliably appears in AOSP when the bulletin comes out, and the full code is published only in Q2 and Q4.
- So FoxieOS gets most of its security fixes through LineageOS and Google's twice-yearly code releases, not monthly.
- The security patch level must be reported honestly; Play Integrity's *strong* level depends on it too.

Sources: [heise on the new patch strategy][heise-rbus], [Android Authority on risk-based updates][aa-rbus], [Android Authority on the AOSP schedule][aa-aosp-schedule].

## Build host

The computer that builds FoxieOS needs a lot of memory, disk and processing power.

### Requirements

- **AOSP:** 64-bit x86 Linux, at least 64 GB of RAM, and about 400 GB of free disk (250 GB for the code, 150 GB for the build).
  A full build takes about 40 minutes on 72 cores with 64 GB, and about 6 hours on 6 cores with 64 GB.
- **GrapheneOS:** at least 32 GiB of RAM, 136 GiB for the download, and 100 GiB or more for the build.
- **LineageOS:** its build pages list 400 GB of disk and 64 GB of RAM for version 21 and later.
- **FoxieOS plans for** 64 GB of RAM plus zram (or 96 GB or more without it), 16 or more cores, and a 1 TB NVMe drive: room for two versions of the code, 50–100 GB of saved build results (ccache), and the compatibility tests.
  The candidate computers are in [ROADMAP.md](ROADMAP.md#d2-build-host).
- Quick rebuilds that reuse saved results (ccache) are what make automatic checks practical.
- KVM, for the virtual phones.

Sources: [AOSP hardware requirements][aosp-requirements], [AOSP build times][aosp-start-requirements], [GrapheneOS build guide][graphene-build], [LineageOS build page for shiba][lineage-shiba-build], [Cuttlefish: get started][cf-start].

### Android 17's memory floor

Before anything is compiled, one program (`soong_build`) reads every build file (`Android.bp`) and holds the whole picture of the code in memory at once.
There is no official figure for how much memory it needs, only reports:

- Emteria (June 2026): 53.6 GiB on Android 17, still rising when the system stopped it.
- A user on XDA building LineageOS 24 with 32 GB of RAM: 35.8 GB went to zram (zstd, sized at twice the RAM) during that step, compressed to 5.7 GB.
  The post gives no build times.

So running fewer jobs at once (`-j`) doesn't lower this peak, and RAM in different computers doesn't add up.
Cover it with 96 GB of RAM or more, or with zram twice the size of the RAM on a 32 or 64 GB computer.
Roadmap task T2 measures the real peak (check C2).

Sources: [Emteria][emteria], [XDA][xda-memory].

### How strict the memory floor is

From the build system's own code (Soong) on the `lineage-24.0` branch, read on 2026-11-20 (line numbers can move):

- **There is no enforced minimum.**
  Soong's only memory check, `checkRAM`, prints a warning at 16 GB or less, or when `-j` is higher than the RAM in GB, and then builds anyway.
  The 64 GB that AOSP and LineageOS give is a recommendation ([build.go][soong-checkram]).
- **The real limit is RAM plus swap.**
  If `soong_build` doesn't fit, the system stops it and the build fails, as in Emteria's run.
  zram counts as swap and uses processor time to save RAM.
  Swap on disk also avoids the failure, but is likely much slower, because the program keeps going through all of its memory (Go's garbage collector) (unsourced).
- **The peak only comes when Soong re-reads the whole code:** the first build, a download that changes build files, or a change of target or settings.
  A rebuild after editing code reuses the earlier result (unsourced; roadmap check C2).
- **`-j` matters in the compile phase that follows.**
  Soong already limits its memory-hungry jobs to 1 at 16 GB or less, 2 at 32 GB or less, and otherwise to the lower of RAM ÷ 8 GB and `-j`; `NINJA_HIGHMEM_NUM_JOBS` overrides it ([config.go][soong-highmem]).
- **Go's memory settings can't be changed from outside.**
  The step that runs `soong_build` gets only `TOP` and `PATH` from its surroundings (plus `SISO_EXPERIMENTS` under Siso), so settings such as `GOGC` or `GOMEMLIMIT` don't reach it.
  Changing that would take a carry patch to `build/soong` ([soong.go][soong-env]).
- **zram must be sized by hand.**
  zram-generator's default is the smaller of RAM ÷ 2 and 4 GiB, and it recommends 0.1–0.5 × RAM for general use, so the build host needs `zram-size` set ([zram-generator example][zram-example]).

### Spreading the work over several machines

Not planned yet.

- **The memory-hungry step can't be shared.**
  It runs on the computer that holds the code, along with every step not sent elsewhere.
  Extra computers can't stand in for its RAM.
- **Compiling can be shared.**
  Soong has remote execution built in (`USE_RBE`), which can send each kind of job (C++, javac, r8 and d8) to other computers or keep it local.
  Its client (`reproxy`, `rewrapper`) is in `prebuilts/remoteexecution-client`, which LineageOS 24.0 downloads.
  The other side can be any service that speaks the Remote Execution API, such as a self-hosted Buildbarn.
- **Measured example:** a community guide (AOSP 15, Buildbarn on two computers) reports a first build of 3 h 42 min, with about 76 GB of network traffic and a 71 GB cache, and 1 h 42 min for a rebuild served entirely from the cache.
  The local steps above still remain.
- **The client is being retired elsewhere.**
  Chromium announced in July 2025 that it would remove that client (reclient) at the end of September 2025 and move to Siso.
  ⚠ Whether anyone outside Google will keep it working is uncertain; nothing was found on Android's plans for it.
- lineage-24.0's Soong already uses Siso by default (`NINJA_DEFAULT`).
  With `USE_RBE=true`, remote execution still goes through reclient (`rewrapper`), unless `USE_REWRAPPER=false` selects Siso's own Remote Execution API path, which the code says is not the default yet.
  ⚠ Whether that path works with a self-hosted server is unchecked.
- Reconsider remote execution only if task T2 shows that compiling takes most of the build time.
- **Tests are easy to share.**
  Virtual phones and compatibility tests can run on a second computer from copied images.
  One compatibility test run can be split across computers with Tradefed's sharding (`--shard-count N --shard-index i`): every computer makes the same list of tests and runs its own share.
  Tradefed doesn't combine the results, so the automatic check's script has to.

Sources: [Soong rbe.md][soong-rbe], [LineageOS manifest][lineage-manifest], [Buildbarn for AOSP][buildbarn], [Chromium PSA on reclient][chromium-reclient], [Soong config.go][soong-config], [Tradefed sharding][tf-sharding], [sharded results][tf-sharded-runner].

### Test hosts and bandwidth

- A computer that runs the compatibility tests needs at least 32 GB of RAM and 256 GB of disk, JDK 11 or later, `adb`, `aapt2`, and FFmpeg 5.1.3 or later.
  It can be the build host ([CTS][cts]).
- **Download traffic for releases:** roughly 1–2 GB per full update per phone, plus incremental updates (unsourced).
  That needs a mirror or content-delivery network over HTTPS; the LineageOS Updater refuses addresses that aren't HTTPS ([Updater README][updater-readme]).

## Signing and updates

### Keys a release needs

- **Platform keys:** `releasekey`, `platform`, `shared`, `media`, `networkstack`, `bluetooth`, `nfc` and `sdk_sandbox`.
  LineageOS also generates `cyngn-app`, `testcert` and `verity`.
- **About 70 APEX keys** (SHA256_RSA4096).
- **A verified-boot (AVB) key** (RSA-4096).
- LineageOS provides `lineage-priv-template/keys.sh`, which makes all of them, but without passwords; its `check_keys.py` checks a signed build.
  GrapheneOS encrypts its keys with scrypt and AES-256, with one passphrase per phone.
- Keep the keys offline.
  Changing keys later forces users to reinstall or wipe their phones.

Sources: [LineageOS signing builds][lineage-signing], [AOSP signing builds][aosp-sign], [GrapheneOS build guide][graphene-build].

### Update server

- A simple HTTPS website with fixed files is enough; GrapheneOS works this way.
- The LineageOS Updater instead asks the server questions and expects JSON answers.
  Its address is set with `updater_server_url` (a resource) or `lineage.updater.uri` (a property), with `{device}`, `{type}` and `{incr}` placeholders.
  ⚠ The full answer format still has to be read from the Updater's README (roadmap check C10).

Sources: [GrapheneOS build guide][graphene-build], [Updater README (/e/OS fork)][updater-readme].

## Device selection

Include a phone only if **all** of these are true:

- Its owner can unlock the bootloader officially, which rules out Samsung on One UI 8 or later and most Xiaomi phones.
  A phone that can be locked again with FoxieOS's own key is preferred.
- LineageOS 24.0 supports it officially and has an active volunteer for it, or it is a Treble phone with a GKI kernel, for the generic-image track.
- Preferably a GKI 5.15 kernel or newer: 5.10 drops out at Android 17 QPR1, and 4.4 and 4.9 stop at LineageOS 22.2.
- The maker still sends firmware and security updates.
- A FoxieOS maintainer owns one; LineageOS has the same rule.

One maintainer can look after about 2–4 phones on a LineageOS base (unsourced estimate).

The best candidates, checked on 2026-11-20 (the full table is in [DEVICES.md](DEVICES.md#candidates-for-the-first-phone)):

- **Pixel 8 to Pixel 10a:** all on LineageOS 24.0, can be locked again, with Google's seven-year update period; GrapheneOS shows they can be built for.
- **Fairphone 4:** on 24.0 and can be locked again, but its kernel is 4.19, not GKI.
- **OnePlus 13 and Sony Xperia 10 VII:** on 24.0 with kernel 6.6, but ⚠ locking again with your own key isn't documented.

Second choice: any phone through a generic image, labelled "unofficial".

Sources: [LineageOS devices][lineage-devices], [Pixel update policy][pixel-updates], [LineageOS charter][lineage-charter].

## Project and legal checklist

- [ ] **Name:** a web search found no existing "FoxieOS".
  The EU (EUIPO) and US (USPTO) trademark searches are still to do before a public launch (roadmap check C12).
- [ ] **Logo:** confirm that the maintainer holds the rights to the fox artwork, then make a scalable (SVG) master plus app-icon and start-up-animation versions.
- [ ] **The "Android" trademark:** use it only to describe FoxieOS, followed by a general word ("an operating system based on Android"), never as the product's name.
  Add the line "Android is a trademark of Google LLC."
  Don't use the Android logo's typeface or anything based on the robot logo ([Android brand guidelines][android-brand]).
- [ ] **Licences:** keep the Apache-2.0 notices, and publish the GPL-2.0 source code for every kernel FoxieOS ships; LineageOS's rules also require kernel contributions under GPLv2.
  Credit code taken from GrapheneOS and CalyxOS, which is under MIT or Apache ([LineageOS charter][lineage-charter], [Wikipedia on GrapheneOS][wikipedia-graphene]).
- [ ] **The maker's files (vendor blobs):** copy them from the phone with a script, as LineageOS's rules require, and don't share them further than LineageOS already does ([LineageOS charter][lineage-charter]).

## Business model

Whether FoxieOS earns money, and how, is open: the maintainers decide it.
This section is research for that decision, not the decision.
The rest of this study assumes a project that sells nothing.

### Starting point

- **No Google apps.**
  Google's apps need agreements between Google and the phone maker, a licence fee for each phone, and meeting Android's compatibility requirements ([CMA on Google's OEM agreements][cma-oem]).
  A project that doesn't make the phones can't get them (unsourced).
- **A small audience.**
  Banking and other apps that rely on Play Integrity stop working ([Play Integrity](#play-integrity)).
  So FoxieOS appeals to people who choose a phone without Google, a small market (unsourced).
- **Free competition.**
  The alternatives on the same phones are free: GrapheneOS on Pixels, with stronger security, and LineageOS, CalyxOS, /e/OS and iodéOS ([Choosing a base](#choosing-a-base)).
  A paying user would need a reason to choose FoxieOS, and these docs don't name one yet.
- **The cost is mostly people's time:** taking in security fixes, moving to new versions twice a year, and testing every release on each phone ([Upstream security updates](#upstream-security-updates)).
  A rented build computer costs €149–259 a month ([ROADMAP.md D2](ROADMAP.md#d2-build-host)).
- **Small projects depend on a few people.**
  CalyxOS stopped installs and updates in August 2025, after its founder and its technical lead left, and came back in July 2026 ([CalyxOS letter][calyx-letter], [Privacy Guides][pg-calyx]).

Sources: [CMA on Google's OEM agreements][cma-oem], [CalyxOS letter][calyx-letter], [Privacy Guides][pg-calyx].

### Ways to fund it

| Model | Example | Fit for FoxieOS |
|---|---|---|
| Donations and sponsors | GrapheneOS | Covers costs at best |
| Grants | NLnet | Pays for set pieces of work, not upkeep |
| Selling phones with FoxieOS installed | iodé, Murena | Needs stock, a warranty and EU compliance |
| Paid services alongside a free system | Murena's cloud (unsourced) | Needs users first |
| Building custom Android for businesses | Emteria (unsourced) | A different business on the same tools |

- **Donations and sponsors:** GrapheneOS is funded by donations from people, companies and other organisations ([GrapheneOS donations][graphene-donate]).
  Software that earns no money stays outside the Cyber Resilience Act ([below](#obligations-once-money-is-involved)).
- **Grants:** NLnet funds open-source technical work through open calls, with €5,000–50,000 for a first grant ([NLnet][nlnet-propose]).
  Its next deadline is 2027-01-03, and it asks that proposals be written by people, not AI.
- **Selling phones:** iodé sells new and refurbished phones with iodéOS installed, in Europe only, with a one-year warranty on refurbished ones ([iodé][iode-shop]).
  Murena does the same with /e/OS (unsourced).
  The seller buys stock, and handles the warranty, returns and support.
- **Paid services:** a cloud account or paid support next to a free system (unsourced).
- **Building Android for businesses:** custom versions for kiosks or company phones reuse the same build, signing and update tools (unsourced).
  It would be a services business, and FoxieOS itself would stay free.

Sources: [GrapheneOS donations][graphene-donate], [NLnet][nlnet-propose], [iodé][iode-shop].

### Obligations once money is involved

Selling anything brings EU legal duties.

- **Cyber Resilience Act:** it covers digital products made available as part of a business.
  Free and open-source software that earns no money doesn't count as a business (recital 18).
  A manufacturer is whoever sells the product under its own name or trademark (Art. 3(13)).
- **Dates:** reporting security holes that are being exploited, and serious incidents, applies from 2026-09-11; the rest of the act from 2027-12-11 (recital 126).
- **Support period:** a manufacturer supports a product for, in general, at least five years (Art. 13(8)).
  FoxieOS gets most security fixes through LineageOS and Google's two code releases a year, and each phone's firmware has an end of life ([Vendor firmware](#vendor-firmware)).
- **A lighter role:** an open-source software steward, an organisation that supports open-source software used by businesses, has lighter duties than a manufacturer (Art. 3(14), recital 19).
- **Changing someone else's product:** whoever substantially changes a product and sells it is treated as its manufacturer (Commission guidance, paragraph 91).
  ⚠ Whether installing FoxieOS on another maker's phone and selling it makes the seller that phone's manufacturer, under this act, the radio-equipment rules or the ecodesign rules, is unconfirmed: it needs legal advice (roadmap check C14).
- **Ecodesign:** phones put on sale in the EU from 2025-06-20 need system updates for at least five years after the last phone of that model is sold ([European Commission][ec-ecodesign]).
- **Name and logo:** the trademark search (check C12) and the rights to the logo come before any sale ([Project and legal checklist](#project-and-legal-checklist)).

Sources: [Cyber Resilience Act][cra], [Commission guidance on the Cyber Resilience Act][cra-guidance], [European Commission on ecodesign][ec-ecodesign].

### Assessment

- As planned, FoxieOS has nothing to sell; donations and grants could cover part of its costs (unsourced estimate).
- Selling phones or services first needs a reason to choose FoxieOS over the free alternatives.
- Selling anything makes the Cyber Resilience Act and, for phones, the ecodesign rules part of every release, with a longer support period than the plan promises now.
- Building Android for businesses is the likeliest source of income, but it is a separate business.

## Risks

| Risk | Impact | What reduces it |
|---|---|---|
| Google keeps making AOSP less open | High | Build on LineageOS, which absorbs much of it; plan for the twice-yearly updates |
| Phone makers locking their bootloaders | High for supporting many phones | Keep the list of phones short; prefer Pixels and Fairphones |
| Maintainers burning out, fixes missed | High | Few phones; automatic builds and tests; published end-of-life dates |
| Release keys stolen or lost | Critical | Offline, encrypted keys with backups; only the maintainer handles them |
| Apps that need Play Integrity | Medium to high | Say so clearly; never promise banking apps will work; never fake results |
| Phones made unusable, especially by relocking | Medium to high | An install guide for each phone; never advise relocking phones where it isn't proven; release in stages |
| Selling before meeting the EU's rules | High | Decide the [business model](#business-model) first; legal advice before any sale (check C14) |

## Further reading

- source.android.com: requirements, Cuttlefish, atest, CTS, updates, signing.
- wiki.lineageos.org: build pages for each phone, `signing_builds`, `emulator`.
- github.com/LineageOS/charter: LineageOS's requirements for supported phones.
- grapheneos.org/build: signing, reproducible builds, the update server and channels.
- github.com/alopex-org/alopex: the separate research into building a device, which FoxieOS depends on for a device of its own.

## Sources

All checked on 2026-11-20, except [Regulation and business](#regulation-and-business), checked on 2026-11-22.

### AOSP and Google

- [AOSP hardware requirements][aosp-requirements]: at least 64 GB of RAM and about 400 GB of disk.
- [AOSP build times][aosp-start-requirements]: about 40 minutes on 72 cores and 6 hours on 6 cores, with 64 GB.
- [AOSP Android 17 release notes][aosp-17-notes]: the read-only code and the `android-latest-release` branch.
- [AOSP GKI][aosp-gki]: GKI 2.0 for phones launching on 5.10 or later; 5.10 unsupported from Android 17 QPR1.
- [Android common kernels][aosp-common-kernels]: end-of-support dates of the GKI versions.
- [AOSP device state][aosp-device-state]: `avb_custom_key` on Pixels.
- [AOSP signing builds][aosp-sign]: the keys a release needs.
- [Cuttlefish: get started][cf-start] and [google/android-cuttlefish][cf-github]: what the computer needs, Debian packages and container images.
- [Cuttlefish: run CTS][cf-cts]: the `cts-virtual-device-stable` test set; not all of CTS passes on Cuttlefish.
- [CTS][cts]: what the test computer needs, and how to prepare a phone.
- [Tradefed sharding][tf-sharding] and [sharded results][tf-sharded-runner]: splitting tests across computers; results aren't combined.
- [Soong rbe.md][soong-rbe]: remote execution with `USE_RBE`.
- [Android 16 GSI release notes][gsi16]: Google's Android 16 generic images (February 2026).
- [Pixel update policy][pixel-updates]: seven years for Pixel 8 and later, five for the Pixel 6 and 7 families and the Pixel Fold.
- [Play Integrity improvements][play-integrity]: the May 2025 changes.
- [Android brand guidelines][android-brand]: how "Android" may be used.
- [Chromium PSA on reclient][chromium-reclient]: reclient to be removed at the end of September 2025, moving to Siso.

### LineageOS

- [LineageOS devices][lineage-devices] and each phone's page: which phones run 24.0, their kernels and volunteers.
- [Build page for shiba][lineage-shiba-build]: the `repo init` options for 24.0; 64 GB of RAM and 400 GB of disk.
- [Emulator page][lineage-emulator]: building the emulator; the manifest sets `-c` and `-j4` for `repo sync`.
- [AndroidProducts.mk][lineage-products] and [lineage_cf_phone_x86_64.mk][lineage-cf-mk]: the virtual phones on 24.0.
- [LineageOS manifest][lineage-manifest]: downloads `prebuilts/remoteexecution-client`.
- [Signing builds][lineage-signing]: the list of keys, `keys.sh` (no passwords) and `check_keys.py`.
- [Device support requirements][lineage-charter]: the rules FoxieOS's own phone requirements are adapted from.
- [gs-6.1 kernel manifest][gs61-manifest] and [shusky-kernels][shusky-kernels]: Pixel kernels built in a separate Kleaf workspace, fixed at `android14-6.1-2026-03_r25`.
- Soong on lineage-24.0: [`checkRAM` in build.go][soong-checkram], [`HighmemParallel` in config.go][soong-highmem], [the `soong_build` environment in soong.go][soong-env], [Siso and remote execution in config.go][soong-config].

### News and community reports

- [Android Authority on the AOSP schedule][aa-aosp-schedule] and [PiunikaWeb][piunika-aosp]: AOSP code only in Q2 and Q4 from 2026.
- [9to5Google on Pixel source][9to5-pixel-source]: no Pixel phone files from Android 16; kernel history removed.
- [9to5Google][9to5-lineage24], [heise][heise-lineage24] and [CyberInsider][cyberinsider-lineage24]: LineageOS 24.0, released 2026-10-11.
- [Android Authority on LineageOS 23.2][aa-lineage232]: 23.2 is Android 16 QPR2.
- [heise][heise-rbus] and [Android Authority][aa-rbus]: Google's risk-based security updates.
- [SamMobile][sammobile-oneui8] and [GSMArena][gsmarena-oneui8]: One UI 8 removed bootloader unlocking.
- [Android Authority][aa-xiaomi] and [GSMArena][gsmarena-xiaomi]: Xiaomi's unlocking rules.
- [Android Authority on Play Integrity][aa-play-integrity]: checks based on security hardware.
- [9to5Google][9to5-graphene-moto], [Android Authority][aa-graphene-moto] and [GSMArena][gsmarena-graphene-moto]: GrapheneOS's Motorola partnership.
- [Wikipedia on GrapheneOS][wikipedia-graphene]: its licences.
- [Fairphone forum on the Fairphone 4][fp4-forum]: locking again with your own key works.
- [iodé forum on the Fairphone 5][iode-fp5] and [Fairphone forum on the Fairphone 6][fp6-forum]: ⚠ failures when locking again.
- [avbroot][avbroot]: locking fails unless the system is signed with the stored key.
- [microG wiki][microg-spoofing]: ⚠ LineageOS's built-in signature spoofing.
- [/e/OS copy of the Updater, README][updater-readme]: the Updater's server address and HTTPS requirement.
- [Emteria][emteria] and [XDA][xda-memory]: memory use of Android 17's big build step.
- [Buildbarn for AOSP][buildbarn]: a remote-execution setup with timings.
- [zram-generator example config][zram-example]: the default zram size.
- [GrapheneOS build guide][graphene-build]: build requirements, encrypted keys, `adevtool`, the update server and channels.

### Hosting and CI

- [GitHub's plans][gh-plans] and [about protected branches][gh-protected]: code owners and protected branches are included for public repositories on every plan.
- [About self-hosted runners][gh-self-hosted] and [billing for Actions][gh-billing]: checks on your own computer don't use the plan's included Actions minutes.
- [Secure use reference][gh-hardening]: GitHub advises against running public repositories' checks on your own computer, because pull requests can run code there.
- [Hetzner EX63][hetzner-ex63] and [Hetzner AX102][hetzner-ax102]: prices of rented build computers.

### Regulation and business

- [Cyber Resilience Act][cra]: what it covers, the open-source exemption and stewards, who the manufacturer is, the support period and the dates.
- [Commission guidance on the Cyber Resilience Act][cra-guidance]: substantially changing a product makes you its manufacturer.
- [European Commission on ecodesign][ec-ecodesign]: five years of system updates for phones put on sale from 2025-06-20.
- [CMA on Google's OEM agreements][cma-oem]: Google's apps need agreements, a licence fee for each phone and compatibility.
- [GrapheneOS donations][graphene-donate]: funded by donations.
- [NLnet][nlnet-propose]: open calls and grant sizes.
- [iodé][iode-shop]: phones sold with iodéOS installed.
- [CalyxOS letter][calyx-letter] and [Privacy Guides][pg-calyx]: CalyxOS's pause and return.

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
[calyx-letter]: https://calyxos.org/news/2025/08/01/a-letter-to-our-community/
[cf-cts]: https://source.android.com/docs/devices/cuttlefish/cts
[cf-github]: https://github.com/google/android-cuttlefish
[cf-start]: https://source.android.com/docs/devices/cuttlefish/get-started
[chromium-reclient]: https://groups.google.com/a/chromium.org/g/chromium-dev/c/v-WOvWUtOpg/m/2HlNqp-6BgAJ
[cma-oem]: https://assets.publishing.service.gov.uk/media/6880b39e901d5f8d471204f1/Appendix_C__Google_s_OEM_Agreements.pdf
[cra]: https://eur-lex.europa.eu/eli/reg/2024/2847/oj/eng
[cra-guidance]: https://eur-lex.europa.eu/eli/C/2026/6013
[cts]: https://source.android.com/docs/compatibility/cts
[cyberinsider-lineage24]: https://cyberinsider.com/lineageos-24-lands-with-android-17-and-upgrade-limits-for-older-devices/
[ec-ecodesign]: https://single-market-economy.ec.europa.eu/news/new-eu-rules-durable-energy-efficient-and-repairable-smartphones-and-tablets-start-applying-2025-06-20_en
[emteria]: https://emteria.com/blog/android-17-ram-build-requirement
[fp4-forum]: https://forum.fairphone.com/t/bootloader-avb-keys-used-in-roms-for-fairphone-3-4/83448
[fp6-forum]: https://forum.fairphone.com/t/official-lineageos-23-for-the-fairphone-gen-6/132450?page=4
[gh-billing]: https://docs.github.com/en/billing/managing-billing-for-your-products/managing-billing-for-github-actions/about-billing-for-github-actions
[gh-hardening]: https://docs.github.com/en/actions/security-for-github-actions/security-guides/security-hardening-for-github-actions
[gh-plans]: https://docs.github.com/en/get-started/learning-about-github/githubs-plans
[gh-protected]: https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches/about-protected-branches
[gh-self-hosted]: https://docs.github.com/en/actions/hosting-your-own-runners/managing-self-hosted-runners/about-self-hosted-runners
[graphene-build]: https://grapheneos.org/build
[graphene-donate]: https://grapheneos.org/donate
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
[iode-shop]: https://iode.tech/smartphones-and-tablets/
[lineage-cf-mk]: https://github.com/LineageOS/android_vendor_lineage/blob/lineage-24.0/build/target/product/lineage_cf_phone_x86_64.mk
[lineage-charter]: https://github.com/LineageOS/charter/blob/main/device-support-requirements.md
[lineage-devices]: https://wiki.lineageos.org/devices/
[lineage-emulator]: https://wiki.lineageos.org/emulator
[lineage-manifest]: https://github.com/LineageOS/android/blob/lineage-24.0/default.xml
[lineage-products]: https://github.com/LineageOS/android_vendor_lineage/blob/lineage-24.0/build/target/product/AndroidProducts.mk
[lineage-shiba-build]: https://wiki.lineageos.org/devices/shiba/build/
[lineage-signing]: https://wiki.lineageos.org/signing_builds
[microg-spoofing]: https://www.github.com/microg/GmsCore/wiki/Signature-Spoofing
[nlnet-propose]: https://nlnet.nl/propose/
[pg-calyx]: https://www.privacyguides.org/livestreams/2026/07/03/calyxos-is-officially-back/
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
