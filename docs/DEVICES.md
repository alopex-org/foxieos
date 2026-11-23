# FoxieOS devices

**Status: no supported devices yet.**
FoxieOS is planned for one device, the Alopex cyber-deck, which isn't built yet.
Until it is, FoxieOS develops on a development board (roadmap decision D12) and is tested on a virtual machine ([TESTING.md](TESTING.md#virtual-machine)).
Sources are in [FEASIBILITY.md](FEASIBILITY.md#sources), and technical words in the [glossary](GLOSSARY.md).

## In short

- FoxieOS supports one device: the Alopex cyber-deck.
- While the cyber-deck is being built, FoxieOS runs on a development board like the one Alopex chooses for it.
- Every device has a maintainer who owns one and tests each release on it.
- FoxieOS doesn't support phones.

## Supported devices

The columns:

- **Device:** what it is.
- **Board:** the computer inside it.
- **Role:** the main device, a development board, or a virtual machine for tests.
- **FoxieOS end of life:** when FoxieOS stops supporting it.
- **Maintainer:** the person who owns one and tests it.

| Device | Board | Role | FoxieOS end of life | Maintainer |
|---|---|---|---|---|
| — | — | — | — | — |

## The cyber-deck

The Alopex cyber-deck is designed in the [Alopex repository](https://github.com/alopex-org/alopex/blob/main/docs/CYBERDECK.md).
The prototype it proposes is a rugged hand-held computer:

- a touchscreen used upright, which slides sideways to uncover a physical keyboard and is then used sideways;
- a LoRa radio for the Meshtastic mesh, with a telescopic antenna, and two gauges on top that show the strength (RSSI) and clarity (SNR) of the signal received;
- knobs and buttons on the sides;
- two 18650 batteries in bays at the back, either of which can be swapped while the device runs on the other;
- hardware switches that cut the radios and the microphone;
- a main board still to choose: a Raspberry Pi compute module, another single-board computer or module, or something else ([Alopex decision D1](https://github.com/alopex-org/alopex/blob/main/docs/ROADMAP.md#d1-route-to-a-prototype)).

What FoxieOS has to support on it is task T11 in [ROADMAP.md](ROADMAP.md#t11-the-cyber-deck).
The terms on which FoxieOS supports it are decision [D9](ROADMAP.md#d9-devices-from-the-hardware-project).

## Development boards

Until the cyber-deck exists, FoxieOS is developed on one of these (decision [D12](ROADMAP.md#d12-development-board)):

- **The board Alopex chooses for the cyber-deck,** or its maker's development kit, so drivers and settings carry over.
- **Until Alopex chooses,** one of the candidates it compares, such as a Raspberry Pi Compute Module 5 on its IO board or an Arm or RISC-V board from another maker ([Alopex: boards](https://github.com/alopex-org/alopex/blob/main/docs/BOARDS.md#comparison)).

A LoRa board with an SX1262 chip is wired to the board's pins for the mesh radio (task T5).

## Rules for adding a device

A device is added only if **all** of these are true:

- **A FoxieOS maintainer owns one** and tests every release on it.
- **It is the cyber-deck, or the board it is built around or a candidate for it.**
  Other devices are out of scope ([ROADMAP.md](ROADMAP.md#not-planned)).
- **Its kernel is built from source,** from the mainline kernel or the board maker's published kernel.
- **Every part has a Linux driver** that FoxieOS may ship.
- **Secure boot is under the owner's control:** the device is either not fused, or fused with a key settled under decision D9.

## What every supported device must meet

- The storage is encrypted with LUKS.
- It updates through both A/B slots, and falls back to the old slot when the new one fails.
- Its LoRa radio is set to a legal region for where it is used, never a US-band setting in Europe.
- An install page gives exact steps and a published end-of-life date.
- It passes test layers L3–L7 in [TESTING.md](TESTING.md) for each release.

## Ending support for a device

- Announce it at least 90 days before dropping the device.
- Record the date in the table above and in the release notes.
