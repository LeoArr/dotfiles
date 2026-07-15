#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d_%H%M%S)"

declare -A LINKS=(
  ["$DOTFILES/nvim"]="$HOME/.config/nvim"
  ["$DOTFILES/helix"]="$HOME/.config/helix"
  ["$DOTFILES/ghostty"]="$HOME/.config/ghostty"
  ["$DOTFILES/tmux"]="$HOME/.config/tmux"
  ["$DOTFILES/yazi"]="$HOME/.config/yazi"
  ["$DOTFILES/lazygit"]="$HOME/.config/lazygit"
  ["$DOTFILES/starship"]="$HOME/.config/starship"
  ["$DOTFILES/.bash_profile"]="$HOME/.bash_profile"
  ["$DOTFILES/.bashrc"]="$HOME/.bashrc"
)

backup_and_link() {
  local src="$1"
  local dest="$2"

  # Already linked correctly — nothing to do
  if [[ -L "$dest" && "$(readlink "$dest")" == "$src" ]]; then
    echo "  ok       $dest"
    return
  fi

  # Anything in the way (real file/dir or wrong symlink) gets backed up
  if [[ -e "$dest" || -L "$dest" ]]; then
    mkdir -p "$BACKUP_DIR"
    mv "$dest" "$BACKUP_DIR/$(basename "$dest")"
    echo "  backed up $dest → $BACKUP_DIR/$(basename "$dest")"
  fi

  mkdir -p "$(dirname "$dest")"
  ln -s "$src" "$dest"
  echo "  linked   $dest → $src"
}

echo "Installing dotfiles from $DOTFILES"

# Preserve machine-specific shell config: a pre-existing real ~/.bashrc becomes
# ~/.bashrc.local, which the tracked .bashrc sources at the end.
if [[ -f "$HOME/.bashrc" && ! -L "$HOME/.bashrc" && ! -e "$HOME/.bashrc.local" ]]; then
  cp "$HOME/.bashrc" "$HOME/.bashrc.local"
  echo "  migrated existing ~/.bashrc → ~/.bashrc.local (review it: keep only machine-specific lines)"
  if grep -q 'bash_profile' "$HOME/.bashrc.local"; then
    echo "  WARNING: ~/.bashrc.local references .bash_profile — remove that line or shells will source-loop."
  fi
fi

for src in "${!LINKS[@]}"; do
  backup_and_link "$src" "${LINKS[$src]}"
done

echo "Done."
if [[ -d "$BACKUP_DIR" ]]; then
  echo "Backups saved to $BACKUP_DIR"
fi
