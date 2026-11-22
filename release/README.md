# release/

Planned:

- `sign.sh`, which signs a release, and `verify.sh`, which checks the signatures (roadmap task T8);
- `publish-metadata.py`, which describes each release for the update server (T9).

The signing scripts are told where the keys are, and never read the keys themselves.
The whole process is in [docs/RELEASING.md](../docs/RELEASING.md).
