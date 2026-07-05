# Dotfiles — Portable Terminal & Development Environment

複数マシンで同じターミナル環境を再現するための dotfiles。

**Tech stack**: WezTerm · Zsh · Starship · Neovim · tmux · fzf · ghq

---

## New Machine Setup

```bash
# 1. Clone (~/dotfiles に固定)
git clone https://github.com/kosments/dotfiles.git ~/dotfiles

# 2. セットアップ実行（Homebrew → symlinks → packages → 言語ランタイム）
bash ~/dotfiles/setup.sh
```

`setup.sh` が以下を自動でやってくれる：

| ステップ | 内容 |
|---------|------|
| Homebrew のインストール（未インストール時） | `/bin/bash -c "$(curl ...)` |
| シンボリックリンク作成 | `bootstrap/install.sh` |
| Homebrew パッケージ一括インストール | `bootstrap/brew.sh`（Brewfile 使用） |
| 言語ランタイム | `bootstrap/languages.sh`（Volta/goenv/mise） |
| `~/.zshrc.local` 雛形作成 | `.zshrc.local.example` からコピー |

### setup.sh 完了後にやること

```bash
# 1. ~/.zshrc.local に認証情報・環境固有設定を記入
vi ~/.zshrc.local

# 2. Neovim 設定をクローン（使う場合）
git clone https://github.com/kosments/nvim-config.git ~/.config/nvim

# 3. 新しいシェルを起動
exec zsh
```

### 部分実行（パッケージを後でインストールしたい場合など）

```bash
bash ~/dotfiles/setup.sh --skip-brew       # パッケージインストールをスキップ
bash ~/dotfiles/setup.sh --skip-languages  # 言語ランタイムをスキップ

# 後からでも単体で実行可能
bash ~/dotfiles/bootstrap/install.sh    # symlinks のみ
bash ~/dotfiles/bootstrap/brew.sh       # Homebrew パッケージのみ
bash ~/dotfiles/bootstrap/languages.sh  # 言語ランタイムのみ
```

---

## リポジトリ構成

```
dotfiles/
├── setup.sh                    # ← New Machine Setup はここから
├── Brewfile                    # Homebrew パッケージ一覧
├── bootstrap/
│   ├── install.sh              # シンボリックリンク作成（冪等）
│   ├── brew.sh                 # Brewfile インストール
│   └── languages.sh            # 言語ランタイム（Volta/goenv/mise）
├── shell/
│   ├── zshenv                  # 環境変数（全シェル共通）
│   ├── zshrc                   # メイン初期化・プラグイン
│   ├── aliases.zsh             # 100+ エイリアス
│   ├── functions.zsh           # 20+ ヘルパー関数
│   └── .zshrc.local.example    # ローカル設定テンプレート（git 管理外）
├── config/
│   ├── starship.toml           # Starship プロンプト設定
│   ├── wezterm/                # WezTerm 設定
│   │   ├── wezterm.lua
│   │   ├── keybinds.lua
│   │   └── cheatsheet.md       # wh コマンドで表示
│   ├── mise/config.toml        # mise（多言語バージョン管理）
│   └── aws/config              # AWS CLI 設定
├── claude/                     # Claude Code 設定（~/.config/claude にリンク）
└── docs/
    └── ENVIRONMENTS.md         # 環境別補足（Linux / DevContainer / SSH）
```

---

## シンボリックリンク一覧

`install.sh` が作成するリンクの対応表：

| dotfiles | ホームディレクトリ |
|----------|-----------------|
| `shell/zshenv` | `~/.zshenv` |
| `shell/zshrc` | `~/.zshrc` |
| `.gitconfig` | `~/.gitconfig` |
| `config/starship.toml` | `~/.config/starship.toml` |
| `config/wezterm/` | `~/.config/wezterm/` |
| `config/aws/config` | `~/.aws/config` |
| `config/mise/config.toml` | `~/.config/mise/config.toml` |
| `claude/` | `~/.config/claude/` |
| `claude/CLAUDE.md` | `~/CLAUDE.md` |

---

## ローカル設定（~/.zshrc.local）

git 管理外のファイル。マシン固有の設定・認証情報をここに書く。

```bash
# ~/.zshrc.local の例
export AWS_PROFILE="my-profile"
export GOOGLE_CLOUD_PROJECT="my-gcp-project"
export GITHUB_TOKEN="ghp_..."

# マシン固有エイリアス
alias myproject='cd ~/dev/my-project'
```

テンプレート: `shell/.zshrc.local.example`

---

## プロンプト（Starship）

```
[ …/project ][ branch ✎? ][ ⎈ k8s-context ]     node 22  5s  23:45
❯
```

- 左: ディレクトリ → git ブランチ/差分 → Kubernetes コンテキスト（接続中のみ）
- 右: 言語バージョン（プロジェクトに入ったとき自動表示）→ コマンド実行時間 → 時刻
- AWS / GCloud は常時非表示（プロジェクト作業中のみ手動で確認）

---

## よく使うコマンド

| コマンド | 説明 |
|---------|------|
| `ff` | カレントのファイルを fzf で選択 → nvim で開く |
| `fr` | ghq リポジトリ → ファイル → nvim で開く |
| `Ctrl+]` | ghq リポジトリに fzf でジャンプ |
| `Ctrl+E` | 最近訪問ディレクトリに fzf でジャンプ |
| `wh` | WezTerm チートシートを表示 |

---

## セキュリティ

- 認証情報・API キーは `~/.zshrc.local`（gitignore 済み）に記述
- `~/.aws/credentials`、`~/.kube/config` はリポジトリ管理外
- `.gitignore` でシークレット系ファイルを網羅的に除外済み

---

## トラブルシューティング

```bash
# symlink の確認
readlink ~/.zshrc ~/.zshenv ~/.config/starship.toml

# シェル起動時間の計測
time zsh -i -c exit

# zshrc を再読み込み
exec zsh
```
