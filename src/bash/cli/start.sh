#!/usr/bin/env bash

###########################################################
#
# start.sh
#
# Abre (ou conecta) um workspace para um diretório específico.
# É a porta de entrada usada pelo dashboard em TUI.
#
# Uso:
#
#   termos start <diretorio>
#
###########################################################

start::run() {
    if [[ -z "${TERMOS_WORKSPACE_LOADED:-}" ]]; then
        # shellcheck source=/dev/null
        source "$TERMOS_SRC/workspace/workspace.sh"
    fi

    launcher::start "${1:-}"
}
