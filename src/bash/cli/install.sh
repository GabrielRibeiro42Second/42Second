#!/usr/bin/env bash

###########################################################
#
# install.sh
#
# Instala as dependências externas do TermOS.
#
# Uso:
#
#   termos install
#
###########################################################

# Pacotes obrigatórios: sem eles o TermOS não funciona.
install_required=(tmux fzf)

# Pacotes recomendados: melhoram a experiência.
install_recommended=(neovim zoxide yazi lazygit glow btop zsh fd)

install::_detect_pm() {
    if command -v pacman &>/dev/null; then
        printf 'pacman\n'
    elif command -v apt-get &>/dev/null; then
        printf 'apt\n'
    elif command -v dnf &>/dev/null; then
        printf 'dnf\n'
    elif command -v brew &>/dev/null; then
        printf 'brew\n'
    else
        printf 'unknown\n'
    fi
}

# Remove nomes de pacotes indisponíveis no gerenciador atual.
install::_available() {
    local pm="$1"
    shift
    local pkg

    for pkg in "$@"; do
        case "$pm:$pkg" in
            apt:zoxide|apt:yazi|apt:lazygit|apt:glow) continue ;;
            dnf:yazi|dnf:lazygit|dnf:glow) continue ;;
        esac
        printf '%s\n' "$pkg"
    done
}

install::_pacman() {
    local pkgs=("$@")
    printf '  Instalando com pacman...\n'
    sudo pacman -S --needed --noconfirm "${pkgs[@]}"
}

install::_apt() {
    local pkgs=("$@")
    printf '  Instalando com apt...\n'
    sudo apt-get update && sudo apt-get install -y "${pkgs[@]}"
}

install::_dnf() {
    local pkgs=("$@")
    printf '  Instalando com dnf...\n'
    sudo dnf install -y "${pkgs[@]}"
}

install::_brew() {
    local pkgs=("$@")
    printf '  Instalando com brew...\n'
    brew install "${pkgs[@]}"
}

install::_manual_hint() {
    local pm="$1"
    local pkg missing=()

    for pkg in zoxide yazi lazygit glow; do
        if ! install::_available "$pm" "$pkg" >/dev/null; then
            missing+=("$pkg")
        fi
    done

    [[ ${#missing[@]} -eq 0 ]] && return 0

    printf '\n  \033[0;33mInstale manualmente (fora do %s):\033[0m\n' "$pm"
    printf '    %s\n' "${missing[*]}"
}

install::run() {
    local pm
    pm=$(install::_detect_pm)

    printf '\n  TermOS Installer\n  ────────────────\n\n'
    printf '  Package manager: %s\n\n' "$pm"

    if [[ "$pm" == "unknown" ]]; then
        printf '  Gerenciador de pacotes não suportado.\n'
        printf '  Instale manualmente: %s\n' "${install_required[*]} ${install_recommended[*]}"
        return 1
    fi

    local all=("${install_required[@]}" "${install_recommended[@]}")
    local pkgs=()
    mapfile -t pkgs < <(install::_available "$pm" "${all[@]}")

    local missing=()
    local pkg
    for pkg in "${install_required[@]}"; do
        command -v "$pkg" &>/dev/null || missing+=("$pkg")
    done

    if [[ ${#missing[@]} -gt 0 ]]; then
        printf '  Obrigatórios faltando: %s\n' "${missing[*]}"
    fi

    "install::_$pm" "${pkgs[@]}"

    install::_manual_hint "$pm"

    printf '\n  \033[0;32m✔  Done!\033[0m\n'
    printf "  Rode 'termos doctor' para verificar.\n\n"
}
