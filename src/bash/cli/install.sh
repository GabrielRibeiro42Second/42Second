#!/usr/bin/env bash

###########################################################
#
# install.sh
#
# Instala dependências do TermOS.
#
# Uso:
#
#   termos install
#
###########################################################

install::_detect_pm() {
    if command -v pacman &>/dev/null; then
        echo "pacman"
    elif command -v apt &>/dev/null; then
        echo "apt"
    elif command -v dnf &>/dev/null; then
        echo "dnf"
    else
        echo "unknown"
    fi
}

install::_pacman() {
    local pkgs=(fzf zoxide fd yazi lazygit glow btop neovim)

    echo "  Installing with pacman..."
    sudo pacman -S --needed --noconfirm "${pkgs[@]}"
}

install::_apt() {
    local pkgs=(fzf fd-find neovim btop)

    echo "  Installing with apt..."
    sudo apt update && sudo apt install -y "${pkgs[@]}"
}

install::_dnf() {
    local pkgs=(fzf fd-find neovim btop)

    echo "  Installing with dnf..."
    sudo dnf install -y "${pkgs[@]}"
}

install::run() {
    local pm
    pm=$(install::_detect_pm)

    echo ""
    echo "  TermOS Installer"
    echo "  ────────────────"
    echo ""
    echo "  Package manager: $pm"
    echo ""

    case "$pm" in
        pacman) install::_pacman ;;
        apt)    install::_apt ;;
        dnf)    install::_dnf ;;
        *)
            echo "  Unsupported package manager: $pm"
            echo "  Please install manually: fzf zoxide fd yazi lazygit glow btop neovim"
            return 1
            ;;
    esac

    echo ""
    echo "  \033[0;32m✔  Done!\033[0m"
    echo "  Run 'termos doctor' to verify."
    echo ""
}
