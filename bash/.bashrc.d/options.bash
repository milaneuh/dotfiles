# shellcheck disable=SC2154 # debian_chroot is set by /etc/bash.bashrc
PS1='${RANGER_LEVEL:+(ranger) }${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

stty -ixon lnext undef # Disable Ctrl+S freezing and Ctrl+V quoting

# set -o vi

shopt -s histappend
shopt -s checkwinsize

for f in ~/.local/share/bash-completion/completions/*; do
	# shellcheck source=/dev/null
	[[ -r "$f" ]] && source "$f"
done
