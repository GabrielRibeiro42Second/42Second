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

doctor::_check() {
    local cmd="$1"
    local name="${2:-$1}"

    if command -v "$cmd" &>/dev/null; then
        printf "  \033[0;32m✔\033[0m %s\n" "$name"
        return 0
    else
        printf "  \033[0;31m✘\033[0m %s\n" "$name"
        return 1
    fi
}

doctor::_check_tmux_version() {
    local version
    version=$(tmux -V | grep -oP '[\d.]+')
    local major minor
    major=$(echo "$version" | cut -d. -f1)
    minor=$(echo "$version" | cut -d. -f2)

    if [[ "$major" -ge 3 && "$minor" -ge 2 ]]; then
        printf "  \033[0;32m✔\033[0m tmux %s (popup support)\n" "$version"
    else
        printf "  \033[0;33m⚠\033[0m tmux %s (popup requires 3.2+)\n" "$version"
    fi
}

doctor::run() {
    local errors=0

    echo ""
    echo "  TermOS Doctor"
    echo "  ─────────────"
    echo ""

    echo "  Core:"
    doctor::_check "tmux"  "tmux"  || ((errors++))
    doctor::_check_tmux_version
    doctor::_check "fzf"   "fzf"   || ((errors++))
    echo ""

    echo "  Recommended:"
    doctor::_check "nvim"     "Neovim"
    doctor::_check "zoxide"   "Zoxide"
    doctor::_check "yazi"     "Yazi"
    doctor::_check "lazygit"  "LazyGit"
    doctor::_check "glow"     "Glow"
    doctor::_check "btop"     "btop"
    echo ""

    echo "  Shell:"
    doctor::_check "zsh" "Zsh"
    echo ""

    if [[ "$errors" -gt 0 ]]; then
        echo "  \033[0;33m⚠  $errors required dependencies missing\033[0m"
    else
        echo "  \033[0;32m✔  All good!\033[0m"
    fi

    echo ""
}
