# FoxieOS testing

**Status: planned.**
Only the file checks (layer L0) are in place.
How the other layers run depends on what FoxieOS is built on (roadmap decision D10); tasks T5, T7, T9 and T12 write them once it is chosen.

How releases are signed is in [RELEASING.md](RELEASING.md).
Technical words are explained in the [glossary](GLOSSARY.md).

## In short

- Every change, and every release, goes through a series of tests, called layers.
- The early layers are quick and automatic; the later ones run on real hardware, and finally testers use a release day to day.
- If any layer fails, the process stops until the problem is fixed.
- Which tools run each layer is decided once the base is chosen.

## Test layers

| Layer | Runs | On | Passes when |
|---|---|---|---|
| [L0 file checks](#l0-file-checks) | every commit | any computer | nothing is found |
| L1 build | every pull request | build host | the build succeeds |
| L2 automatic checks | every pull request | build host, and a virtual machine if the base allows | all checks pass |
| L3 board tests | every release candidate | development board | the checks pass on real hardware |
| [L4 update tests](#update-tests) | every release candidate | board or device | every test passes |
| L5 signature checks | every release candidate | signing host | only the release key is accepted |
| [L6 device checklist](#device-checklist) | every release candidate | each device | checklist complete |
| L7 everyday use | after L6 | testers | no serious new problems |

A failure at any layer stops everything after it.
Never skip a layer for a stable release.

### L0: file checks

The pre-commit checks in `.pre-commit-config.yaml` run on every commit ([CONTRIBUTING.md](../CONTRIBUTING.md#keys-secrets-and-personal-details)):

- gitleaks looks for keys, tokens and other secrets;
- two checks block key files and private `*.local.md` notes by name;
- a check makes sure the commit is signed off.

## Update tests

Written in task T9, for the way decision D10 updates FoxieOS.
Whatever that way is, the tests cover at least:

1. **An update** from the previous release to the new one, with the user's data still there afterwards.
2. **A failed update:** the device can still be used or recovered.
3. **An interrupted update,** for example by cutting the power.
4. **An update with the wrong signature,** which the device refuses.
5. **A clean install,** then the first update.

## Device checklist

A checklist for each device, kept in `tests/qa/<device>.md` (task T12), done by hand before every release.
It covers every part of the device that FoxieOS's requirements cover (task T1).

## Commands

None yet.
Task T4 adds the build commands, once decision D10 has chosen the base.

## Sources

- Tools: [gitleaks README][gitleaks-readme], with the [hooks it provides for pre-commit][gitleaks-hooks].

[gitleaks-hooks]: https://github.com/gitleaks/gitleaks/blob/v8.30.1/.pre-commit-hooks.yaml
[gitleaks-readme]: https://github.com/gitleaks/gitleaks/blob/v8.30.1/README.md
