if command -v kl >&/dev/null; then
	export K_DIR="${zettelkasten}"
	source <(kl completion bash)
fi