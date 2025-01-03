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

createWindow ()
{
    local windowDir=""
    local windowNvim=""
    local windowExtraCommands=""
    local windowNumber=""
    while [[ "$#" -gt 0 ]]; do
        case "$1" in
            --dir)
                windowDir="$2"
                shift 2
                ;;
            --nvim)
                windowNvim="$2"
                shift 2
                ;;
            --extraCommands)
                windowExtraCommands="$2"
                shift 2
                ;;
            --num)
                windowNumber="$2"
                shift 2
                ;;
            *)
                echo "Unknown parameter: $1"
                shift
                ;;
        esac
    done

    currentPane=1
    if [[ -n $windowNumber && "$windowNumber" != "null" && $windowNumber != 1 ]]; then
        tmux new-window -t $sessionName:$windowNumber -c "$windowDir"
    fi

    if [[ -n $windowNvim && "$windowNvim" != "null" ]]; then
        tmux send-keys -t $sessionName:$windowNumber 'nv' C-m;
        tmux split-window -c "$windowDir" -t $sessionName:$windowNumber -v -p 15;
        tmux select-pane -t $sessionName:$windowNumber;
        tmux resize-pane -Z -t $sessionName:$windowNumber;
        currentPane=2
    fi
    if [[ -n $windowExtraCommands && "$windowExtraCommands" != "null" ]]; then
        tmux send-keys -t $sessionName:$curretnPane "$windowExtraCommands" C-m;
    fi
}

if [ -f ~/tmux-sessions.json ]; then
    selectedSessions="$(jq -r '.[].sessionName' ~/tmux-sessions.json | fzf -m --tac)"
    jq -c '.[]' ~/tmux-sessions.json | while IFS= read -r sessionJson; do
    sessionName=$(echo "$sessionJson" | jq -r '.sessionName')
    if echo $selectedSessions | grep -q $sessionName; then
        directory=$(echo "$sessionJson" | jq -r '.dir' | sed "s|^~|$HOME|;s|^\.$|$(pwd)|")
        nvim=$(echo "$sessionJson" | jq -r '.nvim')
        extraWindows=$(echo "$sessionJson" | jq -r '.extraWindows')
        extraCommands=$(echo "$sessionJson" | jq -r '.extraCommands')
        num=1

        if ! (tmux ls 2>/dev/null | sed 's/:.*//' | grep -q "$sessionName"); then
            tmux new-session -d -s $sessionName -c "$directory";
            createWindow --dir "$directory" --nvim "$nvim" --num "$num" --extraCommands "$extraCommands"

            if [[ -n $extraWindows && "$extraWindows" != "null" ]]; then
                echo "$extraWindows" | jq -c '.[]' | while read -r extraWindow; do
                extraWindowDirectory=$(echo "$extraWindow" | jq -r '.dir' | sed "s|^~|$HOME|;s|^.$|$(pwd)|")
                extraWindowNvim=$(echo "$extraWindow" | jq -r '.nvim')
                extraWindowExtraCommands=$(echo "$extraWindow" | jq -r '.extraCommands')
                let "num++";

                createWindow --dir "$extraWindowDirectory" --nvim "$nvim" --num "$num" --extraCommands "$extraCommands"
            done
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

