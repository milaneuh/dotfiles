#!/bin/bash

pane_tty=$(tmux display-message -p '#{pane_tty}')
pane_procs=$(ps --tty "${pane_tty#/dev/}" --format comm= 2>/dev/null)
echo "$pane_procs" | grep --quiet --line-regexp --extended-regexp 'vi|vim|nvim|view|fzf'
