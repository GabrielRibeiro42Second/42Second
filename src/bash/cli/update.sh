#!/usr/bin/env bash

###########################################################
#
# update.sh
#
# Recarrega a configuração do TermOS e o tema do tmux.
#
# Uso:
#
#   termos update
#
###########################################################

update::run() {
    printf '\n  TermOS Update\n  ─────────────\n\n'

    # Recarrega termos.conf em memória
    if config::load 2>/dev/null; then
        printf '  \033[0;32m✔\033[0m config recarregada (%d chaves)\n' "${#TERMOS_CONFIG[@]}"
    else
        printf '  \033[0;33m⚠\033[0m config padrão aplicada (termos.conf ausente)\n'
    fi

    # Recarrega o tema no servidor tmux ativo
    if tmux list-sessions &>/dev/null; then
        if tmux source-file "$TERMOS_CONFIG_DIR/tmux.conf" 2>/dev/null; then
            printf '  \033[0;32m✔\033[0m tema do tmux recarregado\n'
        else
            printf '  \033[0;33m⚠\033[0m não foi possível recarregar o tema\n'
        fi
    else
        printf '  \033[0;33m⚠\033[0m nenhum servidor tmux ativo, tema não recarregado\n'
    fi

    printf '\n  \033[0;32m✔  Update complete\033[0m\n\n'
}
