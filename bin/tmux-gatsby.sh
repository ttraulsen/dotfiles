#!/bin/sh
#
# Setup a work space called `work` with two windows
# first window has 3 panes. 
# The first pane set at 65%, split horizontally, set to api root and running vim
# pane 2 is split at 25% and running redis-server 
# pane 3 is set to api root and bash prompt.
# note: `api` aliased to `cd ~/path/to/work`
#
session="gatsby"

# set up tmux
tmux start-server

# create a new tmux session, starting vim from a saved session in the new window
tmux new-session -d -s $session

# Select pane 1, set dir to api, run vim
tmux selectp -t 1 
tmux send-keys "projects/bahnid/bahnid-architecture-docs" C-m 

# Split pane 1 horizontal by 65%, start redis-server
tmux splitw -h
# Select pane 2 
tmux selectp -t 2
tmux send-keys "projects/bahnid/bahnid-architecture-docs" C-m 

# Split pane 2 vertiacally by 25%
tmux splitw -v
tmux selectp -t 3
tmux send-keys "projects/bahnid/bahnid-architecture-docs" C-m 

# Select pane 1
tmux selectp -t 1

# create a new window called gatsby htop
tmux new-window -t $session -n gatsby-htop
tmux select-window -t $session:2
# change to architecture-docs and serve gatsby output
tmux selectp -t 1.1
tmux send-keys "projects/bahnid/bahnid-architecture-docs;gatsby serve" C-m 

# split, run htop
tmux splitw -v -p 85
tmux selectp -t 1.2
tmux send-keys "htop" C-m 

# return to main vim window
tmux select-window -t $session:1

# Finished setup, attach to the tmux session!
tmux attach-session -t $session