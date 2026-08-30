if [[ -d ~/.asdf ]]; then
	export KERL_CONFIGURE_OPTIONS="--without-javac --without-wx --without-odbc --disable-jit"
	export CFLAGS="-O2 -g -Wno-error=implicit-function-declaration -std=gnu11"
	export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"
fi

if command -v asdf &>/dev/null; then
	cache_completion asdf
fi
