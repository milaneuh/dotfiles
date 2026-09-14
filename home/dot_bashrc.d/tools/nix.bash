nix_profile_bin="${HOME}/.nix-profile/bin"

if [[ -d ${nix_profile_bin} && ":${PATH}:" != *":${nix_profile_bin}:"* ]]; then
	export PATH="${nix_profile_bin}:${PATH}"
fi

hm_session_vars="${HOME}/.nix-profile/etc/profile.d/hm-session-vars.sh"

# shellcheck source=/dev/null
[[ -r ${hm_session_vars} ]] && source "${hm_session_vars}"

unset nix_profile_bin hm_session_vars
