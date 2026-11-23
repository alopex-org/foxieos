# FoxieOS releasing

**Status: planned.**
No keys exist and nothing has been released.
What a release is, and how it is signed and delivered, depends on what FoxieOS is built on (roadmap decision D10); tasks T8, T9 and T13 write the details once it is chosen.
Technical words are explained in the [glossary](GLOSSARY.md).

This page holds the rules proposed to apply whatever the base, carried over from the earlier plan for the maintainers to confirm.

## In short

- Every release is **signed** with a secret release key, so a device installs only genuine FoxieOS releases.
- Only **the maintainer** creates the release keys and signs releases, on a separate offline computer, the signing host.
  Nobody else handles the release keys.
  Scripts are written and tested with practice keys (dev keys) that never sign anything published.
- Each release is **checked** after signing, then reaches people in three steps: `testing`, `beta`, then `stable`.
- **Security fixes** have time targets, at the end of this page.

## Release rules

- Never reuse a build number.
- Never ship an older version over a newer one.
- Never skip a test layer ([TESTING.md](TESTING.md)) for a stable release.
- The release notes state what the release is built from, the supported devices, and the known problems.

## Keys

There are two sets of keys:

- **Dev keys,** for automatic checks, development devices and local testing only, never for anything published.
- **Release keys,** encrypted, with a passphrase, kept only on the signing host and its offline backups.

The `testing` channel already uses release keys, so testers follow the same path as everyone else.

Secure boot, if the cyber-deck's board has it, uses a key whose fingerprint may be written into the chip for good ([FEASIBILITY.md](FEASIBILITY.md#secure-boot)).
Who holds that key is decision [D9](ROADMAP.md#d9-devices-from-the-hardware-project).

`docs/KEYS.md` (task T8) will hold the step-by-step procedure for creating, backing up and changing the keys.

## Signing

The maintainer signs on the signing host (decision D7).
`release/sign.sh` (task T8) is given the location of the keys and never reads them itself; it unlocks them into memory only, and wipes the memory afterwards.
`release/verify.sh` checks the signature against the release key, and that a dev-key signature is refused.

## Release record

Each release gets a record holding:

- the exact list of what went into it, with versions, so it can be built again;
- the build date and build number;
- `SHA256SUMS`, a list of fingerprints of every file, and its signature;
- the release notes ([Release rules](#release-rules)).

Release tags in git are signed.

Publishing a release on GitHub announces it in the Alopex Discord's announcements channel (`.github/workflows/discord-release.yml`), once the maintainer has set the `DISCORD_WEBHOOK_RELEASES` secret.

## Channels

- At least 48 hours on `testing`, then at least 7 days on `beta`, then `stable`.
  A security emergency fix may shorten this to 24 hours on testing and 48 hours on beta, with a note in the release notes.
- How a device gets releases from each channel depends on decision D10, and where they are hosted on decision D4.

## Security update targets

How fast FoxieOS aims to ship security fixes, counted from the day the project FoxieOS builds on publishes the fix:

| Event | FoxieOS target |
|---|---|
| A serious fix | testing within 7 days, stable within 14 days |
| Other fixes | in the next regular release |
| A board's maker stops supporting it | announce it at least 90 days before dropping the device, and record it in [DEVICES.md](DEVICES.md) |
