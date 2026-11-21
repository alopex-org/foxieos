#!/usr/bin/env bash
# Creates or updates this repository's issue labels with the GitHub CLI.
# The maintainer runs it after changing the list: `.github/labels.sh`.
# Labels that aren't listed here, such as GitHub's defaults, are left alone.
# Device labels (`device: <codename>`) are added when a device is.
set -euo pipefail

repo=alopex-org/foxieos

while IFS='|' read -r name color description; do
  [[ -z $name || $name == '#'* ]] && continue
  gh label create "$name" --repo "$repo" --color "$color" --description "$description" --force
done <<'EOF'
# Who does the work (docs/ROADMAP.md, "How to read this file").
who: code|0e8a16|A change in a pull request; anyone can do it, including a coding agent
who: hands-on|fbca04|Runs on the build host or a phone; the maintainer runs or approves each step
who: maintainer|d93f0b|Keys, accounts, purchases and publishing; the maintainer only
# What the work touches.
area: build|1d76db|Syncing and building, the build host
area: ci|1d76db|CI, presubmit and nightly runs, test layers
area: release|1d76db|Signing, OTA packages, the update server and channels
area: branding|1d76db|vendor/foxie, boot animation, About page, default apps
area: privacy|1d76db|Privacy features and microG
area: device|1d76db|Device bring-up, QA and the device charter
# State and review.
needs: person review|b60205|Signing, Updater or OTA, manifest, kernel, SELinux, permissions or framework
blocked|000000|Waits on a decision, a check or another task
upstream|c5def5|Belongs in LineageOS or AOSP first
dependencies|0366d6|Dependency updates
EOF
