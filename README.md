# dotfiles

Personal dotfiles — Mac / Windows 共通管理。

## 構成

```
dotfiles/
├── bootstrap/
│   ├── install.sh        # Mac: symlink設定（冪等）
│   ├── install.ps1       # Windows: symlink設定（冪等）
│   ├── brew.sh           # Mac: Brewfileパッケージ一括インストール
│   ├── winget.ps1        # Windows: packages.jsonパッケージ一括インストール
│   └── languages.sh      # Mac: 言語バージョン管理セットアップ
├── shell/
│   ├── zshrc             # Mac (.zshrc)
│   └── profile.ps1       # Windows PowerShellプロファイル
├── config/
│   ├── aws/config        # AWS config（認証情報なし）
│   ├── wezterm/          # Mac ターミナル設定
│   ├── mise/config.toml  # mise設定
│   └── vscode/           # VSCode設定（Windows共有）
├── claude/               # Claude Code設定（共有）
├── .gitconfig            # Git設定（共有）
├── Brewfile              # Mac用パッケージリスト
├── packages.json         # Windows用パッケージリスト（winget）
├── verify.sh             # Mac動作確認
└── verify.ps1            # Windows動作確認
```

---

## Mac セットアップ

### Step 1: Git と Homebrew を入れる（未インストールの場合）

**Git** は Xcode Command Line Tools に含まれます：

```bash
xcode-select --install
```

**Homebrew**:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### Step 2: dotfiles をクローンしてセットアップ

```bash
git clone https://github.com/kosments/dotfiles.git ~/dotfiles
bash ~/dotfiles/bootstrap/install.sh
bash ~/dotfiles/bootstrap/brew.sh
bash ~/dotfiles/bootstrap/languages.sh
```

### Step 3: 動作確認

```bash
bash ~/dotfiles/verify.sh
```

全項目 `✓` になれば完了。

---

## Windows セットアップ

### Step 1: winget を確認する

Windows 10/11 には **winget**（App Installer）が標準搭載されています。

```powershell
winget --version
```

表示されない場合は Microsoft Store で「App Installer」を検索してインストールしてください。

### Step 2: Git をインストールする

```powershell
winget install --id Git.Git -e --silent
```

インストール後、**PowerShell を再起動**してください。

### Step 3: Developer Mode を有効化する（シンボリックリンクに必要）

```powershell
# 設定画面を開く
start ms-settings:developers
```

「開発者モード」を ON にしてください。これにより管理者権限なしでシンボリックリンクを作成できます。

### Step 4: dotfiles をクローンしてセットアップ

```powershell
git clone https://github.com/kosments/dotfiles.git "$HOME\dotfiles"
Set-Location "$HOME\dotfiles"

# 実行ポリシーを一時許可（初回のみ）
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

.\bootstrap\winget.ps1    # パッケージ一括インストール（要再起動の場合あり）
.\bootstrap\install.ps1   # シンボリックリンク設定
```

### Step 5: 動作確認

```powershell
.\verify.ps1
```

全項目 `v` になれば完了。

---

## セットアップ後の手動作業

### Git メールアドレスの設定

`.gitconfig` にメールアドレスは含まれていません。環境ごとにローカルで設定します：

```bash
git config --global user.email "your-email@example.com"
```

### AWS 認証情報

`~/.aws/credentials` は git 管理外です。手動で作成してください：

```
[default]
aws_access_key_id = YOUR_KEY
aws_secret_access_key = YOUR_SECRET
```

### Claude Code ローカル設定

`~/.config/claude/settings.local.json` は環境固有の設定（APIキーなど）を含むため dotfiles 対象外です。必要に応じて手動で作成してください。

---

## 運用ルール

- **編集は `~/dotfiles` 配下で行う** — ホーム直下は symlink のみ
- **秘密情報は含めない** — credentials・APIキー・メールは gitignore 済み
- **`verify.sh` / `verify.ps1` で定期チェック** — 新ツール追加時は verify にも追記する
