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
#   workspace::create "name" "dir"
#   workspace::list
#   workspace::kill "name"
#
###########################################################

TERMOS_WORKSPACE_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

# bootstrap já deve ter sido carregado por bin/termos
source "$TERMOS_WORKSPACE_DIR/detector.sh"
source "$TERMOS_WORKSPACE_DIR/builder.sh"
source "$TERMOS_WORKSPACE_DIR/launcher.sh"

workspace::open() {
    launcher::open
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
