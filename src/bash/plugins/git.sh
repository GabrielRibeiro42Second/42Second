#!/usr/bin/env bash

###########################################################
#
# git.sh
#
# Plugin: abre LazyGit se o projeto for um repositório Git.
#
###########################################################

plugin::git() {
    local session="$1"
    local dir="$2"

    filesystem::is_git_repo "$dir" || return 0

    local git_ui
    git_ui=$(config::get "git_ui" "lazygit")

    tmux new-window -t "$session" -n "Git" -c "$dir"
    tmux send-keys -t "$session:Git" "$git_ui" C-m

    logger::debug "Plugin Git ativado para $session"
}
