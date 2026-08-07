# shellcheck source=/dev/null
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

fzf_theme_apply() {
	local state_dir="${XDG_STATE_HOME:-${HOME}/.local/state}"
	local opts_file="${state_dir}/fzf.conf"
	local theme_conf="${HOME}/.config/fzf/${THEME}.conf"

	if [[ -f ${theme_conf} ]]; then
		mkdir --parents "${state_dir}"
		ln --symbolic --force --no-dereference "${theme_conf}" "${opts_file}"
	fi

	unset FZF_DEFAULT_OPTS

	if [[ -e ${opts_file} ]]; then
		export FZF_DEFAULT_OPTS_FILE="${opts_file}"
	else
		unset FZF_DEFAULT_OPTS_FILE
	fi

	if [[ -n ${TMUX} ]]; then
		export FZF_CTRL_T_OPTS="--preview 'fzf-preview {}' --layout=default --preview-window=top:wrap"
	else
		export FZF_CTRL_T_OPTS=""
	fi
}

if command -v fzf >&/dev/null; then

	fzf_theme_apply

	export FZF_DEFAULT_COMMAND="rg --files --hidden --glob '!.git' --follow"

	if [[ -n ${TMUX} ]]; then
		export FZF_TMUX='1'
		export FZF_TMUX_OPTS="-p90%,80% --layout=default --preview-window=top:wrap"
		export FZF_ALT_C_OPTS="--layout=default --preview 'fzf-preview {}' --preview-window=top:wrap"
	fi

	export FZF_CTRL_R_OPTS="--history=${HOME}/.bash_history --history-size=100000"

	bind -r '\ec'
	bind -x '"\C-g": __fzf_cd__'

fi
