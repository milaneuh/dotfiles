alias man="LANG=en man"

if command -v rg >&/dev/null; then
	alias grep='rg --ignore-case'
else
	alias grep='grep --color=auto --ignore-case'
fi

claude() {
	if [ -n "$TMUX" ]; then
		tmux rename-window "claude_${PWD##*/}"
	fi
	command claude --ide --chrome "$@"
	if [ -n "$TMUX" ]; then
		tmux set-window-option automatic-rename on >/dev/null
	fi
}
