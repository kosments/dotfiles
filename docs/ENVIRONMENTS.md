# 🌍 環境別セットアップガイド

このドキュメントでは、異なる環境で dotfiles を同じ設定で使用する方法を説明します。

**対応環境**:
- [ローカル macOS Terminal](#localhost-macos-terminal)
- [Linux (Ubuntu/Debian)](#linux-ubuntudebian)
- [VS Code DevContainer](#vs-code-devcontainer)
- [SSH Remote Server](#ssh-remote-server)
- [Docker / Rancher Desktop](#docker--rancher-desktop)

---

## Localhost: macOS Terminal

### セットアップ手順

**1. Homebrew で必須ツールをインストール**

```bash
brew install zsh git tmux nvim fzf peco ghq ripgrep bat eza
```

**2. リポジトリをクローン**

```bash
git clone https://github.com/kosments/dotfiles.git ~/.dotfiles
```

**3. シンボリックリンク作成**

```bash
# zsh 設定
mkdir -p ~/.config/zsh
ln -sf ~/.dotfiles/shell/zshrc ~/.zshrc
ln -sf ~/.dotfiles/shell/zshenv ~/.zshenv
ln -sf ~/.dotfiles/shell/.zshrc ~/.config/zsh/.zshrc

# tmux 設定（オプション）
ln -sf ~/.dotfiles/shell/.tmux.conf ~/.tmux.conf
```

**4. ローカル設定作成**

```bash
cp ~/.dotfiles/shell/.zshrc.local.example ~/.zshrc.local

# 以下を編集：
# - AWS_PROFILE, AWS_REGION
# - GOOGLE_PROJECT_ID
# - Kubernetes context
# - API キー、トークン等
```

**5. シェル再起動**

```bash
exec zsh
```

### 検証

```bash
# エイリアス確認
alias | grep "^k="    # kubectl

# 関数確認
type k-pod-shell

# 起動時間計測
time zsh -i -c exit
```

---

## Linux (Ubuntu/Debian)

### セットアップ手順

**1. 必須ツールをインストール**

```bash
sudo apt-get update
sudo apt-get install -y zsh git tmux neovim fzf ripgrep

# Eza (ls 代替)
sudo apt install -y eza

# Peco (対話的フィルタ)
wget https://github.com/peco/peco/releases/download/v0.9.3/peco_linux_amd64.tar.gz
tar xzf peco_linux_amd64.tar.gz && sudo mv peco/peco /usr/local/bin
```

**2. dotfiles をクローン**

```bash
git clone https://github.com/kosments/dotfiles.git ~/.dotfiles
```

**3. シンボリックリンク作成**

macOS と同様（上記参照）

**4. デフォルトシェルを zsh に変更**

```bash
chsh -s $(which zsh)
```

**5. ローカル設定作成**

```bash
cp ~/.dotfiles/shell/.zshrc.local.example ~/.zshrc.local
```

### 注意事項

- **TERM 環境変数**: SSH で接続する場合、`TERM=xterm-256color` または `TERM=tmux-256color` を設定
- **真色サポート**: `$COLORTERM=truecolor` で true color を有効化
- **fzf 補完**: Linux では `/usr/share/doc/fzf/examples/` にキーバインディングがあることを確認

---

## VS Code DevContainer

### セットアップ手順

**1. `.devcontainer/devcontainer.json` を作成**

```json
{
  "name": "Dotfiles Development",
  "image": "mcr.microsoft.com/devcontainers/universal:latest",
  "features": {
    "ghcr.io/devcontainers/features/git:1": {},
    "ghcr.io/devcontainers/features/docker-in-docker:2": {}
  },
  "customizations": {
    "vscode": {
      "extensions": [
        "neovim.nvim",
        "ms-vscode-remote.remote-containers"
      ]
    }
  },
  "postCreateCommand": "bash .devcontainer/setup.sh",
  "remoteUser": "vscode"
}
```

**2. `.devcontainer/setup.sh` を作成**

```bash
#!/bin/bash
set -e

# Install tools
apt-get update
apt-get install -y zsh tmux fzf ripgrep exa peco

# Clone dotfiles
git clone https://github.com/kosments/dotfiles.git /tmp/dotfiles

# Setup symlinks
mkdir -p ~/.config/zsh
ln -sf /tmp/dotfiles/shell/zshrc ~/.zshrc
ln -sf /tmp/dotfiles/shell/zshenv ~/.zshenv

# Create local config
cp /tmp/dotfiles/shell/.zshrc.local.example ~/.zshrc.local

# Set shell
chsh -s /bin/zsh

echo "✅ DevContainer setup complete!"
```

**3. VS Code で DevContainer を開く**

```bash
# Command Palette (Cmd+Shift+P)
> Dev Containers: Reopen in Container
```

### Docker 環境での注意点

- **TERM**: `TERM=xterm-256color` に設定（コンテナ内）
- **真色**: `$COLORTERM=truecolor` を `.zshrc.local` で指定
- **マウント**: dotfiles ディレクトリをボリュームマウント

```json
"mounts": [
  "source=${localEnv:HOME}/dotfiles,target=/home/vscode/.dotfiles,type=bind,consistency=cached"
]
```

### Advanced: nvim + tmux + Claude Code CLI

**ユースケース**: VS Code DevContainer内で nvim, tmux, Claude Code CLIを同時に利用

#### 詳細な devcontainer.json

```json
{
  "name": "Dotfiles + nvim + tmux + Claude Code",
  "image": "mcr.microsoft.com/devcontainers/universal:latest",
  "features": {
    "ghcr.io/devcontainers/features/git:1": {},
    "ghcr.io/devcontainers/features/docker-in-docker:2": {},
    "ghcr.io/devcontainers/features/node:latest": {
      "version": "20"
    }
  },
  "customizations": {
    "vscode": {
      "extensions": [
        "neovim.nvim",
        "ms-vscode-remote.remote-containers",
        "ms-vscode-remote.remote-ssh",
        "ms-vscode.remote-explorer"
      ],
      "settings": {
        "terminal.integrated.defaultProfile.linux": "zsh",
        "terminal.integrated.profiles.linux": {
          "zsh": {
            "path": "/bin/zsh",
            "args": ["-l"]
          }
        },
        "editor.wordWrap": "on",
        "editor.formatOnSave": true
      }
    }
  },
  "mounts": [
    "source=${localEnv:HOME}/dotfiles,target=/home/vscode/.dotfiles,type=bind,consistency=cached",
    "source=${localEnv:HOME}/.ssh,target=/home/vscode/.ssh,type=bind,consistency=cached"
  ],
  "forwardPorts": [
    3000,
    8080,
    9090
  ],
  "portsAttributes": {
    "3000": {
      "label": "Application",
      "onAutoForward": "notify"
    },
    "8080": {
      "label": "Web Preview",
      "onAutoForward": "notify"
    }
  },
  "remoteUser": "vscode",
  "remoteEnv": {
    "TERM": "xterm-256color",
    "COLORTERM": "truecolor"
  },
  "postCreateCommand": "bash .devcontainer/setup-advanced.sh",
  "postStartCommand": "zsh -c 'source ~/.zshrc && echo ✅ DevContainer initialized'"
}
```

#### 詳細な setup-advanced.sh

```bash
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

# 認証初期化スクリプト
cat > /tmp/claude-code-init.sh << 'CLAUDE_INIT'
#!/bin/bash
# Claude Code CLI 初期化
echo "🔐 Claude Code CLI setup"
echo "Run this in VS Code terminal to authenticate:"
echo "  ! claude auth login"
CLAUDE_INIT
chmod +x /tmp/claude-code-init.sh

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
if [[ -z "$TMUX" ]] && [[ "$TERM_PROGRAM" != "vscode" ]]; then
    tmux new-session -d -s main -x 200 -y 50
    tmux attach-session -t main
fi

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
```

#### 利用開始手順

**1. リポジトリにファイルを配置**

```bash
# プロジェクトルートに .devcontainer ディレクトリを作成
mkdir -p .devcontainer
cp docs/templates/devcontainer.json .devcontainer/
cp docs/templates/setup-advanced.sh .devcontainer/
```

**2. VS Code で DevContainer を開く**

```bash
# Command Palette (Cmd+Shift+P / Ctrl+Shift+P)
> Dev Containers: Reopen in Container
```

**3. Claude Code CLI で認証**

```bash
# VS Code ターミナル内で
! claude auth login

# または
claude auth login
```

**4. ローカル設定を編集**

```bash
# コンテナ内のターミナル
nvim ~/.zshrc.local

# 以下を設定:
# - AWS_PROFILE, AWS_REGION
# - GOOGLE_PROJECT_ID
# - ANTHROPIC_API_KEY (Claude Code CLI用)
# - API トークン（GitHub, GitLab等）
```

**5. tmux セッションを開始（オプション）**

```bash
# ターミナル内で
tmux new-session -s work

# または既存セッションにアタッチ
tmux attach-session -s main
```

#### DevContainer 内での操作例

```bash
# nvim で編集
nvim ./src/main.py

# tmux でウィンドウ分割
# Ctrl+b + %  (横分割)
# Ctrl+b + "  (縦分割)

# Claude Code CLI で作業
! claude code review src/

# zsh alias を使用
k get pods
tf plan
git stash
```

#### トラブルシューティング

| 問題 | 原因 | 対策 |
|------|------|------|
| **nvim が遅い** | LazyVim 初回起動時 | `nvim` を実行して プラグイン同期完了を待つ |
| **tmux の色が出ない** | TERM 設定不足 | `export COLORTERM=truecolor` を実行 |
| **Claude Code CLI が見つからない** | npm インストール失敗 | `npm install -g @anthropic-ai/claude-code-cli` を実行 |
| **SSH キーが使えない** | .ssh マウント不足 | devcontainer.json に `.ssh` のマウント設定を追加 |
| **Git 認証が失敗** | SSH エージェント不足 | SSH キーエージェントフォワード設定を確認 |

---

## SSH Remote Server

### セットアップ手順

**1. リモートサーバーで dotfiles をクローン**

```bash
ssh user@server.example.com

# サーバー上で
git clone https://github.com/kosments/dotfiles.git ~/.dotfiles
```

**2. シンボリックリンク作成**

```bash
mkdir -p ~/.config/zsh
ln -sf ~/.dotfiles/shell/zshrc ~/.zshrc
ln -sf ~/.dotfiles/shell/zshenv ~/.zshenv
```

**3. ローカル設定作成**

```bash
cp ~/.dotfiles/shell/.zshrc.local.example ~/.zshrc.local
# サーバー固有の設定を編集
```

**4. SSH 接続設定（ローカル）**

```bash
# ~/.ssh/config
Host server
  HostName server.example.com
  User username
  IdentityFile ~/.ssh/id_rsa
  
  # TERM を統一
  SetEnv TERM=xterm-256color
  SetEnv COLORTERM=truecolor
```

### リモート環境での注意点

- **TERM 互換性**: サーバー側で `TERM=xterm-256color` または `screen-256color` をサポートか確認
- **true color**: SSH で `COLORTERM=truecolor` を接続時に設定
- **Git 認証**: SSH キーエージェントフォワード設定

```bash
# ~/.ssh/config で AddKeysToAgent yes を設定
Host *
  AddKeysToAgent yes
```

- **API キー**: `.zshrc.local` で本番サーバーのトークンを管理（git 記録なし）

---

## Docker / Rancher Desktop

### Docker Desktop でのセットアップ

**1. Dockerfile を作成**

```dockerfile
FROM ubuntu:22.04

RUN apt-get update && apt-get install -y \
    zsh git tmux neovim fzf ripgrep eza peco \
    curl wget build-essential

# dotfiles をコピー
COPY dotfiles /root/.dotfiles

# セットアップ
RUN mkdir -p ~/.config/zsh && \
    ln -sf ~/.dotfiles/shell/zshrc ~/.zshrc && \
    ln -sf ~/.dotfiles/shell/zshenv ~/.zshenv && \
    chsh -s /bin/zsh

# TERM 設定
ENV TERM=xterm-256color
ENV COLORTERM=truecolor

CMD ["zsh"]
```

**2. イメージをビルド**

```bash
docker build -t mydev .
```

**3. コンテナ実行**

```bash
docker run -it \
  -v ~/.dotfiles:/root/.dotfiles \
  -v ~/.zshrc.local:/root/.zshrc.local \
  -e TERM=xterm-256color \
  mydev
```

### Rancher Desktop でのセットアップ

**1. Rancher Desktop を起動**

```bash
# Rancher Desktop アプリを開く
```

**2. CLI コンテキスト設定**

```bash
kubectl config get-contexts
kubectl config use-context rancher-desktop
```

**3. コンテナ内で dotfiles をセットアップ**

```bash
# kubectl exec 経由でアクセス
kubectl run -it --rm debug --image=ubuntu:22.04 -- bash

# コンテナ内で dotfiles をセットアップ
git clone https://github.com/kosments/dotfiles.git ~/.dotfiles
ln -sf ~/.dotfiles/shell/zshrc ~/.zshrc
```

### Docker 環境での TERM 設定

```bash
# コンテナ実行時に設定
docker run -e TERM=xterm-256color -e COLORTERM=truecolor ...

# または docker-compose.yml
services:
  dev:
    environment:
      - TERM=xterm-256color
      - COLORTERM=truecolor
```

---

## 環境別比較表

| 項目 | macOS | Linux | DevContainer | SSH | Docker |
|------|-------|-------|--------------|-----|--------|
| **セットアップ時間** | 5分 | 10分 | 15分 | 5分 | 10分 |
| **TERM 設定** | ✅ デフォルト | ⚠️ 手動設定 | ⚠️ 設定必須 | ⚠️ 設定必須 | ⚠️ 設定必須 |
| **真色サポート** | ✅ | ⚠️ 確認 | ✅ | ⚠️ 確認 | ⚠️ 設定必須 |
| **git 連携** | ✅ | ✅ | ✅ | ✅ | ✅ (volome mount) |
| **API キー管理** | .zshrc.local | .zshrc.local | ⚠️ 環境変数 | .zshrc.local | ⚠️ 環境変数 |

---

## トラブルシューティング

### Q: Color が表示されません

```bash
# 確認1: TERM 設定
echo $TERM          # xterm-256color or screen-256color

# 確認2: true color
echo $COLORTERM     # truecolor

# 確認3: 256 color をサポート
tput colors         # 256 が出ればOK
```

**修正**:
```bash
# ~/.zshrc.local に追加
export TERM=xterm-256color
export COLORTERM=truecolor
```

### Q: SSH でエイリアスが効きません

```bash
# 確認: リモートで dotfiles がインストール済みか
ls ~/.dotfiles/shell/aliases.zsh

# ~/.zshrc が正しく symlink されているか
readlink ~/.zshrc
```

### Q: DevContainer で nvim が起動しません

```bash
# devcontainer.json に追加
"features": {
  "ghcr.io/devcontainers/features/nvim:1": {}
}
```

### Q: Docker でホストの git 認証情報が使えません

**解決法**: `.zshrc.local` で git 認証情報を設定

```bash
# ~/.zshrc.local
export GIT_SSH_COMMAND="ssh -i ~/.ssh/id_rsa"
```

---

## ベストプラクティス

1. **環境ごとに .zshrc.local を分ける**
   ```bash
   # 各マシンで独立管理
   ~/.zshrc.local (local)
   ~/.zshrc.local (remote server)
   ~/.zshrc.local (docker container)
   ```

2. **TERM を統一**
   - どの環境でも `xterm-256color` または `screen-256color` に統一

3. **秘密情報をセキュアに**
   - .zshrc.local は gitignore'd
   - リモートサーバーでも git に記録しない

4. **定期的に同期**
   ```bash
   # 各マシンで定期的に pull
   cd ~/.dotfiles && git pull
   ```

---

**環境別ガイド終了**

