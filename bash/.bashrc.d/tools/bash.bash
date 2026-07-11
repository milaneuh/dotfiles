if [[ ${SHELL} == "/bin/bash" ]]; then
	[[ -f /etc/bashrc ]] && . /etc/bashrc
	if [[ -f /usr/share/bash-completion/bash_completion ]]; then
		. /usr/share/bash-completion/bash_completion
	elif [ -f /etc/bash_completion ]; then
		. /etc/bash_completion
	fi
fi

[[ -f ~/.local_configuration.bash ]] && source "${HOME}/.local_configuration.bash"