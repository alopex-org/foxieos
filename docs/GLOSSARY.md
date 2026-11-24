# Glossary: operating systems and the cyber-deck

Plain explanations of the technical words in the FoxieOS docs.
Look a word up when you meet it; you don't need to read this page from top to bottom.

Words about GitHub and how the project works (branch, pull request, sign-off, roadmap codes such as D2 or T7) are in the [organization's glossary](https://github.com/alopex-org/.github/blob/main/GLOSSARY.md).
Words about the hardware and its rules are in [Alopex's glossary](https://github.com/alopex-org/alopex/blob/main/docs/GLOSSARY.md).

## The device

- **Cyber-deck:** a custom-built, portable computer, often made for one purpose, nominally with a keyboard and a screen.
  The word comes from William Gibson's 1984 novel *Neuromancer*.
- **The Alopex cyber-deck:** the cyber-deck that the Alopex hardware project works toward, and that FoxieOS is proposed for: user-serviceable, with LoRa and Wi-Fi, pocket-sized if possible.
- **LoRa:** a radio technique that sends small amounts of data over long distances with little power, used for messaging without a mobile network.
- **User-serviceable:** built so its owner can open it, repair it and replace parts themselves; the cyber-deck's primary purpose.
- **Main board:** the computer inside the cyber-deck; Alopex hasn't chosen it.
- **Single-board computer (SBC):** a whole computer on one board, ready to use.
- **Compute module:** a computer on a small module, made to plug into a board someone else designs (a carrier board).
- **Microcontroller:** a small, low-power processor with its memory on one chip; it runs firmware rather than a full operating system.
- **Development board:** a ready-made board used to develop FoxieOS before the cyber-deck exists.

## Operating systems

- **Operating system:** the software that runs a computer and the programs on it.
- **Kernel:** the core of the operating system that talks to the hardware; **Linux** is one.
- **Driver:** the part of the kernel that runs one piece of hardware, such as the screen or the keyboard.
- **Firmware:** software built into a piece of hardware, or the whole software of a microcontroller.
- **Distribution:** a complete operating system built around a kernel, with programs and a way to update them, such as Debian or Alpine Linux.
- **Base:** the Linux distribution FoxieOS is built on (roadmap decision D10).
- **AOSP, LineageOS:** the Android source code from Google, and a free version of Android built on it; FoxieOS was earlier planned as a version of LineageOS.
- **Fork:** a project that starts from another project's code and goes its own way.
- **Upstream:** the projects FoxieOS builds on.
  A **patch** is a change FoxieOS makes to their code ([PATCHES.md](PATCHES.md)).
- **System image:** a whole system as one file, written to a device's storage at once.

## Building and testing

- **Build host:** the computer that builds FoxieOS (roadmap decision D2).
- **Virtual machine:** a computer simulated in software.
- **CI (continuous integration):** automatic checks that run on every change.
- **Test layers:** the steps of testing, from quick automatic checks to people using a release ([TESTING.md](TESTING.md)).

## Updates and releases

- **Update:** a new version a device installs.
- **A/B slots:** two copies of the system on one device; an update goes into the copy not running, so a failed update leaves the working one in place.
- **Signing:** adding a digital signature that proves a file came from FoxieOS and wasn't changed.
- **Release keys, dev keys:** the secret keys that sign real releases, and practice keys that never sign anything published.
- **Signing host:** the separate, offline computer where the maintainer signs releases (roadmap decision D7).
- **Channels (`testing`, `beta`, `stable`):** the steps a release goes through, from testers to everyone.
- **Update server:** the website devices download updates from (roadmap decision D4).

## Security

- **Secure boot:** a board starting only software signed with a particular key.
  On many chips, the key's fingerprint is written into the chip's **OTP memory** (one-time programmable), which can never be changed.
- **Fusing:** writing into a chip's one-time-programmable memory; it can't be undone.
- **Encryption of the storage:** scrambling everything stored on the device so it can't be read without a passphrase or key.

## Law and money

- **Cyber Resilience Act (CRA):** an EU law with security duties for anyone who sells digital products.
- **Ecodesign rules:** EU rules that, among other things, make makers of phones and tablets provide updates for at least five years.
- **Manufacturer:** in EU law, whoever sells a product under their own name, and so carries its legal duties.
- **Trademark search:** checking official registers (EUIPO in the EU, USPTO in the US) that nobody else owns the name "FoxieOS".
- **Licences (Apache, MIT, GPL):** the terms under which code can be used.
  Apache and MIT allow almost anything; the GPL requires publishing the source code of what you ship.
