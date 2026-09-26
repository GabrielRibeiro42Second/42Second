#!/usr/bin/env bash

###########################################################
#
# install.sh
#
# Instala o TermOS no sistema.
#
# Uso:
#
#   ./install.sh
#
###########################################################

set -Eeuo pipefail

INSTALL_DIR="${HOME}/.config/termos"
BIN_DIR="${HOME}/.local/bin"

echo ""
echo "  TermOS Installer"
echo "  ────────────────"
echo ""

# Create directories
echo "  Creating directories..."
mkdir -p "$INSTALL_DIR"
mkdir -p "$BIN_DIR"
mkdir -p "$INSTALL_DIR/src"
mkdir -p "$INSTALL_DIR/config"
mkdir -p "$INSTALL_DIR/bin"

# Copy files
echo "  Copying files..."
cp -r src/ "$INSTALL_DIR/"
cp -r config/ "$INSTALL_DIR/"
cp bin/termos "$INSTALL_DIR/bin/termos"

# Dashboard TUI (opcional: precisa ter sido compilado com `make build`)
if [[ -x bin/termos-tui ]]; then
    cp bin/termos-tui "$INSTALL_DIR/bin/termos-tui"
else
    echo "  ! bin/termos-tui ausente — rode 'make build' para o dashboard"
fi

# Make scripts executable
echo "  Setting permissions..."
chmod +x "$INSTALL_DIR/bin/termos"
[[ -f "$INSTALL_DIR/bin/termos-tui" ]] && chmod +x "$INSTALL_DIR/bin/termos-tui"
find "$INSTALL_DIR/src" -name "*.sh" -exec chmod +x {} \;

# Create symlink
echo "  Creating symlink..."
ln -sf "$INSTALL_DIR/bin/termos" "$BIN_DIR/termos"

# Install dependencies
echo "  Installing dependencies..."
if command -v pacman &>/dev/null; then
    sudo pacman -S --needed --noconfirm fzf 2>/dev/null || true
fi

echo ""
echo "  ✓ TermOS installed to: $INSTALL_DIR"
echo "  ✓ Binary: $BIN_DIR/termos"
echo ""
echo "  Next steps:"
echo "    1. Add to your tmux.conf:"
echo "       set -g TERMOS_HOME \"$INSTALL_DIR\""
echo "       bind p display-popup -w 75%% -h 75%% -E \"$INSTALL_DIR/bin/termos open\""
echo ""
echo "    2. Or link tmux.conf:"
echo "       ln -sf $INSTALL_DIR/config/tmux.conf ~/.config/tmux/tmux.conf"
echo ""
echo "    3. Run: termos doctor"
echo ""
