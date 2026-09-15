alias man="LANG=en man"

alias ll='ls -l --color=auto'

alias ta='tmux attach'
alias tast='tmux attach-session -t'
alias tclear='clear; tmux clear-history'
alias tls='tmux ls'

tkst() {
	local session
	for session in "$@"; do
		tmux kill-session -t "${session}"
	done
}

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
