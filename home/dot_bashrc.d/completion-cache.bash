cache_completion() {
	local name=$1
	local bin cache
	bin=$(command -v "${name}") || return
	cache="${HOME}/.cache/bash/${name}-completion.bash"
	if [[ ! -s ${cache} || ${bin} -nt ${cache} ]]; then
		mkdir -p "${cache%/*}"
		"${name}" completion bash >"${cache}"
	fi
	# shellcheck source=/dev/null
	source "${cache}"
}
