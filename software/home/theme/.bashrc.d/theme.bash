THEME_STATE_FILE="${XDG_STATE_HOME:-${HOME}/.local/state}/theme"

theme_detect() {
	if [[ ${XDG_CURRENT_DESKTOP} =~ GNOME ]] &&
		[[ $(gsettings get org.gnome.desktop.interface color-scheme) =~ dark ]]; then
		printf 'dark\n'
	else
		printf 'light\n'
	fi
}

theme_read() {
	local stored=""
	read -r stored 2>/dev/null <"${THEME_STATE_FILE}"

	if [[ -z ${stored} ]]; then
		stored=$(theme_detect)
		mkdir --parents "${THEME_STATE_FILE%/*}"
		printf '%s\n' "${stored}" >"${THEME_STATE_FILE}"
	fi

	export THEME="${stored}"
}

theme_sync() {
	local status=$?
	local stored=""

	read -r stored 2>/dev/null <"${THEME_STATE_FILE}"

	if [[ -n ${stored} && ${stored} != "${THEME}" ]]; then
		export THEME="${stored}"
		declare -F bat_theme_apply >/dev/null && bat_theme_apply
	fi

	return "${status}"
}

theme_read

PROMPT_COMMAND+=(theme_sync)
