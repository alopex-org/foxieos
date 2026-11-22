# FoxieOS carry patches

A carry patch is a change FoxieOS makes to the code of LineageOS or Android itself (AOSP), instead of in its own `vendor/foxie` folder.
FoxieOS has to re-apply each one whenever it moves to a new LineageOS version, so they are kept few and all listed here ([CONTRIBUTING.md](../CONTRIBUTING.md#changes-to-lineageos-or-androids-own-code)).

At every move to a new version (roadmap task T13, the rebase drill), review the whole list, and drop any patch that LineageOS has accepted into its own code.

**Status: none yet.**
The first planned entry is the small change to `vendor/lineage` that brings in `vendor/foxie` (roadmap task T4).

The columns: the repository and its folder in the source tree; the commit or change; why FoxieOS needs it; whether LineageOS or AOSP has accepted it; when it was added; and when it was last checked.

| Repository (path in the tree) | Commit or change | Reason | Upstream status | Added | Last reviewed |
|---|---|---|---|---|---|
| — | — | — | — | — | — |
