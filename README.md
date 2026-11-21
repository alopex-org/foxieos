# FoxieOS

![FoxieOS logo](branding/foxieos-logo.png)

FoxieOS is a planned Android distribution based on LineageOS 24.0 (Android 17).
It adds its own branding, privacy defaults and update server, for a short list of phones.

**Status: planning.**
No Android source has been synced and nothing is built yet.
This repository holds the plan; scripts and tests follow as the roadmap tasks are done.
The members choose the project's maintainers at a founding meeting on 2026-11-24, and the maintainers then decide its foundations together ([governance](https://github.com/alopex-org/.github/blob/main/GOVERNANCE.md#founding-maintainers)).

## What FoxieOS will be

- A soft fork of LineageOS: LineageOS's device support and security fixes, plus a FoxieOS layer in `vendor/foxie`.
- One phone at launch and at most four, each owned by a maintainer who tests every release on it.
- Signed releases delivered through `testing`, `beta` and `stable` update channels.

It will not ship Google apps, make apps that depend on Play Integrity work, or match GrapheneOS's hardening outside Pixels.
[docs/DESIGN.md](docs/DESIGN.md) explains why.

FoxieOS doesn't make hardware.
For a custom device, it depends on a separate project, [foxieos-hardware](https://github.com/alopex-org/foxieos-hardware), which researches building a device; whether that stays a prototype or becomes a product is its own open decision D5.
The dependency runs one way: the hardware project doesn't follow FoxieOS's requirements, and FoxieOS adapts to its choices.
Roadmap decision D9 covers whether, and on what terms, FoxieOS supports a device from it.

## Where to start

1. [docs/ROADMAP.md](docs/ROADMAP.md): open decisions and the next task.
2. [docs/DESIGN.md](docs/DESIGN.md): how the pieces fit together and why.
3. [docs/FEASIBILITY.md](docs/FEASIBILITY.md): the research behind the choices, with sources.

The other docs:

- [docs/TESTING.md](docs/TESTING.md): the test layers every change and release passes.
- [docs/RELEASING.md](docs/RELEASING.md): signing, update packages and channels.
- [docs/DEVICES.md](docs/DEVICES.md): supported devices, the selection criteria and the candidates for device #1.
- [docs/PATCHES.md](docs/PATCHES.md): changes FoxieOS carries on top of LineageOS and AOSP.

## Repository layout

- `docs/`: the documents listed above.
- `branding/`: the logo; later the boot animation and wallpapers.
- `ci/`: host checks and build and CI scripts (planned).
- `tests/`: smoke tests, CTS baselines, OTA scenarios and device checklists (planned).
- `release/`: signing, verification and update-metadata scripts (planned).
- `ota-server/`: the generator for the update server's files (planned).
- `.github/`: code owners, issue forms, the pull-request template, the DCO and Discord release-announcement workflows, the Dependabot configuration and the label list (`labels.sh`).
- `.pre-commit-config.yaml`: the checks that run on every commit ([CONTRIBUTING.md](CONTRIBUTING.md#before-you-start)).

Each planned folder's README names the roadmap task that fills it.
The Android source tree needs about 400 GB and is kept outside this repository.

## Releases

None yet.
Releases will be signed offline by the maintainer and published to an HTTPS update server ([docs/RELEASING.md](docs/RELEASING.md)).

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md).
AI coding agents also follow [AGENTS.md](AGENTS.md).
Report security problems as described in [SECURITY.md](SECURITY.md), not in public issues.

## License

Apache License 2.0; see [LICENSE](LICENSE).
The artwork in `branding/` is not covered until the rights to it are confirmed, and the license grants no rights to the FoxieOS name or logo.

Android is a trademark of Google LLC.
FoxieOS is not affiliated with Google or the LineageOS project.
