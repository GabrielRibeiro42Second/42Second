#!/usr/bin/env bash

###########################################################
#
# filesystem.sh
#
# Utilitários de sistema de arquivos.
#
# API:
#
#   filesystem::find_projects "root"...
#   filesystem::project_exists "path"
#   filesystem::is_git_repo "path"
#   filesystem::has_file "dir" "file"
#   filesystem::file_exists "path"
#   filesystem::find_file "dir" "nome"...
#
###########################################################

# Diretórios que nunca devem virar candidatos a workspace.
# `.*` cobre qualquer pasta oculta (.git, .venv, .config, ...).
_filesystem_prune_dirs=(
    ".*"
    node_modules venv __pycache__
    target dist build out
)

filesystem::find_projects() {
    local roots=("$@")
    local max_depth
    max_depth=$(config::get "max_depth" "2")

    [[ "$max_depth" =~ ^[0-9]+$ ]] || max_depth=2

    local root prune
    local prune_args=()

    for prune in "${_filesystem_prune_dirs[@]}"; do
        if [[ ${#prune_args[@]} -gt 0 ]]; then
            prune_args+=(-o)
        fi
        prune_args+=(-name "$prune")
    done

    for root in "${roots[@]}"; do
        [[ -d "$root" ]] || continue

        # Mantém o caminho como escrito na configuração para que
        # nomes de sessão reflitam o que o usuário configurou.
        find "$root" \
            -mindepth 1 \
            -maxdepth "$max_depth" \
            \( "${prune_args[@]}" \) -prune \
            -o -type d -print \
            2>/dev/null
    done | sort -u
}

filesystem::project_exists() {
    [[ -d "$1" ]]
}

filesystem::is_git_repo() {
    local dir="$1"
    [[ -d "$dir/.git" || -f "$dir/.git" ]]
}

filesystem::has_file() {
    local dir="$1"
    local file="$2"
    [[ -f "$dir/$file" ]]
}

filesystem::file_exists() {
    [[ -f "$1" ]]
}

filesystem::find_file() {
    local dir="$1"
    shift

    local file
    for file in "$@"; do
        if [[ -f "$dir/$file" ]]; then
            printf '%s\n' "$dir/$file"
            return 0
        fi
    done

    return 1
}
