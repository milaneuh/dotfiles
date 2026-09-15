# System variables -------------------------------------------------------------
export HISTCONTROL=ignoreboth:erasedups
export HISTFILESIZE=100000
export HISTIGNORE="rm*:*--force*:vif *:vit *:vig *"
export HISTSIZE=100000
local_bin="${HOME}/.local/bin"
if [[ -d ${local_bin} && ":${PATH}:" != *":${local_bin}:"* ]]; then
	export PATH="${PATH}:${local_bin}"
fi
unset local_bin
PROMPT_COMMAND=('history -a; history -c; history -r')

export BROWSER="firefox"
export CC="gcc"
export EDITOR="nvim"
export PAGER="less"
export SUDO_EDITOR="nvim"
export TERMINAL="alacritty"
export VISUAL="nvim"
