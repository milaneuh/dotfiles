alias man="LANG=en man"

alias grep='grep --color=auto --ignore-case'

claude() {
	if [[ -n ${TMUX} ]]; then
		tmux rename-window "claude_${PWD##*/}"
	fi
	command claude --ide --chrome "$@"
	if [[ -n ${TMUX} ]]; then
		tmux set-window-option automatic-rename on >/dev/null
	fi
}
