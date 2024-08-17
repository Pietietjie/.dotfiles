#!/bin/bash

session="dot"
directory=~/.dotfiles
tmux new-session -d -s $session -c $directory
tmux send-keys -t $session:1 'nv' C-m
tmux split-window -c $directory -t $session:1 -v -p 15
tmux select-pane -t 1
tmux resize-pane -Z -t 1

session="82"
directory=~/proj/laradock8.2
tmux send-keys -t $session:1 'dc up -d nginx phpmyadmin'
tmux new-session -d -s $session -c $directory

session="74"
directory=~/proj/laradock7.4
tmux send-keys -t $session:1 'dc up -d nginx phpmyadmin'
tmux new-session -d -s $session -c $directory

session="pay"
directory=~/proj/bfi-pay-platform
tmux new-session -d -s $session -c $directory
tmux send-keys -t $session:1 'nv' C-m
tmux split-window -c $directory -t $session:1 -v -p 15
tmux select-pane -t 1
tmux resize-pane -Z -t 1

session="foodshare"
directory=~/proj/foodshare
tmux new-session -d -s $session -c $directory
tmux send-keys -t $session:1 'nv' C-m
tmux split-window -c $directory -t $session:1 -v -p 15
tmux select-pane -t 1
tmux resize-pane -Z -t 1

session="monify"
directory=~/proj/monify
tmux new-session -d -s $session -c $directory
tmux send-keys -t $session:1 'nv' C-m
tmux split-window -c $directory -t $session:1 -v -p 15
tmux select-pane -t 1
tmux resize-pane -Z -t 1

session="better-bond"
directory=~/proj/monify-better-bond
tmux new-session -d -s $session -c $directory
tmux send-keys -t $session:1 'nv' C-m
tmux split-window -c $directory -t $session:1 -v -p 15
tmux select-pane -t 1
tmux resize-pane -Z -t 1
tmux new-window -t $session:4 -c $directory
tmux send-keys -t $session:4 'npm run dev' C-m
directory=~/proj/monify-loan-cards
tmux new-window -t $session:2 -c $directory
tmux send-keys -t $session:2 'nv' C-m
tmux split-window -c $directory -t $session:2 -v -p 15
tmux select-pane -t 1
tmux resize-pane -Z -t 1
directory=~/proj/monify-better-bond/vendor/lavalamplab/monifyloanapi
tmux new-window -t $session:3 -c $directory
tmux send-keys -t $session:3 'nv' C-m
tmux split-window -c $directory -t $session:3 -v -p 15
tmux select-pane -t 1
tmux resize-pane -Z -t 1
tmux select-window -t 1

session="ooba"
directory=~/proj/monify-ooba
tmux new-session -d -s $session -c $directory
tmux send-keys -t $session:1 'nv' C-m
tmux split-window -c $directory -t $session:1 -v -p 15
tmux new-window -t $session:4 -c $directory
tmux send-keys -t $session:4 'npm run dev' C-m
tmux select-pane -t 1
tmux resize-pane -Z -t 1
directory=~/proj/monify-loan-cards
tmux new-window -t $session:2 -c $directory
tmux send-keys -t $session:2 'nv' C-m
tmux split-window -c $directory -t $session:2 -v -p 15
tmux select-pane -t 1
tmux resize-pane -Z -t 1
directory=~/proj/monify-ooba/vendor/lavalamplab/monifyloanapi
tmux new-window -t $session:3 -c $directory
tmux send-keys -t $session:3 'nv' C-m
tmux split-window -c $directory -t $session:3 -v -p 15
tmux select-pane -t 1
tmux resize-pane -Z -t 1
tmux select-window -t 1

session="blu"
directory=~/proj/monify-blue-deals
tmux new-session -d -s $session -c $directory
tmux send-keys -t $session:1 'nv' C-m
tmux split-window -c $directory -t $session:1 -v -p 15
tmux select-pane -t 1
tmux resize-pane -Z -t 1
tmux new-window -t $session:4 -c $directory
tmux send-keys -t $session:4 'npm run dev' C-m
directory=~/proj/monify-loan-cards
tmux new-window -t $session:2 -c $directory
tmux send-keys -t $session:2 'nv' C-m
tmux split-window -c $directory -t $session:2 -v -p 15
tmux select-pane -t 1
tmux resize-pane -Z -t 1
directory=~/proj/monify-blue-deals/vendor/lavalamplab/monifyloanapi
tmux new-window -t $session:3 -c $directory
tmux send-keys -t $session:3 'nv' C-m
tmux split-window -c $directory -t $session:3 -v -p 15
tmux select-pane -t 1
tmux resize-pane -Z -t 1
tmux select-window -t 1

session="westfalia"
directory=~/proj/westfalia-frontend
tmux new-session -d -s $session -c $directory
tmux send-keys -t $session:1 'nv' C-m
tmux split-window -c $directory -t $session:1 -v -p 15
tmux select-pane -t 1
tmux resize-pane -Z -t 1
tmux new-window -t $session:3 -c $directory
tmux send-keys -t $session:3 'npm run dev' C-m
directory=~/proj/westfalia-backend
tmux new-window -t $session:2 -c $directory
tmux send-keys -t $session:2 'nv' C-m
tmux split-window -c $directory -t $session:2 -v -p 15
tmux select-pane -t 1
tmux resize-pane -Z -t 1
tmux select-window -t 1

tmux attach-session -t "dot"

