#!/usr/bin/env bash
set -e

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CLAUDE_DIR="$HOME/.claude"
MARKER="# claude-settings auto-update"
UPDATE_CMD="git -C \"$REPO_DIR\" pull --quiet --ff-only 2>/dev/null || true"
HOOK_LINE="${MARKER}"$'\n'"${UPDATE_CMD}"

# Egész mappa egy symlinkként a ~/.claude alá. Csak ott használd, ahol
# garantáltan minden fájl ebből a repóból jön (más eszközök nem írhatnak bele).
SYMLINK_TARGETS=(
  "rules"
  "CLAUDE.md"
  "settings.local.json"
)

# Mappák, amik tartalma fájlonként symlinkelődik a célba. A célmappa valódi
# directory marad ~/.claude/-ban, így más eszközök (pl. lean-ctx hookjai,
# pluginok parancsai) is hozzáadhatnak saját fájlokat. A repóba új fájl
# bekerülése a következő install/update-kor automatikusan szimlinkelődik.
DIR_FILE_SYMLINK_TARGETS=(
  "commands"
  "hooks"
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

link_one() {
  local src="$1" dst="$2"

  if [ ! -e "$src" ]; then
    echo "Kihagyva (nem létezik a repóban): $src"
    return
  fi

  mkdir -p "$(dirname "$dst")"

  if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
    echo "Már symlink: $dst"
    return
  fi

  if [ -e "$dst" ] || [ -L "$dst" ]; then
    if confirm "Létezik: $dst — felülírjam symlink-kel?"; then
      rm -rf "$dst"
    else
      echo "Kihagyva: $dst"
      return
    fi
  fi

  ln -s "$src" "$dst"
  echo "Symlink: $dst → $src"
}

link_dir_files() {
  local src_dir="$1" dst_dir="$2"

  if [ ! -d "$src_dir" ]; then
    echo "Kihagyva (nem mappa a repóban): $src_dir"
    return
  fi

  # Migráció: ha a célmappa korábban egész symlink volt, váltsuk át valódi
  # mappára. Saját repónkra mutató symlink → automatikus; idegen target → confirm.
  if [ -L "$dst_dir" ]; then
    local current_target
    current_target="$(readlink "$dst_dir")"
    if [ "$current_target" = "$src_dir" ] \
       || confirm "Létezik mappa-symlink: $dst_dir → $current_target. Felülírjam valódi mappára?"; then
      echo "Migráció: $dst_dir mappa-symlink → valódi mappa"
      rm "$dst_dir"
    else
      echo "Kihagyva: $dst_dir"
      return
    fi
  fi

  mkdir -p "$dst_dir"

  for src in "$src_dir"/*; do
    [ -e "$src" ] || continue
    link_one "$src" "$dst_dir/$(basename "$src")"
  done
}

install_symlinks() {
  mkdir -p "$CLAUDE_DIR"

  for name in "${SYMLINK_TARGETS[@]}"; do
    link_one "$REPO_DIR/$name" "$CLAUDE_DIR/$name"
  done

  for dir in "${DIR_FILE_SYMLINK_TARGETS[@]}"; do
    link_dir_files "$REPO_DIR/$dir" "$CLAUDE_DIR/$dir"
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
