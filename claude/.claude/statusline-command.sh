#!/bin/bash

input=$(cat)
context_used_percentage=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
model=$(echo "$input" | jq -r '.model.display_name // empty')
current_directory=$(echo "$input" | jq -r '.workspace.current_dir // empty' | sed "s|$HOME|~|")

input_tokens=$(echo "$input" | jq -r '.context_window.total_input_tokens // empty')
output_tokens=$(echo "$input" | jq -r '.context_window.total_output_tokens // empty')
max_tokens=$(echo "$input" | jq -r '.context_window.context_window_size // empty')

context_bar=""
if [ -n "$context_used_percentage" ]; then
    percent=$(printf '%.0f' "$context_used_percentage")
    filled_blocks=$(( percent * 10 / 100 ))
    empty_blocks=$(( 10 - filled_blocks ))
    bar="$(printf '█%.0s' $(seq 1 $filled_blocks 2>/dev/null))$(printf '░%.0s' $(seq 1 $empty_blocks 2>/dev/null))"
    context_bar="context: [${bar}] ${percent}%"
fi

token_display=""
if [ -n "$input_tokens" ] && [ -n "$output_tokens" ] && [ -n "$max_tokens" ] && [ "$max_tokens" -gt 0 ]; then
    total_tokens=$(( input_tokens + output_tokens ))
    filled_blocks=$(( input_tokens * 5 / max_tokens ))
    empty_blocks=$(( 5 - filled_blocks ))
    token_bar="$(printf '█%.0s' $(seq 1 $filled_blocks 2>/dev/null))$(printf '░%.0s' $(seq 1 $empty_blocks 2>/dev/null))"
    if [ "$total_tokens" -ge 1000 ]; then
        token_display="tokens: [${token_bar}] $(( total_tokens / 1000 ))k"
    else
        token_display="tokens: [${token_bar}] ${total_tokens}"
    fi
fi

parts=()
[ -n "$model" ] && parts+=("model: [${model}]")
# [ -n "$current_directory" ] && parts+=("$current_directory")
[ -n "$context_bar" ] && parts+=("$context_bar")
[ -n "$token_display" ] && parts+=("$token_display")

printf "%s" "$(IFS=' | '; echo "${parts[*]}")"
