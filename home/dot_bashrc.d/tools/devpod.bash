if command -v devpod >&/dev/null; then
	cache_completion devpod
	complete -o dirnames devpod-refresh
fi
