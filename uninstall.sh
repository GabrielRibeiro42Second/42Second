#!/usr/bin/env bash

###########################################################
#
# uninstall.sh
#
# Remove o TermOS do sistema.
#
# Uso:
#
#   ./uninstall.sh
#
###########################################################

set -Eeuo pipefail

INSTALL_DIR="${HOME}/.config/termos"
BIN_DIR="${HOME}/.local/bin"

echo ""
echo "  TermOS Uninstaller"
echo "  ──────────────────"
echo ""

# Remove symlink
if [[ -L "$BIN_DIR/termos" ]]; then
    rm "$BIN_DIR/termos"
    echo "  ✓ Removed symlink: $BIN_DIR/termos"
fi

# Remove install directory
if [[ -d "$INSTALL_DIR" ]]; then
    rm -rf "$INSTALL_DIR"
    echo "  ✓ Removed: $INSTALL_DIR"
fi

echo ""
echo "  ✓ TermOS uninstalled"
echo ""
