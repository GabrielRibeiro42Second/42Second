#!/usr/bin/env bash

###########################################################
#
# events.sh
#
# Sistema de eventos do TermOS.
# Permite que plugins se inscrevam em eventos sem
# modificar o core.
#
# API:
#
#   events::emit "evento" "args..."
#   events::on "evento" "callback"
#   events::list
#
###########################################################

declare -A _EVENTS_HANDLERS=()

events::emit() {
    local event="$1"
    shift

    logger::debug "Evento disparado: $event"

    local handlers="${_EVENTS_HANDLERS[$event]:-}"

    if [[ -z "$handlers" ]]; then
        return 0
    fi

    local IFS='|'
    for handler in $handlers; do
        logger::debug "Executando handler: $handler"
        if [[ -x "$handler" ]]; then
            "$handler" "$@" || logger::warn "Handler falhou: $handler"
        elif declare -f "$handler" >/dev/null 2>&1; then
            "$handler" "$@" || logger::warn "Handler falhou: $handler"
        else
            logger::warn "Handler não encontrado ou não executável: $handler"
        fi
    done
}

events::on() {
    local event="$1"
    local handler="$2"

    if [[ -z "${_EVENTS_HANDLERS[$event]:-}" ]]; then
        _EVENTS_HANDLERS["$event"]="$handler"
    else
        _EVENTS_HANDLERS["$event"]="${_EVENTS_HANDLERS[$event]}|$handler"
    fi

    logger::debug "Handler registrado: $event -> $handler"
}

events::list() {
    local event
    for event in "${!_EVENTS_HANDLERS[@]}"; do
        echo "$event: ${_EVENTS_HANDLERS[$event]}"
    done
}
