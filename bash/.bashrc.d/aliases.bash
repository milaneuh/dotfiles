alias man="LANG=en man"

if command -v rg >&/dev/null; then
	alias grep='rg -i'
else
	alias grep='grep --color=auto -i'
fi

alias claude="claude --ide --chrome"
