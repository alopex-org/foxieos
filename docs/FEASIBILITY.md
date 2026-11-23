# FoxieOS feasibility study

This is the research behind the plan.
It asks whether a small team can build and maintain FoxieOS as the operating system of a cyber-deck, what to build it on, and what that takes.
The plan that follows from it is in [ROADMAP.md](ROADMAP.md) and [DESIGN.md](DESIGN.md).
Technical words are explained in the [glossary](GLOSSARY.md).

**How to read it:**

- Sources were checked on 2026-11-23, except those for the [business model](#business-model), checked on 2026-11-22.
- Each section ends with the sources behind it, and the [Sources](#sources) section lists every source with what it supports.
- ⚠ marks a claim that isn't confirmed, or that sources disagree on; check it before relying on it.
- "(unsourced)" marks a statement from general knowledge that wasn't checked against a source.

## Summary

| Goal | Possible? |
|---|---|
| A FoxieOS-branded Linux system on a Raspberry Pi board | Yes |
| The same system on the Alopex cyber-deck | Yes, once the hardware exists |
| Messaging over a LoRa mesh with no network | Yes, with Meshtastic's Linux service |
| Safe updates that can't leave the device unable to start | Yes, with A/B slots and RAUC |
| Secure boot with a key the owner controls | Partly: the key is permanent ⚠ |
| Android apps | No |
| Manageable for one person or a small team | Yes, if it stays on one device |
| Earning money from it | An open question |

- **A branded Linux system on a Raspberry Pi** is ordinary work: Raspberry Pi publishes its own Debian-based system, and Alpine Linux, Buildroot and Yocto all build for it ([Choosing a base](#choosing-a-base)).
- **The cyber-deck's parts** (a LoRa radio, a touchscreen, a keyboard, a GNSS receiver) need drivers and settings rather than new software, except the interface ([What the cyber-deck needs](#what-the-cyber-deck-needs-from-its-software)).
- **Updates:** RAUC installs a signed update beside the running system and falls back if it fails; Home Assistant OS does this on the Raspberry Pi 5 today ([Updates](#updates)).
- **Secure boot:** Raspberry Pi's tool sets up secure boot and disk encryption, but it writes the key's fingerprint into the chip for good ([Secure boot and encryption](#secure-boot-and-encryption)).
- **Keeping it going** is mostly taking in the base system's security fixes, and far less work than an Android version (unsourced estimate).

**Recommendation:** an image-based Linux system for the Alopex cyber-deck and the Raspberry Pi Compute Module 5 it is proposed to use, with A/B updates through RAUC, LUKS encryption, Meshtastic built in, and an interface for both the touchscreen and the keyboard.
Choose the base after trying two of them on a board (roadmap decision D10).

## What a cyber-deck is

- A cyber-deck is a custom-built, portable computer, often made for one purpose, usually with a "cyberpunk" look.
  The word comes from the "cyberspace deck" in William Gibson's 1984 novel *Neuromancer*.
- Builders typically use a single-board computer such as a Raspberry Pi, a compact screen and keyboard, and lithium-ion batteries, in a 3D-printed body or a rugged case; many run Linux, and some carry LoRa radios running Meshtastic or software-defined radios.
- Hackaday, which runs cyber-deck contests, gives no strict definition: a cyber-deck is a computer that serves a practical purpose, nominally with a keyboard and a display, and above all personal.
  Its 2022 contest drew more than 100 finished decks.

For FoxieOS this means the users expect to open, change and extend their device, and the software should allow that rather than lock it down.
The hardware itself, and the cyber-decks already on sale, are compared in the Alopex repository ([CYBERDECK.md](https://github.com/alopex-org/alopex/blob/main/docs/CYBERDECK.md)).

Sources: [Wikipedia: Cyberdeck][wiki-cyberdeck], [Hackaday 2022 contest][had-2022], [Hackaday 2022 results][had-2022-results].

## What the cyber-deck needs from its software

The Alopex cyber-deck is proposed around a Raspberry Pi Compute Module 5, with a LoRa radio, a GNSS receiver, a removable USB Wi-Fi adapter, hardware switches, a touchscreen that slides over a keyboard, and two swappable 18650 batteries.
Most of it needs drivers and settings that already exist:

- **LoRa radio:** Meshtastic's Linux service, `meshtasticd`, drives an SX1262 LoRa radio on the Pi's SPI pins, or one on a USB adapter.
- **Encrypted storage:** LUKS, through the `cryptsetup` tool, encrypts the whole storage and asks for a passphrase at every start.
- **Messaging over the internet:** Session has a Linux app, needs no phone number and sends messages over onion-routed paths; Briar's Linux app is a beta without Bluetooth.
- **Messaging over LoRa:** Meshtastic encrypts channels with AES and a shared key, and direct messages with a key pair for each device; message headers aren't encrypted, and there is no forward secrecy.
- **Position:** ⚠ whether `meshtasticd` can read a GNSS receiver isn't stated in Meshtastic's documentation (Alopex check C14).

What doesn't exist yet is FoxieOS's own part:

- an interface that works upright on the touchscreen and sideways over the keyboard (roadmap decision D11);
- driving the cyber-deck's knobs, signal gauges, battery bays and switches, and showing their state (task T11);
- branding, settings and the update service.

Sources: [Meshtastic Linux hardware][mt-linux], [Meshtastic encryption][mt-encryption], [cryptsetup][cryptsetup], [Session][session], [Briar Desktop][briar-desktop].

## Choosing a base

FoxieOS adds its parts to an existing Linux system, its base.
The choice sets how security fixes arrive and how much work each update is.

### Debian and Raspberry Pi OS

- Raspberry Pi OS is based on Debian; its latest version on Debian "Trixie".
- It is updated package by package with `apt update` and `apt full-upgrade`, which also updates the kernel and the board's firmware; a new major version is installed afresh rather than upgraded in place.
- It is what Raspberry Pi itself supports, so the board's drivers arrive there first (unsourced).

### Alpine Linux and Nura

- Alpine Linux calls itself a security-oriented, lightweight distribution, and publishes images for the Raspberry Pi 3 to 5.
- Nura, formerly postmarketOS, is a Linux system for phones and other devices built directly on Alpine, made to extend the life of consumer electronics; it says it is not yet ready for everyone.
  It offers mobile interfaces such as Phosh and Sxmo (unsourced).
  ⚠ Its support for the Raspberry Pi 5 couldn't be read from its wiki (check C8).

### Buildroot and Yocto

- Buildroot builds a small embedded Linux system from source, including the kernel and the bootloader.
- Yocto does the same at a larger scale, and RAUC's community layers for it include a Raspberry Pi integration (unsourced).
- Both give an exact, repeatable image, but every security fix means rebuilding and shipping the image, and the team follows security notices itself (unsourced).

### Android

- Raspberry Pi offers no official Android.
  A community build of Android 17 runs on the Pi 5 and CM5, but its security rules (SELinux) are permissive, it doesn't encrypt user data, and its added parts may not be used commercially.
- So Android on the cyber-deck would give up the encryption and security FoxieOS is for, and it is turned down until that changes.

**Assessment:** Debian is the closest to what Raspberry Pi supports; Alpine is smaller; Buildroot or Yocto give the most control at the most work.
Whichever is chosen, FoxieOS ships it as a whole image with A/B updates ([Updates](#updates)), not as packages updated one by one.

Sources: [Raspberry Pi OS][rpi-os], [Alpine Linux][alpine-about], [Alpine downloads][alpine-downloads], [Nura][nura], [Buildroot][buildroot], [KonstaKANG AOSP 17][konstakang-aosp17].

## Updates

- **RAUC** is an update tool for embedded Linux.
  An update is a bundle: a SquashFS image with a signature over it, checked against the keys already stored on the device.
- **A/B slots:** the device has two copies of the system; the update goes into the one not running.
  A new slot counts as good only once the system marks it so after starting; otherwise, depending on the bootloader, the device switches back.
- **Separate keys:** RAUC can trust a development key on development devices only, so release devices accept only bundles signed with the release key.
- **On the Raspberry Pi 5:** Home Assistant OS updates with RAUC and two slots, and uses the board's "tryboot" feature through its own RAUC back end.
  It has to restart with `systemctl reboot`: a plain `reboot` starts the old slot again.
  ⚠ The same on a CM5 in the cyber-deck needs checking (check C1).

Sources: [Using RAUC][rauc-using], [RAUC advanced topics][rauc-advanced], [Home Assistant OS update system][haos-update].

## Secure boot and encryption

- Raspberry Pi's Secure Boot Provisioner sets up secure boot, LUKS encryption of the storage, and a secret unique to each device, on the CM5, CM4 and Pi 5.
  It is in active development.
- The fingerprint (hash) of the signing key is written into the chip's one-time-programmable (OTP) memory, and on the Pi 5's chip the same key also signs the bootloader.
- Some of its steps can't be undone, and losing the private key means the device can no longer be updated or recovered with trusted start-up files.
- **What it means for FoxieOS:** on a Raspberry Pi there is no separate owner key for the operating system, as Android phones have.
  Whoever holds the one key written into the chip decides what the device starts, for its whole life.
  ⚠ How that key is shared between Alopex, FoxieOS and the owner needs settling before any device is fused (check C3, and FoxieOS decision D9).

Sources: [Raspberry Pi Secure Boot Provisioner][rpi-provisioner], [Raspberry Pi security architecture][rpi-security].

## The LoRa mesh radio

- Meshtastic sets a region on each device, and devices in a mesh need the same region and preset to talk.
- Greece uses the EU_868 region (or EU_433).
  EU_868 uses 869.4–869.65 MHz, with a 10% limit on transmitting time over a rolling hour and a 27 dBm power ceiling in the firmware.
- The US region uses 902–928 MHz.
  A radio sold for that band, or set to a frequency such as 925 MHz, may not be used in Greece.
- Meshtastic advises checking the national band plan before transmitting.

Sources: [Meshtastic LoRa configuration][mt-lora], [Meshtastic region by country][mt-region].

## Build host

- A Linux image for one board needs far less than an Android build: no 400 GB source tree, and no single step that needs more than 55 GiB of memory (unsourced estimate).
- Building for 64-bit Arm on a normal PC works by cross-compiling; a 64-bit Arm build computer, such as a Pi 5, can also build natively (unsourced).
- Task T1 measures the real needs once the base is chosen.

## Project and legal checklist

- [ ] **Name:** a web search found no existing "FoxieOS".
  The EU (EUIPO) and US (USPTO) trademark searches are still to do before a public launch (roadmap check C6).
- [ ] **Logo:** confirm that the maintainer holds the rights to the fox artwork, then make a scalable (SVG) master plus a start-up screen version.
- [ ] **Licences:** publish the source code of the kernel and every other GPL program FoxieOS ships, and keep the notices of the other licences (unsourced).
- [ ] **Trademarks of others:** use "Raspberry Pi", "Meshtastic" and "Linux" only to describe what FoxieOS runs on or with, never as part of its name (unsourced).

## Business model

Whether FoxieOS earns money, and how, is open: the maintainers decide it.
This section is research for that decision, not the decision.
The rest of this study assumes a project that sells nothing.

### Starting point

- **The device is the product.**
  FoxieOS has value as the system of the Alopex cyber-deck; whether Alopex sells devices is its own decision D5.
- **A small audience** of people who build or buy cyber-decks, and who choose a device without mainstream apps (unsourced).
- **The cost is mostly people's time:** taking in security fixes, testing every release on the device, and the interface.

### Ways to fund it

| Model | Example | Fit for FoxieOS |
|---|---|---|
| Donations and sponsors | GrapheneOS | Covers costs at best |
| Grants | NLnet | Pays for set pieces of work, not upkeep |
| Selling devices with FoxieOS installed | Alopex decision D5 | Needs stock, a warranty and EU compliance |
| Paid services alongside a free system | (unsourced) | Needs users first |

- **Donations and sponsors:** GrapheneOS is funded by donations from people, companies and other organisations ([GrapheneOS donations][graphene-donate]).
  Software that earns no money stays outside the Cyber Resilience Act ([below](#obligations-once-money-is-involved)).
- **Grants:** NLnet funds open-source technical work through open calls, with €5,000–50,000 for a first grant ([NLnet][nlnet-propose]).
  Its next deadline is 2027-01-03, and it asks that proposals be written by people, not AI.
- **Selling devices:** the seller buys stock, and handles the warranty, returns and support (unsourced).
- **Paid services:** paid support or a hosted service next to a free system (unsourced).

Sources: [GrapheneOS donations][graphene-donate], [NLnet][nlnet-propose].

### Obligations once money is involved

Selling anything brings EU legal duties.

- **Cyber Resilience Act:** it covers digital products made available as part of a business.
  Free and open-source software that earns no money doesn't count as a business (recital 18).
  A manufacturer is whoever sells the product under its own name or trademark (Art. 3(13)).
- **Dates:** reporting security holes that are being exploited, and serious incidents, applies from 2026-09-11; the rest of the act from 2027-12-11 (recital 126).
- **Support period:** a manufacturer supports a product for, in general, at least five years (Art. 13(8)).
- **A lighter role:** an open-source software steward, an organisation that supports open-source software used by businesses, has lighter duties than a manufacturer (Art. 3(14), recital 19).
- **Changing someone else's product:** whoever substantially changes a product and sells it is treated as its manufacturer (Commission guidance, paragraph 91).
- **Ecodesign:** phones and tablets put on sale in the EU from 2025-06-20 need system updates for at least five years after the last one of that model is sold ([European Commission][ec-ecodesign]).
  ⚠ Whether a cyber-deck counts as either is unconfirmed (check C7, and Alopex check C12).

Sources: [Cyber Resilience Act][cra], [Commission guidance on the Cyber Resilience Act][cra-guidance], [European Commission on ecodesign][ec-ecodesign].

### Assessment

- On its own, FoxieOS has nothing to sell; donations and grants could cover part of its costs (unsourced estimate).
- If Alopex sells cyber-decks, FoxieOS becomes part of a product, and the Cyber Resilience Act applies to every release, with a support period of at least five years.

## Risks

| Risk | Impact | What reduces it |
|---|---|---|
| The cyber-deck takes longer to build than the software | Medium | Develop on a Raspberry Pi board and a virtual machine first |
| A board fused with a lost or wrong key | High | Fuse only boards kept for testing; settle the key's owner first (check C3) |
| An update leaves a device unable to start | High | A/B slots with fallback; test the fallback before every release |
| Release keys stolen or lost | Critical | Offline, encrypted keys with backups; only the maintainer handles them |
| Maintainers burning out, fixes missed | High | One device; automatic builds and tests; published end-of-life dates |
| Transmitting outside the legal LoRa band | Medium | Set the region by default for the country of use; never ship US-band settings in Europe |
| Selling before meeting the EU's rules | High | Decide the [business model](#business-model) first; legal advice before any sale (check C7) |

## Further reading

- rauc.readthedocs.io: the RAUC documentation.
- raspberrypi.com/documentation: the boards, Raspberry Pi OS and secure boot.
- meshtastic.org/docs: the Meshtastic Linux service and radio settings.
- github.com/alopex-org/alopex: the cyber-deck's hardware.

## Sources

All checked on 2026-11-23, except [Regulation and business](#regulation-and-business), checked on 2026-11-22.

### Cyber-decks

- [Wikipedia: Cyberdeck][wiki-cyberdeck]: the definition, the origin in *Neuromancer*, and what builders use.
- [Hackaday 2022 contest][had-2022]: Hackaday's criteria for a cyber-deck.
- [Hackaday 2022 results][had-2022-results]: more than 100 finished entries.

### Base systems

- [Raspberry Pi OS][rpi-os]: based on Debian Trixie; updated with `apt full-upgrade`, including kernel and firmware.
- [Alpine Linux][alpine-about] and [Alpine downloads][alpine-downloads]: how Alpine describes itself, and its Raspberry Pi images.
- [Nura][nura]: formerly postmarketOS, built on Alpine, its aim and its readiness.
- [Buildroot][buildroot]: what Buildroot builds.
- [KonstaKANG AOSP 17][konstakang-aosp17]: the community Android build for the Pi 5 and CM5, and its limits.

### Updates and security

- [Using RAUC][rauc-using] and [RAUC advanced topics][rauc-advanced]: bundles, signatures, keyrings, slots and fallback.
- [Home Assistant OS update system][haos-update]: RAUC with A/B slots on the Pi 5 through tryboot.
- [Raspberry Pi Secure Boot Provisioner][rpi-provisioner]: what it sets up, on which boards, and its permanent steps.
- [Raspberry Pi security architecture][rpi-security]: the key's hash in OTP memory and the signed bootloader.
- [cryptsetup][cryptsetup]: the LUKS disk-encryption tool.

### Radio and messaging

- [Meshtastic Linux hardware][mt-linux]: `meshtasticd` over SPI and USB.
- [Meshtastic encryption][mt-encryption]: channel and direct-message encryption, and their limits.
- [Meshtastic LoRa configuration][mt-lora]: the EU_868 and US bands, the duty-cycle limit and power ceilings.
- [Meshtastic region by country][mt-region]: Greece uses EU_868 or EU_433.
- [Session][session] and [Briar Desktop][briar-desktop]: messaging apps for Linux.

### Hosting and CI

- [GitHub's plans][gh-plans] and [about protected branches][gh-protected]: code owners and protected branches are included for public repositories on every plan.
- [About self-hosted runners][gh-self-hosted] and [billing for Actions][gh-billing]: checks on your own computer don't use the plan's included Actions minutes.
- [Secure use reference][gh-hardening]: GitHub advises against running public repositories' checks on your own computer, because pull requests can run code there.

### Regulation and business

- [Cyber Resilience Act][cra]: what it covers, the open-source exemption and stewards, who the manufacturer is, the support period and the dates.
- [Commission guidance on the Cyber Resilience Act][cra-guidance]: substantially changing a product makes you its manufacturer.
- [European Commission on ecodesign][ec-ecodesign]: five years of system updates for phones and tablets put on sale from 2025-06-20.
- [GrapheneOS donations][graphene-donate]: funded by donations.
- [NLnet][nlnet-propose]: open calls and grant sizes.

[alpine-about]: https://www.alpinelinux.org/about/
[alpine-downloads]: https://www.alpinelinux.org/downloads/
[briar-desktop]: https://briarproject.org/download-briar-desktop/
[buildroot]: https://buildroot.org/
[cra]: https://eur-lex.europa.eu/eli/reg/2024/2847/oj/eng
[cra-guidance]: https://eur-lex.europa.eu/eli/C/2026/6013
[cryptsetup]: https://gitlab.com/cryptsetup/cryptsetup
[ec-ecodesign]: https://single-market-economy.ec.europa.eu/news/new-eu-rules-durable-energy-efficient-and-repairable-smartphones-and-tablets-start-applying-2025-06-20_en
[gh-billing]: https://docs.github.com/en/billing/managing-billing-for-your-products/managing-billing-for-github-actions/about-billing-for-github-actions
[gh-hardening]: https://docs.github.com/en/actions/security-for-github-actions/security-guides/security-hardening-for-github-actions
[gh-plans]: https://docs.github.com/en/get-started/learning-about-github/githubs-plans
[gh-protected]: https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches/about-protected-branches
[gh-self-hosted]: https://docs.github.com/en/actions/hosting-your-own-runners/managing-self-hosted-runners/about-self-hosted-runners
[graphene-donate]: https://grapheneos.org/donate
[had-2022]: https://hackaday.com/2022/08/08/load-your-icebreakers-the-2022-cyberdeck-contest-is-here
[had-2022-results]: https://hackaday.com/2022/10/13/2022-cyberdeck-contest-picking-the-best-of-the-best
[haos-update]: https://contributors.home-assistant.io/os/operating-system/update-system/
[konstakang-aosp17]: https://konstakang.com/devices/rpi5/AOSP17
[mt-encryption]: https://meshtastic.org/docs/overview/encryption/
[mt-linux]: https://meshtastic.org/docs/software/linux/hardware/
[mt-lora]: https://meshtastic.org/docs/configuration/radio/lora/
[mt-region]: https://meshtastic.org/docs/configuration/region-by-country/
[nlnet-propose]: https://nlnet.nl/propose/
[nura]: https://nura.eco/
[rauc-advanced]: https://rauc.readthedocs.io/en/latest/advanced.html
[rauc-using]: https://rauc.readthedocs.io/en/latest/using.html
[rpi-os]: https://www.raspberrypi.com/documentation/computers/os.html
[rpi-provisioner]: https://www.raspberrypi.com/documentation/security/secure-boot-provisioner.html
[rpi-security]: https://www.raspberrypi.com/documentation/security/security-architecture.html
[session]: https://getsession.org/
[wiki-cyberdeck]: https://en.wikipedia.org/wiki/Cyberdeck
