# Dotfiles

This repository contains the dotfiles of the software I'm using.

I will make frequent modifications to this repository.

I highly recommend **not** installing my entire configuration. Instead, feel free to selectively pick what interests you.

## Dependancy

- macOS
- Git

## Layout

Two directories, one per question:

- `nix/` — what is installed: a pinned flake applied by home-manager
- `home/` — how each piece of software is configured: a chezmoi source tree mirroring `$HOME`

```
home/dot_config/fzf/fzf.conf                  -> ~/.config/fzf/fzf.conf
home/dot_bashrc.d/tools/fzf.bash              -> ~/.bashrc.d/tools/fzf.bash
home/dot_local/bin/executable_lg              -> ~/.local/bin/lg
```

`chezmoi apply` places the files and runs `home-manager switch` whenever a file in `nix/` changes.

## Installation script

```bash
./install
```

It checks your GitHub SSH key, then runs `chezmoi init --apply` on this repository.
Afterwards, pull and apply changes with `chezmoi update`.

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
