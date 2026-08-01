if command -v ranger >&/dev/null; then
	function ranger {
		local IFS=$'\t\n'
		local tempfile target_dir cwd
		tempfile="$(mktemp -t tmp.XXXXXX)"
		local ranger_cmd=(
			command
			ranger
			--cmd="map Q quitallcd $tempfile"
		)

		PYTHONWARNINGS=ignore::SyntaxWarning "${ranger_cmd[@]}" "$@"
		target_dir=$(tr --delete ' ' <"$tempfile")
		cwd=$(printf '%s' "$PWD" | tr --delete ' ')
		if [[ -f "$tempfile" ]] && [[ "$target_dir" != "" ]] &&
			[[ "$target_dir" != "$cwd" ]]; then
			cd -- "$target_dir" || return
		fi
		command rm --force -- "$tempfile" 2>/dev/null
	}


  if command -v ranger >&/dev/null; then
    alias rr='ranger'
  fi
fi
