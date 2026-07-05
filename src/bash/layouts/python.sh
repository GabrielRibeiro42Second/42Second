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
# Ativa venv automaticamente se existir.
#
###########################################################

layout::python() {
    local session="$1"
    local dir="$2"
    local editor
    editor=$(config::get "editor" "nvim")
    local git_ui
    git_ui=$(config::get "git_ui" "lazygit")

    tmux rename-window -t "$session:1" "Python"

    # Main editor pane
    tmux send-keys -t "$session:1.1" "$editor ." C-m

    # Git UI (right)
    tmux split-window -h -c "$dir"
    tmux send-keys "$git_ui" C-m

    # Shell with venv activation (bottom)
    tmux split-window -v -c "$dir"
    if [[ -d "$dir/.venv" || -d "$dir/venv" ]]; then
        local venv_path=".venv"
        [[ -d "$dir/venv" ]] && venv_path="venv"
        tmux send-keys "source $venv_path/bin/activate && clear" C-m
    else
        tmux send-keys "clear" C-m
    fi

    tmux select-layout main-vertical
    tmux select-pane -t "$session:1.1"
}
