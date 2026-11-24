# FoxieOS devices

**Status: no supported devices yet.**
FoxieOS is proposed for one device, the Alopex cyber-deck, which isn't designed yet: a user-serviceable, portable computer with LoRa and Wi-Fi, pocket-sized if possible.
Until it exists, FoxieOS is developed on a development board (roadmap decision D12).
Technical words are explained in the [glossary](GLOSSARY.md).

## In short

- FoxieOS is proposed for one device: the Alopex cyber-deck.
- Its main board and most of its parts are undecided.
- Every device has a maintainer who owns one and tests each release on it.

## Supported devices

The columns:

- **Device:** what it is.
- **Board:** the computer inside it.
- **Role:** the main device, or a development board.
- **FoxieOS end of life:** when FoxieOS stops supporting it.
- **Maintainer:** the person who owns one and tests it.

| Device | Board | Role | FoxieOS end of life | Maintainer |
|---|---|---|---|---|
| — | — | — | — | — |

## The cyber-deck

The Alopex hardware project works toward the cyber-deck ([Alopex: cyber-deck](https://github.com/alopex-org/alopex/blob/main/docs/CYBERDECK.md)).
It is proposed there as user-serviceable and portable, with LoRa and Wi-Fi, pocket-sized if possible; its main board and other parts are open, and FoxieOS adapts to what Alopex decides.

What FoxieOS has to support on it is task T12 in [ROADMAP.md](ROADMAP.md#t12-the-cyber-deck).
The terms on which FoxieOS supports it are decision [D9](ROADMAP.md#d9-devices-from-the-hardware-project).

## Development boards

Until the cyber-deck exists, FoxieOS is developed on a development board (decision [D12](ROADMAP.md#d12-development-board)):

- **the board Alopex chooses for the cyber-deck,** or its maker's development kit, so the work carries over;
- **until Alopex chooses,** one of the candidates it tries on the bench.

## Rules for adding a device

A device is added only if **all** of these are true:

- **A FoxieOS maintainer owns one** and tests every release on it.
- **It is the cyber-deck, or its main board, or a candidate for it.**
  Other devices are out of scope ([ROADMAP.md](ROADMAP.md#not-planned)).
- **FoxieOS may ship everything it needs to run,** such as its drivers and firmware.
- **It meets the terms of decision D9,** once they are settled.

## Ending support for a device

- Announce it at least 90 days before dropping the device.
- Record the date in the table above and in the release notes.
