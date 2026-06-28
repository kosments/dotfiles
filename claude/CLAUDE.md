# プロジェクト作業ガイド

## rule

- 会話を始めたら `dev/01_task/` 配下に作業フォルダを作成し、会話の内容をサマリーしたMarkdownを簡潔に作成・更新する。
- 作業フォルダ名の先頭日付は `yyyymmdd` 形式にする（例: `20260516_cursor_cli`）。`yyyy-mm-dd` や `yyyymmdd-` など他形式は使わない。
- token消費効率を考慮して、適宜コンテキストのコンパクト化を行う。
- 主に更新する頻度が高いリポジトリは以下。
  - 技術と雑記のブログ: `~/dev/02_repos/life-mng-repo/blog-for-kos`
  - ポートフォリオやqiita,zennの記事,検証資源: `~/dev/02_repos/life-mng-repo/life-mng`
  - 運営準備中の学習サイト: `~/dev/02_repos/life-mng-repo/coding-learning`
  - うさぎの体調管理アプリ: `~/dev/02_repos/rabbit-health-mng-repo/rabbit-health-mng`
- 上記のリポジトリのコード修正を勝手に行わない。明示的に依頼があったら行う。
- 日々のタスクは、`https://github.com/kosments/life-mng/issues`で管理する。日々のタスクについて言及があれば、リモートのissueを参照して、todoやinprogress,pending,doneなどの一覧を提示しつつ、今日のタスクを尋ねたり、昨日までのタスクで進捗更新がないか確認する。

## プロジェクト概要

- このリポジトリは dotfiles 管理リポジトリ。シェル設定、エディタ設定、スクリプト、ドキュメントを管理。
- 作業前に該当ディレクトリのREADME、既存の実装、直近の差分を確認する。
- 依頼内容と無関係なファイルは変更しない。

### Shell 設定ポリシー

#### ファイル構成（Tier 1 & 2）
- **`.zshenv`** (環境変数): XDG Base Directory、エディタ、PATH 設定
- **`.zshrc`** (メイン初期化): オプション、プラグイン、source statements のみ
- **`aliases.zsh`** (エイリアス): 100+ aliases（gcloud, kubectl, terraform, aws, git, glab等）
- **`functions.zsh`** (関数): peco-*, K8s/GCP/AWS/Terraform ヘルパー、ユーティリティ
- **`completion.zsh`** (補完設定): 将来移動予定（現在 .zshrc に含む）
- **`.zshrc.local`** (ローカル秘密情報): gitignore'd、マシン固有設定・認証情報

#### セキュリティモデル
- 秘密情報（API キー、トークン、認証情報）は `.zshrc.local` に記述（gitignore'd）
- 各マシンで独立して管理、リポジトリには含めない
- テンプレート `.zshrc.local.example` で新規セットアップを支援

#### パフォーマンス
- Lazy load で起動時間最適化（3.0s → 0.3-0.6s）
- Version manager init は初回使用時のみ（rbenv/pyenv/goenv）
- Compinit キャッシュ使用（~/.cache/zsh/zcompdump）

#### 技術スタック対応
- **Cloud**: GCP (gcloud, gke), AWS (aws, cdk, awscli-local)
- **Container**: Kubernetes (kubectl, kind, minikube), Docker, Podman
- **IaC**: Terraform, CDK
- **VCS**: Git, GitLab (glab), GitHub
- **Monitoring**: New Relic, Sysdig, Prometheus/AlertManager
- **CDN**: Akamai, Fastly
- **Observability**: gcloud logging, CloudWatch等

#### 参考リポジトリ
- radleylewis/zsh (Tier 1 で参考)
- ユーザーカスタマイズによる Tier 2 実装（本リポジトリ）

#### コメント方針
- 日本語・英語両言語対応（[JP]、[EN] タグで区分）
- 各セクションに役割、意図、効果を明記
- 将来メンテナ（or 将来の自分）が理解できるように詳細記述

## 基本コマンド

- 依存関係の確認: `npm install` / `pnpm install` / `mise install`
- Lint: `npm run lint`
- Test: `npm test`
- 型チェック: `npm run typecheck`
- Git状態確認: `git status --short`

## 作業の進め方

- 作業フォルダには、作業概要、判断、未解決事項、実行コマンドをまとめるMarkdownを置く。
- 長い作業では、進捗に合わせて概要Markdownを更新する。
- 図解が有効な場合は、Mermaid、draw.io SVG、PlantUMLなどを使って構成図、WBS、フロー図を追加する。
- 複数の作業フォルダを扱う場合は、進捗サマリーMarkdownも更新する。
- 進捗サマリーは、作業フォルダ名、概要、進捗、優先度、次アクションを列に持つ表にする。
- 表の後に、各行の補足説明を見出しまたは番号付きでまとめる。

## Git / PR / MR

- リポジトリ更新を伴う場合は、作業開始前に `git fetch` と必要に応じた `git pull` を行う。
- コンフリクトが発生した場合は、内容を確認して解消方針をまとめる。
- ブランチ名、PR名、MR名には、指定があればチケット番号やIssue番号を含める。
- 特別な指定がなければ、コミット、push、PR/MR作成まで進める。
- 既存の未コミット変更がある場合は、依頼対象かどうかを確認し、無関係な変更は触らない。

## セキュリティ

- `.env`、秘密鍵、認証情報、個人情報を不用意に読み取らない。
- `terraform apply`、`kubectl delete`、本番DB更新など影響の大きい操作は、明示的な承認なしに実行しない。
- npmなどで新しい依存関係を入れる場合は、パッケージ名、メンテナンス状況、ダウンロード元、既知のリスクを確認する。
- 必要なツールは、Homebrew、WinGet、Chocolatey、mise、Nix、npmなど、プロジェクトに合うパッケージ管理ツール経由で導入する。
