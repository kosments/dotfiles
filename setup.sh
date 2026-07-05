#!/usr/bin/env bash
# ============================================================
# Dotfiles Master Setup Script
# Usage: bash setup.sh [--skip-brew] [--skip-languages]
# ============================================================
# Run this once on a new machine after cloning dotfiles to ~/dotfiles.
# The script is idempotent — safe to run again.

set -e

DOTFILES="${HOME}/dotfiles"
SKIP_BREW=false
SKIP_LANGUAGES=false

for arg in "$@"; do
  case $arg in
    --skip-brew)      SKIP_BREW=true ;;
    --skip-languages) SKIP_LANGUAGES=true ;;
  esac
done

ok()   { echo "  ✓ $1"; }
info() { echo "  → $1"; }
warn() { echo "  ! $1"; }

banner() {
  echo ""
  echo "============================================================"
  echo "  $1"
  echo "============================================================"
}

# ============================================================
# 0. Sanity check: must be run from ~/dotfiles
# ============================================================
if [ ! -f "${DOTFILES}/setup.sh" ]; then
  echo "Error: dotfiles not found at ${DOTFILES}"
  echo "  Clone first: git clone https://github.com/kosments/dotfiles.git ~/dotfiles"
  exit 1
fi

banner "Dotfiles Setup"

# ============================================================
# 1. Homebrew
# ============================================================
banner "Step 1/5: Homebrew"

if ! command -v brew >/dev/null 2>&1; then
  info "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Apple Silicon: add brew to PATH for this session
  if [ -f /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
else
  ok "Homebrew already installed ($(brew --version | head -1))"
fi

# ============================================================
# 2. Symlinks
# ============================================================
banner "Step 2/5: Symlinks"
bash "${DOTFILES}/bootstrap/install.sh"

# ============================================================
# 3. Homebrew packages (Brewfile)
# ============================================================
banner "Step 3/5: Homebrew packages"

if $SKIP_BREW; then
  warn "Skipping (--skip-brew). Run manually: bash ~/dotfiles/bootstrap/brew.sh"
else
  bash "${DOTFILES}/bootstrap/brew.sh"
fi

# ============================================================
# 4. Language runtimes
# ============================================================
banner "Step 4/5: Language runtimes"

if $SKIP_LANGUAGES; then
  warn "Skipping (--skip-languages). Run manually: bash ~/dotfiles/bootstrap/languages.sh"
else
  bash "${DOTFILES}/bootstrap/languages.sh"
fi

# ============================================================
# 5. Local config
# ============================================================
banner "Step 5/5: Local config (~/.zshrc.local)"

if [ ! -f "${HOME}/.zshrc.local" ]; then
  cp "${DOTFILES}/shell/.zshrc.local.example" "${HOME}/.zshrc.local"
  ok "Created ~/.zshrc.local from template"
  info "Edit it to add your API keys, GCP project, AWS profile, etc."
else
  ok "~/.zshrc.local already exists — not overwriting"
fi

# ============================================================
# Done
# ============================================================
banner "Setup complete!"
echo ""
echo "  Next steps:"
echo ""
echo "  1. Edit ~/.zshrc.local with your credentials"
echo "     ${EDITOR:-vi} ~/.zshrc.local"
echo ""
echo "  2. (Optional) Clone your Neovim config"
echo "     git clone https://github.com/kosments/nvim-config.git ~/.config/nvim"
echo ""
echo "  3. Start a new shell"
echo "     exec zsh"
echo ""
