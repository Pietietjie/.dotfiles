#!/bin/bash

session="dot"
directory=~/.dotfiles
tmux new-session -d -s $session -c $directory
tmux send-keys -t $session:1 'nv' C-m
tmux split-window -c $directory -t $session:1 -v -p 15
tmux select-pane -t 1
tmux resize-pane -Z -t 1
