[[ -n ${TMUX:-} ]] && return
[[ -z ${DEVPOD:-} && -z ${REMOTE_CONTAINERS:-} && ! -f /.dockerenv ]] && return
[[ ! -t 0 || ! -t 1 ]] && return
command -v tmux >/dev/null || return

exec tmux new-session -A -s main
