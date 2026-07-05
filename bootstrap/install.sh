#!/usr/bin/env bash
# Install dotfiles symlinks (Mac/Linux)
# Usage: bash bootstrap/install.sh
# Idempotent: safe to run multiple times

set -e

DOTFILES="${HOME}/dotfiles"
ERRORS=0

ok()   { echo "  ✓ $1"; }
skip() { echo "  - $1 (already set)"; }
fail() { echo "  ✗ $1"; ERRORS=$((ERRORS + 1)); }

# シンボリックリンクを冪等に作成する
# すでに正しいリンクなら skip、違うなら上書き、通常ファイルなら abort
symlink() {
  local src="$1" dst="$2"
  if [ ! -e "$src" ]; then
    fail "source not found: $src"
    return
  fi
  if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
    skip "$dst"
    return
  fi
  if [ -e "$dst" ] && [ ! -L "$dst" ]; then
    fail "$dst exists as a real file (backup and remove manually)"
    return
  fi
  ln -sfn "$src" "$dst"
  ok "$dst -> $src"
}

echo "============================================================"
echo " dotfiles symlink setup (Mac)"
echo "============================================================"

mkdir -p "${HOME}/.config"
mkdir -p "${HOME}/.cursor/User"
mkdir -p "${HOME}/.aws"
mkdir -p "${HOME}/.config/mise"
mkdir -p "${HOME}/.config/zsh"

# Shell
echo "[shell]"
symlink "${DOTFILES}/shell/zshenv"             "${HOME}/.zshenv"
symlink "${DOTFILES}/shell/zshrc"              "${HOME}/.zshrc"
symlink "${DOTFILES}/.gitconfig"               "${HOME}/.gitconfig"

# Claude Code
echo "[claude]"
symlink "${DOTFILES}/claude"                   "${HOME}/.config/claude"
symlink "${DOTFILES}/claude/CLAUDE.md"         "${HOME}/CLAUDE.md"

# Editor
echo "[editor]"
symlink "${DOTFILES}/.cursor/settings.json"    "${HOME}/.cursor/User/settings.json"

# Terminal
echo "[terminal]"
symlink "${DOTFILES}/config/wezterm"           "${HOME}/.config/wezterm"

# AWS
echo "[aws]"
symlink "${DOTFILES}/config/aws/config"        "${HOME}/.aws/config"
# Note: credentials は git 管理外 (~/.aws/credentials)

# Starship prompt
echo "[starship]"
symlink "${DOTFILES}/config/starship.toml"     "${HOME}/.config/starship.toml"

# mise
echo "[mise]"
symlink "${DOTFILES}/config/mise/config.toml"  "${HOME}/.config/mise/config.toml"

echo ""
if [ "$ERRORS" -eq 0 ]; then
  echo "============================================================"
  echo " ✓ All symlinks OK"
  echo "============================================================"
else
  echo "============================================================"
  echo " ✗ $ERRORS error(s) — check output above"
  echo "============================================================"
  exit 1
fi

echo ""
echo "Next steps:"
echo "  bash bootstrap/brew.sh"
echo "  bash bootstrap/languages.sh"
echo ""
