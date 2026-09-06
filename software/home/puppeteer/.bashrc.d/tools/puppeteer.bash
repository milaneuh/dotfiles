export MERMAID_FILTER_PUPPETEER_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/puppeteer-config.json"

for _p in \
	"/usr/bin/google-chrome" \
	"/snap/chromium/current/usr/lib/chromium-browser/chrome" \
	"/usr/bin/chromium" \
	"/usr/bin/chromium-browser" \
	"${HOME}/.nix-profile/bin/chromium"; do
	if [[ -x "$_p" ]]; then
		export PUPPETEER_EXECUTABLE_PATH="$_p"
		break
	fi
done
unset _p
