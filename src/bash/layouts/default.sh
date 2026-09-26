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
# API: layout::<tipo> "session" "dir"
#
###########################################################

layout::default() {
    local session="$1"
    local dir="$2"

    local editor file_manager
    editor=$(config::get "editor" "nvim")
    file_manager=$(config::get "file_manager" "yazi")

    local window root
    window=$(tmux::first_window "$session") || return 1
    root=$(tmux::active_pane "$session" "$window") || return 1

    tmux rename-window -t "$session:$window" "Workspace"
    tmux::focus "$root"
    tmux::run "$root" "$editor ."

    local side
    side=$(tmux::split_h "$root" "$dir") || return 1
    tmux::run "$side" "$file_manager"

    local shell
    shell=$(tmux::split_v "$side" "$dir") || return 1
    tmux::run "$shell" "clear"

    tmux::select_layout "$session" "$window" "main-horizontal" "60%"
    tmux::focus "$root"
}
