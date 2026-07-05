#!/usr/bin/env bash

###########################################################
#
# update.sh
#
# Atualiza as configurações do TermOS.
#
# Uso:
#
#   termos update
#
###########################################################

update::run() {
    echo ""
    echo "  TermOS Update"
    echo "  ─────────────"
    echo ""

    # Reload tmux config
    if tmux list-sessions &>/dev/null; then
        tmux source-file "$TERMOS_CONFIG_DIR/tmux.conf" 2>/dev/null && \
            echo "  \033[0;32m✔\033[0m tmux config reloaded" || \
            echo "  \033[0;33m⚠\033[0m Could not reload tmux (no session active?)"
    else
        echo "  \033[0;33m⚠\033[0m No tmux session active, skipping reload"
    fi

    echo ""
    echo "  \033[0;32m✔  Update complete\033[0m"
    echo ""
}
