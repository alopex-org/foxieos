# Instructions for coding agents

This file is for AI coding agents working in this repository.
[CONTRIBUTING.md](CONTRIBUTING.md) applies to you as well: branches, commits, review, carry patches and how to write the docs.

If an `AGENTS.local.md` file exists next to this one, read it too.
Files named `*.local.md` are git-ignored and hold notes for one contributor's setup.
Never copy anything from them into a commit, pull request or issue.

## The project in brief

FoxieOS is a planned Android distribution: a soft fork of LineageOS 24.0 (Android 17) for a short list of phones its maintainers own.
It is in the planning phase: no Android source has been synced and nothing is built yet.

- What it is and where things live: [README.md](README.md)
- How it fits together and why: [docs/DESIGN.md](docs/DESIGN.md), with the research in [docs/FEASIBILITY.md](docs/FEASIBILITY.md)
- What to do next: [docs/ROADMAP.md](docs/ROADMAP.md)
- How changes are tested: [docs/TESTING.md](docs/TESTING.md)
- How releases are signed and shipped: [docs/RELEASING.md](docs/RELEASING.md)
- Related repositories, including alopex, the separate hardware project that FoxieOS depends on (not the reverse): [docs/DESIGN.md](docs/DESIGN.md#related-repositories)

Every step in these docs is a plain shell or file step, so any agent can follow it.
Don't add a step that only one agent's own tools can perform.

## Commands

- Build: none yet.
  Task T2 adds `ci/sync.sh` and `ci/build.sh`; the upstream commands are in [docs/TESTING.md](docs/TESTING.md#commands).
- Checks: the pre-commit hooks in `.pre-commit-config.yaml` (gitleaks, blocks on key files and `*.local.md` notes, and a DCO sign-off on the commit message) run on every commit once `pre-commit install` has been run in the clone ([CONTRIBUTING.md](CONTRIBUTING.md#keys-secrets-and-personal-details)).
  On pull requests, the DCO workflow checks the sign-off again.
  If pre-commit isn't installed or set up in the clone, tell the maintainer rather than committing without the hooks.
  From task T6 on, `ci/presubmit.sh`.
- Release: done by hand by the maintainer ([docs/RELEASING.md](docs/RELEASING.md)).

## Hard rules

1. **Release keys are off-limits.**
   Never generate, read, print, copy, hash, upload or move release keys.
   Write the scripts and the procedure; the maintainer generates the keys and signs on the signing host.
   CI and your own tests use `test-keys` or a separate dev key set that never signs anything published.
2. **No action on a physical device without a go-ahead for that action.**
   This covers `fastboot flash`, `fastboot flashing unlock` and `lock`, erasing or flashing `avb_custom_key`, and factory resets.
   Relocking a phone that isn't proven relockable can brick it; Fairphone 5 and 6 owners have reported this.
   Cuttlefish and emulator instances are exempt: start, wipe and reflash them as needed.
3. **Nothing outward-facing without the maintainer.**
   That includes creating accounts, registering domains, uploading OTAs, pushing to any remote and posting announcements.
4. **Run long jobs in the background.**
   `repo sync`, full builds and CTS take hours.
   Log their output to `logs/<date>-<job>.log`, don't wait on them in the foreground, and report what ran and its exit status.
5. **Check ⚠ claims before acting on them**, then update the doc where you found the claim.
6. **Report honestly.**
   List the tests you ran, which passed and which failed (with log excerpts), and anything you skipped.
7. **Keep private details out of the repository.**
   Describe machines by their role, never by name, address, hardware inventory or local path ([CONTRIBUTING.md](CONTRIBUTING.md#keys-secrets-and-personal-details)).

## Stop and ask when…

- a roadmap decision (D1–D9) is needed and not yet recorded;
- a change here needs a matching change in another repository, such as `alopex`: propose one pull request in each, linking the other.
  FoxieOS depends on `alopex`, not the reverse, so don't propose a change there that asks it to adapt to FoxieOS;
- a step would flash, unlock, lock or wipe a physical device;
- a step touches release keys or the signing host, or would publish something (an OTA upload, a domain, a new repository, an announcement);
- a ⚠ command behaves differently from the docs (report what happened, and don't improvise on device-level steps);
- a test layer fails and the fix needs a carry patch to an upstream repository outside `vendor/foxie`;
- disk use would exceed the space task T1 measured, or a job would run longer than about 6 hours.

## Sign-off

Commit with `git commit -s` only when the person directing you asked for the commit: the sign-off is theirs, in their name ([CONTRIBUTING.md](CONTRIBUTING.md#sign-off)).
Never add a `Signed-off-by:` line for yourself or for anyone who didn't ask for the commit.
Add your own `Co-Authored-By:` trailer naming yourself as well.

## Review

- You may review a change to docs, CI or branding when a member asks you to, as a second reader for them.
  The member approves the pull request and answers for the review; you never approve on your own behalf.
- The sensitive areas in [CONTRIBUTING.md](CONTRIBUTING.md#review) (SELinux, permissions, the framework, the Updater and OTA path, signing scripts, the manifest, the kernel, the roadmap and the design) need a person's review.
  Say so in the pull request when your change touches one.

## Roadmap tasks

- Each task in [docs/ROADMAP.md](docs/ROADMAP.md) ends with **Finished when** and **Share**.
  Treat **Finished when** as the acceptance test, and put what **Share** asks for in the pull request, with the commands you ran and their results (hard rule 6).
- **Hands-on** steps on a physical phone (task T7 and the OTA scenarios in [docs/TESTING.md](docs/TESTING.md#update-tests)) need a go-ahead for each flash, unlock, lock or wipe (hard rule 2).
  Cuttlefish instances on the build host are exempt.
- **Maintainer only** steps (keys, accounts, purchases, publishing) are never yours to perform (hard rules 1 and 3).
  You may write the scripts and the procedure for them.

## Writing docs

The docs are written for members who aren't technical; follow [CONTRIBUTING.md](CONTRIBUTING.md#writing-docs), and in particular:

- Lead each page and section with what it means for the project, in plain words, before the technical detail.
- Explain a technical term the first time a page uses it, or link to [docs/GLOSSARY.md](docs/GLOSSARY.md), and add new terms there.
  GitHub and process terms go in the [organization's glossary](https://github.com/alopex-org/.github/blob/main/GLOSSARY.md).
- Give a roadmap code its name the first time a section uses it: "decision D2 (the build host)".
- Keep instructions addressed to coding agents in this file.
  The people docs mention agents only to say that the person who directs an agent is responsible for its work.
- When you rename a heading, search all three repositories in the organization (`foxieos`, `alopex` and `.github`) and the issue forms for links to its old anchor, and update them.
- Don't write a foundational choice as settled: until the maintainers confirm them, the base (LineageOS) and the other key decisions in [docs/DESIGN.md](docs/DESIGN.md#key-decisions) are proposals.

## Don't

- Commit `keys/`, `*.pk8`, `*.pem`, `*.key`, `avb*.bin`, `out/` or `logs/`; `.gitignore` already excludes them.
- Skip the pre-commit hooks with `git commit --no-verify` or `SKIP=`.
  Report a finding you think is a false positive instead.
- Put the Android source tree, build output or CTS downloads inside this repository.
- Edit an upstream repository in the source tree without an entry in [docs/PATCHES.md](docs/PATCHES.md).
