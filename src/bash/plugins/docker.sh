#!/usr/bin/env bash

###########################################################
#
# docker.sh
#
# Plugin: abre janela de Docker se compose existir.
#
###########################################################

plugin::docker() {
    local session="$1"
    local dir="$2"

    filesystem::has_file "$dir" "docker-compose.yml" || \
    filesystem::has_file "$dir" "docker-compose.yaml" || \
    filesystem::has_file "$dir" "compose.yml" || \
    filesystem::has_file "$dir" "compose.yaml" || \
        return 0

    local pane
    pane=$(tmux::new_window "$session" "Docker" "$dir") || return 0
    tmux::run "$pane" "docker compose logs -f"

    logger::debug "Plugin Docker ativado para $session"
}
