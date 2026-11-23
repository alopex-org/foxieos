# ci/

Planned.
Scripts that check the build computer, build FoxieOS, and run the automatic checks:

- `check-host.sh`, which checks that the build computer is ready (roadmap task T3);
- `build.sh`, which builds FoxieOS (T4);
- the automatic checks on every pull request (T7).

What they run depends on what FoxieOS is built on (decision D10).

The tests they run are described in [docs/TESTING.md](../docs/TESTING.md).
