#!/usr/bin/env bash
# Manuális update: sync + reinstall (csak ha HEAD elmozdult).
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

before=$(git -C "$REPO_DIR" rev-parse HEAD 2>/dev/null || echo "")
bash "$REPO_DIR/scripts/sync.sh"
after=$(git -C "$REPO_DIR" rev-parse HEAD 2>/dev/null || echo "")

if [ "$before" != "$after" ]; then
  make -C "$REPO_DIR" install
else
  echo "Up to date — install kihagyva."
fi
