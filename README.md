# Claude Code ワンクリックインストーラー for Mac 🍎

**プログラミング経験ゼロでもOK！**
ターミナルにコマンドを1行貼り付けるだけで、Claude Codeが使えるようになります。

## 必要なもの

- **Mac**（Intel / Apple Silicon どちらもOK）
- **Claude Pro または Max プラン**（月額課金済み）
- **インターネット接続**

## インストール方法

### 方法1: ワンライナー（一番カンタン）

ターミナルを開いて、以下を**コピペ**して Enter：

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/kshru1/claude-code-installer-mac/master/install-claude-code.sh)
```

> 💡 ターミナルの開き方: `Command + Space` → 「ターミナル」と入力 → Enter

### 方法2: ダウンロードして実行

1. 緑の「Code」ボタン → 「Download ZIP」
2. ダウンロードしたZIPを解凍
3. ターミナルを開いて以下を実行：

```bash
cd ~/Downloads/claude-code-installer-mac-main
bash install-claude-code.sh
```

## 何がインストールされるの？

| ツール | 説明 |
|--------|------|
| **Xcode Command Line Tools** | Macの開発基本ツール |
| **Homebrew** | Macのパッケージマネージャー |
| **Node.js** | JavaScript実行環境（Claude Codeに必要） |
| **Claude Code** | AnthropicのAIコーディングアシスタント |

## インストール後の使い方

```bash
# ターミナルで claude と打つだけ！
claude

# 初回はブラウザが開くのでログインしてください
# 作業フォルダで起動するのがオススメ
cd ~/Desktop
claude
```

## よくある質問

### Q: パスワードを求められた
Macのログインパスワードを入力してください。Homebrew のインストールに必要です。

### Q: 「Xcode Command Line Tools」のポップアップが出た
「インストール」をクリックしてください。完了まで数分かかります。

### Q: "command not found: claude" と表示される
ターミナルを一度閉じて、開き直してから `claude` を実行してください。

### Q: Apple Silicon (M1/M2/M3/M4) でも動く？
はい！自動的に対応します。

### Q: アンインストールしたい場合は？
```bash
npm uninstall -g @anthropic-ai/claude-code
```

## 対応環境

- macOS 12 (Monterey) 以降
- Apple Silicon (M1/M2/M3/M4) ✅
- Intel Mac ✅

## Windows版

Windows版はこちら → [ClaudeCodeをWindowsにインストールする方法](https://note.com/ritsuto2525/)

## ライセンス

MIT License - 自由にお使いください。

## クレジット

Powered by [Claude Code](https://claude.ai/) by Anthropic
