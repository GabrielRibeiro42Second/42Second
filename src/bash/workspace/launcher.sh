#!/usr/bin/env bash

###########################################################
#
# launcher.sh
#
# Interface principal do TermOS.
# Abre o fzf para seleção de workspace.
#
# Uso:
#
#   launcher::open
#
###########################################################

launcher::open() {
    logger::debug "Launcher iniciado"

    if ! command -v fzf &>/dev/null; then
        logger::error "fzf não encontrado. Rode 'termos install'."
        return 1
    fi

    local project_roots_str
    project_roots_str=$(config::get "project_roots" "$HOME/Projetos")

    local roots=()
    IFS=',' read -ra roots <<< "$project_roots_str"

    local projects
    projects=$(filesystem::find_projects "${roots[@]}")

    if [[ -z "$projects" ]]; then
        logger::warn "Nenhum projeto encontrado em: $project_roots_str"
        return 0
    fi

    local selected
    # `|| true`: cancelar o fzf (Esc/Ctrl-C) é um resultado
    # normal, não um erro — sem isto o CLI morria em silêncio.
    selected=$(printf '%s\n' "$projects" | \
        fzf \
            --layout=reverse \
            --border=rounded \
            --height=100% \
            --prompt="Workspace > " \
            --header="$(printf '%s' "$projects" | wc -l | tr -d ' ') projetos | Enter abrir | Esc cancelar" \
            --preview="ls -la {}" \
            2>/dev/null) || true

    if [[ -z "${selected:-}" ]]; then
        logger::debug "Nenhum projeto selecionado"
        return 0
    fi

    local session
    session=$(session::name_from_path "$selected")

    if session::exists "$session"; then
        logger::info "Conectando à sessão existente: $session"
        session::switch "$session" || return 0
        return 0
    fi

    logger::info "Criando novo workspace: $session"
    builder::build "$session" "$selected"
    session::switch "$session" || return 0
}

# Abre um workspace direto, sem passar pelo fzf.
# Usado pelo dashboard (`termos start <dir>`).
launcher::start() {
    local dir="${1:-}"

    if [[ -z "$dir" ]]; then
        logger::error "Uso: termos start <diretorio>"
        return 1
    fi

    if [[ ! -d "$dir" ]]; then
        logger::error "Diretório inexistente: $dir"
        return 1
    fi

    local session
    session=$(session::name_from_path "$dir")

    if session::exists "$session"; then
        logger::info "Conectando à sessão existente: $session"
        session::switch "$session" || return 0
        return 0
    fi

    logger::info "Criando novo workspace: $session"
    builder::build "$session" "$dir"
    session::switch "$session" || return 0
}
