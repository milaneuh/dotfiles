THEME_STATE_FILE="${XDG_STATE_HOME:-${HOME}/.local/state}/theme"

theme_read() {
	if ! read -r THEME <"${THEME_STATE_FILE}" 2>/dev/null || [[ -z ${THEME} ]]; then
		if [[ ${XDG_CURRENT_DESKTOP} =~ GNOME ]] &&
			[[ $(gsettings get org.gnome.desktop.interface color-scheme) =~ dark ]]; then
			THEME="dark"
		else
			THEME="light"
		fi
		mkdir --parents "${THEME_STATE_FILE%/*}"
		printf '%s\n' "${THEME}" >"${THEME_STATE_FILE}"
	fi
	export THEME
}

theme_sync() {
	local status=$?
	local previous="${THEME}"

	if read -r THEME <"${THEME_STATE_FILE}" 2>/dev/null && [[ ${THEME} != "${previous}" ]]; then
		export THEME
		declare -F bat_theme_apply >/dev/null && bat_theme_apply
		declare -F fzf_theme_apply >/dev/null && fzf_theme_apply
	fi

	return "${status}"
}

theme_read

PROMPT_COMMAND+=(theme_sync)
