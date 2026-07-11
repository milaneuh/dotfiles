alias man="LANG=en man"

if command -v rg >&/dev/null; then
	alias grep='rg -i'
else
	alias grep='grep --color=auto -i'
fi

cdd() {
	dir=$(dirname "$1")
	cd "$dir" || return
}

alias claude="claude --ide --chrome"
alias claude-work='CLAUDE_CONFIG_DIR="$HOME/.claude-work" claude --ide --chrome'
