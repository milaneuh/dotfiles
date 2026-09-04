for fzf_integration in ~/.nix-profile/share/fzf/key-bindings.bash \
	~/.nix-profile/share/fzf/completion.bash; do
	# shellcheck source=/dev/null
	[[ -r ${fzf_integration} ]] && source "${fzf_integration}"
done
unset fzf_integration

if command -v fzf >&/dev/null; then

	fzf_opts_file="${XDG_STATE_HOME:-${HOME}/.local/state}/fzf.conf"
	fzf_common_conf="${HOME}/.config/fzf/common.conf"

	if [[ ! -e ${fzf_opts_file} || -L ${fzf_opts_file} || ${fzf_opts_file} -ot ${fzf_common_conf} ]]; then
		fzf-conf
	fi

	unset FZF_DEFAULT_OPTS

	if [[ -e ${fzf_opts_file} ]]; then
		export FZF_DEFAULT_OPTS_FILE="${fzf_opts_file}"
	else
		unset FZF_DEFAULT_OPTS_FILE
	fi

	unset fzf_opts_file fzf_common_conf

	export FZF_DEFAULT_COMMAND="rg --files --hidden --glob '!.git' --follow"

	export FZF_CTRL_R_OPTS="--preview-window=hidden --history=${HOME}/.bash_history --history-size=100000"

	bind -r '\ec'
	bind -x '"\C-g": __fzf_cd__'

fi
