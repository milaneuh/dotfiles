[[ ${GNOME_THEME} =~ "dark" ]] && export BAT_THEME="gruvbox-dark" || export BAT_THEME="gruvbox-light"

# Force groff to use backspace formatting instead of ANSI escapes (for col -bx)
export GROFF_NO_SGR=1

if command -v bat >&/dev/null; then
	export MANPAGER="sh -c 'col -bx | bat -l man -p --theme=${BAT_THEME}'"
else
	export MANPAGER="less -R"
fi
