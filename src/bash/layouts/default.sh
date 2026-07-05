#!/usr/bin/env bash

###########################################################
#
# default.sh
#
# Layout padrão: editor + file manager + terminal
#
# ┌──────────────────────────────┐
# │            Editor            │
# ├──────────────┬───────────────┤
# │   Yazi       │    Shell      │
# └──────────────┴───────────────┘
#
###########################################################

layout::default() {
    local session="$1"
    local dir="$2"
    local editor
    editor=$(config::get "editor" "nvim")
    local file_manager
    file_manager=$(config::get "file_manager" "yazi")

    tmux rename-window -t "$session:1" "Workspace"

    # Main editor pane
    tmux send-keys -t "$session:1.1" "$editor ." C-m

    # File manager (right)
    tmux split-window -h -c "$dir"
    tmux send-keys "$file_manager" C-m

    # Shell (bottom)
    tmux split-window -v -c "$dir"
    tmux send-keys "clear" C-m

    # Layout
    tmux select-layout main-vertical
    tmux select-pane -t "$session:1.1"
}
