# FoxieOS

![FoxieOS logo](branding/foxieos-logo.png)

FoxieOS is the planned operating system for the Alopex cyber-deck: a user-serviceable, portable computer with LoRa and Wi-Fi, pocket-sized if possible, that the [Alopex](https://github.com/alopex-org/alopex) hardware project works toward.
For now, FoxieOS is built on a Linux distribution; which one is undecided.

**Status: planning.**
Nothing is built yet.
This repository holds the plan; the scripts and tests will follow as the roadmap's tasks are done.
The plan was for a version of Android built on LineageOS, for phones.
At their founding meeting on 2026-11-24, the members confirmed that FoxieOS is made for the cyber-deck instead, on a Linux distribution for now, and is no longer a fork of AOSP or LineageOS ([governance](https://github.com/alopex-org/.github/blob/main/GOVERNANCE.md#the-founding-meeting)).
Everything else about the software is open, starting with which distribution.

Unfamiliar words are explained in two glossaries: [operating systems and the cyber-deck](docs/GLOSSARY.md), and [GitHub and how we work](https://github.com/alopex-org/.github/blob/main/GLOSSARY.md).

## What is open

- **Which Linux distribution FoxieOS is built on** (roadmap decision D10), and so how it is updated, secured and used.
- **What it must do:** beyond running the cyber-deck's LoRa and Wi-Fi, and letting its owner service it, that follows from Alopex's requirements for the cyber-deck (Alopex task T1) and FoxieOS's own (task T1 here).
- **Which devices it runs on:** the cyber-deck, whose main board and most parts are undecided, and a development board until the cyber-deck exists (decision D12).

FoxieOS doesn't make hardware: that is Alopex's work.
FoxieOS depends on Alopex, not the other way round: the hardware project doesn't follow FoxieOS's wishes, and FoxieOS adapts to its choices.
Roadmap decision D9 covers the terms on which FoxieOS supports a device from it.

## Where to start

1. [docs/ROADMAP.md](docs/ROADMAP.md): the open decisions and the next piece of work.
2. [docs/DESIGN.md](docs/DESIGN.md): what is decided, what is proposed, what is open, and why.
3. [docs/FEASIBILITY.md](docs/FEASIBILITY.md): research into the options, with sources.

The other docs:

- [docs/GLOSSARY.md](docs/GLOSSARY.md): the technical words, explained.
- [docs/DEVICES.md](docs/DEVICES.md): the cyber-deck, development boards, and the rules for adding a device.
- [docs/TESTING.md](docs/TESTING.md): how changes and releases will be tested.
- [docs/RELEASING.md](docs/RELEASING.md): how releases will be signed and delivered.
- [docs/PATCHES.md](docs/PATCHES.md): the list of changes FoxieOS makes to the software it builds on.

## What's in this repository

- `docs/`: the documents listed above.
- `branding/`: the logo; later the rest of FoxieOS's look.
- `ci/`: scripts that check the build computer and run builds and automatic checks (planned).
- `tests/`: automatic checks, update tests and a checklist for each device (planned).
- `release/`: scripts that sign and check releases (planned).
- `ota-server/`: the tool that writes the update server's files (planned).
- `.github/`: GitHub settings: who reviews what, issue forms, the pull-request template, the automatic checks for sign-offs and the Discord release announcements, Dependabot, and the list of labels (`labels.sh`).
- `.pre-commit-config.yaml`: the checks that run on your computer before every commit ([CONTRIBUTING.md](CONTRIBUTING.md#before-you-start)).

Each planned folder has a short README that names the roadmap task that fills it.
Build output and downloads are kept outside this repository.

## Releases

None yet.
When there are releases, the maintainer will sign them on an offline computer ([docs/RELEASING.md](docs/RELEASING.md)).

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md).
Report security problems as [SECURITY.md](SECURITY.md) describes, never in a public issue.
AI coding agents also follow [AGENTS.md](AGENTS.md).

## License

Apache License 2.0; see [LICENSE](LICENSE).
The artwork in `branding/` isn't covered until the rights to it are confirmed, and the license gives no rights to the FoxieOS name or logo.

FoxieOS is not affiliated with any company or project named in these documents.
