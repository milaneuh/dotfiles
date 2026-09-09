PS1='${RANGER_LEVEL:+(ranger) }\[\033[01;32m\]\u${SSH_CONNECTION:+@\h}\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

stty -ixon lnext undef # Disable Ctrl+S freezing and Ctrl+V quoting

umask 022

shopt -s histappend
shopt -s checkwinsize
