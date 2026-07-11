if [[ -n ${KITTY_PID} ]]; then
	export PROMPT_COMMAND='echo -en "\033]0;Kitty\a"'
fi