export PATH="${PATH}:/usr/local/go/bin"
if command -v go >&/dev/null; then
	export GOPATH="${HOME}/.go"
	export PATH="${PATH}:${GOPATH}/bin"
fi