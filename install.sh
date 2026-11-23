#!/usr/bin/env bash
# Installs this fish config by symlinking it into ~/.config/fish.
# Works on macOS, Linux, WSL2 and (with --copy or native symlinks) MSYS2/Git Bash.
#
#   ./install.sh                 link everything, install fisher + plugins
#   ./install.sh --no-plugins    skip fisher/plugins
#   ./install.sh --copy          copy files instead of linking
#   ./install.sh --history       also import ~/.zsh_history into fish
#   ./install.sh --dry-run       show what would happen
#
# Files are linked one by one (not the whole directory) so that plugins installed
# by fisher don't end up inside this repository.
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CFG="${XDG_CONFIG_HOME:-$HOME/.config}/fish"
STAMP="$(date +%Y%m%d%H%M%S)"
COPY=0 PLUGINS=1 HISTORY=0 DRY=0

for a in "$@"; do
  case "$a" in
    --copy) COPY=1 ;;
    --no-plugins) PLUGINS=0 ;;
    --history) HISTORY=1 ;;
    --dry-run) DRY=1 ;;
    -h|--help) sed -n '2,12p' "$0"; exit 0 ;;
    *) echo "unknown option: $a" >&2; exit 2 ;;
  esac
done

case "$(uname -s)" in
  Darwin) OS=macos ;;
  Linux)  if grep -qi microsoft /proc/version 2>/dev/null; then OS=wsl; else OS=linux; fi ;;
  MINGW*|MSYS*|CYGWIN*) OS=windows-msys ;;
  *) OS=unknown ;;
esac
echo "Detected: $OS"

run() { if [ "$DRY" = 1 ]; then echo "  would: $*"; else "$@"; fi; }

if ! command -v fish >/dev/null 2>&1; then
  echo "fish is not installed. Install it first (needs fish >= 3.6, 4.x recommended):" >&2
  case "$OS" in
    macos)        echo "  brew install fish" >&2 ;;
    linux|wsl)    echo "  Debian/Ubuntu: sudo apt-add-repository ppa:fish-shell/release-4 && sudo apt update && sudo apt install fish" >&2
                  echo "  Fedora: sudo dnf install fish    Arch: sudo pacman -S fish" >&2 ;;
    windows-msys) echo "  MSYS2: pacman -S fish" >&2 ;;
  esac
  exit 1
fi
echo "fish $(fish --version | awk '{print $NF}')"

link() {
  local src="$1" dst="$2"
  run mkdir -p "$(dirname "$dst")"
  if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
    echo "  ok      $dst"; return
  fi
  if [ -e "$dst" ] || [ -L "$dst" ]; then
    run mv "$dst" "$dst.bak.$STAMP"; echo "  backup  $dst -> $dst.bak.$STAMP"
  fi
  if [ "$COPY" = 1 ]; then run cp -R "$src" "$dst"; echo "  copy    $dst"
  else run ln -s "$src" "$dst"; echo "  link    $dst"; fi
}

echo "Installing into $CFG"
link "$REPO/config.fish"  "$CFG/config.fish"
link "$REPO/fish_plugins" "$CFG/fish_plugins"
for f in "$REPO"/conf.d/*.fish; do
  [ "$(basename "$f")" = 11-secrets.fish ] && continue   # copied below, never linked
  link "$f" "$CFG/conf.d/$(basename "$f")"
done

# Secrets: copy once, never symlink (the repo copy stays an empty template) and
# never overwrite, so keys you filled in survive re-runs.
SECRETS="$CFG/conf.d/11-secrets.fish"
if [ -e "$SECRETS" ] || [ -L "$SECRETS" ]; then
  echo "  keep    $SECRETS (already exists)"
else
  run mkdir -p "$CFG/conf.d"
  run cp "$REPO/conf.d/11-secrets.fish" "$SECRETS"
  run chmod 600 "$SECRETS"
  echo "  copy    $SECRETS  <- fill in your keys here"
fi
for f in "$REPO"/functions/*.fish; do link "$f" "$CFG/functions/$(basename "$f")"; done

if [ "$OS" = windows-msys ]; then NVIM_DIR="${LOCALAPPDATA:-$HOME/AppData/Local}/nvim"
else NVIM_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"; fi
link "$REPO/nvimrc" "$NVIM_DIR/init.vim"

if [ "$OS" = windows-msys ]; then STARSHIP_DIR="${USERPROFILE:-$HOME}/.config"
else STARSHIP_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"; fi
link "$REPO/starship/starship.toml" "$STARSHIP_DIR/starship.toml"
link "$REPO/starship/starship-ide.toml" "$STARSHIP_DIR/starship-ide.toml"

if [ "$PLUGINS" = 1 ]; then
  echo "Installing fisher and plugins (from fish_plugins)"
  if [ "$DRY" = 1 ]; then echo "  would: fish -c 'install fisher; fisher update'"
  else
    fish -c 'type -q fisher; or begin; curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source; fisher install jorgebucaran/fisher; end; fisher update'
  fi
fi

if [ "$HISTORY" = 1 ]; then
  echo "Importing zsh history"
  if [ "$DRY" = 1 ]; then run python3 "$REPO/scripts/zsh_history_to_fish.py" --dry-run
  else python3 "$REPO/scripts/zsh_history_to_fish.py"; fi
fi

cat <<MSG

Done. Next:
  1. Try it:            fish
  2. Make it default:   command -v fish | sudo tee -a /etc/shells && chsh -s "\$(command -v fish)"
MSG
case "$OS" in
  wsl) echo "  WSL: Windows Terminal -> Settings -> your distro profile; or run 'chsh' as above inside WSL." ;;
  windows-msys) echo "  MSYS2: use MSYS=winsymlinks:nativestrict (and Developer Mode) for real symlinks, or rerun with --copy." ;;
esac
