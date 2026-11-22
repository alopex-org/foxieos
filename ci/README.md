# ci/

Planned.
Scripts that check the build computer, run the builds, and run the automatic checks:

- `check-host.sh`, which checks that the build computer is ready (roadmap task T1);
- `sync.sh` and `build.sh`, which download the source code and build it (T2);
- `presubmit.sh` and `nightly.sh`, which run the checks on every pull request and every night (T6).

The tests they run are described in [docs/TESTING.md](../docs/TESTING.md).
