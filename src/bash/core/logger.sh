#!/usr/bin/env bash

###########################################################
#
# logger.sh
#
# Sistema de logs do TermOS.
#
# API:
#
#   logger::info  "mensagem"
#   logger::warn  "mensagem"
#   logger::error "mensagem"
#   logger::debug "mensagem"
#
# Habilitar com: export TERMOS_DEBUG=1
#
###########################################################

LOGGER_LEVELS=("DEBUG" "INFO" "WARN" "ERROR")
LOGGER_COLORS=(
    "\033[0;37m"   # DEBUG  - cinza
    "\033[0;32m"   # INFO   - verde
    "\033[0;33m"   # WARN   - amarelo
    "\033[0;31m"   # ERROR  - vermelho
)
LOGGER_RESET="\033[0m"

_logger::_level_index() {
    local level="$1"
    local i=0
    for l in "${LOGGER_LEVELS[@]}"; do
        [[ "$l" == "$level" ]] && echo "$i" && return
        ((i++))
    done
    echo "0"
}

_logger::_should_log() {
    local level="$1"
    local min_level="${TERMOS_LOG_LEVEL:-INFO}"

    if [[ "${TERMOS_DEBUG:-0}" == "1" ]]; then
        min_level="DEBUG"
    fi

    local current
    current=$(_logger::_level_index "$min_level")
    local target
    target=$(_logger::_level_index "$level")

    [[ "$target" -ge "$current" ]]
}

logger::_emit() {
    local level="$1"
    shift
    local msg="$*"

    _logger::_should_log "$level" || return 0

    local idx
    idx=$(_logger::_level_index "$level")
    local color="${LOGGER_COLORS[$idx]}"
    local timestamp
    timestamp=$(date '+%H:%M:%S')

    printf "${color}[%s] [%-5s] %s${LOGGER_RESET}\n" \
        "$timestamp" "$level" "$msg" >&2
}

logger::info()  { logger::_emit "INFO"  "$@"; }
logger::warn()  { logger::_emit "WARN"  "$@"; }
logger::error() { logger::_emit "ERROR" "$@"; }
logger::debug() { logger::_emit "DEBUG" "$@"; }
