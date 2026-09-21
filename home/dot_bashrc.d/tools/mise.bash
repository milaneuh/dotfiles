if [[ ! -d ${HOME}/.asdf/shims ]] && command -v mise >&/dev/null; then
	eval "$(mise activate bash)"
	cache_completion mise
fi
