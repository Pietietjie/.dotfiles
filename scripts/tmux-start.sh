#!/bin/bash

if ! (tmux ls 2>/dev/null | sed 's/:.*//' | grep -q 'dot'); then
    session="dot";
    directory=~/.dotfiles;
    tmux new-session -d -s $session -c "$directory";
    tmux send-keys -t $session:1 'nv' C-m;
    tmux split-window -c "$directory" -t $session:1 -v -p 15;
    tmux select-pane -t $session:1;
    tmux resize-pane -Z -t $session:1;
else
    echo "the Dotfiles session all ready exists";
fi

if [ -f ~/tmux-sessions.json ]; then
    selectedSessions="$(jq -r '.[].sessionName' ~/tmux-sessions.json | fzf -m --tac)"
    jq -c '.[]' ~/tmux-sessions.json | while IFS= read -r sessionJson; do
        sessionName=$(echo "$sessionJson" | jq -r '.sessionName')
        if echo $selectedSessions | grep -q $sessionName; then
            directory=$(echo "$sessionJson" | jq -r '.dir' | sed "s|^~|$HOME|")
            nvim=$(echo "$sessionJson" | jq -r '.nvim')
            extraCommands=$(echo "$sessionJson" | jq -r '.extraCommands')
            if ! (tmux ls 2>/dev/null | sed 's/:.*//' | grep -q "$sessionName"); then
                tmux new-session -d -s $sessionName -c "$directory";
                availableWindow=1
                if [[ -n $nvim && "$nvim" != "null" ]]; then
                    availableWindow=2
                    tmux send-keys -t $sessionName:1 'nv' C-m;
                    tmux split-window -c "$directory" -t $sessionName:1 -v -p 15;
                    tmux select-pane -t $sessionName:1;
                    tmux resize-pane -Z -t $sessionName:1;
                fi
                if [[ -n $extraCommands && "$extraCommands" != "null" ]]; then
                    tmux send-keys -t $sessionName:$avialableWindow "$extraCommands" C-m;
                fi
            else
                echo "the $sessionName session all ready exists";
            fi
        fi
    done
fi
if ! { [ "$TERM" = "screen" ] && [ -n "$TMUX" ]; } then
    tmux attach-session
fi

