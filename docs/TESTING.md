# FoxieOS testing

**Status: planned.**
None of the scripts below exist yet; roadmap tasks T3, T6, T8 and T11 build them.
Until the cyber-deck exists, layers L1–L3 run on a virtual machine ([Virtual machine](#virtual-machine)), and layers L4, L5 and L7 on a development board.

How builds are signed and shipped is in [RELEASING.md](RELEASING.md).
Sources are listed at the [end of this file](#sources) and in [FEASIBILITY.md](FEASIBILITY.md#sources).
Technical words are explained in the [glossary](GLOSSARY.md).

## In short

- Every change, every night's build and every release goes through a series of tests, called layers, numbered L0 to L8.
- The early layers are quick and automatic: they check the files, build FoxieOS, and start it on a virtual machine.
- The later layers are slower: tests on a real board, update tests, signature checks, a checklist on the cyber-deck, and finally testers using it day to day.
- If any layer fails, the process stops until the problem is fixed.

## The order of the tests

```
Every change:
  L0 file checks → L1 build and L2 unit tests → review → merge

Every night:
  L1 full build → L3 start-up and quick checks on the virtual machine

Every release candidate:
  build → sign offline → L6 signature checks → L4 board tests → L5 update tests
  → L7 checklist on each device → testing channel (48 hours or more)
  → beta (7 days or more) → stable
```

A failure at any layer stops everything after it.
Fix the problem with a new change rather than going back, and never skip a layer for a stable release.
A security emergency fix may shorten L8 to 24 hours on testing and 48 hours on beta, with a note in the release notes.

## Test layers

| Layer | Runs | On | Passes when |
|---|---|---|---|
| [L0 file checks](#l0-file-checks) | every commit | any computer | nothing is found |
| [L1 build](#l1-build) | every pull request; nightly | build host | the build succeeds |
| [L2 unit tests](#l2-unit-tests) | every pull request | build host | all tests pass |
| [L3 start-up and quick checks](#l3-start-up-and-quick-checks) | pull requests that change the system; nightly | virtual machine | it starts and the checks pass |
| [L4 board tests](#l4-board-tests) | every release candidate | development board | the checks pass on real hardware |
| [L5 updates](#l5-update-tests) | every release candidate | board or device | every scenario passes |
| [L6 signatures](#l6-signature-checks) | every release candidate | signing host | only the release key |
| [L7 device checklist](#l7-device-checklist) | every release candidate | each device | checklist complete |
| [L8 everyday use](#l8-everyday-use) | after L7 | testers | no serious new problems |

### L0: file checks

The pre-commit checks in `.pre-commit-config.yaml` run on every commit ([CONTRIBUTING.md](../CONTRIBUTING.md#keys-secrets-and-personal-details)):

- gitleaks looks for keys, tokens and other secrets;
- two checks block key files and private `*.local.md` notes by name;
- a check makes sure the commit is signed off.

From task T6, `ci/presubmit.sh` adds checks of shell scripts (ShellCheck) and of the settings files (unsourced).

### L1: build

`ci/build.sh` builds the whole system image from a clean start (task T2).
It passes when the image is built and its size is within the limit the board's storage allows.

### L2: unit tests

Tests of FoxieOS's own programs and scripts, without starting the system: for example, the program that writes update descriptions, and the service that drives the signal gauges.

### L3: start-up and quick checks

The image starts on the virtual machine, and `tests/smoke/run.sh` checks over SSH that:

- the system started, and reports FoxieOS's version and channel;
- its services are running, with none failed;
- the data partition is encrypted;
- the update service knows both slots.

The script prints its results in TAP format, so CI can read them.

### L4: board tests

The quick checks again, on the development board, plus what a virtual machine can't test: the LoRa radio sending and receiving, Wi-Fi, the GNSS receiver, and the board's temperature under load.

### L5: update tests

The scenarios in [Update tests](#update-tests), on the development board and, once it exists, on the cyber-deck.

### L6: signature checks

`release/verify.sh` on the signing host ([RELEASING.md](RELEASING.md#checking-a-signed-release)).

### L7: device checklist

A checklist for each device, kept in `tests/qa/<device>.md` (task T11), done by hand before every release:

- start-up, and unlocking the encrypted storage;
- the touchscreen upright, the keyboard with the screen slid out, and the switch between the two;
- the knobs and side buttons;
- LoRa: sending and receiving a mesh message, and the RSSI and SNR gauges moving with it;
- Wi-Fi, the GNSS position, and sound;
- each hardware switch: the part stops, and the interface shows it;
- swapping each battery while the device runs on the other, charging, and battery drain overnight.

### L8: everyday use

Testers use the release on the `testing` channel, then `beta`, for the times in [RELEASING.md](RELEASING.md#update-server-and-channels).

## Virtual machine

The automatic tests start FoxieOS on a virtual 64-bit Arm machine with QEMU on the build host (unsourced).

- It tests the system and its services, not the hardware: there is no LoRa radio, no screen sliding and no batteries.
- The tests can start, wipe and restart virtual machines as often as needed.

## Update tests

The update scenarios, kept in `tests/ota/`.
How the update files are made is in [RELEASING.md](RELEASING.md#update-files).

They run on the development board or the cyber-deck, where the maintainer does or approves every install.
In the scenarios, N is the new build and N-1 the one before it.

1. **Update** from N-1 to N, through the update service on the `testing` channel.
   Afterwards the device runs from the other slot, the quick checks pass, the slot is marked good, and test data is still there: a mesh contact, a file, and a saved Wi-Fi network.
2. **A failed start:** install a build that doesn't start properly.
   The device goes back to N-1 by itself, and reports the failure.
3. **Interrupted install:** cut the power during the install.
   The device starts N-1, and trying again works.
4. **A bundle with the wrong signature:** offer a bundle signed with the dev key to a device that trusts only the release key.
   The device refuses it.
5. **Clean install** from the full image, then the first update.

## Commands

None yet.
Task T2 adds the build commands, once decision D10 has chosen the base.

## Sources

- RAUC: [using RAUC][rauc-using], [advanced topics][rauc-advanced] (slots, marking good or bad, keys).
- Home Assistant OS: [update system][haos-update] (A/B on the Raspberry Pi 5).
- Tools: [gitleaks README][gitleaks-readme], with the [hooks it provides for pre-commit][gitleaks-hooks].

[gitleaks-hooks]: https://github.com/gitleaks/gitleaks/blob/v8.30.1/.pre-commit-hooks.yaml
[gitleaks-readme]: https://github.com/gitleaks/gitleaks/blob/v8.30.1/README.md
[haos-update]: https://contributors.home-assistant.io/os/operating-system/update-system/
[rauc-advanced]: https://rauc.readthedocs.io/en/latest/advanced.html
[rauc-using]: https://rauc.readthedocs.io/en/latest/using.html
