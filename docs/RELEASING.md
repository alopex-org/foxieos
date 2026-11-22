# FoxieOS releasing

**Status: planned.**
No keys exist and nothing has been released; roadmap tasks T8–T10 build this.
Sources are listed at the [end of this file](#sources), and technical words are explained in the [glossary](GLOSSARY.md).

## In short

- Every release is **signed** with secret release keys, so a phone installs only genuine FoxieOS updates.
- Only **the maintainer** creates the release keys and signs releases, on a separate offline computer, the signing host.
  Nobody else handles the release keys.
  Scripts are written and tested with practice keys (dev keys) that never sign anything published.
- Each release is **checked** after signing, then reaches phones through an **update server** in three steps: `testing`, `beta`, then `stable`.
- **Security fixes** have time targets, at the end of this page.

## Release rules

- Never reuse a build number.
- Never ship an older version over a newer one.
- Never skip a test layer ([TESTING.md](TESTING.md)) for a stable release.
- The release notes state the security patch level, the LineageOS version the release is based on, the supported phones, and the known problems.
- Report the real security patch level (`ro.build.version.security_patch`); never make it look newer than it is.
  Play Integrity's *strong* level depends on it.

## Keys

Android checks many separate signatures, so a release needs many keys:

- **platform keys:** `releasekey`, `platform`, `shared`, `media`, `networkstack`, `bluetooth`, `nfc` and `sdk_sandbox`; LineageOS also generates `cyngn-app`, `testcert` and `verity`;
- **about 70 APEX keys** (SHA256_RSA4096), one for each separately updatable part of Android;
- **one verified-boot (AVB) key** (RSA-4096).
  Its public part (`avb_custom_key.bin`, also called `avb_pkmd.bin`) is what a phone stores when its bootloader is locked again with FoxieOS's key.

There are two sets of keys:

- **Dev keys,** for automatic checks and local testing only, never for anything published.
  The unencrypted keys from LineageOS's `lineage-priv-template/keys.sh` are acceptable for this.
- **Release keys,** encrypted with scrypt and AES-256, with one passphrase per set (as GrapheneOS does).
  They exist only on the signing host and its offline backups.

The `testing` channel already uses release keys, so testers follow the same update path as everyone else.

Changing keys forces users to reinstall or wipe their phones.
Treat a key change as an emergency, not a routine step.

`docs/KEYS.md` (task T8) will hold the step-by-step procedure for creating, backing up and changing the keys.

## Signing

The maintainer signs on the signing host.

- **From the build host** come two unsigned files: `*-target_files-*.zip` and `otatools.zip`, made with `mka target-files-package otatools`.
- **`release/sign.sh --keys-dir <path>`** is given the location of the keys and never reads them itself.
  It:
  1. unlocks (decrypts) the keys into memory only (tmpfs), with swap switched off, so they never touch a disk unencrypted;
  2. runs `sign_target_files_apks -o -d <keys> --extra_apks …` with the full list of apps and APEX packages to sign;
  3. wipes the memory.
- The `--extra_apks` list changes between LineageOS versions.
  Copy it fresh from `wiki.lineageos.org/signing_builds` for each release (roadmap check C9).

## Update packages

An update package (OTA) is what a phone downloads and installs.

- **Full update,** the whole system: `ota_from_target_files signed-target_files.zip full.zip`.
- **Incremental update,** only the changes since one earlier build: `ota_from_target_files -i PREV-signed-target_files.zip signed-target_files.zip incr.zip`.
  It installs only on the exact build it was made from.
- Ship a full update at least once every 3–4 incremental ones.
- Keep the signed build files (target-files) of the last two releases; incremental updates and the update tests need them.

## Checking a signed release

`release/verify.sh` is test layer L6 in [TESTING.md](TESTING.md).
It checks:

- the keys, with LineageOS's `check_keys.py` or a similar tool;
- the system images, with `avbtool info_image` and `verify_image` against the public verified-boot key (unsourced);
- a sample of the built-in apps, with `apksigner verify --print-certs` (unsourced);
- that the build is marked as signed with release keys (`ro.build.tags` is `release-keys`);
- that the build number (`ro.build.version.incremental`) and the build date in the update's description match the release record.

## Release record

Each release gets a folder, `release/<BUILD_NUMBER>/`, in the release storage, holding:

- the exact list of source versions used (the pinned manifest, from `repo manifest -r -o manifest.xml`);
- `BUILD_DATETIME` and `BUILD_NUMBER`, so the unsigned build can be made again identically;
- `SHA256SUMS`, a list of fingerprints of every file, and its signature;
- the release notes ([Release rules](#release-rules)).

Release tags in git are signed.
GrapheneOS signs its tags with SSH keys and an `allowed_signers` file.

Publishing a release on GitHub announces it in the Alopex Discord's announcements channel (`.github/workflows/discord-release.yml`), once the maintainer has set the `DISCORD_WEBHOOK_RELEASES` secret.

## Update server and channels

- **Where phones look for updates.**
  The LineageOS Updater app reads the update server's address from `updater_server_url` (a resource) or `lineage.updater.uri` (a property).
  The address takes `{device}`, `{type}` and `{incr}` placeholders and must use HTTPS.
- ⚠ Take the exact format of the server's answers (its JSON schema) from the README of LineageOS's `android_packages_apps_Updater` (roadmap check C10).
- **Channels:** at least 48 hours on `testing`, then at least 7 days on `beta`, then `stable`.
  A security emergency fix may shorten this to 24 hours on testing and 48 hours on beta, with a note in the release notes.
- **Never publish a build older than the one already on a channel:** phones refuse it (anti-rollback), and the release rules forbid it.

## Security update targets

How fast FoxieOS aims to ship security fixes, counted from the day the fix is accepted upstream:

| Upstream event | FoxieOS target |
|---|---|
| LineageOS adds a serious fix from Google's monthly security bulletin | testing within 7 days, stable within 14 days |
| Google's quarterly bundle of fixes (March, June, September, December) | stable within 30 days |
| A new LineageOS major version (after Google's Q2 and Q4 code releases, about every 6 months) | beta within 60 days of LineageOS's release; the old version gets security fixes until then |
| A phone's maker stops updating its firmware | announce it at least 90 days before dropping the phone, and record it in [DEVICES.md](DEVICES.md) |

## Sources

- LineageOS: [signing builds][lineage-signing].
- AOSP: [signing builds][aosp-sign], [OTA tools][aosp-ota-tools].
- GrapheneOS: [build guide][graphene-build] (encrypted keys, reproducible builds, signed tags, channels).
- LineageOS Updater: [README of the /e/OS copy][updater-readme].
- Google's risk-based security updates: [heise][heise-rbus].

[aosp-ota-tools]: https://source.android.com/docs/core/ota/tools
[aosp-sign]: https://source.android.com/docs/core/ota/sign_builds
[graphene-build]: https://grapheneos.org/build
[heise-rbus]: https://www.heise.de/en/news/Bad-news-for-custom-ROMs-Google-changes-Android-security-patch-strategy-10645674.html
[lineage-signing]: https://wiki.lineageos.org/signing_builds
[updater-readme]: https://gitlab.e.foundation/e/os/android_packages_apps_Updater/-/raw/a14/README.md
