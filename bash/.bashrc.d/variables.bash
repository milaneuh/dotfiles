# System variables -------------------------------------------------------------
export HISTCONTROL=ignoreboth:erasedups
export HISTFILESIZE=100000
export HISTIGNORE+="vif *:vit *:vig *"
export HISTIGNORE="rm*:*--force*:"
export HISTSIZE=100000
export PATH="${PATH}":"${HOME}"/.local/bin
export PROMPT_COMMAND="history -a; history -c; history -r;${PROMPT_COMMAND}"

export BROWSER="firefox"
export CC="gcc"
export EDITOR="nvim"
export PAGER="less"
export QT_QPA_PLATFORMTHEME=qt5ct
export SUDO_EDITOR="nvim"
export TERMINAL="kitty"
export VISUAL="nvim"

if [[ ${XDG_CURRENT_DESKTOP} =~ 'GNOME' ]]; then
	GNOME_THEME=$(gsettings get org.gnome.desktop.interface color-scheme)
	export GNOME_THEME
else
	GNOME_THEME=""
	export GNOME_THEME
fi

# Personal variables -----------------------------------------------------------
export remoterepos=~/remoterepos
export dotfiles=~/.dotfiles
export logiciels=~/logiciels

export notes="${remoterepos}"/notes
export projects="${remoterepos}"/projects
export zettelkasten="${remoterepos}"/zettelkasten/notes
