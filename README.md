# FoxieOS

![FoxieOS logo](branding/foxieos-logo.png)

FoxieOS is a planned operating system for a cyber-deck: a rugged, hand-held computer with a physical keyboard and a LoRa radio for messaging without a mobile network.
It is built on Linux, for the cyber-deck that the [Alopex](https://github.com/alopex-org/alopex) hardware project designs, and for the Raspberry Pi boards that the cyber-deck is built around.

**Status: planning.**
Nothing is built yet.
This repository holds the plan; the scripts and tests will follow as the roadmap's tasks are done.
The plan was for a version of Android built on LineageOS; the proposal in these docs replaces it with a Linux system for a cyber-deck.
The members choose the project's maintainers at a founding meeting on 2026-11-24, and the maintainers confirm or change that direction together ([governance](https://github.com/alopex-org/.github/blob/main/GOVERNANCE.md#founding-maintainers)).

Unfamiliar words are explained in two glossaries: [Linux and the cyber-deck](docs/GLOSSARY.md), and [GitHub and how we work](https://github.com/alopex-org/.github/blob/main/GLOSSARY.md).

## What FoxieOS will be

- **Linux for one device.**
  FoxieOS is a small Linux system made for the Alopex cyber-deck: its touchscreen and slide-out keyboard, its knobs and signal gauges, its two swappable batteries and its hardware switches.
  Which existing Linux system it starts from is open (roadmap decision D10).
- **Messaging without a network.**
  A LoRa mesh radio, running Meshtastic, is built in and works with no mobile network or Wi-Fi.
- **Private by default.**
  The whole storage is encrypted, and the hardware switches that cut the radios and the microphone are shown to the user.
- **Updated safely.**
  The whole system is updated in one piece, from signed update files, and falls back to the previous version if an update doesn't start.
  Updates reach testers first (`testing`), then more people (`beta`), then everyone (`stable`).

What it won't do:

- run Android apps, Google's apps or banking apps;
- support phones, or a long list of devices;
- make the cyber-deck's hardware: that is Alopex's work.

[docs/DESIGN.md](docs/DESIGN.md) explains why.

FoxieOS depends on Alopex, not the other way round: the hardware project doesn't follow FoxieOS's wishes, and FoxieOS adapts to its choices.
Roadmap decision D9 covers the terms on which FoxieOS supports a device from it.

## Where to start

1. [docs/ROADMAP.md](docs/ROADMAP.md): the open decisions and the next piece of work.
2. [docs/DESIGN.md](docs/DESIGN.md): how the pieces fit together, and why they were chosen.
3. [docs/FEASIBILITY.md](docs/FEASIBILITY.md): the research behind the choices, with sources.

The other docs:

- [docs/GLOSSARY.md](docs/GLOSSARY.md): the technical words, explained.
- [docs/DEVICES.md](docs/DEVICES.md): the cyber-deck, the boards used until it exists, and the rules for adding a device.
- [docs/TESTING.md](docs/TESTING.md): how every change and every release is tested.
- [docs/RELEASING.md](docs/RELEASING.md): how releases are signed and delivered.
- [docs/PATCHES.md](docs/PATCHES.md): the list of changes FoxieOS makes to the software it builds on.

## What's in this repository

- `docs/`: the documents listed above.
- `branding/`: the logo; later the start-up screen and wallpapers.
- `ci/`: scripts that check the build computer and run builds and automatic checks (planned).
- `tests/`: quick checks, update tests and a checklist for each device (planned).
- `release/`: scripts that sign and check releases and describe updates (planned).
- `ota-server/`: the tool that writes the update server's files (planned).
- `.github/`: GitHub settings: who reviews what, issue forms, the pull-request template, the automatic checks for sign-offs and the Discord release announcements, Dependabot, and the list of labels (`labels.sh`).
- `.pre-commit-config.yaml`: the checks that run on your computer before every commit ([CONTRIBUTING.md](CONTRIBUTING.md#before-you-start)).

Each planned folder has a short README that names the roadmap task that fills it.
Build output and downloads are kept outside this repository.

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

Linux is a registered trademark of Linus Torvalds.
Raspberry Pi is a trademark of Raspberry Pi Ltd.
FoxieOS is not affiliated with Raspberry Pi Ltd, the Meshtastic project or any other project named in these documents.
