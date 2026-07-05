#!/usr/bin/env bash

###########################################################
#
# readme.sh
#
# Plugin: abre README com glow se existir.
#
# Dependência: sudo pacman -S glow
#
###########################################################

plugin::readme() {
    local session="$1"
    local dir="$2"

    local readme_file
    readme_file=$(filesystem::find_file "$dir" "README.md" "README.org" "README.rst" "README") || return 0

    tmux new-window -t "$session" -n "README" -c "$dir"
    tmux send-keys -t "$session:README" "glow $readme_file" C-m

    logger::debug "Plugin README ativado para $session"
}
