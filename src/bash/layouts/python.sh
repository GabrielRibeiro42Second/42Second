#!/usr/bin/env bash

###########################################################
#
# python.sh
#
# Layout para projetos Python
#
# ┌──────────────────────────────┐
# │            Editor            │
# ├──────────────┬───────────────┤
# │   LazyGit    │    Shell      │
# └──────────────┴───────────────┘
#
# Ativa o venv automaticamente se existir.
#
# API: layout::python "session" "dir"
#
###########################################################

layout::python() {
    local session="$1"
    local dir="$2"

    local editor git_ui
    editor=$(config::get "editor" "nvim")
    git_ui=$(config::get "git_ui" "lazygit")

    local window root
    window=$(tmux::first_window "$session") || return 1
    root=$(tmux::active_pane "$session" "$window") || return 1

    tmux rename-window -t "$session:$window" "Python"
    tmux::focus "$root"
    tmux::run "$root" "$editor ."

    local side
    side=$(tmux::split_h "$root" "$dir") || return 1
    tmux::run "$side" "$git_ui"

    local shell venv_cmd
    shell=$(tmux::split_v "$side" "$dir") || return 1

    venv_cmd="clear"
    if [[ -d "$dir/.venv" ]]; then
        venv_cmd="source .venv/bin/activate && clear"
    elif [[ -d "$dir/venv" ]]; then
        venv_cmd="source venv/bin/activate && clear"
    fi
    tmux::run "$shell" "$venv_cmd"

    tmux::select_layout "$session" "$window" "main-horizontal" "60%"
    tmux::focus "$root"
}
