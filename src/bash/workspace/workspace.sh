#!/usr/bin/env bash

###########################################################
#
# workspace.sh
#
# API pública do Workspace Engine.
#
# Uso:
#
#   workspace::open
#   workspace::start "dir"
#   workspace::create "name" "dir"
#   workspace::list
#   workspace::kill "name"
#
###########################################################

if [[ -z "${TERMOS_WORKSPACE_LOADED:-}" ]]; then
    declare -g TERMOS_WORKSPACE_LOADED=1

    TERMOS_WORKSPACE_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

    # bootstrap já deve ter sido carregado por bin/termos
    # shellcheck source=/dev/null
    source "$TERMOS_WORKSPACE_DIR/detector.sh"
    # shellcheck source=/dev/null
    source "$TERMOS_WORKSPACE_DIR/builder.sh"
    # shellcheck source=/dev/null
    source "$TERMOS_WORKSPACE_DIR/launcher.sh"
fi

workspace::open() {
    launcher::open
}

workspace::start() {
    launcher::start "${1:-}"
}

workspace::create() {
    local name="$1"
    local dir="$2"
    builder::build "$name" "$dir"
}

workspace::list() {
    session::list
}

workspace::kill() {
    local name="$1"
    session::kill "$name"
}
