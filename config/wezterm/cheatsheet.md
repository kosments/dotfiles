# WezTerm + nvim + Claude Code チートシート

> `wh` でこの画面を表示 | Leader = `Ctrl+Q`

---

## ペイン操作

| 操作 | キー |
|------|------|
| 右に分割（左右） | `Cmd+D` または `Leader r` |
| 下に分割（上下） | `Cmd+Shift+D` または `Leader d` |
| ペインを閉じる | `Leader x` |
| 左ペインへ | `Leader h` |
| 右ペインへ | `Leader l` |
| 上ペインへ | `Leader k` |
| 下ペインへ | `Leader j` |
| ペイン選択（番号） | `Ctrl+Shift+[` |
| ズーム（全画面化） | `Leader z` |
| サイズ調整モード | `Leader s` → `h/j/k/l` → `Enter` で終了 |

## タブ操作

| 操作 | キー |
|------|------|
| 新しいタブ | `Cmd+T` |
| タブを閉じる | `Cmd+W` |
| 次のタブ | `Ctrl+Tab` |
| 前のタブ | `Ctrl+Shift+Tab` |
| タブ番号指定 | `Cmd+1〜9` |

## Workspace（プロジェクト単位）

| 操作 | キー |
|------|------|
| Workspace一覧・切り替え | `Leader w` |
| Workspace新規作成 | `Leader Shift+W` |
| Workspace名変更 | `Leader $` |

## コピー・貼り付け

| 操作 | キー |
|------|------|
| コピー | `Cmd+C` |
| 貼り付け | `Cmd+V` |
| コピーモード（vim操作） | `Leader [` → `v`で選択 → `y`でコピー → `Esc`で終了 |

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
# 一発セットアップ（右40%にclaudeを起動、左でnvimを開く）
cc-dev ~/dev/02_repos/some-repo ~/dev/01_task/20260705_task

# または WezTermから: Leader+e でインタラクティブ起動
# Ctrl+Q → e → "~/dev/02_repos/some-repo ~/dev/01_task/20260705_task"

# ペイン分割なしでclaudeだけ起動
cc ~/dev/02_repos/some-repo ~/dev/01_task/20260705_task
```

## nvim でのパスコピー

| 操作 | キー |
|------|------|
| ファイルパスをクリップボードにコピー | `\cp` |
| ディレクトリパスをクリップボードにコピー | `\cd` |

コピー後: `Leader l` で右ペイン → `Cmd+V` で貼り付け
