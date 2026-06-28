# tmux 完全ガイド（基本編）

**対象**: tmux を初めて使う方、基本操作を知りたい方

---

## 📋 目次

1. [tmux とは](#tmuxとは)
2. [基本操作](#基本操作)
3. [セッション管理](#セッション管理)
4. [ウィンドウ・ペイン管理](#ウィンドウペイン管理)
5. [実践例](#実践例)
6. [よくある操作](#よくある操作)

---

## tmux とは

**tmux** = Terminal Multiplexer（ターミナル多重化ツール）

```
1つのターミナルを複数の「セッション」「ウィンドウ」「ペイン」に分割
→ 複数のコマンドを同時に実行・監視できる
```

### 階層構造

```
セッション (Session)
    └── ウィンドウ (Window) - 1つ以上必須
        └── ペイン (Pane) - 1つ以上必須
```

**例**:
```
Session: my-project-dev
├── Window 0 "editor"
│   ├── Pane 0: nvim
│   └── Pane 1: Claude CLI
└── Window 1 "shell"
    └── Pane 0: zsh
```

---

## 基本操作

### プリフィックスキー

tmux のコマンドは **Ctrl+B** の後にキーを押します

```
Ctrl+B (長押しせず、離す) → キー入力
```

### セッション一覧を表示

```bash
tmux list-sessions
```

または tmux 内で：

```
Ctrl+B s    # セッション一覧を表示
↑↓          # 移動
Enter       # 選択
```

---

## セッション管理

| 操作 | コマンド / キー | 説明 |
|------|-----------------|------|
| **新規作成** | `tmux new-session -s <name>` | セッション作成 |
| **アタッチ** | `tmux attach-session -t <name>` | セッションに接続 |
| **デタッチ** | `Ctrl+B d` | セッションを一時離脱 |
| **セッション一覧** | `tmux list-sessions` | すべてのセッション表示 |
| **セッション削除** | `tmux kill-session -t <name>` | セッション終了 |
| **名前変更** | `Ctrl+B $` | セッション名変更 |

### 実例

```bash
# セッション作成（"work" という名前）
tmux new-session -s work

# 別のセッションを作成
tmux new-session -s debug

# セッション一覧を表示
tmux list-sessions
# 出力:
# debug: 1 windows (created Mon Jun 29 14:30:00 2026)
# work: 1 windows (created Mon Jun 29 14:25:00 2026)

# work セッションにアタッチ
tmux attach-session -t work

# デタッチ（セッションは実行継続）
Ctrl+B d

# セッション削除
tmux kill-session -t work
```

---

## ウィンドウ・ペイン管理

### ウィンドウ操作

| 操作 | キー | 説明 |
|------|------|------|
| **新規ウィンドウ作成** | Ctrl+B c | 新しいウィンドウを作成 |
| **次のウィンドウ** | Ctrl+B n | 次のウィンドウに移動 |
| **前のウィンドウ** | Ctrl+B p | 前のウィンドウに移動 |
| **ウィンドウ一覧** | Ctrl+B w | ウィンドウ一覧を表示 |
| **ウィンドウ削除** | Ctrl+B & | ウィンドウを削除（確認あり） |
| **ウィンドウ名変更** | Ctrl+B , | ウィンドウ名を変更 |
| **特定ウィンドウへ移動** | Ctrl+B <number> | Window 0,1,2... に移動 |

### ペイン操作

| 操作 | キー | 説明 |
|------|------|------|
| **ペイン分割（左右）** | Ctrl+B % | ペインを左右に分割 |
| **ペイン分割（上下）** | Ctrl+B " | ペインを上下に分割 |
| **ペイン移動** | Ctrl+B ← ↑ ↓ → | 方向キーでペイン移動 |
| **ペイン切り替え** | Ctrl+B o | 次のペインに移動 |
| **ペイン削除** | Ctrl+B x | ペインを削除（確認あり） |
| **ペインサイズ調整** | Ctrl+B Ctrl+← ↑ ↓ → | ペインサイズ調整 |
| **ペイン最大化** | Ctrl+B z | ペインをフルスクリーン表示 |

### 実例

```bash
# ウィンドウ 0 で、nvim と Claude CLI を左右に分割

# 1. 新規セッション作成
tmux new-session -s dev -c ~/my-project

# 2. nvim を起動
nvim .

# 3. ペインを左右に分割（40%:60%）
Ctrl+B %

# 4. 右ペインで Claude CLI 準備
Ctrl+B o  # 右ペインに移動
clear
echo "Claude Code CLI ready"

# 5. 別ウィンドウ（ウィンドウ 1）作成
Ctrl+B c

# 6. ウィンドウ 1 をシェル専用に
# すでにシェルなので特に操作不要

# 7. ウィンドウ 0 に戻る
Ctrl+B 0

# 8. ペイン最大化（nvim をフルスクリーン）
Ctrl+B z

# 9. 元に戻す（最大化解除）
Ctrl+B z

# 10. デタッチ
Ctrl+B d

# 11. 後で再度アタッチ
tmux attach-session -t dev
```

---

## ペインのサイズ比率指定

```bash
# 初期から比率を指定して分割
tmux split-window -h -p 40  # 右に 40% のペイン追加（左に 60%）

# 例：デフォルトレイアウト
tmux new-session -s work -d
tmux send-keys -t work "nvim ." Enter
tmux split-window -h -p 40 -t work
tmux send-keys -t work.1 "# Claude CLI ready" Enter
```

---

## 実践例

### シナリオ 1: 開発環境セットアップ

```bash
# 1. セッション作成
tmux new-session -s myapp -c ~/my-app

# 2. nvim でエディター起動
tmux send-keys -t myapp "nvim ." Enter

# 3. 右側にペイン追加（40%）
tmux split-window -h -p 40 -t myapp -c ~/my-app

# 4. 右ペインにメッセージ
tmux send-keys -t myapp.1 "# Terminal for Claude CLI / git / npm" Enter

# 5. アタッチ
tmux attach-session -t myapp
```

画面：
```
┌──────────────────────────────────┬────────────────┐
│ nvim                             │ Terminal       │
│ (60%)                            │ (40%)          │
│                                  │                │
│ [File Explorer]                  │ # Ready        │
│ ├── src/                         │ >              │
│ ├── package.json                 │                │
│ └── README.md                    │                │
└──────────────────────────────────┴────────────────┘
```

### シナリオ 2: マルチウィンドウワークフロー

```bash
# 1. セッション作成
tmux new-session -s dev

# 2. ウィンドウ 0: エディター
tmux send-keys -t dev:0 "nvim ." Enter
tmux split-window -h -p 40 -t dev:0

# 3. ウィンドウ 1: デバッグ・テスト
tmux new-window -t dev:1 -n "debug"
tmux send-keys -t dev:1 "npm test" Enter

# 4. ウィンドウ 2: ログ監視
tmux new-window -t dev:2 -n "logs"
tmux send-keys -t dev:2 "tail -f app.log" Enter

# 5. ウィンドウ 0 に戻る
tmux select-window -t dev:0

# 6. アタッチ
tmux attach-session -t dev
```

操作：
```
Ctrl+B 0  → ウィンドウ 0（エディター + ターミナル）
Ctrl+B 1  → ウィンドウ 1（テスト出力）
Ctrl+B 2  → ウィンドウ 2（ログ監視）
```

---

## よくある操作

### 画面レイアウトを変更

```bash
# 現在のペインレイアウトを表示
Ctrl+B Space

# レイアウトを次に変更（複数回で循環）
Ctrl+B Space

# レイアウトオプション:
# - even-horizontal  (左右均等)
# - even-vertical    (上下均等)
# - main-horizontal  (上に大きく、下に小さく)
# - main-vertical    (左に大きく、右に小さく)
# - tiled            (タイル状)
```

### ペインの内容をコピー

```bash
# コピーモード開始
Ctrl+B [

# テキスト選択（Shift+矢印キー）
Shift+← Shift+↑ Shift+↓ Shift+→

# コピー
Enter

# コピーモード終了
q または Esc
```

### ペイン間のテキスト移動

```bash
# ペイン A でコピー
Ctrl+B [
# 選択＆ Enter でコピー

# ペイン B に移動
Ctrl+B o

# ペースト
Ctrl+B ]
```

### バッファ一覧を表示

```bash
Ctrl+B #
```

---

## キーバインディング一覧（早見表）

| キー | 操作 |
|------|------|
| **Ctrl+B c** | 新ウィンドウ作成 |
| **Ctrl+B n** | 次ウィンドウ |
| **Ctrl+B p** | 前ウィンドウ |
| **Ctrl+B %** | 左右分割 |
| **Ctrl+B "** | 上下分割 |
| **Ctrl+B ←** | ペイン左移動 |
| **Ctrl+B →** | ペイン右移動 |
| **Ctrl+B ↑** | ペイン上移動 |
| **Ctrl+B ↓** | ペイン下移動 |
| **Ctrl+B o** | 次ペイン |
| **Ctrl+B x** | ペイン削除 |
| **Ctrl+B z** | ペイン最大化 |
| **Ctrl+B d** | デタッチ |
| **Ctrl+B s** | セッション一覧 |
| **Ctrl+B w** | ウィンドウ一覧 |
| **Ctrl+B $** | セッション名変更 |
| **Ctrl+B ,** | ウィンドウ名変更 |
| **Ctrl+B [** | コピーモード |
| **Ctrl+B ]** | ペースト |
| **Ctrl+B ?** | キーバインディング表示 |

---

## トラブルシューティング

### Q: ペイン分割ができない

```bash
# セッションが壊れている場合
tmux kill-session -t session-name

# セッション再作成
tmux new-session -s session-name
```

### Q: キーバインディングが効かない

```bash
# Ctrl+B を押してから キーを離す（同時押しではない）
Ctrl+B (離す) → c
```

### Q: バッファサイズが小さい

```bash
# tmux 起動時にサイズ指定
tmux new-session -s work -x 200 -y 50
# -x: 幅, -y: 高さ
```

### Q: セッション一覧が空

```bash
# バックグラウンドで実行中のセッションがあるか確認
tmux list-sessions

# なければ新規作成
tmux new-session -s work
```

---

## 次のステップ

- [nvim 基本ガイド](../nvim/basics.md) — ファイル編集
- [Claude Code CLI ガイド](../claude-cli/usage.md) — AI コマンド実行
- [tmux カスタマイズ](./config.md) — キーバインディングの変更

---

## リファレンス

```bash
# ヘルプを表示
tmux list-commands

# tmux 内でヘルプ
Ctrl+B ?
```
