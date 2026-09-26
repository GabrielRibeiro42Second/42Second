#!/usr/bin/env bash

###########################################################
#
# open.sh
#
# Abre o workspace launcher (fzf).
#
# Uso:
#
#   termos open
#
###########################################################

open::run() {
    if [[ -z "${TERMOS_WORKSPACE_LOADED:-}" ]]; then
        # shellcheck source=/dev/null
        source "$TERMOS_SRC/workspace/workspace.sh"
    fi
    workspace::open
}
