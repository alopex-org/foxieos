# FoxieOS releasing

**Status: planned.**
No keys exist and nothing has been released; roadmap tasks T7, T8 and T12 build this.
Sources are listed at the [end of this file](#sources), and technical words are explained in the [glossary](GLOSSARY.md).

## In short

- Every release is **signed** with a secret release key, so a device installs only genuine FoxieOS updates.
- Only **the maintainer** creates the release keys and signs releases, on a separate offline computer, the signing host.
  Nobody else handles the release keys.
  Scripts are written and tested with practice keys (dev keys) that never sign anything published.
- Each release is **checked** after signing, then reaches devices through an **update server** in three steps: `testing`, `beta`, then `stable`.
- A device installs an update **beside** the running system, and goes back to the old one if the new one doesn't start properly.
- **Security fixes** have time targets, at the end of this page.

## Release rules

- Never reuse a build number.
- Never ship an older version over a newer one.
- Never skip a test layer ([TESTING.md](TESTING.md)) for a stable release.
- The release notes state the version of the base system the release is built from, the supported devices, and the known problems.

## Keys

An update file is a RAUC bundle, signed with an X.509 certificate and key and checked against the certificates stored on the device (its keyring).

There are two sets of keys:

- **Dev keys,** for automatic checks, development devices and local testing only, never for anything published.
- **Release keys,** encrypted, with a passphrase, kept only on the signing host and its offline backups.

Release devices carry only the release certificate in their keyring, so they refuse a bundle signed with a dev key; development devices may trust both, as Home Assistant OS's development images do.
The `testing` channel already uses release keys, so testers follow the same update path as everyone else.

Secure boot, if it is set up on a device, uses a separate key whose fingerprint is written into the board's chip for good ([FEASIBILITY.md](FEASIBILITY.md#secure-boot-and-encryption)).
Who holds that key is decision [D9](ROADMAP.md#d9-devices-from-the-hardware-project).

Changing the release key means devices must first trust the new certificate, through an update signed with the old key (unsourced).
Treat a key change as planned work, never a quick fix.

`docs/KEYS.md` (task T7) will hold the step-by-step procedure for creating, backing up and changing the keys.

## Signing

The maintainer signs on the signing host.

- **From the build host** comes the unsigned system image and the files that go into the bundle.
- **`release/sign.sh --keys-dir <path>`** is given the location of the keys and never reads them itself.
  It:
  1. unlocks (decrypts) the key into memory only (tmpfs), with swap switched off, so it never touches a disk unencrypted;
  2. runs `rauc bundle` with the release certificate and key;
  3. wipes the memory.

## Update files

- A **bundle** holds the whole system image for one slot, and is signed as a whole.
- A **full image** is also published, for installing FoxieOS on a new device or starting over.
- Keep the images and bundles of the last two releases; the update tests need them.

## Checking a signed release

`release/verify.sh` is test layer L6 in [TESTING.md](TESTING.md).
It checks:

- that the bundle's signature is valid against the release certificate, and fails against the dev one (`rauc info` with each keyring) (unsourced);
- that the version and build number inside the bundle match the release record.

## Release record

Each release gets a folder, `release/<BUILD_NUMBER>/`, in the release storage, holding:

- the exact list of packages and sources used, with their versions;
- the build date and build number, so the image can be built again;
- `SHA256SUMS`, a list of fingerprints of every file, and its signature;
- the release notes ([Release rules](#release-rules)).

Release tags in git are signed.

Publishing a release on GitHub announces it in the Alopex Discord's announcements channel (`.github/workflows/discord-release.yml`), once the maintainer has set the `DISCORD_WEBHOOK_RELEASES` secret.

## Update server and channels

- **Where devices look for updates:** a small service on the device asks the update server, over HTTPS, for the newest bundle on its channel (task T8).
- **Channels:** at least 48 hours on `testing`, then at least 7 days on `beta`, then `stable`.
  A security emergency fix may shorten this to 24 hours on testing and 48 hours on beta, with a note in the release notes.
- **Never publish a build older than the one already on a channel.**

## Security update targets

How fast FoxieOS aims to ship security fixes, counted from the day the base system publishes the fix:

| Event | FoxieOS target |
|---|---|
| A serious fix in the base system or the kernel | testing within 7 days, stable within 14 days |
| Other fixes | in the next regular release |
| A new major version of the base system | beta within 60 days; the old version gets security fixes until then |
| A board's maker stops supporting it | announce it at least 90 days before dropping the device, and record it in [DEVICES.md](DEVICES.md) |

## Sources

- RAUC: [using RAUC][rauc-using], [advanced topics][rauc-advanced] (bundles, signatures, keyrings, separate dev and release keys).
- Home Assistant OS: [update system][haos-update] (which images trust which keys).
- Raspberry Pi: [Secure Boot Provisioner][rpi-provisioner].

[haos-update]: https://contributors.home-assistant.io/os/operating-system/update-system/
[rauc-advanced]: https://rauc.readthedocs.io/en/latest/advanced.html
[rauc-using]: https://rauc.readthedocs.io/en/latest/using.html
[rpi-provisioner]: https://www.raspberrypi.com/documentation/security/secure-boot-provisioner.html
