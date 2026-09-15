# System variables -------------------------------------------------------------
export HISTCONTROL=ignoreboth:erasedups
export HISTFILESIZE=100000
export HISTIGNORE="rm*:*--force*:vif *:vit *:vig *"
export HISTSIZE=100000
for bin_dir in "${HOME}/.local/bin" "${HOME}/.local/scripts"; do
	if [[ -d ${bin_dir} && ":${PATH}:" != *":${bin_dir}:"* ]]; then
		export PATH="${PATH}:${bin_dir}"
	fi
done
unset bin_dir
PROMPT_COMMAND=('history -a; history -c; history -r')

export BROWSER="firefox"
export CC="gcc"
export EDITOR="nvim"
export PAGER="less"
export SUDO_EDITOR="nvim"
export TERMINAL="alacritty"
export VISUAL="nvim"
