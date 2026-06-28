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

