# dotfiles

Personal dotfiles and Claude Code settings.

## 構成

```
dotfiles/
├── .vscode/
│   ├── workspace.code-workspace  # VSCode マルチルートワークスペース
│   └── settings.json             # VSCode/Cursor エディタ設定
├── .cursor/
│   └── settings.json             # Cursor エディタ設定
├── claude/
│   ├── CLAUDE.md                 # Claude コンテキスト設定
│   ├── settings.json             # Claude Code IDE 設定
│   ├── statusline-command.sh
│   └── skills/
├── .zshrc                        # Shell 設定
├── .gitconfig                    # Git グローバル設定
├── .gitconfig.local.example      # Git ローカル設定（テンプレート）
└── README.md
```

## インストール

```bash
# 1. リポジトリを clone
git clone https://github.com/kosments/dotfiles.git ~/dotfiles

# 2. Shell 設定を symlink で展開
ln -s ~/dotfiles/.zshrc ~/.zshrc
ln -s ~/dotfiles/.gitconfig ~/.gitconfig

# 3. Claude Code 設定を展開
ln -s ~/dotfiles/claude ~/.config/claude
ln -s ~/dotfiles/claude/CLAUDE.md ~/CLAUDE.md

# 4. Cursor 設定を展開（使用する場合）
mkdir -p ~/.cursor/User
ln -s ~/dotfiles/.cursor/settings.json ~/.cursor/User/settings.json
```

## ⚠️ セットアップ後の手動作業

### Git ローカル設定
`.gitconfig` にはメールアドレスが含まれないため、以下を実行して個人設定を追加：

```bash
cp ~/dotfiles/.gitconfig.local.example ~/.gitconfig.local
# ~/.gitconfig.local を編集してメールアドレスを設定
git config user.email "your-email@example.com"
```

### Claude Code ローカル設定
`~/.config/claude/settings.local.json` は環境固有の秘密情報（API キーなど）を保持するため、dotfiles に含まれていません。必要に応じて手動で作成します。

## 運用ルール

### 基本原則
- **編集は常に `~/dotfiles` 配下で行う** — ホーム直下は symlink のみ
- **秘密情報は dotfiles に含めない** — `.gitignore` や `.example` テンプレートを活用
- **パスは環境に依存しない形で管理** — 絶対パスではなく `~`, `$HOME` を使用
- **IDE 設定（VSCode/Cursor）は共有可能** — `.vscode/` と `.cursor/` で同期

### 秘密情報の管理
- メールアドレス、API キー、トークンなどは dotfiles に含めない
- ローカル設定（`.gitconfig.local`, `~/.config/claude/settings.local.json`）で個別管理
- 必要に応じて `.example` テンプレートを提供

## VSCode / Cursor ワークスペース

```bash
# VSCode で multi-root workspace を開く
code ~/dotfiles/.vscode/workspace.code-workspace

# Cursor で workspace を開く
cursor ~/dotfiles/.vscode/workspace.code-workspace
```

このワークスペースには以下が含まれます：
- `~/dev/` — 日常業務のプロジェクト
- `~/dotfiles/` — dotfiles リポジトリ

## 環境移行

新しい環境で dotfiles を復元：

```bash
git clone https://github.com/kosments/dotfiles.git ~/dotfiles

# すべての symlink を一括張り替え（上記の「インストール」セクション参照）
ln -s ~/dotfiles/.zshrc ~/.zshrc
ln -s ~/dotfiles/.gitconfig ~/.gitconfig
ln -s ~/dotfiles/claude ~/.config/claude
ln -s ~/dotfiles/claude/CLAUDE.md ~/CLAUDE.md
mkdir -p ~/.cursor/User && ln -s ~/dotfiles/.cursor/settings.json ~/.cursor/User/settings.json

# ローカル設定を再作成
cp ~/dotfiles/.gitconfig.local.example ~/.gitconfig.local
# ~/.gitconfig.local を編集
```
