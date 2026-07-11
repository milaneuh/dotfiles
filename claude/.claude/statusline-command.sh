#!/bin/bash

fmt_duration() {
    local ms="$1"
    [ -z "$ms" ] && return
    local total_s=$(( ms / 1000 ))
    local m=$(( total_s / 60 ))
    local s=$(( total_s % 60 ))
    local cs=$(( (ms % 1000) / 10 ))
    if [ "$m" -gt 0 ]; then
        printf '%dm %d.%ds' "$m" "$s" "$cs"
    else
        printf '%d.%ds' "$s" "$cs"
    fi
}

input=$(cat)
context_used_percentage=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
model=$(echo "$input" | jq -r '.model.display_name // empty')
current_directory=$(echo "$input" | jq -r '.workspace.current_dir // empty' | sed "s|$HOME|~|")

input_tokens=$(echo "$input" | jq -r '.context_window.total_input_tokens // empty')
output_tokens=$(echo "$input" | jq -r '.context_window.total_output_tokens // empty')
max_tokens=$(echo "$input" | jq -r '.context_window.context_window_size // empty')

total_cost_usd=$(echo "$input" | jq -r '.cost.total_cost_usd // empty')
total_duration_ms=$(echo "$input" | jq -r '.cost.total_duration_ms // empty')
total_api_duration_ms=$(echo "$input" | jq -r '.cost.total_api_duration_ms // empty')
total_lines_added=$(echo "$input" | jq -r '.cost.total_lines_added // empty')
total_lines_removed=$(echo "$input" | jq -r '.cost.total_lines_removed // empty')

cost_display=""
[ -n "$total_cost_usd" ] && cost_display="\$$(printf '%.4f' "$total_cost_usd")"

api_duration_display=$(fmt_duration "$total_api_duration_ms")
wall_duration_display=$(fmt_duration "$total_duration_ms")

lines_display=""
if [ -n "$total_lines_added" ] || [ -n "$total_lines_removed" ]; then
    lines_display="+${total_lines_added:-0}/-${total_lines_removed:-0}"
fi

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
[ -n "$cost_display" ] && parts+=("cost: ${cost_display}")
[ -n "$api_duration_display" ] && parts+=("API: ${api_duration_display}")
[ -n "$wall_duration_display" ] && parts+=("wall: ${wall_duration_display}")
[ -n "$lines_display" ] && parts+=("lines: ${lines_display}")
[ -n "$model" ] && parts+=("model: [${model}]")
# [ -n "$current_directory" ] && parts+=("$current_directory")
[ -n "$context_bar" ] && parts+=("$context_bar")
[ -n "$token_display" ] && parts+=("$token_display")

printf "%s" "$(IFS=' | '; echo "${parts[*]}")"
