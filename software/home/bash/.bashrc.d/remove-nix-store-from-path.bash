# Drops raw /nix/store/<hash>-<pkg>/bin entries from the PATH of interactive shells.
#
# Legitimate nix tools come through profile directories (~/.nix-profile/bin, /nix/var/nix/profiles/default/bin), which are kept.
# So raw store path can only be an injection from a sandbox.
#
# Motivating case, bubblewrap:
#
# Symptom: FileZilla, or any GTK app, aborts on startup with "Loader process exited early with
# status '1'". Glycin, the GTK image decoder, runs `bwrap` by name from the PATH and picks up the
# store one, which no AppArmor profile covers: profiles match by path, and the shipped
# bwrap-userns-restrict targets /usr/bin/bwrap.
# Denied a user namespace, it exits 1 and GTK aborts.
#
# The leak escapes Claude Code through long-lived processes: a tmux server started from a sandboxed
# shell freezes that PATH and hands it to every pane. Interactive shells only, so the sandbox itself
# keeps its bwrap.

if [[ -z ${IN_NIX_SHELL} ]]; then
	sanitized_path=""

	while IFS= read -r -d ':' path_entry || [[ -n ${path_entry} ]]; do
		[[ ${path_entry} == /nix/store/* ]] && continue
		sanitized_path="${sanitized_path:+${sanitized_path}:}${path_entry}"
	done < <(printf '%s' "${PATH}")

	export PATH="${sanitized_path}"
	unset sanitized_path path_entry
fi
