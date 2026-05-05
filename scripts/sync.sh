#!/usr/bin/env bash
# Két-irányú git sync — a remote az igazság forrása.
# Divergencia esetén a lokális commitok eldobódnak (reflog 90 napig megőrzi),
# dirty working tree stash-be kerül. Force-push soha.
set -uo pipefail

QUIET=0
[ "${1:-}" = "--quiet" ] && QUIET=1

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_DIR" || exit 0

log()  { [ "$QUIET" -eq 1 ] || echo "$@"; }
warn() { echo "$@" >&2; }

upstream=$(git rev-parse --abbrev-ref --symbolic-full-name '@{u}' 2>/dev/null || true)
if [ -z "$upstream" ]; then
  log "sync: nincs upstream — kihagyva."
  exit 0
fi

git fetch --quiet 2>/dev/null || warn "sync: 'git fetch' nem sikerült (hálózat?)."

ahead=$(git rev-list --count "$upstream..HEAD"  2>/dev/null || echo 0)
behind=$(git rev-list --count "HEAD..$upstream" 2>/dev/null || echo 0)

# Pull
if [ "$behind" -gt 0 ] && [ "$ahead" -eq 0 ]; then
  if git pull --ff-only --quiet 2>/dev/null; then
    log "sync: pull OK ($behind commit)."
  else
    warn "sync: 'git pull --ff-only' nem sikerült."
  fi
elif [ "$behind" -gt 0 ] && [ "$ahead" -gt 0 ]; then
  dropped=$(git rev-parse HEAD)
  log "sync: divergens ($ahead lokális / $behind remote) — reset $upstream."

  if ! git diff --quiet --ignore-submodules HEAD 2>/dev/null; then
    git stash push --include-untracked --quiet \
      -m "sync.sh autostash $(date +%Y-%m-%d_%H:%M:%S)" 2>/dev/null \
      && warn "sync: dirty tree stash-elve ('git stash list')."
  fi

  if git reset --hard --quiet "$upstream" 2>/dev/null; then
    warn "sync: $ahead lokális commit eldobva (visszaállítás: 'git reset --hard $dropped')."
  else
    warn "sync: 'git reset --hard $upstream' nem sikerült."
  fi
fi

# Push
ahead=$(git rev-list --count "$upstream..HEAD"  2>/dev/null || echo 0)
behind=$(git rev-list --count "HEAD..$upstream" 2>/dev/null || echo 0)

if [ "$ahead" -gt 0 ] && [ "$behind" -eq 0 ]; then
  if git push --quiet 2>/dev/null; then
    log "sync: push OK ($ahead commit → $upstream)."
  else
    warn "sync: 'git push' nem sikerült — $ahead lokális commit lent maradt."
  fi
fi

exit 0
