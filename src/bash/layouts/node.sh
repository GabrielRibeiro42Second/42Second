#!/usr/bin/env bash

###########################################################
#
# node.sh
#
# Layout para projetos Node.js
#
# ┌──────────────────────────────┐
# │            Editor            │
# ├──────────────┬───────────────┤
# │   LazyGit    │    Shell      │
# └──────────────┴───────────────┘
#
# Detecta e instala dependências se necessário.
#
###########################################################

layout::node() {
    local session="$1"
    local dir="$2"
    local editor
    editor=$(config::get "editor" "nvim")
    local git_ui
    git_ui=$(config::get "git_ui" "lazygit")

    tmux rename-window -t "$session:1" "Node"

    # Main editor pane
    tmux send-keys -t "$session:1.1" "$editor ." C-m

    # Git UI (right)
    tmux split-window -h -c "$dir"
    tmux send-keys "$git_ui" C-m

    # Shell (bottom)
    tmux split-window -v -c "$dir"
    tmux send-keys "clear" C-m

    tmux select-layout main-vertical
    tmux select-pane -t "$session:1.1"
}
