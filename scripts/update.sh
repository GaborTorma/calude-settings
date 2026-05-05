#!/usr/bin/env bash
# Pull + reinstall, de csak akkor, ha a HEAD ténylegesen elmozdult.
# No-op pull esetén kihagyja a symlink-walkot.
# Ha a pull elhasal (pl. head/main ütközés, divergált branch, hálózat),
# figyelmeztet, és mindenképp lefuttatja az install-t — így a lokális
# új fájlok is szimlinkelődnek.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

before=$(git -C "$REPO_DIR" rev-parse HEAD)

pull_failed=0
if ! git -C "$REPO_DIR" pull --ff-only --quiet; then
  pull_failed=1
  echo "FIGYELEM: 'git pull --ff-only' nem sikerült (valószínűleg head/main ütközés vagy divergált branch). Install mindenképp lefut."
fi

after=$(git -C "$REPO_DIR" rev-parse HEAD)

if [ "$before" != "$after" ] || [ "$pull_failed" -eq 1 ]; then
  make -C "$REPO_DIR" install
else
  echo "Up to date — install kihagyva."
fi
