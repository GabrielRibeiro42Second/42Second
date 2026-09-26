#!/usr/bin/env bash

###########################################################
#
# java.sh
#
# Layout para projetos Java
#
# ┌──────────────────────────────┐
# │            Editor            │
# ├──────────────┬───────────────┤
# │   LazyGit    │    Shell      │
# └──────────────┴───────────────┘
#
# API: layout::java "session" "dir"
#
###########################################################

layout::java() {
    local session="$1"
    local dir="$2"

    local editor git_ui
    editor=$(config::get "editor" "nvim")
    git_ui=$(config::get "git_ui" "lazygit")

    local window root
    window=$(tmux::first_window "$session") || return 1
    root=$(tmux::active_pane "$session" "$window") || return 1

    tmux rename-window -t "$session:$window" "Java"
    tmux::focus "$root"
    tmux::run "$root" "$editor ."

    local side
    side=$(tmux::split_h "$root" "$dir") || return 1
    tmux::run "$side" "$git_ui"

    local shell
    shell=$(tmux::split_v "$side" "$dir") || return 1
    tmux::run "$shell" "clear"

    tmux::select_layout "$session" "$window" "main-horizontal" "60%"
    tmux::focus "$root"
}
