#!/usr/bin/env bash

###########################################################
#
# tasks.sh
#
# Plugin: abre arquivo de tarefas (TODO.md) se existir.
#
###########################################################

plugin::tasks() {
    local session="$1"
    local dir="$2"

    local task_file
    task_file=$(filesystem::find_file "$dir" "TODO.md" "todo.md" "TASKS.md" "tasks.md") || return 0

    local editor
    editor=$(config::get "editor" "nvim")

    tmux new-window -t "$session" -n "Tasks" -c "$dir"
    tmux send-keys -t "$session:Tasks" "$editor $task_file" C-m

    logger::debug "Plugin Tasks ativado para $session"
}
