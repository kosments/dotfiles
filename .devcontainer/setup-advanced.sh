#!/bin/bash
set -e

echo "🔧 Advanced DevContainer Setup: nvim + tmux + Claude Code CLI"

# ============================================================
# 1. 基本ツールのインストール
# ============================================================
echo "📦 Installing base tools..."
apt-get update
apt-get install -y \
    zsh tmux neovim git fzf ripgrep eza peco \
    curl wget build-essential \
    openssh-client \
    python3 python3-pip python3-dev \
    nodejs npm

# ============================================================
# 2. Claude Code CLI のインストール
# ============================================================
echo "🤖 Installing Claude Code CLI..."
npm install -g @anthropic-ai/claude-code-cli 2>/dev/null || true

# ============================================================
# 3. dotfiles のセットアップ
# ============================================================
echo "🔗 Setting up dotfiles..."

# dotfiles ディレクトリを確認
if [ ! -d ~/.dotfiles ]; then
    if [ -d /home/vscode/.dotfiles ]; then
        export DOTFILES_PATH=/home/vscode/.dotfiles
    else
        git clone https://github.com/kosments/dotfiles.git ~/.dotfiles
        export DOTFILES_PATH=~/.dotfiles
    fi
else
    export DOTFILES_PATH=~/.dotfiles
fi

# zsh 設定をシンボリックリンク
mkdir -p ~/.config/zsh
ln -sf $DOTFILES_PATH/shell/zshenv ~/.zshenv
ln -sf $DOTFILES_PATH/shell/zshrc ~/.zshrc
ln -sf $DOTFILES_PATH/shell/zshrc ~/.config/zsh/.zshrc

# tmux 設定（.tmux.conf がある場合）
if [ -f $DOTFILES_PATH/shell/.tmux.conf ]; then
    ln -sf $DOTFILES_PATH/shell/.tmux.conf ~/.tmux.conf
fi

# ============================================================
# 4. ローカル設定テンプレートの作成
# ============================================================
echo "📝 Creating local configuration template..."

if [ ! -f ~/.zshrc.local ]; then
    cp $DOTFILES_PATH/shell/.zshrc.local.example ~/.zshrc.local

    # DevContainer 用カスタマイズ
    cat >> ~/.zshrc.local << 'LOCAL_CONFIG'

# ============================================================
# [DevContainer] VS Code 統合設定
# ============================================================
# [JP] VS Code DevContainer 内での追加設定
# [EN] Additional settings for VS Code DevContainer

# Claude Code CLI 設定
export ANTHROPIC_API_KEY="${ANTHROPIC_API_KEY:-}"  # 必要に応じて設定

# コンテナ内の tmux・nvim パス
export EDITOR=nvim
export VISUAL=nvim

# tmux セッション自動作成（オプション）
# [JP] VS Code ターミナルで tmux セッションを自動作成
# [EN] Auto-create tmux session in VS Code terminal
# if [[ -z "$TMUX" ]] && [[ "$TERM_PROGRAM" != "vscode" ]]; then
#     tmux new-session -d -s main -x 200 -y 50
#     tmux attach-session -t main
# fi

# DevContainer ホスト用エイリアス
alias claude='claude-code'  # Claude Code CLI
alias nvim-edit='nvim .'    # 現在のディレクトリを nvim で開く

# ============================================================
# [DevContainer] Git 設定（コンテナ内）
# ============================================================
# コンテナ内で Git が必要な場合のセットアップ
# [JP] SSH キーフォワード: ~/.ssh がマウントされていることを確認
# [EN] SSH key forwarding: Ensure ~/.ssh is mounted via devcontainer.json

LOCAL_CONFIG
fi

# ============================================================
# 5. シェルをzshに変更
# ============================================================
echo "🐚 Setting default shell to zsh..."
if ! grep -q "^vscode:/bin/zsh" /etc/passwd 2>/dev/null; then
    chsh -s /bin/zsh || true
fi

# ============================================================
# 6. nvim プラグイン初期化（オプション）
# ============================================================
echo "📝 Initializing nvim..."

# nvim config が別リポジトリの場合
if [ ! -d ~/.config/nvim ]; then
    echo "⚠️  nvim config not found. To setup LazyVim:"
    echo "  git clone https://github.com/LazyVim/starter ~/.config/nvim"
    echo "  nvim"
fi

# ============================================================
# 7. tmux 設定確認
# ============================================================
echo "🎯 Checking tmux configuration..."
if [ -f ~/.tmux.conf ]; then
    echo "✅ tmux.conf found"
    tmux -c ~/.tmux.conf source-file ~/.tmux.conf 2>/dev/null || true
else
    echo "⚠️  tmux.conf not found. Create ~/.dotfiles/shell/.tmux.conf or use defaults"
fi

# ============================================================
# 8. バージョン確認
# ============================================================
echo ""
echo "✅ Setup Complete! Versions:"
echo "  zsh: $(zsh --version)"
echo "  tmux: $(tmux -V)"
echo "  nvim: $(nvim --version | head -1)"
echo "  node: $(node --version)"
echo "  npm: $(npm --version)"
echo ""
echo "📌 Next steps:"
echo "  1. Run: ! claude auth login (if using Claude Code CLI)"
echo "  2. Run: nvim to initialize LazyVim"
echo "  3. Edit ~/.zshrc.local with API keys, tokens, etc."
echo "  4. Run: source ~/.zshrc"
