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

# Determina o diretório raiz do TermOS
if [[ -n "${TERMOS_HOME:-}" ]]; then
    _TERMOS_ROOT="$TERMOS_HOME"
else
    _TERMOS_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../../" &>/dev/null && pwd)"
fi

# Exporta caminhos padronizados
export TERMOS_HOME="$_TERMOS_ROOT"
export TERMOS_SRC="$_TERMOS_ROOT/src"
export TERMOS_CORE="$_TERMOS_ROOT/src/core"
export TERMOS_CONFIG_DIR="$_TERMOS_ROOT/config"
export TERMOS_LAYOUTS_DIR="$_TERMOS_ROOT/src/layouts"
export TERMOS_PLUGINS_DIR="$_TERMOS_ROOT/src/plugins"
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
