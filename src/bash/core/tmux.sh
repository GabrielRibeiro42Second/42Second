#!/usr/bin/env bash

###########################################################
#
# tmux.sh
#
# Utilitários para operações avançadas no tmux.
#
# API:
#
#   tmux::new_window "session" "name" "dir"
#   tmux::send_keys "target" "keys"
#   tmux::split_h "session" "dir"
#   tmux::split_v "session" "dir"
#   tmux::rename_window "session" "name"
#   tmux::select_layout "session" "layout"
#   tmux::select_pane "session" "target"
#   tmux::version
#
###########################################################

tmux::new_window() {
    local session="$1"
    local name="$2"
    local dir="$3"

    tmux new-window -t "$session" -n "$name" -c "$dir"
}

tmux::send_keys() {
    local target="$1"
    shift
    local keys="$*"

    tmux send-keys -t "$target" "$keys" C-m
}

tmux::split_h() {
    local session="$1"
    local dir="$2"

    tmux split-window -h -c "$dir"
}

tmux::split_v() {
    local session="$1"
    local dir="$2"

    tmux split-window -v -c "$dir"
}

tmux::rename_window() {
    local session="$1"
    local name="$2"

    tmux rename-window -t "$session:1" "$name"
}

tmux::select_layout() {
    local session="$1"
    local layout="$2"

    tmux select-layout -t "$session" "$layout"
}

tmux::select_pane() {
    local session="$1"
    local target="$2"

    tmux select-pane -t "$session:$target"
}

tmux::version() {
    tmux -V | awk '{print $2}'
}
