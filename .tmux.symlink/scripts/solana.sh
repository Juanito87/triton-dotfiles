#!/bin/bash
tmux neww -n:deploy
tmux split-window -h
tmux send 'a9' ENTER
tmux send 'cd rpcpool' ENTER
tmux send 'git pull' ENTER
tmux send 'clear' ENTER
tmux split-window -v
tmux send 'a9' ENTER
tmux send 'cd rpcpool' ENTER
tmux send 'clear' ENTER
tmux split-window -v
tmux send 'a9' ENTER
tmux send 'cd rpcpool' ENTER
tmux send 'clear' ENTER
tmux select-layout main-vertical
