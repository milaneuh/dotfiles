# System variables -------------------------------------------------------------
export HISTCONTROL=ignoreboth:erasedups
export HISTFILESIZE=100000
export HISTIGNORE="rm*:*--force*:vif *:vit *:vig *"
export HISTSIZE=100000
export PATH="${PATH}":"${HOME}"/.local/bin
PROMPT_COMMAND=('history -a; history -c; history -r')

export BROWSER="firefox"
export CC="gcc"
export EDITOR="nvim"
export PAGER="less"
export SUDO_EDITOR="nvim"
export TERMINAL="kitty"
export VISUAL="nvim"

# Personal variables -----------------------------------------------------------
export remoterepos=~/remoterepos
export dotfiles=~/.dotfiles
export logiciels=~/logiciels

export projects="${remoterepos}"/projects
export zettelkasten="${remoterepos}"/zettelkasten/notes
