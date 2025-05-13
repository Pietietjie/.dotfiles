#!/bin/bash

if [ -f ~/tmux-sessions.json ]; then
    jq -c ".[] | select(.blueprintName == \"$(jq -r '.[].blueprintName' ~/tmux-sessions.json | fzf --tac)\") | .sessions | .[]" ~/tmux-sessions.json | while IFS= read -r sessionJson; do
        sessionName=$(echo "$sessionJson" | jq -r '.sessionName')
        sessionDir=$(echo "$sessionJson" | jq -r '.dir' | sed "s|^~|$HOME|;s|^.$|$(pwd)|")
        if tmux new-session -d -s $sessionName -c "$sessionDir"; then
            windowNumber=1
            echo "$sessionJson" | jq -c '.windows | .[]' | while IFS= read -r windowsJson; do
                # Check if window has its own directory
                windowDir=$(echo "$windowsJson" | jq -r '.dir')
                if [[ -n $windowDir && "$windowDir" != "null" ]]; then
                    # Use window-specific directory, expanding ~ to $HOME
                    currentDir=$(echo "$windowDir" | sed "s|^~|$HOME|;s|^.$|$(pwd)|")
                else
                    # Fall back to session directory
                    currentDir="$sessionDir"
                fi
                paneNumber=1
                if [[ "$windowNumber" != "1" ]]; then
                    tmux new-window -t $sessionName:$windowNumber -c "$currentDir"
                else
                    # For the first window, we need to set the directory since it was already created
                    tmux send-keys -t $sessionName:$windowNumber "cd \"$currentDir\"" C-m
                fi
                echo "$windowsJson" | jq -c '.panes | .[]' | while IFS= read -r paneJson; do
                    if [[ "$paneNumber" != "1" ]]; then
                        heightPercentage=$(echo "$paneJson" | jq -r '.heightPercentage')
                        if [[ -n $heightPercentage && "$heightPercentage" != "null" ]]; then
                            tmux split-window -c "$currentDir" -t $sessionName:$windowNumber -v -p $heightPercentage
                        else
                            tmux split-window -c "$currentDir" -t $sessionName:$windowNumber -v
                        fi
                    fi
                    commands=$(echo "$paneJson" | jq -r '.commands')
                    if [[ -n $commands && "$commands" != "null" ]]; then
                        tmux send-keys -t $sessionName:$windowNumber.$paneNumber "$commands" C-m;
                    fi
                    ((paneNumber++))
                done
                maximized=$(echo "$windowsJson" | jq -r '.maximized')
                if [[ -n $maximized && "$maximized" != "null" ]]; then
                    tmux resize-pane -Z -t $sessionName:$windowNumber;
                fi
                ((windowNumber++))
            done
        fi
    done
fi

if [[ -z "$TMUX" ]]; then
    tmux attach-session
fi

