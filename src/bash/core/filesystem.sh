#!/usr/bin/env bash

###########################################################
#
# filesystem.sh
#
# Utilitários de sistema de arquivos.
#
# API:
#
#   filesystem::find_projects
#   filesystem::project_exists "path"
#   filesystem::is_git_repo "path"
#   filesystem::has_file "dir" "file"
#   filesystem::file_exists "path"
#
###########################################################

filesystem::find_projects() {
    local roots=("$@")
    local max_depth
    max_depth=$(config::get "max_depth" "2")

    for root in "${roots[@]}"; do
        # Resolve symlinks
        root=$(readlink -f "$root" 2>/dev/null || echo "$root")
        [[ -d "$root" ]] || continue

        find "$root" \
            -mindepth 1 \
            -maxdepth "$max_depth" \
            -type d \
            2>/dev/null
    done | sort -u
}

filesystem::project_exists() {
    local path="$1"
    [[ -d "$path" ]]
}

filesystem::is_git_repo() {
    local dir="$1"
    [[ -d "$dir/.git" ]]
}

filesystem::has_file() {
    local dir="$1"
    local file="$2"
    [[ -f "$dir/$file" ]]
}

filesystem::file_exists() {
    local path="$1"
    [[ -f "$path" ]]
}

filesystem::find_file() {
    local dir="$1"
    shift
    local files=("$@")

    for file in "${files[@]}"; do
        if [[ -f "$dir/$file" ]]; then
            echo "$dir/$file"
            return 0
        fi
    done

    return 1
}
