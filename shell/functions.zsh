# ============================================================
# Zsh Functions (functions.zsh)
# ============================================================
# [JP] 複雑な処理、引数処理が必要な操作を関数として定義
# [EN] Define complex operations and interactive functions
#
# Structure:
#   - Navigation functions (peco-based)
#   - Kubernetes helpers
#   - Cloud platform utilities
#   - Git helpers
#   - Development utilities
#
# Note: Load via: source "$ZDOTDIR/functions.zsh" in .zshrc

# ============================================================
# Navigation Functions (Peco-based)
# ============================================================

# [JP] Ctrl+R: 重複削除したhistoryをfuzzy検索
# [EN] Ctrl+R: Fuzzy search history with deduplication
function peco-history-selection() {
  BUFFER=`history -n 1 | tac | awk '!a[$0]++' | peco`
  CURSOR=$#BUFFER
  zle reset-prompt
}
zle -N peco-history-selection
bindkey '^R' peco-history-selection

# [JP] Ctrl+E: 最近訪問したディレクトリにジャンプ
# [EN] Ctrl+E: Jump to recently visited directory
function peco-cdr () {
  local selected_dir="$(cdr -l | sed 's/^[0-9]* *//' | peco)"
  if [ -n "$selected_dir" ]; then
    BUFFER="cd ${selected_dir}"
    zle accept-line
  fi
}
zle -N peco-cdr
bindkey '^E' peco-cdr

# [JP] Ctrl+X: カレントディレクトリ以下のディレクトリを検索してcd
# [EN] Ctrl+X: Find and cd into subdirectory
function find_cd() {
  local selected_dir=$(find . -type d | peco)
  if [ -n "$selected_dir" ]; then
    BUFFER="cd ${selected_dir}"
    zle accept-line
  fi
}
zle -N find_cd
bindkey '^X' find_cd

# [JP] Ctrl+G: ghqで管理されているGitリポジトリにジャンプ
# [EN] Ctrl+G: Jump to ghq-managed Git repository
function peco-src () {
  local selected_dir=$(ghq list -p | peco)
  if [ -n "$selected_dir" ]; then
    BUFFER="cd ${selected_dir}"
    zle accept-line
  fi
}
zle -N peco-src
bindkey '^G' peco-src

# ============================================================
# Kubernetes Helpers
# ============================================================

# [JP] k-pod: Podを対話的に選択してシェル接続
# [EN] k-pod: Interactively select pod and enter shell
function k-pod-shell() {
  local pod=$(kubectl get pods -o name | sed 's|.*/||' | peco)
  if [ -z "$pod" ]; then
    echo "[JP] Pod が選択されていません"
    echo "[EN] No pod selected"
    return 1
  fi
  kubectl exec -it "$pod" -- /bin/sh
}

# [JP] k-logs: Podのログをストリーム表示
# [EN] k-logs: Stream pod logs
function k-logs-follow() {
  local pod=$(kubectl get pods -o name | sed 's|.*/||' | peco)
  if [ -z "$pod" ]; then
    echo "[JP] Pod が選択されていません"
    echo "[EN] No pod selected"
    return 1
  fi
  kubectl logs -f "$pod"
}

# [JP] k-resource-usage: ノード・Podのリソース使用状況表示
# [EN] k-resource-usage: Show resource usage (nodes and pods)
function k-resource-usage() {
  echo "[JP] === ノードリソース ==="
  echo "[EN] === Node Resources ==="
  kubectl top nodes
  echo ""
  echo "[JP] === Pod リソース ==="
  echo "[EN] === Pod Resources ==="
  kubectl top pods --all-namespaces | head -20
}

# [JP] k-context: Kubernetesコンテキストを対話的に切り替え
# [EN] k-context: Interactively switch Kubernetes context
function k-context() {
  local context=$(kubectl config get-contexts -o name | peco)
  if [ -z "$context" ]; then
    echo "[JP] コンテキストが選択されていません"
    echo "[EN] No context selected"
    return 1
  fi
  kubectl config use-context "$context"
  echo "[JP] コンテキスト切り替え: $context"
  echo "[EN] Switched to context: $context"
}

# ============================================================
# Git Helpers
# ============================================================

# [JP] git-branch-cleanup: ローカルブランチを削除
# [EN] git-branch-cleanup: Delete local branches
function git-branch-cleanup() {
  echo "[JP] マージ済みブランチを削除します"
  echo "[EN] Deleting merged branches..."
  git branch --merged | grep -v '\*' | xargs -n 1 git branch -d
  echo "[JP] 完了"
  echo "[EN] Done"
}

# [JP] git-sync-fork: Fork リポジトリを upstream と同期
# [EN] git-sync-fork: Sync fork with upstream
function git-sync-fork() {
  if ! git remote get-url upstream &>/dev/null; then
    echo "[JP] upstream リモートが設定されていません"
    echo "[EN] upstream remote not configured"
    return 1
  fi

  git fetch upstream
  git checkout main 2>/dev/null || git checkout master
  git merge upstream/main 2>/dev/null || git merge upstream/master
  git push origin

  echo "[JP] Fork を同期しました"
  echo "[EN] Fork synced"
}

# [JP] git-rebase-interactive: 過去N個のコミットを対話的にrebase
# [EN] git-rebase-interactive: Interactive rebase last N commits
function git-rebase-interactive() {
  if [ -z "$1" ]; then
    echo "[JP] 使用方法: git-rebase-interactive <n>"
    echo "[EN] Usage: git-rebase-interactive <n>"
    return 1
  fi
  git rebase -i HEAD~$1
}

# ============================================================
# GCP Helpers
# ============================================================

# [JP] gcp-project: GCP プロジェクトを対話的に切り替え
# [EN] gcp-project: Interactively switch GCP project
function gcp-project() {
  local project=$(gcloud projects list --format='value(project_id)' | peco)
  if [ -z "$project" ]; then
    echo "[JP] プロジェクトが選択されていません"
    echo "[EN] No project selected"
    return 1
  fi
  gcloud config set project "$project"
  echo "[JP] プロジェクトを切り替えました: $project"
  echo "[EN] Switched to project: $project"
}

# [JP] gke-get-credentials: GKE クラスタに認証情報を取得して接続
# [EN] gke-get-credentials: Get GKE cluster credentials and connect
function gke-connect() {
  local cluster=$(gcloud container clusters list --format='value(name)' | peco)
  if [ -z "$cluster" ]; then
    echo "[JP] クラスタが選択されていません"
    echo "[EN] No cluster selected"
    return 1
  fi

  local zone=$(gcloud container clusters list --filter="name:$cluster" --format='value(location)')
  gcloud container clusters get-credentials "$cluster" --zone "$zone"
  echo "[JP] クラスタに接続しました: $cluster (zone: $zone)"
  echo "[EN] Connected to cluster: $cluster (zone: $zone)"
}

# [JP] gke-port-forward: GKE Pod にポートフォワード
# [EN] gke-port-forward: Port forward to GKE pod
function gke-port-forward() {
  local pod=$(kubectl get pods -o name | sed 's|.*/||' | peco)
  if [ -z "$pod" ]; then
    echo "[JP] Pod が選択されていません"
    echo "[EN] No pod selected"
    return 1
  fi

  local local_port=${1:-8080}
  local remote_port=${2:-8080}

  kubectl port-forward pod/"$pod" "$local_port:$remote_port"
}

# ============================================================
# AWS Helpers
# ============================================================

# [JP] aws-profile: AWS プロファイルを対話的に切り替え
# [EN] aws-profile: Interactively switch AWS profile
function aws-profile() {
  local profile=$(grep '\[' ~/.aws/config | sed 's/\[//g' | sed 's/\]//g' | peco)
  if [ -z "$profile" ]; then
    echo "[JP] プロファイルが選択されていません"
    echo "[EN] No profile selected"
    return 1
  fi
  export AWS_PROFILE="$profile"
  echo "[JP] AWS プロファイルを切り替えました: $profile"
  echo "[EN] Switched to AWS profile: $profile"
}

# [JP] aws-region: AWS リージョンを対話的に切り替え
# [EN] aws-region: Interactively switch AWS region
function aws-region() {
  local region=$(aws ec2 describe-regions --query 'Regions[].RegionName' --output text | tr '\t' '\n' | peco)
  if [ -z "$region" ]; then
    echo "[JP] リージョンが選択されていません"
    echo "[EN] No region selected"
    return 1
  fi
  export AWS_REGION="$region"
  echo "[JP] AWS リージョンを切り替えました: $region"
  echo "[EN] Switched to AWS region: $region"
}

# ============================================================
# Terraform Helpers
# ============================================================

# [JP] tf-plan-review: terraform plan の結果を確認して apply
# [EN] tf-plan-review: Review plan and confirm before apply
function tf-plan-review() {
  echo "[JP] Terraform plan を実行しています..."
  echo "[EN] Running terraform plan..."

  terraform plan -out=tfplan

  echo "[JP] Plan を確認してください。続行しますか？ (yes/no)"
  echo "[EN] Review the plan above. Continue? (yes/no)"
  read -r response

  if [ "$response" = "yes" ]; then
    terraform apply tfplan
    rm tfplan
    echo "[JP] Apply が完了しました"
    echo "[EN] Apply completed"
  else
    rm tfplan
    echo "[JP] キャンセルしました"
    echo "[EN] Cancelled"
  fi
}

# [JP] tf-workspace: Terraform ワークスペースを対話的に切り替え
# [EN] tf-workspace: Interactively switch Terraform workspace
function tf-workspace() {
  local workspace=$(terraform workspace list | grep -v '\*' | awk '{print $1}' | peco)
  if [ -z "$workspace" ]; then
    echo "[JP] ワークスペースが選択されていません"
    echo "[EN] No workspace selected"
    return 1
  fi
  terraform workspace select "$workspace"
  echo "[JP] ワークスペースを切り替えました: $workspace"
  echo "[EN] Switched to workspace: $workspace"
}

# ============================================================
# Docker Helpers
# ============================================================

# [JP] docker-cleanup: 未使用のイメージ・コンテナを削除
# [EN] docker-cleanup: Remove unused images and containers
function docker-cleanup() {
  echo "[JP] 停止済みコンテナを削除..."
  echo "[EN] Removing stopped containers..."
  docker container prune -f

  echo "[JP] ダングリングイメージを削除..."
  echo "[EN] Removing dangling images..."
  docker image prune -f

  echo "[JP] クリーンアップ完了"
  echo "[EN] Cleanup complete"
}

# [JP] docker-shell: コンテナを対話的に選択してシェル接続
# [EN] docker-shell: Interactively select container and enter shell
function docker-shell() {
  local container=$(docker ps --format '{{.Names}}' | peco)
  if [ -z "$container" ]; then
    echo "[JP] コンテナが選択されていません"
    echo "[EN] No container selected"
    return 1
  fi
  docker exec -it "$container" /bin/sh
}

# ============================================================
# Utility Functions
# ============================================================

# [JP] extract: 複数の圧縮形式に対応した解凍関数
# [EN] extract: Universal decompression function
function extract() {
  if [ -z "$1" ]; then
    echo "[JP] 使用方法: extract <file>"
    echo "[EN] Usage: extract <file>"
    return 1
  fi

  case "$1" in
    *.tar.gz|*.tgz) tar xzf "$1" ;;
    *.tar.bz2|*.tbz2) tar xjf "$1" ;;
    *.tar.xz) tar xJf "$1" ;;
    *.zip) unzip "$1" ;;
    *.rar) unrar x "$1" ;;
    *.7z) 7z x "$1" ;;
    *) echo "[JP] 未対応の形式です" && echo "[EN] Unsupported format" && return 1 ;;
  esac
}

# [JP] mkcd: ディレクトリを作成して移動
# [EN] mkcd: Create directory and cd into it
function mkcd() {
  mkdir -p "$1" && cd "$1"
}

# [JP] chpwd-profile: ディレクトリ移動時にプロファイル自動読み込み
# [EN] chpwd-profile: Auto-load profile when entering directory
function chpwd-profile() {
  if [ -f ".zshrc.local.directory" ]; then
    source ".zshrc.local.directory"
    echo "[JP] ディレクトリプロファイルを読み込みました"
    echo "[EN] Loaded directory profile"
  fi
}
# Auto-call on directory change
add-zsh-hook chpwd chpwd-profile

# ============================================================
# Development Helpers
# ============================================================

# [JP] update-all: 主要なツールをアップデート
# [EN] update-all: Update all major tools
function update-all() {
  echo "[JP] Homebrew をアップデート..."
  echo "[EN] Updating Homebrew..."
  brew update && brew upgrade

  if command -v npm >/dev/null; then
    echo "[JP] npm をアップデート..."
    echo "[EN] Updating npm..."
    npm install -n pm2 -g
  fi

  if command -v pip >/dev/null; then
    echo "[JP] pip をアップデート..."
    echo "[EN] Updating pip..."
    pip install --upgrade pip
  fi

  echo "[JP] アップデート完了"
  echo "[EN] Update complete"
}

# ============================================================
# End of functions.zsh
# ============================================================
