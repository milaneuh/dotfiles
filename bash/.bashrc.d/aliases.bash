alias man="LANG=en man"

if command -v rg >&/dev/null; then
	alias grep='rg -i'
else
	alias grep='grep --color=auto -i'
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
