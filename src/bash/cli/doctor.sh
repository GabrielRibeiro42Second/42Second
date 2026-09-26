#!/usr/bin/env bash

###########################################################
#
# doctor.sh
#
# Verifica se todas as dependências estão instaladas.
#
# Uso:
#
#   termos doctor
#
###########################################################

declare -g _DOCTOR_ERRORS=0
declare -g _DOCTOR_WARNINGS=0

doctor::_ok() {
    printf '  \033[0;32m✔\033[0m %s\n' "$1"
}

doctor::_fail() {
    printf '  \033[0;31m✘\033[0m %s\n' "$1"
}

doctor::_warn() {
    printf '  \033[0;33m⚠\033[0m %s\n' "$1"
}

# Uso: doctor::_check "comando" "nome"
# Retorna 1 se ausente (sem matar o script: o incremento
# acontece no caller com arithmetic sem pós-incremento).
doctor::_check() {
    local cmd="$1"
    local name="${2:-$1}"

    if command -v "$cmd" &>/dev/null; then
        doctor::_ok "$name"
        return 0
    fi

    doctor::_fail "$name"
    return 1
}

doctor::_check_optional() {
    local cmd="$1"
    local name="${2:-$1}"

    if command -v "$cmd" &>/dev/null; then
        doctor::_ok "$name"
    else
        doctor::_warn "$name (recomendado)"
        _DOCTOR_WARNINGS=$((_DOCTOR_WARNINGS + 1))
    fi
    return 0
}

doctor::_check_tmux_version() {
    local version major minor
    version=$(tmux::version)
    major="${version%%.*}"
    minor="${version#*.}"
    minor="${minor%%.*}"

    [[ "$major" =~ ^[0-9]+$ ]] || major=0
    [[ "$minor" =~ ^[0-9]+$ ]] || minor=0

    if ((major > 3)) || { ((major == 3)) && ((minor >= 2)); }; then
        doctor::_ok "tmux $version (popup support)"
    else
        doctor::_warn "tmux $version (popup requer 3.2+)"
        _DOCTOR_WARNINGS=$((_DOCTOR_WARNINGS + 1))
    fi
}

doctor::run() {
    _DOCTOR_ERRORS=0
    _DOCTOR_WARNINGS=0

    printf '\n  TermOS Doctor\n  ─────────────\n\n'

    printf '  Core:\n'
    doctor::_check "tmux" "tmux" || _DOCTOR_ERRORS=$((_DOCTOR_ERRORS + 1))
    if command -v tmux &>/dev/null; then
        doctor::_check_tmux_version
    fi
    doctor::_check "fzf" "fzf" || _DOCTOR_ERRORS=$((_DOCTOR_ERRORS + 1))
    printf '\n'

    printf '  Recommended:\n'
    doctor::_check_optional "nvim"     "Neovim"
    doctor::_check_optional "zoxide"   "Zoxide"
    doctor::_check_optional "yazi"     "Yazi"
    doctor::_check_optional "lazygit"  "LazyGit"
    doctor::_check_optional "glow"     "Glow"
    doctor::_check_optional "btop"     "btop"
    printf '\n'

    printf '  Shell:\n'
    doctor::_check_optional "zsh" "Zsh"
    printf '\n'

    printf '  Dashboard:\n'
    if [[ -x "$TERMOS_BIN/termos-tui" ]]; then
        doctor::_ok "termos-tui (bubbletea)"
    else
        doctor::_warn "termos-tui não compilado (make build)"
        _DOCTOR_WARNINGS=$((_DOCTOR_WARNINGS + 1))
    fi

    if command -v lua &>/dev/null || command -v lua5.4 &>/dev/null || command -v luajit &>/dev/null; then
        doctor::_ok "lua (termos report)"
    else
        doctor::_warn "lua ausente (termos report)"
        _DOCTOR_WARNINGS=$((_DOCTOR_WARNINGS + 1))
    fi
    printf '\n'

    if ((_DOCTOR_ERRORS > 0)); then
        printf '  \033[0;31m✘  %d dependência(s) obrigatória(s) ausente(s)\033[0m\n' "$_DOCTOR_ERRORS"
        printf '  \033[0;33m⚠  %d recomendação(ões)\033[0m\n' "$_DOCTOR_WARNINGS"
        printf '\n'
        return 1
    fi

    if ((_DOCTOR_WARNINGS > 0)); then
        printf '  \033[0;33m⚠  Tudo funcional, %d recomendação(ões) pendente(s)\033[0m\n' "$_DOCTOR_WARNINGS"
    else
        printf '  \033[0;32m✔  All good!\033[0m\n'
    fi
    printf '\n'

    return 0
}
