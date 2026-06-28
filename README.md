# 🚀 Dotfiles - Portable Terminal & Development Environment

**[日本語](#日本語) | [English](#english)**

---

## 日本語

### 📌 概要

複数のマシン・環境で同じターミナル設定を使用できるポータブル dotfiles です。

- ローカル、SSH、Docker、VS Code DevContainer など、どの環境でも同じ設定で作業可能
- 秘密情報は .zshrc.local で独立管理（git 記録なし）
- 100+ エイリアス + 20+ ヘルパー関数
- 技術スタック対応: gcloud, kubectl, terraform, aws, git, glab, newrelic 等
- 起動時間最適化: 3.0s → 0.3-0.6s (90%削減)

### 🎯 対応環境

| 環境 | 対応 | 詳細 |
|------|------|------|
| **macOS Terminal** | ✅ | [ENVIRONMENTS.md](docs/ENVIRONMENTS.md) |
| **Linux** | ✅ | [ENVIRONMENTS.md](docs/ENVIRONMENTS.md) |
| **VS Code DevContainer** | ✅ | [ENVIRONMENTS.md](docs/ENVIRONMENTS.md) |
| **SSH Remote** | ✅ | [ENVIRONMENTS.md](docs/ENVIRONMENTS.md) |
| **Docker / Rancher** | ✅ | [ENVIRONMENTS.md](docs/ENVIRONMENTS.md) |

### 🚀 クイックスタート

```bash
# 1. クローン
git clone https://github.com/kosments/dotfiles.git ~/.dotfiles

# 2. シンボリックリンク作成
mkdir -p ~/.config/zsh
ln -sf ~/.dotfiles/shell/zshrc ~/.zshrc
ln -sf ~/.dotfiles/shell/zshenv ~/.zshenv

# 3. ローカル設定作成（秘密情報）
cp ~/.dotfiles/shell/.zshrc.local.example ~/.zshrc.local
# ~/.zshrc.local を編集してAPI キーなどを設定

# 4. 環境別セットアップ
# 詳細は docs/ENVIRONMENTS.md を参照
```

### 📁 ファイル構成

```
shell/
├── .zshenv                        環境変数（XDG Base Directory 標準）
├── .zshrc                         メイン初期化・プラグイン
├── aliases.zsh                    100+ エイリアス定義
├── functions.zsh                  20+ ヘルパー関数
├── .zshrc.local.example           ローカル設定テンプレート（git除外）
└── .tmux.conf                     tmux 設定（マルチ環境対応）

docs/
├── zsh-startup-optimization.md    起動時間最適化の詳細
└── ENVIRONMENTS.md                環境別セットアップガイド
```

### 🔧 主要機能

**100+ エイリアス**  
gcloud, kubectl, terraform, aws, git, glab, newrelic, docker 等

**20+ ヘルパー関数**  
k-pod-shell, gcp-project, aws-profile, tf-plan-review 等

**🔒 セキュリティ**  
秘密情報は .zshrc.local で管理（git 記録なし）

**⚡ パフォーマンス**  
起動時間 90% 削減

### 📚 詳細ドキュメント

- [docs/ENVIRONMENTS.md](docs/ENVIRONMENTS.md) - macOS/Linux/Docker/SSH/DevContainer 環境別ガイド
- [docs/zsh-startup-optimization.md](docs/zsh-startup-optimization.md) - 起動時間最適化の詳細
- [shell/.zshrc.local.example](shell/.zshrc.local.example) - ローカル設定テンプレート

### 🔄 カスタマイズ

`.zshrc.local` にマシン固有の設定を追加：

```bash
# ~/.zshrc.local
export AWS_PROFILE="my-profile"
export GOOGLE_PROJECT_ID="my-project"

alias myproject='cd ~/dev/my-project && ls'

my-deploy() {
  echo "Deploying to $1..."
  # your deployment logic
}
```

### 🐛 トラブルシューティング

**起動が遅い場合**
```bash
time zsh -i -c exit
```

**エイリアスが効きません**
```bash
# 確認1: symlink 確認
readlink ~/.zshrc

# 確認2: シェル再起動
exec zsh
```

### 📝 ファイル説明

| ファイル | 役割 | 共有 |
|---------|------|------|
| .zshenv | 環境変数（全シェル） | ✅ |
| .zshrc | 初期化・プラグイン | ✅ |
| aliases.zsh | エイリアス | ✅ |
| functions.zsh | ヘルパー関数 | ✅ |
| .zshrc.local | 秘密情報・ローカル設定 | ❌ (gitignore) |
| .tmux.conf | tmux 設定 | ✅ |

---

## English

### 📌 Overview

A portable dotfiles repository for consistent terminal configuration across multiple machines and environments.

- Work locally, over SSH, in Docker, VS Code DevContainer with the same setup
- Secrets managed in .zshrc.local (not tracked by git)
- 100+ aliases + 20+ helper functions
- Tech stack support: gcloud, kubectl, terraform, aws, git, glab, newrelic, etc.
- Startup time optimized: 3.0s → 0.3-0.6s

### 🎯 Supported Environments

macOS, Linux, Docker, SSH, VS Code DevContainer, and more.

### 🚀 Quick Start

```bash
git clone https://github.com/kosments/dotfiles.git ~/.dotfiles
mkdir -p ~/.config/zsh
ln -sf ~/.dotfiles/shell/zshrc ~/.zshrc
ln -sf ~/.dotfiles/shell/zshenv ~/.zshenv
cp ~/.dotfiles/shell/.zshrc.local.example ~/.zshrc.local
```

### 📚 Documentation

- [docs/ENVIRONMENTS.md](docs/ENVIRONMENTS.md) - Environment-specific setup
- [docs/zsh-startup-optimization.md](docs/zsh-startup-optimization.md) - Optimization details

### 🔒 Security

Manage secrets in `.zshrc.local` (gitignore'd). Each machine maintains independent configuration.

---

**MIT License**

