# Force groff to use backspace formatting instead of ANSI escapes (for col)
export GROFF_NO_SGR=1

bat_theme_apply() {
	[[ ${THEME} == "dark" ]] && export BAT_THEME="gruvbox-dark" || export BAT_THEME="gruvbox-light"

	if command -v bat >&/dev/null; then
		export MANPAGER="sh -c 'col --no-backspaces --spaces | bat --language man --plain --theme=${BAT_THEME}'"
	else
		export MANPAGER="less --RAW-CONTROL-CHARS"
	fi
}

bat_theme_apply
