#!/usr/bin/env bash
# Install language version managers and runtimes
# Usage: bash bootstrap/languages.sh

set -e

echo "============================================================"
echo "Installing language managers and runtimes..."
echo "============================================================"

# ============================================================
# Volta (Node.js)
# ============================================================
if ! command -v volta &> /dev/null; then
  echo "→ Installing Volta..."
  curl https://get.volta.sh | bash
else
  echo "→ Volta already installed"
fi

echo "→ Installing Node.js 24 via Volta..."
volta install node@24

# ============================================================
# goenv (Go)
# ============================================================
echo "→ Installing Go 1.23.12 via goenv..."
goenv install 1.23.12 || true
goenv global 1.23.12

# ============================================================
# mise (multi-tool version manager)
# ============================================================
echo "→ Installing mise tools (bun)..."
mise install

# ============================================================
# uv (Python package manager)
# ============================================================
if ! command -v uv &> /dev/null; then
  echo "→ Installing uv..."
  curl -LsSf https://astral.sh/uv/install.sh | sh
else
  echo "→ uv already installed"
fi

# ============================================================
# Neovim (optional: uncomment to clone)
# ============================================================
# echo "→ Setting up Neovim config..."
# if [ ! -d "${HOME}/.config/nvim" ]; then
#   git clone https://github.com/kosments/nvim-config.git "${HOME}/.config/nvim"
# fi

echo ""
echo "============================================================"
echo "✓ Language managers installed!"
echo "============================================================"
echo ""
echo "Installed versions:"
echo "  Node.js: $(node --version)"
echo "  Go: $(go version)"
echo "  Python (via pyenv): $(pyenv version)"
echo "  uv: $(uv --version 2>/dev/null || echo 'not yet in PATH')"
echo ""
