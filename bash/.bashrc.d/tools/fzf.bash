[ -f ~/.fzf.bash ] && source ~/.fzf.bash

fzf_theme_apply() {
	local colors

	if [[ ${THEME} == "dark" ]]; then
		colors="--color=preview-border:#727272,border:#727272,separator:#ebdbb2,hl+:#d11010,hl:#d11010"
	else
		colors="--color=hl+:#d11011,hl:#d11010,bg+:#ddd3ac,fg+:#000000,border:#292929"
	fi

	export FZF_DEFAULT_OPTS="${colors} --bind 'ctrl-v:transform-query:echo -n {q}; xclip -out -selection clipboard'"

	if [[ -n ${TMUX} ]]; then
		export FZF_CTRL_T_OPTS="--preview 'bat --plain --color=always --theme=${BAT_THEME} {}' --layout=default --preview-window=top:wrap"
	else
		export FZF_CTRL_T_OPTS=""
	fi
}

if command -v fzf >&/dev/null; then

	fzf_theme_apply

	export FZF_DEFAULT_COMMAND="rg --files --hidden --glob '!.git' --follow"

	if [[ -n ${TMUX} ]]; then
		export FZF_TMUX='1'
		export FZF_TMUX_OPTS="-p90%,80% --layout=default --preview-window=top:wrap"
		export FZF_ALT_C_OPTS="--layout=default --preview 'tree -C {}' --preview-window=top:wrap"
	fi

	export FZF_CTRL_R_OPTS="--history=${HOME}/.bash_history --history-size=100000"

	bind -r '\ec'
	bind -x '"\C-g": __fzf_cd__'

fi
