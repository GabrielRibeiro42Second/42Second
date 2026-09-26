#!/usr/bin/env bash

###########################################################
#
# bootstrap.sh
#
# Ponto de entrada de todos os scripts do TermOS.
# Carrega configuração, bibliotecas e prepara o ambiente.
#
# Uso:
#
#   source "$SCRIPT_DIR/../core/bootstrap.sh"
#
###########################################################

set -Eeuo pipefail

# Resolve a raiz do TermOS a partir da localização deste arquivo.
_bootstrap_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
_bootstrap_candidate="$(cd -- "$_bootstrap_dir/../../.." &>/dev/null && pwd)"

_termos_is_root() {
    [[ -n "${1:-}" && -f "$1/src/bash/core/logger.sh" ]]
}

# Retorna a primeira raiz válida entre os candidatos.
_termos_resolve_root() {
    local candidate
    for candidate in "${TERMOS_HOME:-}" "$_bootstrap_candidate"; do
        if _termos_is_root "$candidate"; then
            printf '%s\n' "$(cd -- "$candidate" && pwd)"
            return 0
        fi
    done
    return 1
}

if ! _TERMOS_ROOT="$(_termos_resolve_root)"; then
    printf 'termos: bootstrap: cannot locate installation root\n' >&2
    printf '  TERMOS_HOME=%s\n' "${TERMOS_HOME:-<unset>}" >&2
    printf '  searched: %s\n' "$_bootstrap_candidate" >&2
    return 1 2>/dev/null || exit 1
fi

# Exporta caminhos padronizados
export TERMOS_HOME="$_TERMOS_ROOT"
export TERMOS_SRC="$_TERMOS_ROOT/src/bash"
export TERMOS_CORE="$_TERMOS_ROOT/src/bash/core"
export TERMOS_LUA="$_TERMOS_ROOT/src/lua"
export TERMOS_CONFIG_DIR="$_TERMOS_ROOT/config"
export TERMOS_LAYOUTS_DIR="$_TERMOS_ROOT/src/bash/layouts"
export TERMOS_PLUGINS_DIR="$_TERMOS_ROOT/src/bash/plugins"
export TERMOS_BIN="$_TERMOS_ROOT/bin"

# Carrega core (ordem importa)
source "$TERMOS_CORE/logger.sh"
source "$TERMOS_CORE/config.sh"
source "$TERMOS_CORE/filesystem.sh"
source "$TERMOS_CORE/session.sh"
source "$TERMOS_CORE/tmux.sh"
source "$TERMOS_CORE/events.sh"

# Carrega configuração
config::load 2>/dev/null || true

logger::debug "TermOS bootstrapped desde: $TERMOS_HOME"
