# Glossary: Android and phones

Plain explanations of the technical words in the FoxieOS docs.
Look a word up when you meet it; you don't need to read this page from top to bottom.

Words about GitHub and how the project works (branch, pull request, sign-off, roadmap codes such as D2 or T7) are in the [organization's glossary](https://github.com/alopex-org/.github/blob/main/GLOSSARY.md).

## Android and the projects FoxieOS builds on

- **Android:** the operating system on most phones.
  Google develops it.
- **AOSP (Android Open Source Project):** the free, public part of Android that Google publishes, without Google's own apps.
  Every other Android version on this page starts from it.
- **Android 17:** the Android version FoxieOS plans to start from.
  **QPR** (quarterly platform release) is a smaller update between major versions, such as Android 17 QPR1.
- **Source drop:** a moment when Google publishes a new batch of AOSP's source code.
  From 2026 this happens only twice a year, in Q2 and Q4.
- **LineageOS:** the best-known free version of Android, built by volunteers for about 150 phone models.
  The current proposal is to build FoxieOS on LineageOS 24.0, which is based on Android 17.
- **GrapheneOS:** a free version of Android focused on security, only for Google Pixel phones.
- **CalyxOS, /e/OS, crDroid, iodéOS:** other free versions of Android, most of them built on LineageOS.
- **Distribution:** a ready-to-install version of an operating system, made by a particular project.
- **Fork:** a project that starts from a copy of another project and changes it.
  A **soft fork** stays very close to the original and keeps taking its updates; FoxieOS plans to be a soft fork of LineageOS.
- **Upstream:** the project FoxieOS builds on (LineageOS, and AOSP behind it).
  "Sending a fix upstream" means offering it to them.
- **Carry patch:** a change FoxieOS makes to upstream code and has to carry along at every update.
  They are listed in [PATCHES.md](PATCHES.md).
- **Rebase (on a new version):** moving FoxieOS's own changes onto a newer version of upstream, for example from LineageOS 24.0 to the next major version.

## Building FoxieOS

- **Source code / source tree:** all the files that FoxieOS is built from.
  For Android this is about 400 GB, so it stays on the build computer and never goes into these repositories.
- **Sync:** downloading or updating the source tree, with a tool called `repo`.
- **Manifest:** a list of every part of the source tree and the exact version of each, so anyone can download the same set.
- **Build:** turning the source code into files that can be installed on a phone.
  A full build of Android takes hours.
- **Build host:** the computer that holds the source tree and runs the builds.
  Roadmap decision D2 chooses it.
- **Signing host:** a separate, offline computer where the release keys are kept and releases are signed.
  Roadmap decision D7 chooses it.
- **Test host:** a computer that runs tests, so the build host is free for the next build.
- **RAM:** a computer's working memory.
  Android 17's build needs a lot of it at one step (about 55 GB or more).
- **Swap and zram:** ways to stretch RAM.
  Swap uses the disk; zram compresses part of the memory instead.
  Both are slower than real RAM.
- **NVMe:** a fast kind of disk.
- **ccache:** a store of earlier build results, so a rebuild after a small change is much faster.
- **Soong, `soong_build`, Siso, Ninja:** parts of Android's build system.
  `soong_build` is the step that reads the whole tree and needs the most memory.
- **Remote execution:** sending parts of a build to other computers.
  FoxieOS doesn't plan to use it.
- **`vendor/foxie`:** the folder in the source tree where FoxieOS's own additions will live: its logo, settings and apps.
- **Overlay:** a small file that changes a setting or image in Android without editing Android's own files.
- **Property:** a named value built into the system, such as `ro.foxie.version`, which says which FoxieOS version is installed.
- **Build variant:** `userdebug` builds keep some tools for developers; `user` builds don't and are what normal phones run.
  Roadmap decision D6 chooses which one releases use.
- **Target:** what a build is made for, such as one phone model or a virtual device.
- **KVM:** a feature of Linux that lets a computer run virtual devices at full speed.

## Phones and their parts

- **Device:** a phone, or another gadget, that FoxieOS runs on.
- **Codename:** the short internal name of a phone model, such as `tegu` for the Pixel 9a.
- **Device tree:** the files that teach Android how to run on one particular phone model.
- **Bootloader:** the small program that starts the phone and checks what it is allowed to start.
- **Unlocking the bootloader:** allowing the phone to start an operating system its maker didn't sign.
  It is needed to install FoxieOS, and it wipes the phone.
- **Relocking:** locking the bootloader again after installing FoxieOS, so the phone again refuses software that isn't signed.
  This only works on some phones, and doing it on the wrong phone can make it unusable.
- **Brick:** to make a phone unusable, usually by a failed install or relock.
- **Flash:** to write a new operating system onto a phone.
- **Verified boot (AVB):** the check at every start-up that the system hasn't been changed.
  **`avb_custom_key`** is the place on a phone where an owner can store their own key, so the phone accepts a system signed by someone other than its maker.
- **Kernel:** the core of the operating system, which talks to the hardware.
- **GKI (Generic Kernel Image):** Google's shared kernel for newer phones.
  Each GKI version (such as 5.15, 6.1 or 6.6) gets updates until a fixed end date.
- **Firmware:** the software inside a phone's chips, such as the modem.
  Only the phone's maker can update it.
- **Vendor blobs:** files from the phone's maker that Android needs but that aren't open source.
- **Modem:** the part of the phone that talks to the mobile network.
- **TEE, secure element, MTE:** hardware security features that keep secrets safe or stop some attacks.
- **Treble and GSI (Generic System Image):** Treble splits Android so that one generic system image can run on many phones.
  A GSI is easy to spread, but has no verified boot and works less well on each phone.
- **Pixel, Fairphone, OnePlus, Sony Xperia:** phone brands mentioned in the device research.
- **End of life:** the date after which a phone or a part of it gets no more updates.

## Updates and releases

- **OTA (over-the-air) update:** an update the phone downloads and installs itself.
- **Full update:** an OTA that contains the whole system.
  **Incremental update:** a smaller OTA that contains only the changes since one particular earlier version.
- **A/B (and Virtual A/B):** a way of updating where the phone installs the new version beside the old one, so it can fall back to the old one if something goes wrong.
- **Anti-rollback:** a protection that stops a phone from installing an older version than it already has.
- **Updater:** the LineageOS app on the phone that checks for and installs updates.
- **Update server:** the website the Updater downloads updates from.
  Roadmap decision D4 chooses where it is hosted.
- **Update channels:** `testing`, `beta` and `stable`.
  A new version goes to testers first, then to more people, then to everyone.
- **Release candidate (RC):** a version that could become a release if it passes every test.
- **Release keys:** the secret files that sign FoxieOS releases, so phones can tell a real update from a fake one.
  Only the maintainer handles them.
- **Dev keys and test-keys:** keys for testing only, never for anything published.
- **Signing:** marking files with a key so that a phone can check where they came from.
- **APEX:** a package format for parts of Android that can be updated separately; each has its own key.
- **Target-files:** the unsigned output of a build, which is signed afterwards on the signing host.
- **Security patch level:** the date of the newest security fixes a system contains.
- **Security bulletin:** Google's monthly list of Android security problems and their fixes.

## Testing

- **Test layer:** one stage of testing, numbered L0 to L8 in [TESTING.md](TESTING.md).
- **Virtual device:** a phone simulated on a computer, used for testing without a real phone.
- **Cuttlefish:** Google's virtual Android device for automated testing.
  FoxieOS tests on it until the first real phone arrives.
- **Emulator (goldfish):** another virtual Android device, mostly for trying things by hand.
- **Smoke test:** a quick check that the basics work, such as the phone starting up.
- **CTS (Compatibility Test Suite):** Google's large set of tests that checks whether a system behaves like Android should.
- **Baseline:** the list of CTS tests that already fail on plain LineageOS.
  FoxieOS only has to avoid adding new failures.
- **Tradefed:** the program that runs CTS.
  **Sharding** splits one test run over several computers.
- **adb:** a tool for controlling an Android device from a computer.
- **TAP:** a simple text format for test results.

## Apps, privacy and security

- **Google apps / Google Mobile Services (GMS):** Google's own apps and services, such as the Play Store.
  They need a licence from Google, so FoxieOS won't include them.
- **Play Integrity:** Google's check that apps, such as banking apps, use to see whether a phone runs approved software.
  FoxieOS won't pass it, and won't try to cheat it.
- **microG:** a free replacement for some Google services.
  **Signature spoofing** is a trick that lets microG stand in for Google's services.
  Roadmap decision D5 chooses whether FoxieOS includes microG.
- **SELinux:** a security system in Android that limits what each program may do.
  "Enforcing" means it is switched on.
- **Root / `su`:** full control over the system.
  FoxieOS doesn't include it, because it weakens security.
- **Hardening:** extra security changes beyond the usual ones.

## Law and money

- **Cyber Resilience Act (CRA):** an EU law with security duties for anyone who sells digital products.
- **Ecodesign rules:** EU rules that, among other things, make phone makers provide updates for at least five years.
- **Manufacturer:** in EU law, whoever sells a product under their own name, and so carries its legal duties.
- **Trademark search:** checking official registers (EUIPO in the EU, USPTO in the US) that nobody else owns the name "FoxieOS".
- **Licences (Apache, MIT, GPL):** the terms under which code can be used.
  Apache and MIT allow almost anything; the GPL, which covers the Linux kernel, requires publishing the source code of what you ship.
