#!/bin/bash

# 変更メッセージを引数から取得（デフォルトは「自動更新」）
COMMIT_MESSAGE=${1:-"自動更新"}

# 現在の状態を表示
echo "📊 現在の状態:"
git status

# すべての変更をステージング
echo "➕ 変更をステージングに追加しています..."
git add .

# 変更をコミット
echo "💾 変更をコミットしています..."
git commit -m "$COMMIT_MESSAGE"

# GitHubにプッシュ
echo "☁️ GitHubにプッシュしています..."
git push

echo "✅ 完了しました！" 