# ci/

Planned.
Scripts that check the build computer, build FoxieOS, and run the automatic checks:

- `check-host.sh`, which checks that the build computer is ready (roadmap task T1);
- `build.sh`, which builds the system image (T2);
- `presubmit.sh` and `nightly.sh`, which run the checks on every pull request and every night (T6).

The tests they run are described in [docs/TESTING.md](../docs/TESTING.md).
