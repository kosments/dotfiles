#!/usr/bin/env bash
# Verify dotfiles symlinks and required commands (Mac)
# Usage: bash verify.sh
# Exit code: 0 = all OK, 1 = failures found

DOTFILES="${HOME}/dotfiles"
PASS=0
FAIL=0

green='\033[0;32m'
red='\033[0;31m'
gray='\033[0;90m'
reset='\033[0m'

pass() { echo -e "  ${green}✓${reset} $1"; PASS=$((PASS + 1)); }
fail() { echo -e "  ${red}✗${reset} $1"; FAIL=$((FAIL + 1)); }

# シンボリックリンクが期待するターゲットを指しているか確認
check_symlink() {
  local dst="$1" expected_src="$2"
  if [ ! -e "$dst" ] && [ ! -L "$dst" ]; then
    fail "missing: $dst"
  elif [ ! -L "$dst" ]; then
    fail "not a symlink: $dst (real file exists)"
  elif [ "$(readlink "$dst")" = "$expected_src" ]; then
    pass "symlink: $dst -> $expected_src"
  else
    actual=$(readlink "$dst")
    fail "wrong target: $dst -> $actual (expected $expected_src)"
  fi
}

# コマンドが存在するか確認
check_cmd() {
  local cmd="$1"
  if command -v "$cmd" &>/dev/null; then
    pass "command: $cmd ($(command -v "$cmd"))"
  else
    fail "command not found: $cmd"
  fi
}

echo "============================================================"
echo " dotfiles verify (Mac)"
echo "============================================================"

echo ""
echo "[symlinks]"
check_symlink "${HOME}/.zshrc"                    "${DOTFILES}/shell/zshrc"
check_symlink "${HOME}/.gitconfig"                "${DOTFILES}/.gitconfig"
check_symlink "${HOME}/.config/claude"            "${DOTFILES}/claude"
check_symlink "${HOME}/CLAUDE.md"                 "${DOTFILES}/claude/CLAUDE.md"
check_symlink "${HOME}/.config/wezterm"           "${DOTFILES}/config/wezterm"
check_symlink "${HOME}/.config/mise/config.toml"  "${DOTFILES}/config/mise/config.toml"

echo ""
echo "[commands]"
check_cmd git
check_cmd gh
check_cmd brew
check_cmd mise
check_cmd starship
check_cmd node
check_cmd python3

echo ""
echo "============================================================"
if [ "$FAIL" -eq 0 ]; then
  echo -e " ${green}✓ All checks passed ($PASS)${reset}"
  echo "============================================================"
  exit 0
else
  echo -e " ${red}✗ $FAIL failed, $PASS passed${reset}"
  echo "============================================================"
  exit 1
fi
