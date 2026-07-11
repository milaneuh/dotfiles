export MERMAID_FILTER_PUPPETEER_CONFIG="$HOME/.puppeteer.json"

for _p in \
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
