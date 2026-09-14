if [[ ${SHELL} == "/bin/bash" ]]; then
	# shellcheck source=/dev/null
	[[ -f /etc/bashrc ]] && . /etc/bashrc
	if [[ -f ~/.nix-profile/share/bash-completion/bash_completion ]]; then
		# shellcheck source=/dev/null
		. ~/.nix-profile/share/bash-completion/bash_completion
	elif [[ -f /usr/share/bash-completion/bash_completion ]]; then
		# shellcheck source=/dev/null
		. /usr/share/bash-completion/bash_completion
	elif [[ -f /etc/bash_completion ]]; then
		# shellcheck source=/dev/null
		. /etc/bash_completion
	fi
fi

# shellcheck source=/dev/null
[[ -f ~/.bashrc.local ]] && source "${HOME}/.bashrc.local"
