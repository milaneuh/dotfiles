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

fmt_bar() {
    local percent="$1" width="$2"
    local filled=$(( percent * width / 100 ))
    local empty=$(( width - filled ))
    local filled_str="" empty_str=""
    [ "$filled" -gt 0 ] && filled_str=$(printf '█%.0s' $(seq 1 $filled))
    [ "$empty" -gt 0 ] && empty_str=$(printf '░%.0s' $(seq 1 $empty))
    printf '[%s%s] %d%%' "$filled_str" "$empty_str" "$percent"
}

input=$(cat)
context_used_percentage=$(echo "$input" | jq --raw-output '.context_window.used_percentage // empty')
model=$(echo "$input" | jq --raw-output '.model.display_name // empty')
total_cost_usd=$(echo "$input" | jq --raw-output '.cost.total_cost_usd // empty')
total_duration_ms=$(echo "$input" | jq --raw-output '.cost.total_duration_ms // empty')
total_api_duration_ms=$(echo "$input" | jq --raw-output '.cost.total_api_duration_ms // empty')
total_lines_added=$(echo "$input" | jq --raw-output '.cost.total_lines_added // empty')
total_lines_removed=$(echo "$input" | jq --raw-output '.cost.total_lines_removed // empty')

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
    context_bar="context: $(fmt_bar "$(printf '%.0f' "$context_used_percentage")" 10)"
fi

five_hour_percentage=$(echo "$input" | jq --raw-output '.rate_limits.five_hour.used_percentage // empty')

five_hour_bar=""
if [ -n "$five_hour_percentage" ]; then
    five_hour_bar="5h: $(fmt_bar "$(printf '%.0f' "$five_hour_percentage")" 5)"
fi

parts=()
[ -n "$cost_display" ] && parts+=("cost: ${cost_display}")
[ -n "$api_duration_display" ] && parts+=("API: ${api_duration_display}")
[ -n "$wall_duration_display" ] && parts+=("wall: ${wall_duration_display}")
[ -n "$lines_display" ] && parts+=("lines: ${lines_display}")
[ -n "$model" ] && parts+=("model: [${model}]")
[ -n "$context_bar" ] && parts+=("$context_bar")
[ -n "$five_hour_bar" ] && parts+=("$five_hour_bar")

printf "%s" "$(IFS=' | '; echo "${parts[*]}")"
