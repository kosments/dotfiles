#!/bin/bash
# ============================================================
# DevContainer Quick Start Script
# ============================================================
# 用途: ターミナルから DevContainer を素早く起動し、
#       tmux + nvim + Claude Code CLI の開発環境をセットアップ
#
# 使用方法:
#   devcontainer-quickstart [DIRECTORY]
#
# 例:
#   devcontainer-quickstart              (カレントディレクトリ)
#   devcontainer-quickstart ~/my-project
#
# 実行内容:
#   1. DevContainer ビルド・起動
#   2. tmux セッション作成（画面分割）
#   3. nvim でファイルエクスプローラを開く
#   4. Claude Code CLI をスタンバイ
# ============================================================

set -e

# ============================================================
# 1. 初期化
# ============================================================

PROJECT_DIR="${1:-.}"
PROJECT_NAME=$(basename "$PROJECT_DIR")
TMUX_SESSION="${PROJECT_NAME}-dev"

# color codes
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}🚀 DevContainer Quick Start${NC}"
echo "Project: $PROJECT_DIR"
echo ""

# ============================================================
# 2. DevContainer がある確認
# ============================================================

if [ ! -d "$PROJECT_DIR/.devcontainer" ]; then
    echo -e "${RED}❌ Error: .devcontainer not found in $PROJECT_DIR${NC}"
    exit 1
fi

cd "$PROJECT_DIR"

# ============================================================
# 3. DevContainer を起動
# ============================================================

echo -e "${BLUE}📦 Building and opening DevContainer...${NC}"
echo "   This may take a few minutes on first run..."
echo ""

# VS Code CLI を使用（インストール済みの場合）
if command -v code &> /dev/null; then
    code --remote "dev-container+$(printf '%s' "$PROJECT_DIR" | sed 's/\//+/g')+.dev-container" "$PROJECT_DIR" &

    # VS Code が起動するのを待つ（最大30秒）
    echo -e "${YELLOW}⏳ Waiting for VS Code to start (max 30s)...${NC}"
    for i in {1..30}; do
        if pgrep -f "code.*dev-container" > /dev/null; then
            echo -e "${GREEN}✅ VS Code started${NC}"
            break
        fi
        sleep 1
    done
else
    echo -e "${YELLOW}⚠️  VS Code CLI not found. Please open manually:${NC}"
    echo "   1. Open VS Code"
    echo "   2. Open folder: $PROJECT_DIR"
    echo "   3. Run: Dev Containers: Reopen in Container"
    echo ""
    echo "   Continuing with tmux setup..."
fi

echo ""

# ============================================================
# 4. tmux セッション作成
# ============================================================

echo -e "${BLUE}🔧 Setting up tmux...${NC}"

# 既存セッションを削除（cleanup）
if tmux has-session -t "$TMUX_SESSION" 2>/dev/null; then
    echo "   Cleaning up existing session..."
    tmux kill-session -t "$TMUX_SESSION"
fi

# 新規セッション作成（200x50 サイズ）
tmux new-session -d -s "$TMUX_SESSION" -x 200 -y 50 -c "$PROJECT_DIR"

# ウィンドウ1: nvim（左側 60%）
tmux send-keys -t "$TMUX_SESSION:0" "nvim ." Enter
tmux split-window -h -p 40 -t "$TMUX_SESSION:0" -c "$PROJECT_DIR"

# ウィンドウ1の右側: Claude Code CLI（右側 40%）
tmux send-keys -t "$TMUX_SESSION:0.1" "# Claude Code CLI (ready)" Enter
tmux send-keys -t "$TMUX_SESSION:0.1" "# Run: claude <command>" Enter
tmux send-keys -t "$TMUX_SESSION:0.1" "echo '✅ Ready for Claude Code CLI'" Enter
tmux send-keys -t "$TMUX_SESSION:0.1" "" Enter

# ウィンドウ2: シェル（デバッグ/その他コマンド用）
tmux new-window -t "$TMUX_SESSION:1" -n "shell" -c "$PROJECT_DIR"
tmux send-keys -t "$TMUX_SESSION:1" "echo '📝 Shell window - use for git, npm, etc.'" Enter

echo -e "${GREEN}✅ tmux session created: $TMUX_SESSION${NC}"
echo ""

# ============================================================
# 5. tmux にアタッチ
# ============================================================

echo -e "${BLUE}📌 Attaching to tmux...${NC}"
echo ""
echo "Session: $TMUX_SESSION"
echo "Windows:"
echo "  0: nvim (left) | Claude CLI (right)"
echo "  1: shell (debugging/other commands)"
echo ""
echo -e "${YELLOW}Tips:${NC}"
echo "  Ctrl+B % - Split pane horizontally"
echo "  Ctrl+B \" - Split pane vertically"
echo "  Ctrl+B o - Switch between panes"
echo "  Ctrl+B x - Close pane"
echo "  Ctrl+B d - Detach session"
echo ""

# アタッチ
tmux attach-session -t "$TMUX_SESSION"
