# Dotfiles

This repository contains the dotfiles of the software I'm using.

I will make frequent modifications to this repository.

I highly recommend **not** installing my entire configuration. Instead, feel free to selectively pick what interests you.

## Dependancy

- Ubuntu
- Git

## Layout

Three directories, one per question:

- `nix/` — what is installed: a pinned flake applied by home-manager, see `nix/README.md`
- `software/` — how each piece of software is configured, one directory per software
- `scripts/` — what I wrote, deployed as a whole into `~/.local/bin`

`software/` holds two stow trees, one per deployment target, each with one package
per software:

```
software/home/fzf/.config/fzf/common.conf      -> ~/.config/fzf/common.conf
software/home/fzf/.bashrc.d/tools/fzf.bash     -> ~/.bashrc.d/tools/fzf.bash
software/system/keyd/etc/keyd/default.conf     -> /etc/keyd/default.conf
scripts/speech2text                            -> ~/.local/bin/speech2text
```

Each tree is stowed in a single command, so stow sees every package at once and
splits open a shared directory such as `.bashrc.d/tools` on its own.

## Installation script

Clone this repository under $HOME/.dotfiles.

Then run :

```bash
mkdir ~/.dotfiles
cd !$
./install
./deploy
```

## Credits

Much of my configuration is inspired by:

- [Chewie](https://github.com/Chewie)
- [Chris\@machine](https://github.com/ChristianChiarulli)
- [Dereck Taylor](https://gitlab.com/dwt1)
- [Gavin Freeborn](https://github.com/Gavinok)
- [Leeren](https://github.com/leeren)
- [Rob Muhlestein](https://github.com/rwxrob)
- [Luke Smith](https://lukesmith.xyz/)
- [The Primeagen](https://github.com/ThePrimeagen/.dotfiles)
- [Tjdevries](https://github.com/tjdevries)
