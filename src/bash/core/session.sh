#!/usr/bin/env bash

###########################################################
#
# session.sh
#
# Gerenciamento de sessões do tmux.
#
# API:
#
#   session::exists "name"
#   session::create "name" "dir"
#   session::switch "name"
#   session::kill "name"
#   session::name_from_path "path"
#   session::list
#
###########################################################

session::exists() {
    local name="$1"
    tmux has-session -t "$name" 2>/dev/null
}

session::create() {
    local name="$1"
    local dir="$2"

    if session::exists "$name"; then
        logger::debug "Sessão já existe: $name"
        return 0
    fi

    logger::info "Criando sessão: $name em $dir"
    tmux new-session -d -s "$name" -c "$dir"
}

session::switch() {
    local name="$1"

    if ! session::exists "$name"; then
        logger::error "Sessão não existe: $name"
        return 1
    fi

    tmux switch-client -t "$name"
}

session::kill() {
    local name="$1"

    if ! session::exists "$name"; then
        logger::warn "Sessão não existe: $name"
        return 0
    fi

    logger::info "Encerrando sessão: $name"
    tmux kill-session -t "$name"
}

session::name_from_path() {
    local path="$1"
    basename "$path" | tr ' .-' '___'
}

session::list() {
    tmux list-sessions -F '#{session_name}' 2>/dev/null
}
