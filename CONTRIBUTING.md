# Contributing to FoxieOS

FoxieOS is in its planning phase.
This repository holds the docs, and later the scripts and tests that build, check and release FoxieOS.
The Android source itself comes from LineageOS; FoxieOS's own Android code will live in `vendor/foxie` and a manifest repository (roadmap task T5).

These rules apply to everyone, people and coding agents alike.
Agents also follow [AGENTS.md](AGENTS.md).

## Before you start

- Read [README.md](README.md) and [docs/DESIGN.md](docs/DESIGN.md).
- Install [pre-commit](https://pre-commit.com/#install) and run `pre-commit install` in your clone.
  Every commit is then checked for secrets, key files and private notes ([Keys, secrets and personal details](#keys-secrets-and-personal-details)).
- Pick work from [docs/ROADMAP.md](docs/ROADMAP.md).
  Decisions marked open there are the maintainer's to make; ask before building on one.
- Report security problems as described in [SECURITY.md](SECURITY.md), never in a public issue.
- To ask for a new device, use the device-request issue form.
  The criteria are in [docs/DEVICES.md](docs/DEVICES.md).

## Branches

Use a fresh branch for each change, named by what it changes:

- `feat/<topic>`, `fix/<topic>`, `docs/<topic>`
- `device/<codename>-<topic>`
- `rebase/lineage-<version>`
- `release/<BUILD_NUMBER>`

## Commits

- Write the subject as `scope: description`, in the imperative, for example `vendor/foxie: add boot animation`.
- Explain *why* in the body.
- Keep one logical change per commit.
- Change the docs in the same commit as the behaviour they describe.
- Commit with your GitHub noreply address (`<id>+<login>@users.noreply.github.com`, set with `git config --local user.email`), not a personal address.
- Coding agents add a `Co-Authored-By:` trailer naming themselves.
- If the project moves to Gerrit later, keep the `Change-Id` line Gerrit adds.

## Review

Every change is reviewed by someone other than its author.
For docs, CI and branding, a review by a different coding agent is enough.

A person must review changes to:

- SELinux policy, permissions and the Android framework;
- the Updater and the OTA path;
- the signing scripts;
- the manifest;
- the kernel.

`.github/CODEOWNERS` requests these reviews automatically for the paths in this repository.

In the pull request, list the commands you ran and their results: what passed, what failed (with a log excerpt) and what you skipped.

If a change needs a matching change in another FoxieOS repository, such as [foxieos-hardware](https://github.com/alopex-org/foxieos-hardware), open a pull request there as well, and link each one from the other.

## Changes to LineageOS or AOSP

FoxieOS stays as close to upstream as it can:

- Prefer overlays and `vendor/foxie` to editing upstream files.
- Every change to a LineageOS or AOSP repository is a *carry patch*.
  Record it in [docs/PATCHES.md](docs/PATCHES.md) with its reason and any upstream link.
- Send fixes upstream where they belong.
  A patch that LineageOS has merged is dropped at the next rebase.

## Keys, secrets and personal details

- Never commit key material or secrets.
- The pre-commit hooks in `.pre-commit-config.yaml` check every commit:
  - [gitleaks][gitleaks] scans the staged changes for keys, tokens and other secrets;
  - two more hooks block key files (the "Key material" patterns in `.gitignore`) and `*.local.md` notes by name, in case one was added with `git add -f`.
- Don't skip the hooks with `git commit --no-verify` or `SKIP=`.
  If a gitleaks finding is a false positive, say so in the pull request, and add a `gitleaks:allow` comment to the line or the finding's fingerprint to `.gitleaksignore`.
- If the hook stops a commit because of a real secret, take the secret out of the change.
  If a secret ever reached a pushed commit, removing it is not enough: revoke or rotate it, and tell the maintainer.
- A hook runs only in a clone where it is installed.
  CI will repeat the checks from roadmap task T6 (planned).
- Config files are committed only as `*.example` templates or SOPS-encrypted files.
- Release keys live only on the signing host and are handled only by the maintainer ([docs/RELEASING.md](docs/RELEASING.md)).
- Describe machines by their role (build host, signing host, test host).
  Hostnames, addresses, local paths, account details and other personal information stay out of commits, pull requests and issues.
  Keep such notes in a `*.local.md` file, which git ignores.

[gitleaks]: https://github.com/gitleaks/gitleaks

## Licensing and branding

- This repository is under the Apache License 2.0.
  `branding/` is excluded until the rights to the artwork are confirmed.
- Every shipped kernel has its GPL source published.
- Keep Apache and MIT notices, and credit cherry-picks from GrapheneOS, CalyxOS or LineageOS.
- Use "Android" only as a descriptor ("an operating system based on Android"), together with the line "Android is a trademark of Google LLC."
- Don't use GrapheneOS or LineageOS logos as FoxieOS branding.
- Don't claim Google certification or Play Integrity support.
  Passing CTS gives neither.

## Writing docs

The docs are read by people first, and reviewed as diffs.

- Put each sentence on its own line.
  The rendered page is unchanged, and a diff then shows exactly which sentence changed.
- Keep table cells short.
  When an entry needs more than a phrase, give it its own section or bullet list.
- Back factual claims with a source: link it in the sentence, or list the sources at the end of the section.
- Mark a claim that is unconfirmed or disputed with ⚠, and say what would confirm it.
  Check a ⚠ claim before acting on it, then update the doc.
- Mark a statement that rests on general knowledge, with no source checked, as "(unsourced)".
- Label anything not built yet as planned.
- Refer to the project's owner as "the maintainer".

## Security fixes

Security fixes take priority over features.
The targets for shipping them are in [docs/RELEASING.md](docs/RELEASING.md#security-update-targets).
