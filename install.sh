#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==> Linking shell + git config"
ln -sf "$DOTFILES_DIR/zshrc"     "$HOME/.zshrc"
ln -sf "$DOTFILES_DIR/gitconfig" "$HOME/.gitconfig"

echo "==> Setting default shell to zsh"
if command -v zsh >/dev/null 2>&1; then
  if [ "$(getent passwd "$(whoami)" | cut -d: -f7)" != "$(command -v zsh)" ]; then
    sudo chsh -s "$(command -v zsh)" "$(whoami)" ||
      echo "couldn't chsh to zsh — set it manually with: chsh -s $(command -v zsh)" >&2
  fi
else
  echo "zsh not found — skipping default-shell change" >&2
fi

echo "==> Pulling helix config"
if [ ! -d "$HOME/.config/helix" ]; then
  git clone --depth 1 https://github.com/milaneuh/helix-config.git "$HOME/.config/helix"
fi

echo "==> Installing helix (if missing)"
if ! command -v hx >/dev/null 2>&1; then
  HX_VERSION="25.07.1"
  ARCH="$(uname -m)"
  case "$ARCH" in
    x86_64)  HX_TARGET="x86_64-linux" ;;
    aarch64) HX_TARGET="aarch64-linux" ;;
    *) echo "unsupported arch: $ARCH, skipping helix install"; exit 0 ;;
  esac
  HX_URL="https://github.com/helix-editor/helix/releases/download/${HX_VERSION}/helix-${HX_VERSION}-${HX_TARGET}.tar.xz"
  for attempt in 1 2 3; do
    curl -fL --retry 3 "$HX_URL" -o /tmp/hx.tar.xz
    if tar -tJf /tmp/hx.tar.xz >/dev/null 2>&1; then
      break
    fi
    echo "helix download looked corrupt (attempt $attempt/3), retrying..."
    rm -f /tmp/hx.tar.xz
    if [ "$attempt" = 3 ]; then
      echo "helix install failed after 3 attempts — run 'bash ~/dotfiles/install.sh' again later" >&2
      exit 0
    fi
    sleep 2
  done
  mkdir -p "$HOME/.local/share/helix" "$HOME/.local/bin"
  tar -xJf /tmp/hx.tar.xz -C "$HOME/.local/share/helix" --strip-components=1
  ln -sf "$HOME/.local/share/helix/hx" "$HOME/.local/bin/hx"
  rm /tmp/hx.tar.xz
fi

install_tmux_stack() {
  echo "==> Installing tmux + fzf + zoxide via mise"
  if ! mise use -g tmux@latest fzf@latest zoxide@latest; then
    echo "tmux/fzf/zoxide install failed (network?) — run 'bash ~/dotfiles/install.sh' again later" >&2
    return 0
  fi

  echo "==> Linking tmux config"
  ln -sf "$DOTFILES_DIR/tmux.conf" "$HOME/.tmux.conf"

  echo "==> Installing tmux plugins (tpm, tmux-fingers, tmux-session-wizard)"
  if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    if ! git clone --depth 1 https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"; then
      echo "tpm clone failed (network?) — run 'bash ~/dotfiles/install.sh' again later" >&2
      return 0
    fi
  fi
  tmux start-server
  tmux set-environment -g TMUX_PLUGIN_MANAGER_PATH "$HOME/.tmux/plugins/"
  "$HOME/.tmux/plugins/tpm/bin/install_plugins" ||
    echo "tmux plugin install failed — run 'bash ~/dotfiles/install.sh' again later" >&2
}
install_tmux_stack

echo "==> Done. This shell is still bash — run 'exec zsh' to pick it up now;"
echo "    new sessions will default to zsh automatically from here on."
