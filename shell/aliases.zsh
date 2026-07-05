# ============================================================
# Zsh Aliases (.aliases)
# ============================================================
# [JP] よく使用するコマンドの短縮形を定義
# [EN] Define shortcuts for frequently used commands
#
# Structure:
#   - Core utilities (ls, cat, grep, etc.)
#   - Git & Version Control
#   - Cloud platforms (GCP, AWS)
#   - Container & Kubernetes
#   - Infrastructure as Code (Terraform, CDK)
#   - Monitoring & Observability
#   - Development tools
#
# Note: Load via: source "$ZDOTDIR/aliases.zsh" in .zshrc

# ============================================================
# Core Utilities
# ============================================================

# [JP] ls: eza に置き換え（アイコン・カラー対応）
# [EN] ls: Replace with eza (icon and color support)
alias ls='eza --icons'
alias ll='eza -lh --icons --git'
alias la='eza -lah --icons --git'
alias tree='eza --tree --icons'
# compdef eza=ls  # [DEBUG] Commented out: causes zsh completion error

# [JP] cat: bat に置き換え（シンタックスハイライト）
# [EN] cat: Replace with bat (syntax highlighting)
alias cat='bat'

# [JP] grep: ripgrep に置き換え（カラー対応、高速）
# [EN] grep: Replace with ripgrep (color, faster)
alias grep='rg --color=auto'

# [JP] diff: カラー対応
# [EN] diff: Enable colors
alias diff='diff --color=auto'

# [JP] ディスク容量表示
# [EN] Disk usage with human-readable format
alias df='df -h'

# [JP] ディレクトリ移動履歴
# [EN] Go to previous directory
alias -- -='cd -'

# ============================================================
# Git & Version Control
# ============================================================
# [JP] Git エイリアス
# [EN] Git shortcuts

# [JP] ステータス確認
# [EN] Status
alias gst='git status'

# [JP] ブランチ操作
# [EN] Branch operations
alias gb='git branch'
alias gbv='git branch -v'
alias gco='git checkout'
alias gcob='git checkout -b'

# [JP] ステージング・コミット
# [EN] Staging and commit
alias ga='git add'
alias gaa='git add -A'
alias gc='git commit -m'
alias gca='git commit -am'
alias gcaa='git commit --amend --no-edit'

# [JP] プッシュ・プル
# [EN] Push and pull
alias gpush='git push'
alias gpull='git pull'
alias gfetch='git fetch'

# [JP] ログ表示（シンプル）
# [EN] Log display (simple)
alias glog='git log --oneline'
alias gloga='git log --oneline --all'
alias glogd='git log --oneline -10'  # Last 10 commits

# [JP] ログ表示（詳細グラフ）
# [EN] Log display (detailed graph)
alias gadog='PAGER="less -F -X" git log --all --decorate --oneline --graph'

# [JP] 変更差分表示
# [EN] Show changes
alias gdiff='git diff'
alias gdiffc='git diff --cached'

# [JP] リセット・クリーンアップ
# [EN] Reset and cleanup
alias greset='git reset --soft HEAD~1'
alias gclean='git clean -fd'

# [JP] Stash 操作
# [EN] Stash operations
alias gst='git stash'  # Conflict with `gst` (status) - handled in functions.zsh
alias gstp='git stash pop'
alias gstl='git stash list'

# ============================================================
# GitLab (glab)
# ============================================================
# [JP] GitLab CLI
# [EN] GitLab CLI shortcuts

alias glb='glab'
alias glmr='glab mr list'
alias glmrv='glab mr view'
alias glmrc='glab mr create'
alias glmrm='glab mr merge'
alias glpi='glab issue list'
alias glpic='glab issue create'

# ============================================================
# Google Cloud (gcloud, gke)
# ============================================================
# [JP] Google Cloud Platform エイリアス
# [EN] GCP shortcuts

# [JP] gcloud 基本
# [EN] gcloud basics
alias gcl='gcloud'
alias gci='gcloud info'
alias gcconfig='gcloud config list'

# [JP] GCP プロジェクト操作
# [EN] GCP project management
alias gcp='gcloud config get-value project'
alias gcps='gcloud config set project'

# [JP] GCE (Compute Engine)
# [EN] GCE instances
alias gce='gcloud compute instances'
alias gcelist='gcloud compute instances list'

# [JP] GKE (Kubernetes Engine)
# [EN] GKE clusters
alias gke='gcloud container clusters'
alias gkelist='gcloud container clusters list'
alias gkecreds='gcloud container clusters get-credentials'

# [JP] Cloud Storage
# [EN] Cloud Storage buckets
alias gcs='gsutil'
alias gcsls='gsutil ls'

# [JP] Cloud Logging
# [EN] Cloud Logs
alias gclogs='gcloud logging read'

# ============================================================
# AWS
# ============================================================
# [JP] AWS CLI エイリアス
# [EN] AWS CLI shortcuts

alias awscli='aws'
alias awsx='aws --version'

# [JP] EC2 操作
# [EN] EC2 instances
alias ec2list='aws ec2 describe-instances'
alias ec2start='aws ec2 start-instances'
alias ec2stop='aws ec2 stop-instances'

# [JP] S3 操作
# [EN] S3 buckets
alias s3ls='aws s3 ls'
alias s3cp='aws s3 cp'

# [JP] IAM 確認
# [EN] IAM info
alias iamlist='aws iam list-users'
alias iamget='aws iam get-user'

# ============================================================
# Kubernetes (kubectl, kind, minikube)
# ============================================================
# [JP] Kubernetes コマンド短縮形
# [EN] Kubernetes shortcuts

# [JP] kubectl 基本
# [EN] kubectl basics
alias k='kubectl'
alias kg='kubectl get'
alias kd='kubectl describe'
alias ka='kubectl apply'
alias kdel='kubectl delete'
alias kl='kubectl logs'
alias kex='kubectl exec -it'
alias kpf='kubectl port-forward'

# [JP] リソース別エイリアス
# [EN] Resource-specific aliases
alias kgp='kubectl get pods'
alias kgn='kubectl get nodes'
alias kgs='kubectl get svc'
alias kgi='kubectl get ingress'
alias kgd='kubectl get deployment'
alias kgss='kubectl get statefulset'

# [JP] デバッグ・トラブルシューティング
# [EN] Debugging and troubleshooting
alias kdp='kubectl describe pod'
alias kddn='kubectl describe node'
alias kldp='kubectl logs -f'  # Follow logs

# [JP] Kind (ローカル Kubernetes)
# [EN] Kind (local Kubernetes)
alias kind='kind'
alias kindcreate='kind create cluster --name'
alias kinddelete='kind delete cluster --name'

# [JP] Minikube
# [EN] Minikube
alias minikube='minikube'
alias mkstart='minikube start'
alias mkstop='minikube stop'

# ============================================================
# Terraform
# ============================================================
# [JP] Terraform コマンド短縮形
# [EN] Terraform shortcuts

alias tf='terraform'
alias tfa='terraform apply'
alias tfp='terraform plan'
alias tfd='terraform destroy'
alias tfv='terraform validate'
alias tfmt='terraform fmt'
alias tfstate='terraform state'
alias tfoutput='terraform output'

# [JP] Terraform ワークスペース
# [EN] Terraform workspace
alias tfws='terraform workspace'
alias tfwsl='terraform workspace list'
alias tfwss='terraform workspace select'

# ============================================================
# Docker & Container
# ============================================================
# [JP] Docker エイリアス
# [EN] Docker shortcuts

alias d='docker'
alias dps='docker ps'
alias dpsa='docker ps -a'
alias di='docker images'
alias dlog='docker logs'
alias dlogf='docker logs -f'
alias dex='docker exec -it'
alias drm='docker rm'
alias drmi='docker rmi'

# [JP] Docker Compose
# [EN] Docker Compose
alias dc='docker-compose'
alias dcup='docker-compose up'
alias dcdn='docker-compose down'
alias dclogs='docker-compose logs'

# [JP] Podman (Docker 互換）
# [EN] Podman (Docker compatible)
alias pod='podman'
alias podps='podman ps'
alias podi='podman images'

# ============================================================
# Monitoring & Observability
# ============================================================
# [JP] 監視・可観測性ツール
# [EN] Monitoring and observability tools

# [JP] New Relic
# [EN] New Relic
alias nr='newrelic'
alias nrl='newrelic nrql query'

# [JP] Sysdig (カーネルレベル監視)
# [EN] Sysdig (kernel-level monitoring)
alias sd='sysdig'
alias sdtop='sysdig -c topprocs_net'
alias sdcsysdig='sysdig -c spy_sockets'

# [JP] Prometheus/AlertManager
# [EN] Prometheus/AlertManager (when local)
# alias prom='docker run -d prom/prometheus'

# ============================================================
# CDN & Edge Services
# ============================================================
# [JP] CDN・エッジサービス
# [EN] CDN and edge services

# [JP] Akamai
# [EN] Akamai
alias akamai='akamai'

# [JP] Fastly
# [EN] Fastly
alias fastly='fastly'

# ============================================================
# Development Tools
# ============================================================

# [JP] エディタ
# [EN] Editor
alias vim='nvim'
alias vi='nvim'

# [JP] Node.js / npm / pnpm
# [EN] Node.js package managers
alias n='node'
alias nv='node --version'

# [JP] Python
# [EN] Python (lazy-loaded from .zshrc)
# alias py='python3'

# ============================================================
# Utility Functions
# ============================================================
# [JP] よく使う便利コマンド
# [EN] Handy utility commands

# [JP] マンページを bat で表示
# [EN] View man pages with bat
man() {
  command man "$@" | bat -l man -p
}

# [JP] パス表示（改行区切り）
# [EN] Display PATH with line breaks
alias pathprint='echo $PATH | tr ":" "\n"'

# [JP] ポート確認
# [EN] Check open ports
alias lsports='lsof -i -P -n | grep LISTEN'

# ============================================================
# WezTerm / Dev Workflow
# ============================================================
# チートシートをglow表示 (wezterm help)
# [EN] Display WezTerm cheatsheet with glow
wh() {
  glow ~/.config/wezterm/cheatsheet.md
}

# ============================================================
# Notes
# ============================================================
# [JP] 注意事項
# [EN] Notes:
#
# 1. Conflict resolution:
#    - "gc" maps to both "git commit" and "gcloud"
#    - Handled in functions.zsh with context-aware wrapper
#
# 2. Local overrides:
#    - Add custom aliases to ~/.zshrc.local (gitignored)
#    - Loaded after this file
#
# 3. Security:
#    - Sensitive aliases (API calls, auth tokens) go in .zshrc.local
#    - Never commit credentials via aliases
