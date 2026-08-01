# System variables -------------------------------------------------------------
export HISTCONTROL=ignoreboth:erasedups
export HISTFILESIZE=100000
export HISTIGNORE+="vif *:vit *:vig *"
export HISTIGNORE="rm*:*--force*:"
export HISTSIZE=100000
export PATH="${PATH}":"${HOME}"/.local/bin
PROMPT_COMMAND=('history -a; history -c; history -r')

export BROWSER="firefox"
export CC="gcc"
export EDITOR="nvim"
export PAGER="less"
export QT_QPA_PLATFORMTHEME=qt5ct
export SUDO_EDITOR="nvim"
export TERMINAL="kitty"
export VISUAL="nvim"

# Personal variables -----------------------------------------------------------
export remoterepos=~/remoterepos
export dotfiles=~/.dotfiles
export logiciels=~/logiciels

export notes="${remoterepos}"/notes
export projects="${remoterepos}"/projects
export zettelkasten="${remoterepos}"/zettelkasten/notes
