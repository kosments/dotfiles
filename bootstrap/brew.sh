#!/usr/bin/env bash
# Install packages from Brewfile
# Usage: bash bootstrap/brew.sh

set -e

DOTFILES="${HOME}/dotfiles"

echo "============================================================"
echo "Installing Homebrew packages from Brewfile..."
echo "============================================================"

brew bundle --file="${DOTFILES}/Brewfile"

echo ""
echo "============================================================"
echo "✓ Homebrew packages installed!"
echo "============================================================"
