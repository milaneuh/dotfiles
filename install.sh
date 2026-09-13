#!/usr/bin/env bash
# Entry point DevPod runs after creating a workspace
# (devpod context set-options -o DOTFILES_URL=... picks this up automatically,
# since "install.sh" is DevPod's default script name).
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==> Linking shell + git config"
ln -sf "$DOTFILES_DIR/zshrc"     "$HOME/.zshrc"
ln -sf "$DOTFILES_DIR/gitconfig" "$HOME/.gitconfig"

echo "==> Pulling helix config"
if [ ! -d "$HOME/.config/helix" ]; then
  git clone --depth 1 https://github.com/milaneuh/helix-config.git "$HOME/.config/helix"
fi

echo "==> Installing helix (if missing)"
if ! command -v hx >/dev/null 2>&1; then
  HX_VERSION="25.07.1"  # bump to whatever's current when you use this
  ARCH="$(uname -m)"
  case "$ARCH" in
    x86_64)  HX_TARGET="x86_64-linux" ;;
    aarch64) HX_TARGET="aarch64-linux" ;;
    *) echo "unsupported arch: $ARCH, skipping helix install"; exit 0 ;;
  esac
  curl -L "https://github.com/helix-editor/helix/releases/download/${HX_VERSION}/helix-${HX_VERSION}-${HX_TARGET}.tar.xz" -o /tmp/hx.tar.xz
  mkdir -p "$HOME/.local/share/helix" "$HOME/.local/bin"
  tar -xJf /tmp/hx.tar.xz -C "$HOME/.local/share/helix" --strip-components=1
  ln -sf "$HOME/.local/share/helix/hx" "$HOME/.local/bin/hx"
  rm /tmp/hx.tar.xz
fi

echo "==> Done. Run 'exec zsh' to pick up the new shell config."
