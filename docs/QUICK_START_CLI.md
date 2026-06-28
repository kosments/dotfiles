# 🚀 ターミナルからの DevContainer 迅速起動ガイド

**対象**: ターミナルから DevContainer (nvim + tmux + Claude Code CLI) を素早く起動したい方  
**前提**: VS Code, Docker, Dev Containers 拡張がインストール済み

---

## 📋 目次

1. [1分クイックスタート](#1分クイックスタート)
2. [セットアップ](#セットアップ)
3. [ワークフロー例](#ワークフロー例)
4. 詳細ガイド
   - [tmux の使い方](./tmux/basics.md)
   - [nvim の使い方](./nvim/basics.md)
   - [Claude Code CLI の使い方](./claude-cli/usage.md)

---

## 1分クイックスタート

### パターン1: カレントディレクトリで起動

```bash
devcontainer-quickstart
```

### パターン2: 特定ディレクトリで起動

```bash
devcontainer-quickstart ~/my-project
```

**実行内容**:
```
✅ DevContainer ビルド・起動（VS Code）
✅ tmux セッション作成
   ├─ nvim でファイルエクスプローラ開く（左60%）
   └─ Claude Code CLI スタンバイ（右40%）
✅ tmux にアタッチ（すぐに使用開始可能）
```

---

## セットアップ

### 1. スクリプトをインストール

```bash
# dotfiles から symlink を作成
ln -sf ~/.dotfiles/scripts/devcontainer-quickstart.sh /usr/local/bin/devcontainer-quickstart
chmod +x /usr/local/bin/devcontainer-quickstart
```

### 2. VS Code CLI 確認

```bash
# インストール確認
code --version

# インストール済みでない場合
# VS Code → Command Palette → Shell Command: Install 'code' command in PATH
```

### 3. 実行

```bash
# テスト
devcontainer-quickstart --help

# 実際に起動
devcontainer-quickstart ~/your-project
```

---

## ワークフロー例

### シナリオ: GitHub リポジトリで開発開始

```bash
# 1. リポジトリをクローン
git clone https://github.com/username/my-repo.git
cd my-repo

# 2. DevContainer を起動
devcontainer-quickstart

# → 自動的に tmux/nvim/Claude Code が準備される
```

### 初回起動時

```
🚀 DevContainer Quick Start
Project: /Users/username/my-repo

📦 Building and opening DevContainer...
   This may take a few minutes on first run...

⏳ Waiting for VS Code to start (max 30s)...
✅ VS Code started

🔧 Setting up tmux...
✅ tmux session created: my-repo-dev

📌 Attaching to tmux...

Session: my-repo-dev
Windows:
  0: nvim (left) | Claude CLI (right)
  1: shell (debugging/other commands)

Tips:
  Ctrl+B % - Split pane horizontally
  Ctrl+B " - Split pane vertically
  Ctrl+B o - Switch between panes
  Ctrl+B x - Close pane
  Ctrl+B d - Detach session
```

---

## 画面レイアウト（起動直後）

```
┌─────────────────────────────────────────────────────────────┐
│ NVIM (File Explorer)              │ Claude Code CLI          │
│                                    │                          │
│ .                                  │ # Claude Code CLI ready  │
│ ├── src/                           │ # Run: claude <cmd>      │
│ ├── package.json                   │ ✅ Ready                 │
│ ├── README.md                      │                          │
│ └── ...                            │                          │
│                                    │                          │
└─────────────────────────────────────────────────────────────┘

nvim left pane      Claude CLI right pane
(60%)               (40%)

下: Window 1 "shell" (他のコマンド用)
```

---

## 基本操作

### tmux

| 操作 | キー | 説明 |
|------|------|------|
| **ペイン分割（横）** | Ctrl+B % | 左右に分割 |
| **ペイン分割（縦）** | Ctrl+B " | 上下に分割 |
| **ペイン移動** | Ctrl+B o | 次のペインに移動 |
| **ペイン切り替え** | Ctrl+B 矢印 | 方向キーで移動 |
| **セッション一覧** | Ctrl+B s | セッション一覧表示 |
| **セッション終了** | Ctrl+B d | セッションをデタッチ |

詳細 → [tmux 完全ガイド](./tmux/basics.md)

### nvim

| 操作 | キー | 説明 |
|------|------|------|
| **ファイルオープン** | :e . | ファイルエクスプローラ |
| **ファイル選択** | Enter | ファイルを開く |
| **ディレクトリ移動** | - | 親ディレクトリに戻る |
| **新規ファイル** | % | 新規ファイル作成 |
| **新規ディレクトリ** | d | 新規ディレクトリ作成 |
| **削除** | D | ファイル/ディレクトリ削除 |
| **終了** | :q | nvim を終了 |

詳細 → [nvim 完全ガイド](./nvim/basics.md)

### Claude Code CLI

```bash
# コマンドプリフィックス（VS Code ターミナル内）
! claude <command>

# または直接実行（DevContainer 内ターミナル）
claude <command>

# 例
! claude code review src/main.py
! claude explain ./config.json
```

詳細 → [Claude Code CLI ガイド](./claude-cli/usage.md)

---

## トラブルシューティング

### Q: スクリプトが見つからない

```bash
# /usr/local/bin にインストールされているか確認
which devcontainer-quickstart

# インストールされていない場合
ln -sf ~/.dotfiles/scripts/devcontainer-quickstart.sh /usr/local/bin/devcontainer-quickstart
chmod +x /usr/local/bin/devcontainer-quickstart
```

### Q: VS Code が起動しない

```bash
# code コマンドが利用可能か確認
code --version

# 手動で起動
code --remote "dev-container+..." ~/my-project
```

### Q: tmux の画面分割がうまくいかない

```bash
# 既存セッションを削除
tmux kill-session -t session-name

# 再度起動
devcontainer-quickstart
```

### Q: nvim でファイルが見えない

```bash
# nvim 内でファイルエクスプローラを再度開く
:e .

# または
:Explore
```

### Q: Claude Code CLI が見つからない

```bash
# DevContainer 内のターミナルで確認
npm list -g @anthropic-ai/claude-code-cli

# インストール
npm install -g @anthropic-ai/claude-code-cli
```

---

## 次のステップ

### さらに詳しく学ぶ

1. **[tmux 基本ガイド](./tmux/basics.md)** — ウィンドウ、ペイン、セッション管理
2. **[nvim 基本ガイド](./nvim/basics.md)** — ファイルエクスプローラ、編集、プラグイン
3. **[Claude Code CLI ガイド](./claude-cli/usage.md)** — コマンド、認証、実践例

### カスタマイズ

- `.devcontainer/devcontainer.json` — DevContainer 設定変更
- `shell/.tmux.conf` — tmux キーバインディングカスタマイズ
- `shell/.zshrc.local` — シェル環境のカスタマイズ

---

## よくある質問（FAQ）

**Q: 毎回 DevContainer をビルドするのは遅くないか？**  
A: 初回は遅いですが（3-5分）、以降は数秒で起動します。`--rebuild` で再ビルド可能。

**Q: tmux セッションが自動で作成されて邪魔では？**  
A: `~/.zshrc.local` で自動作成をオフにできます。

**Q: nvim を使わないで VS Code で編集したい**  
A: スクリプトの最後の `tmux attach-session` を削除し、VS Code ターミナルから tmux を開く。

**Q: Claude Code CLI だけ使いたい場合は？**  
A: `devcontainer-quickstart` 後、右ペインのターミナルから `! claude <command>` で実行。

---

## 参考リンク

- [Dotfiles Repository](https://github.com/kosments/dotfiles)
- [VS Code Dev Containers](https://code.visualstudio.com/docs/devcontainers)
- [tmux Manual](https://man.openbsd.org/tmux)
- [Neovim Documentation](https://neovim.io/doc/user/)
- [Claude Code CLI](https://claude.ai/code)
