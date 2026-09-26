#!/usr/bin/env bash

###########################################################
#
# readme.sh
#
# Plugin: abre o README com glow se existir.
#
###########################################################

plugin::readme() {
    local session="$1"
    local dir="$2"

    local readme_file pane
    readme_file=$(filesystem::find_file "$dir" "README.md" "README.org" "README.rst" "README") || return 0

    command -v glow &>/dev/null || {
        logger::debug "Plugin README ignorado: glow ausente"
        return 0
    }

    pane=$(tmux::new_window "$session" "README" "$dir") || return 0
    tmux::run "$pane" "glow \"$readme_file\""

    logger::debug "Plugin README ativado para $session"
}
