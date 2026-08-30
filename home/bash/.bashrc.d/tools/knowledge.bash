if command -v kl >&/dev/null; then
	# shellcheck disable=SC2154 # zettelkasten is exported by variables.bash
	export K_DIR="${zettelkasten}"
	cache_completion kl
fi