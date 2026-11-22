# FoxieOS

![FoxieOS logo](branding/foxieos-logo.png)

FoxieOS is a planned operating system for phones, based on Android.
The current proposal is to build it on LineageOS 24.0, an existing free version of Android 17, and to add FoxieOS's own look, privacy settings and update service, for a short list of phones.

**Status: planning.**
Nothing is built yet, and the Android source code hasn't been downloaded.
This repository holds the plan; the scripts and tests will follow as the roadmap's tasks are done.
The members choose the project's maintainers at a founding meeting on 2026-11-24.
The maintainers then decide the foundations together, including whether FoxieOS is built on LineageOS ([governance](https://github.com/alopex-org/.github/blob/main/GOVERNANCE.md#founding-maintainers)).

Unfamiliar words are explained in two glossaries: [Android and phones](docs/GLOSSARY.md), and [GitHub and how we work](https://github.com/alopex-org/.github/blob/main/GLOSSARY.md).

## What FoxieOS will be

- **Built on LineageOS.**
  FoxieOS stays close to LineageOS and takes its support for phones and its security fixes.
  FoxieOS's own additions live in one place, the `vendor/foxie` folder.
- **For few phones.**
  One phone at launch and at most four, each owned by a maintainer who tests every release on it.
- **Updated safely.**
  Every update is signed, so phones only install real FoxieOS updates.
  Updates reach testers first (`testing`), then more people (`beta`), then everyone (`stable`).

What it won't do:

- include Google's apps;
- make apps work that rely on Google's Play Integrity check, such as many banking apps;
- match GrapheneOS's security on phones other than Pixels.

[docs/DESIGN.md](docs/DESIGN.md) explains why.

FoxieOS doesn't make hardware.
A separate project, [alopex](https://github.com/alopex-org/alopex), researches building a device.
Whether that stays a prototype or becomes a product is that project's own open decision (its D5).
FoxieOS depends on it, not the other way round: the hardware project doesn't follow FoxieOS's wishes, and FoxieOS adapts to its choices.
Roadmap decision D9 covers whether, and on what terms, FoxieOS supports a device from it.

## Where to start

1. [docs/ROADMAP.md](docs/ROADMAP.md): the open decisions and the next piece of work.
2. [docs/DESIGN.md](docs/DESIGN.md): how the pieces fit together, and why they were chosen.
3. [docs/FEASIBILITY.md](docs/FEASIBILITY.md): the research behind the choices, with sources.

The other docs:

- [docs/GLOSSARY.md](docs/GLOSSARY.md): the technical words, explained.
- [docs/TESTING.md](docs/TESTING.md): how every change and every release is tested.
- [docs/RELEASING.md](docs/RELEASING.md): how releases are signed and delivered to phones.
- [docs/DEVICES.md](docs/DEVICES.md): which phones FoxieOS will support, the rules for choosing them, and the candidates for the first one.
- [docs/PATCHES.md](docs/PATCHES.md): the list of changes FoxieOS makes to LineageOS and Android's own code.

## What's in this repository

- `docs/`: the documents listed above.
- `branding/`: the logo; later the start-up animation and wallpapers.
- `ci/`: scripts that check the build computer and run builds and automatic checks (planned).
- `tests/`: quick checks, test lists, update tests and a checklist for each phone (planned).
- `release/`: scripts that sign and check releases and describe updates (planned).
- `ota-server/`: the tool that writes the update server's files (planned).
- `.github/`: GitHub settings: who reviews what, issue forms, the pull-request template, the automatic checks for sign-offs and the Discord release announcements, Dependabot, and the list of labels (`labels.sh`).
- `.pre-commit-config.yaml`: the checks that run on your computer before every commit ([CONTRIBUTING.md](CONTRIBUTING.md#before-you-start)).

Each planned folder has a short README that names the roadmap task that fills it.
The Android source code needs about 400 GB, so it is kept outside this repository.

## Releases

None yet.
When there are releases, the maintainer will sign them on an offline computer and publish them on a secure (HTTPS) update server ([docs/RELEASING.md](docs/RELEASING.md)).

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md).
Report security problems as [SECURITY.md](SECURITY.md) describes, never in a public issue.
AI coding agents also follow [AGENTS.md](AGENTS.md).

## License

Apache License 2.0; see [LICENSE](LICENSE).
The artwork in `branding/` isn't covered until the rights to it are confirmed, and the license gives no rights to the FoxieOS name or logo.

Android is a trademark of Google LLC.
FoxieOS is not affiliated with Google or the LineageOS project.
