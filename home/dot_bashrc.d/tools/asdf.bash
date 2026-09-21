# asdf and mise both claim .tool-versions, so only one may activate.
# asdf wins where it is installed; see mise.bash for the other half.
if [[ -d ${HOME}/.asdf/shims ]]; then
	export PATH="${HOME}/.asdf/shims:${HOME}/.asdf/bin:${PATH}"
fi
