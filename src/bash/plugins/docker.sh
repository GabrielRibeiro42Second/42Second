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
    filesystem::has_file "$dir" "compose.yml" || \
    filesystem::has_file "$dir" "compose.yaml" || \
        return 0

    tmux new-window -t "$session" -n "Docker" -c "$dir"
    tmux send-keys -t "$session:Docker" "docker compose logs -f" C-m

    logger::debug "Plugin Docker ativado para $session"
}
