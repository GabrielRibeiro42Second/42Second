#!/usr/bin/env bash

###########################################################
#
# dashboard.sh
#
# Abre o dashboard em TUI (Bubble Tea).
#
# Uso:
#
#   termos dashboard
#
###########################################################

dashboard::run() {
    local binary="$TERMOS_BIN/termos-tui"

    if [[ ! -x "$binary" ]]; then
        printf '\n  \033[0;33m⚠  Dashboard não compilado.\033[0m\n\n'
        printf '  Compile uma vez:\n'
        printf '    make build\n\n'
        printf '  Alternativa sem TUI:\n'
        printf '    termos open\n\n'
        return 1
    fi

    exec "$binary" "$@"
}
