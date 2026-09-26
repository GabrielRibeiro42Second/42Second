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
#   config::get "CHAVE" ["PADRÃO"]
#   config::set "CHAVE" "VALOR"
#
###########################################################

declare -A TERMOS_CONFIG=()

_config::trim() {
    local s="$1"
    s="${s#"${s%%[![:space:]]*}"}"
    s="${s%"${s##*[![:space:]]}"}"
    printf '%s' "$s"
}

# Expande apenas `~`, `$VAR` e `${VAR}` de variáveis já
# definidas no ambiente. Nada de `eval`: um valor malicioso
# em termos.conf nunca é executado.
_config::expand() {
    local value="$1"
    local guard=0
    local name replacement

    case "$value" in
        "~")   value="$HOME" ;;
        "~/"*) value="$HOME/${value#~/}" ;;
    esac

    while ((guard++ < 32)); do
        if [[ "$value" =~ \$\{([A-Za-z_][A-Za-z0-9_]*)\} ]]; then
            name="${BASH_REMATCH[1]}"
            replacement=""
            [[ -v "$name" ]] && replacement="${!name}"
            value="${value//\$\{$name\}/$replacement}"
            continue
        fi

        if [[ "$value" =~ \$([A-Za-z_][A-Za-z0-9_]*) ]]; then
            name="${BASH_REMATCH[1]}"
            replacement=""
            [[ -v "$name" ]] && replacement="${!name}"
            value="${value//\$$name/$replacement}"
            continue
        fi

        break
    done

    printf '%s' "$value"
}

config::load() {
    local config_file="${TERMOS_CONFIG_FILE:-}"

    if [[ -z "$config_file" ]]; then
        config_file="$TERMOS_CONFIG_DIR/termos.conf"
    fi

    if [[ ! -f "$config_file" ]]; then
        logger::warn "Arquivo de configuração não encontrado: $config_file"
        _config::apply_defaults
        return 1
    fi

    logger::debug "Carregando configuração: $config_file"

    local key value
    while IFS='=' read -r key value || [[ -n "$key" ]]; do
        key=$(_config::trim "$key")
        value=$(_config::trim "${value:-}")

        [[ "$key" =~ ^[A-Za-z_][A-Za-z0-9_]*$ ]] || continue
        [[ -z "$value" ]] && continue

        TERMOS_CONFIG["$key"]=$(_config::expand "$value")
    done < "$config_file"

    _config::apply_defaults

    logger::debug "Configuração carregada: ${#TERMOS_CONFIG[@]} chaves"
}

config::get() {
    local key="$1"
    local default="${2:-}"

    printf '%s' "${TERMOS_CONFIG[$key]:-$default}"
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
    [[ -z "${TERMOS_CONFIG[default_layout]:-}" ]] && TERMOS_CONFIG[default_layout]="main-vertical"
    return 0
}
