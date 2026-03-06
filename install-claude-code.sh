#!/bin/bash
# ============================================================
#  Claude Code ワンクリックインストーラー for Mac
#
#  これ1つでClaude Codeが使えるようになります。
#  必要なもの: Claude Pro または Max プラン
#
#  使い方:
#    ターミナルを開いて以下を貼り付けて Enter:
#    bash install-claude-code.sh
# ============================================================

set -e

# --- 色付き出力 ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

print_step() {
  echo ""
  echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo -e "${BOLD}${CYAN}  $1${NC}"
  echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

print_success() {
  echo -e "${GREEN}  ✅ $1${NC}"
}

print_warning() {
  echo -e "${YELLOW}  ⚠️  $1${NC}"
}

print_error() {
  echo -e "${RED}  ❌ $1${NC}"
}

print_info() {
  echo -e "  ℹ️  $1"
}

# --- ヘッダー ---
clear
echo ""
echo -e "${BOLD}${CYAN}"
echo "  ╔══════════════════════════════════════════╗"
echo "  ║                                          ║"
echo "  ║    Claude Code インストーラー for Mac     ║"
echo "  ║                                          ║"
echo "  ║    プログラミング経験ゼロでもOK!          ║"
echo "  ║    全自動でセットアップします              ║"
echo "  ║                                          ║"
echo "  ╚══════════════════════════════════════════╝"
echo -e "${NC}"
echo ""
echo -e "  ${YELLOW}※ Claude Pro または Max プランへの課金が必要です${NC}"
echo -e "  ${YELLOW}※ インストール中にパスワードを求められることがあります${NC}"
echo ""
read -p "  Enterキーを押してインストールを開始します..." _

# ============================================================
# STEP 1: macOSバージョン確認
# ============================================================
print_step "STEP 1/5: macOSバージョンを確認中..."

OS_VERSION=$(sw_vers -productVersion 2>/dev/null || echo "unknown")
ARCH=$(uname -m)

if [[ "$OSTYPE" != "darwin"* ]]; then
  print_error "このスクリプトはMac専用です。"
  exit 1
fi

print_success "macOS $OS_VERSION ($ARCH) を検出"

# ============================================================
# STEP 2: Xcode Command Line Tools
# ============================================================
print_step "STEP 2/5: Xcode Command Line Tools を確認中..."

if xcode-select -p &>/dev/null; then
  print_success "Xcode Command Line Tools はインストール済み"
else
  print_info "Xcode Command Line Tools をインストールします..."
  print_info "ポップアップが表示されたら「インストール」をクリックしてください"
  xcode-select --install 2>/dev/null || true

  echo ""
  echo -e "  ${YELLOW}Xcode Command Line Tools のインストールが完了するまで待ってください。${NC}"
  echo -e "  ${YELLOW}完了したら Enter を押してください。${NC}"
  read -p "  " _

  if ! xcode-select -p &>/dev/null; then
    print_error "Xcode Command Line Tools のインストールに失敗しました。"
    print_info "手動でインストールしてから再実行してください:"
    print_info "  xcode-select --install"
    exit 1
  fi
  print_success "Xcode Command Line Tools インストール完了"
fi

# ============================================================
# STEP 3: Homebrew
# ============================================================
print_step "STEP 3/5: Homebrew を確認中..."

if command -v brew &>/dev/null; then
  BREW_VERSION=$(brew --version | head -1)
  print_success "Homebrew はインストール済み ($BREW_VERSION)"
else
  print_info "Homebrew をインストールします..."
  print_info "パスワードを求められたらMacのログインパスワードを入力してください"
  echo ""

  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Apple Silicon の場合、PATHに追加
  if [[ "$ARCH" == "arm64" ]]; then
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi

  if command -v brew &>/dev/null; then
    print_success "Homebrew インストール完了"
  else
    # PATHが通っていない場合の対応
    if [[ -f /opt/homebrew/bin/brew ]]; then
      eval "$(/opt/homebrew/bin/brew shellenv)"
      print_success "Homebrew インストール完了 (Apple Silicon)"
    elif [[ -f /usr/local/bin/brew ]]; then
      eval "$(/usr/local/bin/brew shellenv)"
      print_success "Homebrew インストール完了 (Intel Mac)"
    else
      print_error "Homebrew のインストールに失敗しました。"
      exit 1
    fi
  fi
fi

# ============================================================
# STEP 4: Node.js
# ============================================================
print_step "STEP 4/5: Node.js を確認中..."

if command -v node &>/dev/null; then
  NODE_VERSION=$(node -v)
  NODE_MAJOR=$(echo "$NODE_VERSION" | sed 's/v//' | cut -d. -f1)

  if [[ "$NODE_MAJOR" -ge 18 ]]; then
    print_success "Node.js $NODE_VERSION はインストール済み（対応バージョン）"
  else
    print_warning "Node.js $NODE_VERSION は古いバージョンです。更新します..."
    brew install node
    print_success "Node.js $(node -v) に更新しました"
  fi
else
  print_info "Node.js をインストールします..."
  brew install node

  if command -v node &>/dev/null; then
    print_success "Node.js $(node -v) インストール完了"
  else
    print_error "Node.js のインストールに失敗しました。"
    exit 1
  fi
fi

# npm確認
if command -v npm &>/dev/null; then
  print_success "npm $(npm -v) を確認"
else
  print_error "npm が見つかりません。Node.jsを再インストールしてください。"
  exit 1
fi

# ============================================================
# STEP 5: Claude Code
# ============================================================
print_step "STEP 5/5: Claude Code をインストール中..."

if command -v claude &>/dev/null; then
  CURRENT_VERSION=$(claude --version 2>/dev/null || echo "unknown")
  print_info "Claude Code は既にインストールされています ($CURRENT_VERSION)"
  echo ""
  read -p "  最新版に更新しますか？ (y/N): " UPDATE_CHOICE
  if [[ "$UPDATE_CHOICE" =~ ^[Yy]$ ]]; then
    npm install -g @anthropic-ai/claude-code@latest
    print_success "Claude Code を最新版に更新しました"
  else
    print_info "更新をスキップしました"
  fi
else
  print_info "Claude Code をインストールしています..."
  npm install -g @anthropic-ai/claude-code@latest

  if command -v claude &>/dev/null; then
    print_success "Claude Code インストール完了"
  else
    print_error "Claude Code のインストールに失敗しました。"
    print_info "手動でインストールしてください:"
    print_info "  npm install -g @anthropic-ai/claude-code"
    exit 1
  fi
fi

# ============================================================
# 完了
# ============================================================
echo ""
echo ""
echo -e "${BOLD}${GREEN}"
echo "  ╔══════════════════════════════════════════╗"
echo "  ║                                          ║"
echo "  ║    🎉 インストール完了!                   ║"
echo "  ║                                          ║"
echo "  ╚══════════════════════════════════════════╝"
echo -e "${NC}"
echo ""
echo -e "  ${BOLD}インストールされたもの:${NC}"
echo -e "    • Node.js  : $(node -v)"
echo -e "    • npm      : $(npm -v)"
echo -e "    • Claude   : $(claude --version 2>/dev/null || echo 'installed')"
echo ""
echo -e "${BOLD}${CYAN}  ━━━ 使い方 ━━━${NC}"
echo ""
echo -e "  ${BOLD}1. ターミナルで以下を実行:${NC}"
echo -e "     ${GREEN}claude${NC}"
echo ""
echo -e "  ${BOLD}2. 初回はブラウザが開きます。${NC}"
echo -e "     Claudeアカウントでログインしてください。"
echo ""
echo -e "  ${BOLD}3. ログイン完了後、ターミナルでClaude Codeが使えます!${NC}"
echo ""
echo -e "  ${YELLOW}━━━ Tips ━━━${NC}"
echo -e "  • 作業したいフォルダに cd で移動してから claude を起動"
echo -e "  • 例: cd ~/Desktop && claude"
echo -e "  • 終了: Ctrl+C または /exit"
echo ""
echo ""
read -p "  今すぐ Claude Code を起動しますか？ (y/N): " LAUNCH_CHOICE
if [[ "$LAUNCH_CHOICE" =~ ^[Yy]$ ]]; then
  echo ""
  echo -e "  ${CYAN}Claude Code を起動します...${NC}"
  echo ""
  claude
fi
