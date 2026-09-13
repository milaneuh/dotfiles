# dotfiles

Personal environment layer for DevPod workspaces — shell, git, editor. Kept
separate from [dev-container](../dev-container) (the shared devops-tooling
layer) on purpose: this is "how *I* work", that repo is "what a project needs".

Applied automatically to every workspace once you've run, on any machine:

```sh
devpod context set-options \
  -o DOTFILES_URL=https://github.com/milaneuh/dotfiles \
  -o DOTFILES_SCRIPT=install.sh
```

`install.sh` runs inside the container after creation. It:

1. Symlinks `zshrc` → `~/.zshrc` and `gitconfig` → `~/.gitconfig`.
2. Clones [helix-config](https://github.com/milaneuh/helix-config) into
   `~/.config/helix` (kept as its own repo since it's already maintained that way).
3. Installs the `hx` binary if it isn't already on `PATH`.

## Why zshrc here isn't a copy of your Mac one

Your host `~/.zshrc` is full of Homebrew/asdf/sdkman/nvm/erlang wiring specific
to macOS package management. None of that exists in a Linux container, so it's
deliberately not ported — this file starts lean and only grows what containers
actually need.

## Before your first commit in a container

Fill in `gitconfig`'s `[user]` section (left blank deliberately) — either here,
or via `git config --global user.email ...` inside the running workspace.

## Switching editors later (Helix → nvim)

If/when you move to nvim, add an equivalent block to `install.sh` (clone your
nvim config, install the `nvim` binary) and flip `EDITOR` in `zshrc`. No need
to remove the Helix path until you're sure.
