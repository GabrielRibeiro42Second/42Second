#!/usr/bin/env bash

###########################################################
#
# launcher.sh
#
# Interface principal do TermOS.
# Abre fzf para seleção de workspace.
#
# Uso:
#
#   launcher::open
#
###########################################################

launcher::open() {
    logger::debug "Launcher iniciado"

    local project_roots_str
    project_roots_str=$(config::get "project_roots" "$HOME/Projetos")

    IFS=',' read -ra roots <<< "$project_roots_str"

    local selected
    selected=$(filesystem::find_projects "${roots[@]}" | \
        fzf \
            --layout=reverse \
            --border=rounded \
            --height=100% \
            --prompt="Workspace > " \
            --header="Select a project to open" \
            --preview="ls -la {}" 2>/dev/null)

    if [[ -z "$selected" ]]; then
        logger::debug "Nenhum projeto selecionado"
        return 0
    fi

    local session
    session=$(session::name_from_path "$selected")

    if session::exists "$session"; then
        logger::info "Conectando à sessão existente: $session"
        session::switch "$session"
        return 0
    fi

    logger::info "Criando novo workspace: $session"
    builder::build "$session" "$selected"
    session::switch "$session"
}
