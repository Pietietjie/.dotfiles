#!/bin/bash

if ! (tmux ls 2>/dev/null | sed 's/:.*//' | grep -q 'dot'); then
    session="dot";
    directory=~/.dotfiles;
    tmux new-session -d -s $session -c $directory;
    tmux send-keys -t $session:1 'nv' C-m;
    tmux split-window -c $directory -t $session:1 -v -p 15;
    tmux select-pane -t $session:1;
    tmux resize-pane -Z -t $session:1;
else
    echo "the Dotfiles session all ready exists";
fi

if ! (tmux ls 2>/dev/null | sed 's/:.*//' | grep -q 'proj'); then
    session="proj";
    directory=~/proj/;
    tmux new-session -d -s $session -c $directory;
    tmux send-keys -t $session:1 "powershell.exe -Command \"Start-Process 'C:\\Program Files\\Docker\\Docker\\Docker Desktop.exe'\" && dc up" C-m;
else
    echo "the Project session all ready exists";
fi

if [ -f ~/tmux-sessions.json ]; then 
    selectedSessions="$(jq -r '.[].sessionName' ~/tmux-sessions.json | fzf -m)"
    jq -c '.[]' ~/tmux-sessions.json | while IFS= read -r sessionJson; do
        sessionName=$(echo "$sessionJson" | jq -r '.sessionName')
        if echo $selectedSessions | grep -q $sessionName; then
            directory=$(echo "$sessionJson" | jq -r '.dir')
            if ! (tmux ls 2>/dev/null | sed 's/:.*//' | grep -q "$sessionName"); then
                tmux new-session -d -s $sessionName -c $directory;
                tmux send-keys -t $sessionName:1 'nv' C-m;
                tmux split-window -c $directory -t $sessionName:1 -v -p 15;
                tmux select-pane -t $sessionName:1;
                tmux resize-pane -Z -t $sessionName:1;
            else
                echo "the $sessionName session all ready exists";
            fi
        fi
    done
fi
