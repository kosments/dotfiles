# WezTerm + nvim + Claude Code チートシート

> `wh` でこの画面を表示 | Leader = `Ctrl+Q`（離してから次のキーを押す）

---

## ファイル・リポジトリ移動（fzf + ghq）

| 操作 | キー/コマンド |
|------|------|
| ghqリポジトリ一覧 → cdでジャンプ | `Ctrl+]` |
| カレントのファイルを選択 → nvimで開く | `ff` |
| リポジトリ選択 → ファイル選択 → nvimで開く | `fr` |
| ファイルをCLIに貼り付け | `Ctrl+T` |
| サブディレクトリにジャンプ | `Alt+C` |
| 最近訪問したディレクトリにジャンプ | `Ctrl+E` |
| 履歴をfzfで検索 | `Ctrl+R` |

### nvim の終了

| 操作 | キー |
|------|------|
| 閉じる（変更なし） | `Esc` → `:q` → `Enter` |
| 保存して閉じる | `Esc` → `:wq` → `Enter` |
| 強制終了（変更破棄） | `Esc` → `:q!` → `Enter` |
| 保存して終了（ショートカット） | `ZZ` |

---

## ペイン操作

| 操作 | キー |
|------|------|
| 右に分割（左右） | `Cmd+D` または `Leader r` |
| 下に分割（上下） | `Cmd+Shift+D` または `Leader d` |
| 左30%にエクスプローラーを開く | `Leader f` |
| ペインを閉じる | `Leader x` |
| 左ペインへ | `Leader h` |
| 右ペインへ | `Leader l` |
| 上ペインへ | `Leader k` |
| 下ペインへ | `Leader j` |
| ペイン選択（番号） | `Ctrl+Shift+[` |
| ズーム（全画面化/解除） | `Leader z` |
| サイズ調整モード | `Leader s` → `h/j/k/l` → `Enter` で終了 |
| 前後のプロンプトへスクロール | `Shift+↑` / `Shift+↓` |
| 単語単位カーソル移動 | `Meta+←` / `Meta+→` |

---

## タブ操作

| 操作 | キー |
|------|------|
| 新しいタブ | `Cmd+T` |
| タブを閉じる | `Cmd+W` |
| 次のタブ | `Ctrl+Tab` |
| 前のタブ | `Ctrl+Shift+Tab` |
| タブ番号指定 | `Cmd+1〜9` |
| タブを左/右に移動 | `Leader {` / `Leader }` |

---

## Workspace（プロジェクト単位）

| 操作 | キー |
|------|------|
| Workspace一覧・切り替え | `Leader w` |
| Workspace新規作成 | `Leader Shift+W` |
| Workspace名変更 | `Leader $` |

---

## コピー・貼り付け

| 操作 | キー |
|------|------|
| コピー | `Cmd+C` |
| 貼り付け | `Cmd+V` |
| コピーモード（vim操作） | `Leader [` → `v`で選択 → `y`でコピー → `Esc`で終了 |
| コマンド出力を丸ごと選択 | トリプルクリック |

---

## その他

| 操作 | キー |
|------|------|
| コマンドパレット | `Cmd+P` |
| 設定再読み込み | `Ctrl+Shift+R` |
| フォント拡大/縮小/リセット | `Cmd++` / `Cmd+-` / `Cmd+0` |
| フルスクリーン切り替え | `Alt+Enter` |

---

## Claude Code セッション起動

```bash
# 右40%にclaudeを起動（WezTermペイン分割込み）
cc-dev ~/dev/02_repos/some-repo ~/dev/01_task/20260705_task

# Leader+e でインタラクティブ起動
# Ctrl+Q → e → "~/dev/02_repos/some-repo ~/dev/01_task/task"

# ペイン分割なしでclaudeだけ起動
cc ~/dev/02_repos/some-repo
```

---

## nvim でのパスコピー

| 操作 | キー |
|------|------|
| ファイルパスをクリップボードにコピー | `\cp` |
| ディレクトリパスをクリップボードにコピー | `\cd` |

コピー後: `Leader l` で右ペイン → `Cmd+V` で貼り付け

---

## 典型的なワークフロー

```
# パターン A: リポジトリ移動 → ファイルを開く
Ctrl+]          # ghqリポジトリ選択 → cd
ff              # ファイル選択 → nvim起動
Esc :q Enter    # nvim終了

# パターン B: ワンショットでリポジトリ＋ファイルを開く
fr              # リポジトリ選択 → ファイル選択 → nvim起動

# パターン C: VS Code風レイアウト
Leader f        # 左30%にnvimエクスプローラー
Cmd+D           # 右に作業用シェル追加
Leader e        # claudeセッション起動
```
