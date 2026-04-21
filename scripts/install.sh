#!/usr/bin/env bash
set -e

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CLAUDE_DIR="$HOME/.claude"
MARKER="# claude-settings auto-update"
UPDATE_CMD="git -C \"$REPO_DIR\" pull --quiet --ff-only 2>/dev/null || true"
HOOK_LINE="${MARKER}"$'\n'"${UPDATE_CMD}"

SYMLINK_TARGETS=(
  "commands"
  "rules"
  "CLAUDE.md"
  "settings.local.json"
)

detect_shell() {
  basename "${SHELL:-}"
}

rc_file_for() {
  case "$1" in
    zsh)  echo "$HOME/.zshrc" ;;
    bash) echo "$HOME/.bashrc" ;;
    fish) echo "$HOME/.config/fish/config.fish" ;;
    *)    echo "" ;;
  esac
}

install_hook() {
  local rc="$1"

  if [ -z "$rc" ]; then
    echo "Ismeretlen shell: $SHELL — add hozzá manuálisan:"
    echo "  $UPDATE_CMD"
    exit 1
  fi

  if grep -qF "$MARKER" "$rc" 2>/dev/null; then
    echo "Hook már telepítve: $rc"
    return
  fi

  mkdir -p "$(dirname "$rc")"
  printf '\n%s\n' "$HOOK_LINE" >> "$rc"
  echo "Hook hozzáadva: $rc"
}

confirm() {
  local prompt="$1"
  local answer
  read -r -p "$prompt [i/N] " answer
  [[ "$answer" =~ ^[iI]$ ]]
}

install_symlinks() {
  mkdir -p "$CLAUDE_DIR"

  for name in "${SYMLINK_TARGETS[@]}"; do
    local src="$REPO_DIR/$name"
    local dst="$CLAUDE_DIR/$name"

    if [ ! -e "$src" ]; then
      echo "Kihagyva (nem létezik a repóban): $src"
      continue
    fi

    # már helyes symlink → skip
    if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
      echo "Már symlink: $dst"
      continue
    fi

    # létezik valami más → kérdez
    if [ -e "$dst" ] || [ -L "$dst" ]; then
      if confirm "Létezik: $dst — felülírjam symlink-kel?"; then
        rm -rf "$dst"
      else
        echo "Kihagyva: $dst"
        continue
      fi
    fi

    ln -s "$src" "$dst"
    echo "Symlink: $dst → $src"
  done
}

main() {
  local shell rc
  shell="$(detect_shell)"
  rc="$(rc_file_for "$shell")"

  echo "Shell: $shell"
  install_symlinks
  install_hook "$rc"
  echo "Kész."
}

main "$@"
