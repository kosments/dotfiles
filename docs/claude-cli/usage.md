# Claude Code CLI 完全ガイド

**対象**: Claude Code CLI を初めて使う方、コマンドを知りたい方

---

## 📋 目次

1. [Claude Code CLI とは](#claudecodeCliとは)
2. [セットアップ](#セットアップ)
3. [基本コマンド](#基本コマンド)
4. [DevContainer での使用](#devcontainerでの使用)
5. [実践例](#実践例)
6. [よくある質問](#よくある質問)

---

## Claude Code CLI とは

**Claude Code CLI** = コマンドラインから Claude AI を使用するツール

```
ターミナルから直接 Claude に指示を出して、
コード生成、レビュー、説明、バグ修正などを実行可能
```

### できること

| 用途 | コマンド例 |
|------|----------|
| **コード生成** | `claude code write` |
| **コード確認** | `claude code review` |
| **バグ修正** | `claude code fix` |
| **説明要求** | `claude explain` |
| **テスト生成** | `claude test` |

---

## セットアップ

### 1. インストール

**DevContainer 内（自動）**:
```bash
npm install -g @anthropic-ai/claude-code-cli
```

**ローカル（手動）**:
```bash
# Node.js / npm が必要
node --version    # v20 以上推奨
npm --version     # 10 以上推奨

# インストール
npm install -g @anthropic-ai/claude-code-cli
```

### 2. 認証

```bash
# DevContainer 内のターミナルで
! claude auth login

# または
claude auth login

# → ブラウザで認証画面が開く
# → API キーを入力
# → ローカルに保存される
```

### 3. 動作確認

```bash
claude --version

# または DevContainer ターミナルで
! claude --version
```

---

## 基本コマンド

### ヘルプを表示

```bash
claude --help          # 全コマンド表示
claude code --help     # code コマンドのみ
! claude --help        # DevContainer 内
```

### コマンド構造

```
claude [command] [options] [target]
```

| 部分 | 説明 | 例 |
|------|------|-----|
| **command** | 何をするか | code, explain, test |
| **options** | フラグ | --model, --output |
| **target** | 対象ファイル/パス | ./app.js, src/ |

---

## よく使うコマンド

### 1. コード生成

```bash
# ファイルを作成するよう指示
claude code write "Create a function to validate email addresses"

# または ファイルを指定して生成
claude code generate src/validators.ts
```

### 2. コードレビュー

```bash
# ファイルをレビュー
claude code review src/main.js

# ディレクトリ全体をレビュー
claude code review src/

# 出力をファイルに保存
claude code review src/ --output review.md
```

### 3. バグ修正

```bash
# ファイルの問題を修正
claude code fix src/app.js

# 具体的な問題を指定
claude code fix src/app.js "Fix the error handling in line 42"
```

### 4. 説明要求

```bash
# ファイルの説明
claude explain src/utils.js

# コードの特定部分について
claude explain "function factorial(n) { return n <= 1 ? 1 : n * factorial(n-1); }"
```

### 5. テスト生成

```bash
# テストファイルを生成
claude test src/validators.js

# 特定の関数のテストを生成
claude test src/validators.js --function validateEmail
```

---

## DevContainer での使用

### ターミナルからの実行

**VS Code DevContainer のターミナルで**:

```bash
# VS Code ターミナル内では ! プリフィックス不要
claude code review src/main.js

# または ! を使用しても可
! claude code review src/main.js
```

### tmux との連携

```bash
# tmux セッション内で実行
# 右ペイン（Claude CLI 用）に移動
Ctrl+B o

# コマンド実行
claude code review src/

# 結果を確認
# スクロール: Ctrl+B [ で コピーモード
```

### nvim との連携

**nvim 内から Claude を実行する（外部コマンド）**:

```
:!claude code review %
```

`%` = 現在ファイル

---

## 実践例

### シナリオ 1: ファイルをレビューして修正

```bash
# 1. tmux セッション内（右ペイン）
Ctrl+B o

# 2. ファイルをレビュー
claude code review src/app.js

# 3. 出力を読む
# → 改善提案が表示される

# 4. nvim で該当ファイルを開く（左ペイン）
Ctrl+B o
# または :e src/app.js

# 5. レビューに従って修正

# 6. 修正後、再度レビュー
claude code review src/app.js
```

### シナリオ 2: 新規ファイルを生成

```bash
# 1. 要件を指定して生成
claude code write "Create a REST API endpoint for user login using Express.js"

# 2. 出力内容を確認
# → コード例が表示される

# 3. nvim で新規ファイルを作成
# :e src/routes/auth.js

# 4. 出力コードをコピー・ペースト
# または :read コマンドで直接挿入

# 5. 生成されたコードをレビュー
claude code review src/routes/auth.js
```

### シナリオ 3: テストを自動生成

```bash
# 1. テスト対象ファイルを確認
nvim src/utils.js

# 2. テストを生成
claude test src/utils.js

# 3. 出力内容を確認（テストコード）

# 4. テストファイルを作成
# :e tests/utils.test.js

# 5. 生成されたテストコードを挿入

# 6. テスト実行
! npm test
```

### シナリオ 4: バグ修正

```bash
# 1. エラーが発生したファイルをレビュー
claude code review src/main.js

# 2. 具体的なエラーを指定
claude code fix src/main.js "TypeError: Cannot read properties of undefined"

# 3. 修正案を確認

# 4. nvim で修正（左ペイン）
Ctrl+B o
# :e src/main.js
# 修正内容を適用

# 5. 修正後、実行確認
Ctrl+B 1
npm run dev
```

---

## 出力をファイルに保存

```bash
# レビュー結果をファイル保存
claude code review src/ --output review.md

# テスト生成結果をファイル保存
claude test src/utils.js --output tests/utils.test.js

# 修正提案をファイル保存
claude code fix src/app.js --output fix-suggestions.md
```

---

## モデル・オプション指定

```bash
# モデルを指定（デフォルト: claude-3-sonnet）
claude code review src/ --model claude-3-opus

# 言語を指定
claude code review src/ --language ja

# 詳細出力
claude code review src/ --verbose
```

---

## よくある使用パターン

### パターン 1: コード レビュー → 修正ループ

```bash
# 1. レビュー
claude code review src/

# 2. 結果を確認（ターミナル右ペイン）
# → 問題点を読む

# 3. nvim で修正（左ペイン）
Ctrl+B o

# 4. 修正後、再度レビュー
Ctrl+B 1
claude code review src/

# 5. 問題がなくなるまで繰り返す
```

### パターン 2: 新規機能実装

```bash
# 1. 要件を指定して生成
claude code write "Create a database connection module for PostgreSQL"

# 2. 生成されたコードをコピー
# 3. nvim で新規ファイルを作成
# 4. コードをペースト
# 5. レビューして微調整
# 6. テスト生成
claude test src/db.js
```

### パターン 3: ドキュメント生成

```bash
# コードの説明を生成
claude explain src/complex-algorithm.js > ALGORITHM.md

# READMEの内容を生成
claude code write "Create a comprehensive README.md for a Node.js web server"
```

---

## トラブルシューティング

### Q: `claude: command not found`

```bash
# npm グローバルインストール確認
npm list -g @anthropic-ai/claude-code-cli

# 再インストール
npm install -g @anthropic-ai/claude-code-cli

# DevContainer の場合
npm install -g @anthropic-ai/claude-code-cli
```

### Q: 認証エラー

```bash
# 再度ログイン
claude auth login

# トークンを削除して初期化
rm ~/.claude-code/config.json
claude auth login
```

### Q: 出力が長すぎて見えない

```bash
# ページャーで表示
claude code review src/ | less

# ファイルに保存
claude code review src/ > review.txt

# 最初の N 行のみ表示
claude code review src/ | head -50
```

### Q: DevContainer で `! claude` が効かない

```bash
# claude コマンドが PATH に含まれるか確認
which claude
echo $PATH

# デフォルトシェル確認
echo $SHELL

# 直接実行
/usr/local/bin/claude --version
```

---

## ワークフロー統合例

### 完全な開発ループ

```bash
# 1. tmux セッション起動
devcontainer-quickstart ~/my-project

# → nvim (左) + Claude CLI (右) に分割

# 2. nvim でファイルを開く（左ペイン）
Ctrl+B o
nvim src/app.js

# 3. コードを編集
# i で挿入モード
# <code>
# Esc で終了

# 4. 右ペイン（Claude CLI）に移動
Ctrl+B o

# 5. レビュー
claude code review src/app.js

# 6. 修正が必要なら左ペインで編集
Ctrl+B o

# 7. 再度レビュー
Ctrl+B o
claude code review src/app.js

# 8. OK なら別ウィンドウでテスト実行
Ctrl+B 1
npm test

# 9. 完了
```

---

## 次のステップ

- [tmux 基本ガイド](../tmux/basics.md) — ターミナル分割・マルチタスク
- [nvim 基本ガイド](../nvim/basics.md) — ファイル編集・操作
- [QUICK_START_CLI](../QUICK_START_CLI.md) — 統合ワークフロー

---

## リファレンス

```bash
# ローカル help
claude --help

# オンラインドキュメント
https://claude.ai/code

# バージョン確認
claude --version

# API キー設定
export ANTHROPIC_API_KEY="sk-..."
```

---

## API キー管理（セキュリティ）

### .zshrc.local に設定

```bash
# ~/.zshrc.local
export ANTHROPIC_API_KEY="${ANTHROPIC_API_KEY:-}"

# または claude auth login で自動設定
```

### 秘密を保護

```bash
# .gitignore に含める
.claude-code/
.anthropic-key
```

**重要**: API キーを git にコミットしない！
