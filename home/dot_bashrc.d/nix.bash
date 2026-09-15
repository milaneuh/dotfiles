nix_profile_bin="${HOME}/.nix-profile/bin"

if [[ -d ${nix_profile_bin} ]]; then
	path_rest=":${PATH}:"
	path_rest="${path_rest//:${nix_profile_bin}:/:}"
	path_rest="${path_rest#:}"
	path_rest="${path_rest%:}"
	export PATH="${nix_profile_bin}${path_rest:+:${path_rest}}"
fi

hm_session_vars="${HOME}/.nix-profile/etc/profile.d/hm-session-vars.sh"

# shellcheck source=/dev/null
[[ -r ${hm_session_vars} ]] && source "${hm_session_vars}"

unset nix_profile_bin path_rest hm_session_vars
