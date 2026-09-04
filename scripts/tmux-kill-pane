#!/bin/bash

cmd=$(tmux display-message -p "#{pane_current_command}")

if [[ "$cmd" =~ ^(bash|zsh|sh|fish)$ ]]; then
    tmux kill-pane
else
    tmux confirm-before -p "Kill pane with running process $cmd? (y/n)" kill-pane
fi
