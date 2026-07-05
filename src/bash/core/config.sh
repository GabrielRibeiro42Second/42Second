#!/usr/bin/env bash

###########################################################
#
# config.sh
#
# Carrega e valida a configuração do TermOS.
#
# API:
#
#   config::load
#   config::get "CHAVE"
#   config::set "CHAVE" "VALOR"
#
###########################################################

declare -A TERMOS_CONFIG=()

config::load() {
    local config_file="${TERMOS_CONFIG_FILE:-}"

    if [[ -z "$config_file" ]]; then
        config_file="$TERMOS_CONFIG_DIR/termos.conf"
    fi

    if [[ ! -f "$config_file" ]]; then
        logger::warn "Arquivo de configuração não encontrado: $config_file"
        return 1
    fi

    logger::debug "Carregando configuração: $config_file"

    while IFS='=' read -r key value; do
        key=$(echo "$key" | xargs)
        value=$(echo "$value" | xargs)

        [[ -z "$key" ]] && continue
        [[ "$key" == \#* ]] && continue

        # Expand environment variables like $HOME
        value=$(eval echo "$value")

        TERMOS_CONFIG["$key"]="$value"
    done < "$config_file"

    _config::apply_defaults

    logger::debug "Configuração carregada: ${#TERMOS_CONFIG[@]} chaves"
}

config::get() {
    local key="$1"
    local default="${2:-}"

    echo "${TERMOS_CONFIG[$key]:-$default}"
}

config::set() {
    local key="$1"
    local value="$2"
    TERMOS_CONFIG["$key"]="$value"
}

_config::apply_defaults() {
    [[ -z "${TERMOS_CONFIG[editor]:-}" ]] && TERMOS_CONFIG[editor]="nvim"
    [[ -z "${TERMOS_CONFIG[file_manager]:-}" ]] && TERMOS_CONFIG[file_manager]="yazi"
    [[ -z "${TERMOS_CONFIG[git_ui]:-}" ]] && TERMOS_CONFIG[git_ui]="lazygit"
    [[ -z "${TERMOS_CONFIG[monitor]:-}" ]] && TERMOS_CONFIG[monitor]="btop"
    [[ -z "${TERMOS_CONFIG[shell]:-}" ]] && TERMOS_CONFIG[shell]="${SHELL:-/bin/zsh}"
    [[ -z "${TERMOS_CONFIG[popup_width]:-}" ]] && TERMOS_CONFIG[popup_width]="75%"
    [[ -z "${TERMOS_CONFIG[popup_height]:-}" ]] && TERMOS_CONFIG[popup_height]="75%"
    [[ -z "${TERMOS_CONFIG[max_depth]:-}" ]] && TERMOS_CONFIG[max_depth]="2"
}
