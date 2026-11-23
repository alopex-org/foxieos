# release/

Planned:

- `sign.sh`, which signs a release's update bundle, and `verify.sh`, which checks the signature (roadmap task T7);
- `publish-metadata.py`, which describes each release for the update server (T8).

The signing scripts are told where the keys are, and never read the keys themselves.
The whole process is in [docs/RELEASING.md](../docs/RELEASING.md).
