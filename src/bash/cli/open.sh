#!/usr/bin/env bash

###########################################################
#
# open.sh
#
# Abre o workspace launcher via popup.
#
# Uso:
#
#   termos open
#
###########################################################

open::run() {
    source "$TERMOS_SRC/workspace/workspace.sh"
    workspace::open
}
