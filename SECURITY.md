# Security policy

FoxieOS hasn't released anything yet, so there is nothing in use to report a problem against.
If you find a security problem in this repository or its plans, report it as described here.

## Reporting

Report a security problem privately, through GitHub's [private vulnerability reporting](https://github.com/alopex-org/foxieos/security/advisories/new): open the repository's Security tab, then "Report a vulnerability".
Only the maintainer sees the report.
Never report a security problem in a public issue or on Discord.

## Planned before the first public release

These are part of roadmap decision D8 (the security contact):

- A dedicated contact address may be added here, next to private vulnerability reporting.
- Coordinated disclosure: the details of a problem are made public only after it is fixed, or after 90 days by default.
- Security fixes come before new features.
  The targets for shipping them are in [docs/RELEASING.md](docs/RELEASING.md#security-update-targets).
- Problems in the base system, the Linux kernel, Meshtastic or other upstream code are reported to those projects first.
  FoxieOS ships the fix once they have accepted it.
