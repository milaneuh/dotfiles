# Dotfiles

Forked from [maxencetholomier/dotfiles](https://gitlab.com/maxencetholomier/dotfiles) and adapted to macOS, chezmoi and devpod.

This repository contains the dotfiles of the software I'm using.

I will make frequent modifications to this repository.

I highly recommend **not** installing my entire configuration. Instead, feel free to selectively pick what interests you.

## Dependancy

- macOS or Linux
- curl

## Layout

Three directories, one per question:

- `nix/` — what is installed: a pinned flake applied by home-manager
- `home/` — how each piece of software is configured: a chezmoi source tree mirroring `$HOME`
- `scripts/` — what I wrote, deployed as a whole into `~/.local/scripts`

```
home/dot_config/fzf/fzf.conf                  -> ~/.config/fzf/fzf.conf
home/dot_bashrc.d/tools/fzf.bash              -> ~/.bashrc.d/tools/fzf.bash
scripts/lg                                    -> ~/.local/scripts/lg
```

`chezmoi apply` places the files and runs `home-manager switch` whenever a file in `nix/` changes.

`~/.local/scripts` is a single symlink to this repository's `scripts/`, so edits there take
effect immediately without `chezmoi apply`. `~/.local/bin` is left alone for binaries other
installers drop in it.

## Installation script

```bash
curl -fsSL https://raw.githubusercontent.com/milaneuh/dotfiles/main/install | bash
```

It installs a pinned Nix version, Rosetta on Apple Silicon, then runs `chezmoi init --apply`
on this repository. It finally sets up a GitHub SSH key with `gh` and makes Nix's bash the
login shell.

Afterwards, pull and apply changes with `chezmoi update`.

## Devcontainer image

`container/Dockerfile` builds `ghcr.io/milaneuh/devcontainer-base` with Nix and the container
home-manager profile already installed, so devpod workspaces only have to apply the dotfiles.
GitHub Actions rebuilds it for amd64 and arm64 whenever `nix/`, `install` or the Dockerfile change.

Use `install` as the devpod dotfiles script; inside a container it skips the host-only steps.

## Credits

Much of my configuration is inspired by:

- [Chris\@machine](https://github.com/ChristianChiarulli)
- [Dereck Taylor](https://gitlab.com/dwt1)
- [Gavin Freeborn](https://github.com/Gavinok)
- [Leeren](https://github.com/leeren)
- [Rob Muhlestein](https://github.com/rwxrob)
- [Luke Smith](https://lukesmith.xyz/)
- [The Primeagen](https://github.com/ThePrimeagen/.dotfiles)
- [Tjdevries](https://github.com/tjdevries)
