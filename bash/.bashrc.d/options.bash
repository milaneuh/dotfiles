PS1='${RANGER_LEVEL:+(ranger) }${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

stty -ixon       # Disable terminal freezing with Ctrl+S
stty lnext undef # Disable terminal quoting with Ctrl+V

# set -o vi

shopt -s histappend
shopt -s checkwinsize

for f in ~/.local/share/bash-completion/completions/*; do
	[[ -r "$f" ]] && source "$f"
done
