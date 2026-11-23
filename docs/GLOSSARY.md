# Glossary: Linux and the cyber-deck

Plain explanations of the technical words in the FoxieOS docs.
Look a word up when you meet it; you don't need to read this page from top to bottom.

Words about GitHub and how the project works (branch, pull request, sign-off, roadmap codes such as D2 or T7) are in the [organization's glossary](https://github.com/alopex-org/.github/blob/main/GLOSSARY.md).
Words about the hardware, radios and its rules are in [Alopex's glossary](https://github.com/alopex-org/alopex/blob/main/docs/GLOSSARY.md).

## The device

- **Cyber-deck:** a custom-built, portable computer, often made for one purpose, with a keyboard, a screen and a rugged or "cyberpunk" look.
  The word comes from William Gibson's 1984 novel *Neuromancer*.
- **The Alopex cyber-deck:** the hand-held cyber-deck that the Alopex hardware project designs, and that FoxieOS is made for.
- **Main board:** the computer inside the cyber-deck; Alopex hasn't chosen it yet.
- **Single-board computer (SBC):** a whole computer on one board, ready to use.
- **Compute module:** a computer on a small module, made to plug into a board someone else designs (a carrier board).
- **Raspberry Pi:** a family of small, cheap computers on one board, made by Raspberry Pi Ltd; one candidate for the cyber-deck.
  The **Compute Module 5 (CM5)** is a Raspberry Pi 5 as a compute module, and its **IO board** is Raspberry Pi's own board for trying it.
- **Development board:** a ready-made board used to develop FoxieOS before the cyber-deck exists.
- **Slide-out keyboard:** the cyber-deck's keyboard, hidden under the screen until the screen slides sideways.
- **18650:** a common size of rechargeable lithium-ion battery cell, 18 mm across and 65 mm long.
  The cyber-deck holds two, in bays that can be swapped one at a time.
- **Hardware switch (kill switch):** a physical switch that cuts power to a part, such as the Wi-Fi or the microphone, so software can't turn it back on.

## Linux and the base system

- **Linux:** the free operating-system kernel, and the family of systems built on it.
- **Kernel:** the core of the operating system that talks to the hardware.
- **Driver:** the part of the kernel that runs one piece of hardware, such as the screen or the keyboard.
- **Distribution:** a complete Linux system, with the kernel, programs and a way to update them.
- **Base system:** the existing distribution FoxieOS starts from (roadmap decision D10).
- **Debian:** a large, long-running Linux distribution.
  **Raspberry Pi OS** is Raspberry Pi's own version of Debian.
- **Alpine Linux:** a small Linux distribution focused on security.
- **Nura:** a Linux distribution for phones and other devices, built on Alpine; formerly called postmarketOS.
- **Buildroot, Yocto:** tools that build a whole Linux system from source code, for one device.
- **Package:** one program or library, as the distribution ships it.
  **`apt`** (Debian) and **`apk`** (Alpine) install and update packages.
- **System image:** the whole system as one file, written to the device's storage at once.
- **Upstream:** the projects FoxieOS builds on, such as its base system and Meshtastic.
  A **patch** is a change FoxieOS makes to their code ([PATCHES.md](PATCHES.md)).

## Building and testing

- **Build host:** the computer that builds FoxieOS (roadmap decision D2).
- **arm64:** 64-bit Arm, the kind of processor in most candidate boards, such as the Raspberry Pi 5.
  **RISC-V** is another kind, which some candidate boards use.
- **Cross-compiling:** building, on one kind of processor, programs that run on another.
- **Virtual machine:** a computer simulated in software.
  **QEMU** is the program that runs it, and **KVM** lets Linux run it fast.
- **CI (continuous integration):** automatic checks that run on every change.
- **Test layers (L0–L8):** the steps of testing, from quick automatic checks to people using a release ([TESTING.md](TESTING.md)).
- **Quick checks (smoke tests):** a short set of tests that the system starts and its basics work.
- **TAP:** a simple text format for test results.
- **Serial console:** a text connection to a board through a few wires, which works even when the screen and network don't.

## Updates and releases

- **Update (OTA, "over the air"):** a new version a device downloads and installs itself.
- **A/B slots:** two copies of the system on one device.
  An update goes into the copy not running, so a failed update leaves the working one in place.
- **RAUC:** an update tool for embedded Linux that installs signed updates into A/B slots.
  A **bundle** is one RAUC update file.
- **Tryboot:** a Raspberry Pi feature that starts a different system once, for a test, and goes back if it isn't confirmed.
- **Marking good:** the system confirming, after starting, that a new slot works, so the device keeps it.
- **Signing:** adding a digital signature that proves a file came from FoxieOS and wasn't changed.
- **Release keys, dev keys:** the secret keys that sign real releases, and practice keys that never sign anything published.
- **Keyring:** the list of certificates a device trusts, kept on the device.
- **X.509 certificate:** the standard format for the public half of a signing key.
- **Signing host:** the separate, offline computer where the maintainer signs releases (roadmap decision D7).
- **Channels (`testing`, `beta`, `stable`):** the steps a release goes through, from testers to everyone.
- **Update server:** the HTTPS website devices download updates from (roadmap decision D4).

## Security and privacy

- **Secure boot:** the board starting only a system signed with a particular key.
  On many chips, such as a Raspberry Pi's, the key's fingerprint is written into the chip's **OTP memory** (one-time programmable), which can never be changed.
- **Fusing:** writing into a chip's one-time-programmable memory; it can't be undone.
- **LUKS:** the standard way to encrypt a whole disk on Linux; **cryptsetup** is its tool.
- **MAC address:** the hardware address a device shows on a Wi-Fi network.
  A new, random one for each network makes the device harder to follow.
- **Tor, onion routing:** sending traffic through several relays so no single one knows both sender and receiver.

## Radio and messaging

- **LoRa:** a radio technique that sends small amounts of data over long distances with little power.
- **Mesh network:** devices passing messages on for each other, with no central network.
- **Meshtastic:** free software for LoRa mesh messaging; **`meshtasticd`** is its Linux service.
- **Region (EU_868):** the Meshtastic setting for the band a country allows; Greece uses EU_868, in 869.4–869.65 MHz.
- **Duty cycle:** the share of time a radio may transmit; 10% on EU_868.
- **RSSI:** how strong a received signal is, in dBm; nearer zero is stronger.
- **SNR:** how far a received signal stands above the noise, in dB; higher is clearer.
- **SX1262:** a common LoRa radio chip.
- **GNSS:** satellite positioning, such as GPS and Galileo.
- **Session, Briar:** messaging apps that need no phone number and route messages privately.

## Law and money

- **Cyber Resilience Act (CRA):** an EU law with security duties for anyone who sells digital products.
- **Ecodesign rules:** EU rules that, among other things, make makers of phones and tablets provide updates for at least five years.
- **Manufacturer:** in EU law, whoever sells a product under their own name, and so carries its legal duties.
- **Trademark search:** checking official registers (EUIPO in the EU, USPTO in the US) that nobody else owns the name "FoxieOS".
- **Licences (Apache, MIT, GPL):** the terms under which code can be used.
  Apache and MIT allow almost anything; the GPL, which covers the Linux kernel, requires publishing the source code of what you ship.
