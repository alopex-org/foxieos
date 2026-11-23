# FoxieOS feasibility study

This is the research behind the plan.
It asks what FoxieOS, as the operating system of a cyber-deck, could be built on, and what each option would take.
Nothing here chooses an option: what FoxieOS is built on is roadmap decision D10, taken after FoxieOS's requirements (task T1) and a comparison of the options (task T2).
The plan is in [ROADMAP.md](ROADMAP.md) and [DESIGN.md](DESIGN.md).
Technical words are explained in the [glossary](GLOSSARY.md).

**How to read it:**

- Sources were checked on 2026-11-23, except those for the [business model](#business-model), checked on 2026-11-22.
- Each section ends with the sources behind it, and the [Sources](#sources) section lists every source with what it supports.
- ⚠ marks a claim that isn't confirmed, or that sources disagree on; check it before relying on it.
- "(unsourced)" marks a statement from general knowledge that wasn't checked against a source.

## Summary

- **The device is undecided.**
  Alopex hasn't decided what the cyber-deck is for, what it has or what main board it uses, so no option can be ruled in or out yet ([What FoxieOS has to fit](#what-foxieos-has-to-fit)).
- **The options found so far** are an existing Linux distribution, a system built from source for one device, or firmware for a microcontroller ([Possible bases](#possible-bases)).
  Task T2 compares them once the requirements exist.
- **Updates, security and the interface** all follow from the base: each option updates, encrypts and starts securely in its own way ([Updates](#updates), [Secure boot](#secure-boot)).
- **Earning money** is an open question for the maintainers ([Business model](#business-model)).

## What a cyber-deck is

- A cyber-deck is a custom-built, portable computer, often made for one purpose, usually with a "cyberpunk" look.
  The word comes from the "cyberspace deck" in William Gibson's 1984 novel *Neuromancer*.
- Builders typically use a single-board computer such as a Raspberry Pi, a compact screen and keyboard, and lithium-ion batteries, in a 3D-printed body or a rugged case; many run Linux.
- Hackaday, which runs cyber-deck contests, gives no strict definition: a cyber-deck is a computer that serves a practical purpose, nominally with a keyboard and a display, and above all personal.
  Its 2022 contest drew more than 100 finished decks.

Cyber-decks already on sale or published, and what is undecided about Alopex's, are in the Alopex repository ([CYBERDECK.md](https://github.com/alopex-org/alopex/blob/main/docs/CYBERDECK.md)).

Sources: [Wikipedia: Cyberdeck][wiki-cyberdeck], [Hackaday 2022 contest][had-2022], [Hackaday 2022 results][had-2022-results].

## What FoxieOS has to fit

What FoxieOS must do depends on decisions that are open in both projects:

- **In Alopex:** what the cyber-deck is for, its form, its screen and controls, its radios, its power, and above all its main board ([Alopex: what is undecided](https://github.com/alopex-org/alopex/blob/main/docs/CYBERDECK.md#what-is-undecided)).
  The main board decides which systems can run at all.
- **In FoxieOS:** its own requirements (task T1), such as how it is updated, how the data on it is protected, and how long each release is supported.

So this study lists options and what is known about them, and leaves the choice to decision D10.

## Possible bases

None of these is preferred.
Each line says what its own project says about it.

### An existing Linux distribution

FoxieOS would add its own parts to a distribution that already runs on the chosen board.

- **Debian,** and Raspberry Pi OS, which is based on it: updated package by package with `apt update` and `apt full-upgrade`, which on Raspberry Pi OS also updates the kernel and the board's firmware; a new major version is installed afresh rather than upgraded in place.
- **Alpine Linux** calls itself a security-oriented, lightweight distribution, and publishes images for the Raspberry Pi 3 to 5.
- **Nura,** formerly postmarketOS, is a Linux system for phones and other devices built on Alpine, made to extend the life of consumer electronics; it says it is not yet ready for everyone.

Sources: [Raspberry Pi OS][rpi-os], [Alpine Linux][alpine-about], [Alpine downloads][alpine-downloads], [Nura][nura].

### A system built from source for one device

- **Buildroot** builds a small embedded Linux system from source, including the kernel and the bootloader.
- **Yocto** does the same at a larger scale (unsourced).
- Both give an exact, repeatable image, but every security fix means rebuilding and shipping the image, and the team follows security notices itself (unsourced).

Sources: [Buildroot][buildroot].

### Firmware for a microcontroller

- If Alopex builds the cyber-deck around a microcontroller, there is no full operating system: the device runs firmware, as the cyber-decks built on an ESP32-S3 do ([Alopex: cyber-decks that already exist](https://github.com/alopex-org/alopex/blob/main/docs/CYBERDECK.md#cyber-decks-that-already-exist)).
- FoxieOS would then be that firmware, or a part of it.

### Not an option: a fork of AOSP or LineageOS

FoxieOS was planned as a version of Android built on LineageOS; it is proposed that it no longer be a fork of AOSP or LineageOS ([DESIGN.md](DESIGN.md#a-cyber-deck-not-an-android-fork)).

## Updates

How FoxieOS is updated depends on the base.
Two ways found so far, with no choice between them:

- **Package by package,** as Debian and Alpine do: each program is updated on its own, with the distribution's tool (`apt`, `apk`).
- **The whole system in one piece:** a complete new system is installed beside the running one, in a second "slot", and the device goes back to the old slot if the new one doesn't start properly.
  RAUC is one tool for this: an update is a signed bundle, checked against keys stored on the device.
  Home Assistant OS updates this way, with RAUC and two slots.
- How a board switches between slots depends on its bootloader; on the Raspberry Pi 5, for example, Home Assistant OS uses the board's "tryboot" feature.

Sources: [Using RAUC][rauc-using], [RAUC advanced topics][rauc-advanced], [Home Assistant OS update system][haos-update].

## Secure boot

Secure boot makes a board start only software signed with a particular key.
Whether the cyber-deck has it, and how it works, depends on the main board Alopex chooses; Alopex compares the candidates' public secure-boot guides ([BOARDS.md](https://github.com/alopex-org/alopex/blob/main/docs/BOARDS.md#comparison)).
A Raspberry Pi shows a typical case:

- Raspberry Pi's Secure Boot Provisioner sets up secure boot, encryption of the storage, and a secret unique to each device, on the CM5, CM4 and Pi 5.
- The fingerprint (hash) of the signing key is written into the chip's one-time-programmable (OTP) memory, and on the Pi 5's chip the same key also signs the bootloader.
- Some of its steps can't be undone, and losing the private key means the device can no longer be updated or recovered with trusted start-up files.

So whoever holds such a key decides what the device starts, for its whole life.
⚠ Who holds it for the cyber-deck needs settling before any device is fused (check C2, and decision D9).

Sources: [Raspberry Pi Secure Boot Provisioner][rpi-provisioner], [Raspberry Pi security architecture][rpi-security].

## Build host

What the build computer needs depends on the base; task T4 measures it (check C1).

## Project and legal checklist

- [ ] **Name:** a web search found no existing "FoxieOS".
  The EU (EUIPO) and US (USPTO) trademark searches are still to do before a public launch (roadmap check C3).
- [ ] **Logo:** confirm that the maintainer holds the rights to the fox artwork, then make a scalable (SVG) master plus a start-up screen version.
- [ ] **Licences:** follow the licence of everything FoxieOS ships, for example publishing the source code of any GPL program, and keep the notices of the other licences (unsourced).
- [ ] **Trademarks of others:** use other projects' and companies' names only to describe what FoxieOS runs on or with, never as part of its name (unsourced).

## Business model

Whether FoxieOS earns money, and how, is open: the maintainers decide it.
This section is research for that decision, not the decision.

### Starting point

- **The device is the product.**
  FoxieOS has value as the system of the Alopex cyber-deck; whether Alopex sells devices is its own decision D5.
- **A small audience** of people who build or buy cyber-decks (unsourced).
- **The cost is mostly people's time:** taking in security fixes and testing every release on the device (unsourced).

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
  ⚠ Whether a cyber-deck counts as either is unconfirmed (check C4, and Alopex check C12).

Sources: [Cyber Resilience Act][cra], [Commission guidance on the Cyber Resilience Act][cra-guidance], [European Commission on ecodesign][ec-ecodesign].

### Assessment

- On its own, FoxieOS has nothing to sell; donations and grants could cover part of its costs (unsourced estimate).
- If Alopex sells cyber-decks, FoxieOS becomes part of a product, and the Cyber Resilience Act applies to every release, with a support period of at least five years.

## Risks

| Risk | Impact | What reduces it |
|---|---|---|
| Choosing a base before the cyber-deck's purpose and parts are known | High | Requirements first (task T1), then a comparison (task T2) |
| The cyber-deck takes longer to build than the software | Medium | Develop on a development board first |
| A board fused with a lost or wrong key | High | Fuse only boards kept for testing; settle the key's owner first (check C2) |
| Release keys stolen or lost | Critical | Offline, encrypted keys with backups; only the maintainer handles them |
| Maintainers burning out, fixes missed | High | Few devices; automatic builds and tests; published end-of-life dates |
| Selling before meeting the EU's rules | High | Decide the [business model](#business-model) first; legal advice before any sale (check C4) |

## Sources

All checked on 2026-11-23, except [Regulation and business](#regulation-and-business), checked on 2026-11-22.

### Cyber-decks

- [Wikipedia: Cyberdeck][wiki-cyberdeck]: the definition, the origin in *Neuromancer*, and what builders use.
- [Hackaday 2022 contest][had-2022]: Hackaday's criteria for a cyber-deck.
- [Hackaday 2022 results][had-2022-results]: more than 100 finished entries.

### Base systems

- [Raspberry Pi OS][rpi-os]: based on Debian Trixie; updated with `apt full-upgrade`, including kernel and firmware.
- [Alpine Linux][alpine-about] and [Alpine downloads][alpine-downloads]: how Alpine describes itself, and its images.
- [Nura][nura]: formerly postmarketOS, built on Alpine, its aim and its readiness.
- [Buildroot][buildroot]: what Buildroot builds.

### Updates and security

- [Using RAUC][rauc-using] and [RAUC advanced topics][rauc-advanced]: bundles, signatures, keyrings, slots and fallback.
- [Home Assistant OS update system][haos-update]: RAUC with A/B slots, and tryboot on the Pi 5.
- [Raspberry Pi Secure Boot Provisioner][rpi-provisioner]: what it sets up, on which boards, and its permanent steps.
- [Raspberry Pi security architecture][rpi-security]: the key's hash in OTP memory and the signed bootloader.

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
[buildroot]: https://buildroot.org/
[cra]: https://eur-lex.europa.eu/eli/reg/2024/2847/oj/eng
[cra-guidance]: https://eur-lex.europa.eu/eli/C/2026/6013
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
[nlnet-propose]: https://nlnet.nl/propose/
[nura]: https://nura.eco/
[rauc-advanced]: https://rauc.readthedocs.io/en/latest/advanced.html
[rauc-using]: https://rauc.readthedocs.io/en/latest/using.html
[rpi-os]: https://www.raspberrypi.com/documentation/computers/os.html
[rpi-provisioner]: https://www.raspberrypi.com/documentation/security/secure-boot-provisioner.html
[rpi-security]: https://www.raspberrypi.com/documentation/security/security-architecture.html
[wiki-cyberdeck]: https://en.wikipedia.org/wiki/Cyberdeck
