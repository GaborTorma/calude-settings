#!/usr/bin/env bash
# Pull + reinstall, de csak akkor, ha a HEAD ténylegesen elmozdult.
# No-op pull esetén kihagyja a symlink-walkot.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

before=$(git -C "$REPO_DIR" rev-parse HEAD)
git -C "$REPO_DIR" pull --ff-only --quiet
after=$(git -C "$REPO_DIR" rev-parse HEAD)

if [ "$before" != "$after" ]; then
  make -C "$REPO_DIR" install
else
  echo "Up to date — install kihagyva."
fi
