#!/usr/bin/env bash
# Entry point DevPod runs after creating a workspace
# (devpod context set-options -o DOTFILES_URL=... picks this up automatically,
# since "install.sh" is DevPod's default script name).
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==> Linking shell + git config"
ln -sf "$DOTFILES_DIR/zshrc"     "$HOME/.zshrc"
ln -sf "$DOTFILES_DIR/gitconfig" "$HOME/.gitconfig"

echo "==> Setting default shell to zsh"
# The base image's login shell is bash, so a plain new SSH/devpod session (and,
# without tmux.conf's own default-shell override, every new tmux pane) would
# otherwise never see zshrc — no starship prompt, no aliases, no $EDITOR.
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
  HX_VERSION="25.07.1"  # bump to whatever's current when you use this
  ARCH="$(uname -m)"
  case "$ARCH" in
    x86_64)  HX_TARGET="x86_64-linux" ;;
    aarch64) HX_TARGET="aarch64-linux" ;;
    *) echo "unsupported arch: $ARCH, skipping helix install"; exit 0 ;;
  esac
  # Retried because this download has been observed arriving truncated when
  # this script runs concurrently with DevPod's other container-startup work
  # (curl reports 100%, but the file is short — a race, not a bad URL).
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

# tmux + plugins last, and self-contained: a transient failure anywhere in here
# (network blip, GitHub rate limit) must not take down the script and skip the
# shell/git/helix setup above — same tolerance the helix block above gives itself.
install_tmux_stack() {
  echo "==> Installing tmux + fzf + zoxide via mise"
  # fzf and zoxide are hard requirements for the tmux-session-wizard plugin below,
  # not just nice-to-haves — https://github.com/27medkamal/tmux-session-wizard#required
  # mise is already on PATH in this image (see base/Dockerfile) — same OS-agnostic
  # install path used on the host in dev-container/bootstrap.sh, no apt needed.
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
  "$HOME/.tmux/plugins/tpm/bin/install_plugins" ||
    echo "tmux plugin install failed — run 'bash ~/dotfiles/install.sh' again later" >&2
}
install_tmux_stack

echo "==> Done. This shell is still bash — run 'exec zsh' to pick it up now;"
echo "    new sessions will default to zsh automatically from here on."
