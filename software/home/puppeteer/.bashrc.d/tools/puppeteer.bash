export MERMAID_FILTER_PUPPETEER_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/puppeteer-config.json"

for _p in \
	"${HOME}/.nix-profile/bin/chromium" \
	"/snap/chromium/current/usr/lib/chromium-browser/chrome" \
	"/usr/bin/chromium" \
	"/usr/bin/chromium-browser" \
	"/usr/bin/google-chrome"; do
	if [[ -x "$_p" ]]; then
		export PUPPETEER_EXECUTABLE_PATH="$_p"
		break
	fi
done
unset _p
