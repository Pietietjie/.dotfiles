#!/bin/bash

session_list=$(tmux list-sessions -F "#{session_created}|#{session_name}|#{session_attached}" 2>/dev/null | sort -n | awk -F'|' '
{
    idx = NR - 1
    if (idx <= 9) {
        key = idx
    } else {
        key = "M-" sprintf("%c", 96 + idx - 9)
    }
    attached = $3 == "1" ? " (attached)" : ""
    printf "(%s) + %s%s\n", key, $2, attached
}')

if [ -z "$session_list" ]; then
    echo "No tmux sessions found."
    exit 0
fi

selected=$(echo "$session_list" | fzf --multi --prompt="Tmux sessions> ")

if [ -z "$selected" ]; then
    exit 0
fi

selected_sessions=$(echo "$selected" | awk -F' \\+ ' '{print $2}' | sed 's/ (attached)$//')

selected_command=$(printf '%s\n' \
    "1 - kill      - Kill session(s)" \
    "2 - send-keys - Send a command to session(s)" \
    "3 - rename    - Rename session (single only)" \
    | fzf --prompt="Command> " | awk '{print $3}')

if [ -z "$selected_command" ]; then
    exit 0
fi

case "$selected_command" in
    kill)
        echo "$selected_sessions" | while IFS= read -r session; do
            tmux kill-session -t "$session" && echo "Killed: $session"
        done
        ;;
    send-keys)
        read -rp "Keys to send: " keys
        echo "$selected_sessions" | while IFS= read -r session; do
            tmux send-keys -t "$session" "$keys" Enter && echo "Sent to: $session"
        done
        ;;
    rename)
        count=$(echo "$selected_sessions" | wc -l)
        if [ "$count" -gt 1 ]; then
            echo "Rename only supports a single session."
            exit 1
        fi
        session=$(echo "$selected_sessions" | head -1)
        read -rp "New name for '$session': " new_name
        if [ -n "$new_name" ]; then
            tmux rename-session -t "$session" "$new_name" && echo "Renamed '$session' -> '$new_name'"
        fi
        ;;
esac
