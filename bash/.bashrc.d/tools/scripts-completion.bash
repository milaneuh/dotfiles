scripts_paths=$(grep -RlI "COMP_LINE" "${HOME}/.local/bin")
for s in ${scripts_paths[*]}; do
	complete -C "${s##*/}" "${s##*/}"
done

_tast() {
	local sessions=$(tmux list-sessions 2>/dev/null | sed "s/:.*//g")

	if [[ -n $sessions ]]; then
		COMPREPLY=($(compgen -W "$sessions" -- "${COMP_WORDS[COMP_CWORD]}"))
	else
		COMPREPLY=()
	fi
}

complete -F _tast tast
complete -F _tast tkst
