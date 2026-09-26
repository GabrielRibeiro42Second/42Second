#!/usr/bin/env bash

###########################################################
#
# git.sh
#
# Plugin: abre o Git UI se o projeto for um repositório.
#
###########################################################

plugin::git() {
    local session="$1"
    local dir="$2"

    filesystem::is_git_repo "$dir" || return 0

    local git_ui pane
    git_ui=$(config::get "git_ui" "lazygit")

    pane=$(tmux::new_window "$session" "Git" "$dir") || return 0
    tmux::run "$pane" "$git_ui"

    logger::debug "Plugin Git ativado para $session"
}
