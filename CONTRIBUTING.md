# Contributing to FoxieOS

Thank you for helping.
This page explains how to suggest a change and the rules every change follows.
GitHub words such as branch, commit and pull request are explained in the [organization's glossary][glossary].

FoxieOS is still being planned.
This repository holds the docs, and later the scripts and tests that build, check and release FoxieOS.
The Android code itself will come from LineageOS; FoxieOS's own Android code will live in `vendor/foxie` and in a separate manifest repository (roadmap task T5).

Everyone in the `alopex-org` organization follows its [code of conduct][coc], and its [governance][governance] says who decides what.
If you use an AI coding agent, you are responsible for its work as for your own; the agent's own rules are in [AGENTS.md](AGENTS.md).

## In short

1. Read [README.md](README.md) and [docs/DESIGN.md](docs/DESIGN.md).
2. Pick something from [docs/ROADMAP.md](docs/ROADMAP.md) or its issues, or open an issue about what you want to change.
3. Fork the repository (until the founding meeting, members work from forks), then make a new branch for your change.
4. Make the change, and commit it with a sign-off (`git commit -s`).
5. Open a pull request and say what you changed, why, and what you checked.
6. Someone else reviews it; answer their comments.
7. The maintainer merges it.

The sections below explain each rule.

## Before you start

- **Install the checks.**
  Install [pre-commit](https://pre-commit.com/#install), then run `pre-commit install` in your clone.
  From then on, every commit is checked for secrets, key files and private notes ([Keys, secrets and personal details](#keys-secrets-and-personal-details)), and for a sign-off ([Sign-off](#sign-off)).
  If you set up your clone before the sign-off check was added, run `pre-commit install` again.
- **Choose the work.**
  Pick work from [docs/ROADMAP.md](docs/ROADMAP.md), or from its [issues](#issues-and-labels).
  Decisions marked open there are the maintainers' to make, so ask before building on one.
- **Talk it over.**
  Organization members also discuss the work on the Alopex Discord, which has no public invite for now.
  Discord is for conversation, not for keeping a record.
  Put anything that should be kept, such as a bug, a correction or an argument for a decision, in an issue or a pull request.
- **Security problems** go through [SECURITY.md](SECURITY.md), never a public issue.
  Don't post them, or code-of-conduct reports, on Discord either.
- **Asking for a new phone:** use the device-request issue form.
  The rules for choosing phones are in [docs/DEVICES.md](docs/DEVICES.md).

## Branches

Until the founding meeting on 2026-11-24 ([governance][governance]), members can read this repository but not change it directly, like everyone else.
Put your branch in your own fork and open the pull request from there.

Use a new branch for each change, named after what it changes:

- `feat/<topic>` for something new, `fix/<topic>` for a fix, `docs/<topic>` for the docs;
- `device/<codename>-<topic>` for one phone;
- `rebase/lineage-<version>` for moving to a new LineageOS version;
- `release/<BUILD_NUMBER>` for a release.

## Commits

- **Subject line:** write `scope: description`, as a command, for example `vendor/foxie: add boot animation`.
  The scope is the part of the project the change touches.
- **Body:** explain *why* you made the change.
- **Sign-off:** sign off every commit with `git commit -s` ([Sign-off](#sign-off)).
- **One change per commit:** keep each commit to one logical change.
- **Docs with the change:** update the docs in the same commit as the behaviour they describe.
- **Email address:** commit with your GitHub noreply address (`<id>+<login>@users.noreply.github.com`, set with `git config --local user.email`), not a personal address.
- **If the project moves to Gerrit later** (another review tool), keep the `Change-Id` line Gerrit adds.

## Sign-off

FoxieOS uses the [Developer Certificate of Origin][dco] (DCO) instead of a contributor licence agreement.
By adding a `Signed-off-by:` line to a commit, you state that you wrote the change, or otherwise have the right to submit it, under the project's licence.

- `git commit -s` adds the line from your `user.name` and `user.email`.
  It must use the same address as the commit's author, which is your GitHub noreply address ([Commits](#commits)).
- The commit check in `.pre-commit-config.yaml` refuses a commit without the line.
  On GitHub, the DCO workflow (`.github/workflows/dco.yml`) checks every commit in a pull request, and `main` accepts a pull request only once it passes.
- **Forgot the sign-off?**
  Run `git rebase --signoff main`, then push the branch again with `git push --force-with-lease`.
- **Updating your branch:** the check also covers merge commits, so a plain `git merge`, or a `git pull` that creates a merge commit, is refused.
  Bring a branch up to date with `git pull --rebase` or `git rebase main` instead.
  If you really need a merge commit, use `git merge --signoff`.
- Commits from bots, such as Dependabot, don't need a sign-off.

The sign-off is a person's statement.
If an AI coding agent writes a commit for you, you sign it off with your own name, and you take responsibility for it as for your own work.

## Review

Someone other than the author reviews every change.

- **Until the founding meeting** on 2026-11-24 ([governance][governance]), only the interim maintainer's approval lets a pull request merge.
  `.github/CODEOWNERS` names them as the owner of every file.
- **Members still review** each other's changes and the maintainer's own, and their comments are answered before merging.
  A member's approval doesn't count toward merging while members only have read access, but GitHub still records it on the pull request.
- **Docs, automatic checks and branding** may be reviewed by the reviewer with the help of a coding agent; the reviewer answers for that review as for their own.

A person must read every change to these sensitive areas:

- Android's security rules (SELinux policy), permissions and the Android framework;
- the Updater and the way updates reach phones;
- the signing scripts;
- the manifest;
- the kernel;
- any part of [docs/ROADMAP.md](docs/ROADMAP.md) or [docs/DESIGN.md](docs/DESIGN.md), which hold the decisions.

`.github/CODEOWNERS` asks for these reviews automatically, and the rules on `main` require a code owner's approval before such a change merges.

These rules, called a ruleset, protect `main`:

- every change arrives through a pull request; nobody pushes to `main` directly;
- someone with write access, other than the author, approves the pull request (until the founding meeting, only the interim maintainer has write access);
- pushing new commits cancels earlier approvals;
- every review comment thread is resolved before merging;
- the DCO check passes;
- the history stays one straight line: pull requests are merged by rebasing, so each commit lands on `main` as written, and rewriting or deleting `main` is blocked;
- the maintainer can override these rules on a pull request, for example to merge their own change, which no other code owner can approve, once another member has approved it.
  Every override is recorded in the ruleset's history.

A second ruleset covers tags: only the maintainer creates, moves or deletes a tag, so only the maintainer publishes a release.

In the pull request, list the commands you ran and what happened: what passed, what failed (with a short excerpt of the output) and what you skipped.

**Changes that touch another repository.**
If a change needs a matching change in a related repository, such as [alopex](https://github.com/alopex-org/alopex) for the Alopex hardware project, open a pull request there as well, and link each one from the other.
FoxieOS depends on Alopex, not the other way round.
A change in the hardware project can need a matching change here, but a change here never asks the hardware project to adapt to FoxieOS.

## Issues and labels

- **Every roadmap item has an issue.**
  Every decision (D), task (T) and check (C) in [docs/ROADMAP.md](docs/ROADMAP.md) has one, and each roadmap phase is a [milestone](https://github.com/alopex-org/foxieos/milestones).
  The roadmap stays the plan; the issues track progress and discussion.
  When an item changes, update the roadmap in a pull request and link the issue.
- **Issue types** say what an issue is: Decision, Task, Check, Bug or Feature.
- **Labels** say who does the work (`who:`), what it touches (`area:`) and what it is waiting for.
  The list lives in `.github/labels.sh`; change it there, not by hand on GitHub.
  Add a `device: <codename>` label when a phone joins.
- Until the founding meeting, only the maintainer sets labels, types and milestones.
  Suggest them in a comment.

## Changes to LineageOS or Android's own code

FoxieOS stays as close to the projects it builds on (its "upstream") as it can, so that each update from them is easy to take:

- Prefer overlays and `vendor/foxie` to editing upstream files.
- Every change to a LineageOS or AOSP repository is a *carry patch*.
  Record it in [docs/PATCHES.md](docs/PATCHES.md), with its reason and any link to the upstream discussion.
- Offer fixes to the upstream project where they belong.
  Once LineageOS has accepted a patch, FoxieOS drops its own copy at the next update.

## Keys, secrets and personal details

- **Never commit keys or secrets**, such as passwords, tokens or signing keys.
- **The pre-commit checks** in `.pre-commit-config.yaml` look at every commit:
  - [gitleaks][gitleaks] scans your changes for keys, tokens and other secrets;
  - two more checks block key files (the "Key material" patterns in `.gitignore`) and private `*.local.md` notes by name, in case one was added with `git add -f`.
- **Don't skip the checks** with `git commit --no-verify` or `SKIP=`.
  If gitleaks flags something that isn't a secret, say so in the pull request, and add a `gitleaks:allow` comment to the line, or the finding's fingerprint to `.gitleaksignore`.
- **If a check stops a real secret,** take the secret out of the change.
  If a secret ever reached GitHub, deleting it isn't enough: cancel or replace it, and tell the maintainer.
- The checks only run in a clone where `pre-commit install` was run.
  Automatic checks on GitHub will repeat them from roadmap task T6 (planned).
- Settings files are committed only as `*.example` templates, or encrypted with SOPS.
- Release keys live only on the signing computer and only the maintainer handles them ([docs/RELEASING.md](docs/RELEASING.md)).
- **Describe computers by their role** (build host, signing host, test host).
  Computer names, addresses, folder paths on your computer, account details and other personal information stay out of commits, pull requests and issues.
  Keep such notes in a `*.local.md` file, which git ignores.

[gitleaks]: https://github.com/gitleaks/gitleaks
[coc]: https://github.com/alopex-org/.github/blob/main/CODE_OF_CONDUCT.md
[governance]: https://github.com/alopex-org/.github/blob/main/GOVERNANCE.md
[glossary]: https://github.com/alopex-org/.github/blob/main/GLOSSARY.md
[dco]: https://developercertificate.org/

## Licensing and branding

- This repository is under the Apache License 2.0.
  `branding/` is excluded until the rights to the artwork are confirmed.
- Every kernel FoxieOS ships has its source code published, as its GPL licence requires.
- Keep the Apache and MIT notices in code you reuse, and credit code taken from GrapheneOS, CalyxOS or LineageOS.
- Use "Android" only to describe FoxieOS ("an operating system based on Android"), together with the line "Android is a trademark of Google LLC."
- Don't use GrapheneOS or LineageOS logos as FoxieOS branding.
- Don't claim that Google has certified FoxieOS, or that it passes Play Integrity.
  Passing Google's compatibility tests (CTS) gives neither.

## Writing docs

The docs are read by people first, many of them not technical, and reviewed as changes line by line.

- **Write for a reader who isn't technical.**
  Use short sentences and everyday words.
  Say what something means for the project before the technical detail.
- **Explain technical words** the first time a page uses them, or link to the [glossary](docs/GLOSSARY.md); add new words to the glossary.
- **Name the roadmap codes.**
  Write "decision D2 (the build host)", not just "D2", the first time a section uses a code.
- **One sentence per line.**
  The page on GitHub looks the same, and a change then shows exactly which sentence changed.
- **Keep table cells short.**
  When an entry needs more than a phrase, give it its own section or bullet list.
- **Back facts with a source:** link it in the sentence, or list the sources at the end of the section.
- **Mark doubt.**
  Mark a claim that isn't confirmed, or that sources disagree on, with ⚠, and say what would confirm it.
  Check a ⚠ claim before acting on it, then update the doc.
  Mark a statement from general knowledge, with no source checked, as "(unsourced)".
- **Label anything not built yet as planned.**
- **Call the project's owner "the maintainer".**
- **Keep instructions for coding agents in [AGENTS.md](AGENTS.md),** not in the docs people read.

## Security fixes

Security fixes come before new features.
The targets for shipping them are in [docs/RELEASING.md](docs/RELEASING.md#security-update-targets).
