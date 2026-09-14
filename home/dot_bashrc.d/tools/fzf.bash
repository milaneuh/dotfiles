for fzf_integration in ~/.nix-profile/share/fzf/key-bindings.bash \
	~/.nix-profile/share/fzf/completion.bash; do
	# shellcheck source=/dev/null
	[[ -r ${fzf_integration} ]] && source "${fzf_integration}"
done
unset fzf_integration

if command -v fzf >&/dev/null; then

	unset FZF_DEFAULT_OPTS
	export FZF_DEFAULT_OPTS_FILE="${HOME}/.config/fzf/fzf.conf"

	export FZF_DEFAULT_COMMAND="rg --files --hidden --glob '!.git' --follow"

	export FZF_CTRL_R_OPTS="--preview-window=hidden --history=${HOME}/.bash_history --history-size=100000"

	fzf_cd() {
		eval "$(__fzf_cd__)"
	}

	bind -r '\ec'
	bind -x '"\C-g": fzf_cd'

fi
