# FoxieOS releasing

**Status: planned.**
No keys exist and nothing has been released; roadmap tasks T8–T10 build this.
Sources are listed at the [end of this file](#sources).

The **maintainer** generates the release keys and does the signing.
Scripts are written and tested with dev keys only; coding agents never handle release keys ([AGENTS.md](../AGENTS.md), hard rule 1).

## Release rules

- Never reuse a build number.
- Never ship a downgrade.
- Never skip a test layer ([TESTING.md](TESTING.md)) for a stable release.
- The release notes state the security patch level, the LineageOS tag the release is based on, the supported devices, and the known issues.
- Publish the real `ro.build.version.security_patch`; never inflate it.
  Play Integrity's *strong* verdict depends on it.

## Keys

A release needs:

- the platform keys `releasekey`, `platform`, `shared`, `media`, `networkstack`, `bluetooth`, `nfc` and `sdk_sandbox`; LineageOS also generates `cyngn-app`, `testcert` and `verity`;
- about 70 APEX keys (SHA256_RSA4096);
- an AVB key (RSA-4096).
  Its public part (`avb_custom_key.bin`, also called `avb_pkmd.bin`) is what a relockable device is given.

There are two key sets:

- **Dev keys**, for CI and local testing only, never for anything published.
  The output of LineageOS's `lineage-priv-template/keys.sh` is acceptable here, even though it is unencrypted.
- **Release keys**, encrypted with scrypt and AES-256, with one passphrase per set (the GrapheneOS model).
  They exist only on the signing host and its offline backups.

The `testing` channel uses release keys, so testers follow the real update chain.

Changing keys forces users to migrate or wipe their phones.
Treat a key rotation as an incident, not a routine step.

`docs/KEYS.md` (task T8) will hold the procedure for generating, backing up and rotating the keys.

## Signing

The maintainer signs on the signing host.

- **Inputs from the build host:** the unsigned `*-target_files-*.zip` and `otatools.zip`, built with `mka target-files-package otatools`.
- **`release/sign.sh --keys-dir <path>`** passes the path through and never reads the keys itself. It:
  1. decrypts the keys into tmpfs, with swap disabled;
  2. runs `sign_target_files_apks -o -d <keys> --extra_apks …` with the full `--extra_apks` and APEX list;
  3. wipes the tmpfs.
- The `--extra_apks` list changes between LineageOS versions.
  Copy it fresh from `wiki.lineageos.org/signing_builds` for each release (roadmap check C9).

## OTA packages

- **Full update:** `ota_from_target_files signed-target_files.zip full.zip`.
- **Incremental update:** `ota_from_target_files -i PREV-signed-target_files.zip signed-target_files.zip incr.zip`.
  It applies only on the exact build it was made from.
- Ship a full update at least every 3–4 incremental ones.
- Keep the signed target-files of the last two releases; incremental updates and the OTA tests need them.

## Verification

`release/verify.sh` is test layer L6 in [TESTING.md](TESTING.md). It checks:

- the keys, with LineageOS's `check_keys.py` or an equivalent;
- the images, with `avbtool info_image` and `verify_image` against the AVB public key (unsourced);
- a sample of system apps, with `apksigner verify --print-certs` (unsourced);
- that `ro.build.tags` is `release-keys`;
- that `ro.build.version.incremental` and the build date in the OTA metadata match the release record.

## Release record

Each release gets a folder, `release/<BUILD_NUMBER>/`, in release storage, holding:

- the pinned manifest (`repo manifest -r -o manifest.xml`);
- `BUILD_DATETIME` and `BUILD_NUMBER`, so the unsigned build can be reproduced;
- `SHA256SUMS` and its signature;
- the release notes ([Release rules](#release-rules)).

Release tags in git are signed.
GrapheneOS uses SSH-signed tags with an `allowed_signers` file.

## Update server and channels

- The LineageOS Updater reads its server address from `updater_server_url` (a resource) or `lineage.updater.uri` (a property).
  The URL takes `{device}`, `{type}` and `{incr}` placeholders and must use HTTPS.
- ⚠ Take the exact JSON schema from the README of LineageOS's `android_packages_apps_Updater` (roadmap check C10).
- Channels: `testing` for at least 48 hours, then `beta` for at least 7 days, then `stable`.
  A security hotfix may shorten this to 24 hours on testing and 48 hours on beta, with a note in the release notes.
- Never publish a build older than the one already on a channel: devices refuse it (anti-rollback), and the release rules forbid it.

## Security update targets

Measured from the day the fix is merged upstream:

| Upstream event | FoxieOS target |
|---|---|
| LineageOS merges a high-risk fix from a monthly Android Security Bulletin | testing within 7 days, stable within 14 days |
| A quarterly bulletin bundle (March, June, September, December) | stable within 30 days |
| A new LineageOS major version (after the Q2 and Q4 AOSP drops, about every 6 months) | beta within 60 days of LineageOS's release; the old branch gets security fixes until then |
| A device's firmware reaches end of life | announce it at least 90 days before dropping the device, and record it in [DEVICES.md](DEVICES.md) |

## Sources

- LineageOS: [signing builds][lineage-signing].
- AOSP: [signing builds][aosp-sign], [OTA tools][aosp-ota-tools].
- GrapheneOS: [build guide][graphene-build] (encrypted keys, reproducible builds, signed tags, channels).
- LineageOS Updater: [README of the /e/OS fork][updater-readme].
- Google's risk-based security updates: [heise][heise-rbus].

[aosp-ota-tools]: https://source.android.com/docs/core/ota/tools
[aosp-sign]: https://source.android.com/docs/core/ota/sign_builds
[graphene-build]: https://grapheneos.org/build
[heise-rbus]: https://www.heise.de/en/news/Bad-news-for-custom-ROMs-Google-changes-Android-security-patch-strategy-10645674.html
[lineage-signing]: https://wiki.lineageos.org/signing_builds
[updater-readme]: https://gitlab.e.foundation/e/os/android_packages_apps_Updater/-/raw/a14/README.md
