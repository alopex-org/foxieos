# Contributing to FoxieOS

FoxieOS is in its planning phase.
This repository holds the docs, and later the scripts and tests that build, check and release FoxieOS.
The Android source itself comes from LineageOS; FoxieOS's own Android code will live in `vendor/foxie` and a manifest repository (roadmap task T5).

These rules apply to everyone, people and coding agents alike.
Agents also follow [AGENTS.md](AGENTS.md).
Everyone in the `alopex-org` organization also follows its [code of conduct][coc], and its [governance][governance] says who decides what.

## Before you start

- Read [README.md](README.md) and [docs/DESIGN.md](docs/DESIGN.md).
- Install [pre-commit](https://pre-commit.com/#install) and run `pre-commit install` in your clone.
  Every commit is then checked for secrets, key files and private notes ([Keys, secrets and personal details](#keys-secrets-and-personal-details)), and for a sign-off ([Sign-off](#sign-off)).
  If you set up your clone before the sign-off hook was added, run `pre-commit install` again.
- Pick work from [docs/ROADMAP.md](docs/ROADMAP.md), or from its [issues](#issues-and-labels).
  Decisions marked open there are the maintainers' to make; ask before building on one.
- Organization members also talk the work over on the Alopex Discord, which has no public invite for now.
  Discord is for conversation, not the record: put anything that should be kept, such as a bug, a correction or an argument for a decision, in an issue or a pull request.
- Report security problems as described in [SECURITY.md](SECURITY.md), never in a public issue.
  Don't post them, or code-of-conduct reports, on Discord either.
- To ask for a new device, use the device-request issue form.
  The criteria are in [docs/DEVICES.md](docs/DEVICES.md).

## Branches

Until the founding meeting on 2026-11-24 ([governance][governance]), members have read access to this repository, like everyone else.
Push your branch to your own fork and open the pull request from there.

Use a fresh branch for each change, named by what it changes:

- `feat/<topic>`, `fix/<topic>`, `docs/<topic>`
- `device/<codename>-<topic>`
- `rebase/lineage-<version>`
- `release/<BUILD_NUMBER>`

## Commits

- Write the subject as `scope: description`, in the imperative, for example `vendor/foxie: add boot animation`.
- Explain *why* in the body.
- Sign off every commit with `git commit -s` ([Sign-off](#sign-off)).
- Keep one logical change per commit.
- Change the docs in the same commit as the behaviour they describe.
- Commit with your GitHub noreply address (`<id>+<login>@users.noreply.github.com`, set with `git config --local user.email`), not a personal address.
- Coding agents add a `Co-Authored-By:` trailer naming themselves.
- If the project moves to Gerrit later, keep the `Change-Id` line Gerrit adds.

## Sign-off

FoxieOS uses the [Developer Certificate of Origin][dco] (DCO) instead of a contributor licence agreement.
By adding a `Signed-off-by:` line to a commit, you certify that you wrote the change or otherwise have the right to submit it under the project's licence.

- `git commit -s` adds the line from your `user.name` and `user.email`.
  It must use the same address as the commit's author, which is your GitHub noreply address ([Commits](#commits)).
- The commit-msg hook in `.pre-commit-config.yaml` refuses a commit without the line.
  The DCO workflow (`.github/workflows/dco.yml`) checks every commit in a pull request, and `main` accepts a pull request only once it passes.
- To fix a branch that lacks the line, run `git rebase --signoff main` and push the branch again with `git push --force-with-lease`.
- The hook also checks the message of a merge commit, so a plain `git merge` or `git pull` that creates one is refused.
  Bring a branch up to date with `git pull --rebase` or `git rebase main` instead; if you need a merge commit, use `git merge --signoff`.
- Commits from bots, such as Dependabot, are exempt.

**Commits written by coding agents.**
The sign-off is a person's statement, so an agent never certifies on its own behalf.
The person who directs the agent and asks it to commit signs those commits off with their own identity, and takes responsibility for them as for their own work.
The agent still names itself in a `Co-Authored-By:` trailer.

## Review

Every change is reviewed by someone other than its author.
Until the members choose the founding maintainers on 2026-11-24 ([governance][governance]), only the interim maintainer's approval lets a pull request merge: `.github/CODEOWNERS` makes them a code owner of every file.
Members still review each other's changes and the maintainer's own, and their comments are answered before merging.
With read access, a member's approval doesn't count toward merging, but it is still recorded on the pull request.
For docs, CI and branding, the reviewer may have a different coding agent read the change, and answers for it as for their own review.

A person must review changes to:

- SELinux policy, permissions and the Android framework;
- the Updater and the OTA path;
- the signing scripts;
- the manifest;
- the kernel;
- any part of [docs/ROADMAP.md](docs/ROADMAP.md) or [docs/DESIGN.md](docs/DESIGN.md), which hold the decisions.

`.github/CODEOWNERS` requests these reviews automatically for the paths in this repository, and the ruleset on `main` requires a code owner's approval before a change to them is merged.

A ruleset protects `main`:

- every change arrives through a pull request, and no one pushes to `main` directly;
- someone with write access other than the author approves the pull request (until the founding meeting, only the interim maintainer has write access), and pushing new commits dismisses earlier approvals;
- review threads are resolved before merging;
- the DCO check must pass;
- history stays linear: pull requests are merged by rebasing, so each commit lands on `main` as written, and force pushes and deleting the branch are blocked;
- the maintainer can bypass these rules on a pull request, for example to merge their own change, which no other code owner can approve, once another member has approved it.
  Bypasses are recorded in the ruleset's history.

A second ruleset covers tags: only the maintainer creates, moves or deletes a tag, so only the maintainer publishes a release.

In the pull request, list the commands you ran and their results: what passed, what failed (with a log excerpt) and what you skipped.

If a change needs a matching change in another FoxieOS repository, such as [foxieos-hardware](https://github.com/alopex-org/foxieos-hardware), open a pull request there as well, and link each one from the other.
FoxieOS depends on foxieos-hardware, not the other way round: a change in the hardware project can need a matching change here, but a change here never asks the hardware project to adapt to FoxieOS.

## Issues and labels

- Every decision (D), task (T) and check (C) in [docs/ROADMAP.md](docs/ROADMAP.md) has an issue, and each roadmap phase is a [milestone](https://github.com/alopex-org/foxieos/milestones).
  The roadmap stays the plan; the issues track status and discussion.
  When an item changes, update the roadmap in a pull request and link the issue.
- Issue types say what an issue is: Decision, Task, Check, Bug or Feature.
- Labels say who does the work (`who:`), what it touches (`area:`) and what it waits on.
  The list lives in `.github/labels.sh`; change it there, not by hand on GitHub.
  Until the founding meeting, only the maintainer sets labels, types and milestones; suggest them in a comment.
  Add a `device: <codename>` label when a device joins.

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
[coc]: https://github.com/alopex-org/.github/blob/main/CODE_OF_CONDUCT.md
[governance]: https://github.com/alopex-org/.github/blob/main/GOVERNANCE.md
[dco]: https://developercertificate.org/

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
