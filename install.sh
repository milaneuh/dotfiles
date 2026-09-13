#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

link() {
  mkdir -p "$(dirname "$HOME/$2")"
  ln -sfn "$DOTFILES_DIR/$1" "$HOME/$2"
}

echo "==> Linking config"
link gitconfig .gitconfig
link tmux.conf .tmux.conf
link mise.toml .config/mise/conf.d/dotfiles.toml
link alacritty/alacritty.toml .config/alacritty/alacritty.toml
link alacritty/themes/gruvbox_material_medium_dark.toml .config/alacritty/themes/gruvbox_material_medium_dark.toml

if [ "${1:-}" != "--host" ]; then
  link zshrc .zshrc
  if [ "$(getent passwd "$(whoami)" | cut -d: -f7)" != "$(command -v zsh)" ]; then
    sudo chsh -s "$(command -v zsh)" "$(whoami)"
  fi
fi

echo "==> Pulling helix config"
[ -d "$HOME/.config/helix" ] || git clone --depth 1 https://github.com/milaneuh/helix-config.git "$HOME/.config/helix"

echo "==> Installing tools via mise"
(cd / && mise install)

if [ ! -f "$HOME/.local/share/man/man1/tmux.1" ]; then
  echo "==> Installing tmux man page"
  mkdir -p "$HOME/.local/share/man/man1"
  curl -fsSL -o "$HOME/.local/share/man/man1/tmux.1" \
    "https://raw.githubusercontent.com/tmux/tmux/$(tmux -V | cut -d' ' -f2)/tmux.1"
fi

echo "==> Done. Run 'exec zsh' to reload your shell."
