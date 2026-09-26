#!/usr/bin/env bash

###########################################################
#
# tasks.sh
#
# Plugin: abre o arquivo de tarefas (TODO.md) se existir.
#
###########################################################

plugin::tasks() {
    local session="$1"
    local dir="$2"

    local task_file editor pane
    task_file=$(filesystem::find_file "$dir" "TODO.md" "todo.md" "TASKS.md" "tasks.md") || return 0

    editor=$(config::get "editor" "nvim")

    pane=$(tmux::new_window "$session" "Tasks" "$dir") || return 0
    tmux::run "$pane" "$editor \"$task_file\""

    logger::debug "Plugin Tasks ativado para $session"
}
