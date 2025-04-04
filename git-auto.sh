#!/bin/bash

# カラー設定
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# 関数: ヘルプを表示
show_help() {
  echo -e "${BLUE}===== Git自動化スクリプト ======${NC}"
  echo "使い方: $0 [オプション] [コミットメッセージ]"
  echo ""
  echo "オプション:"
  echo "  -h, --help     このヘルプメッセージを表示"
  echo "  -d, --diff     変更の差分を表示"
  echo "  -s, --specific ファイルを指定してコミット"
  echo "  -p, --pull     プッシュ前にプルを実行"
  echo "  -b, --branch   ブランチを指定または作成"
  echo ""
  echo "例:"
  echo "  $0                        # すべての変更を「自動更新」としてコミット"
  echo "  $0 \"新機能を追加\"         # すべての変更を指定メッセージでコミット"
  echo "  $0 -d                     # 変更の差分を表示してから処理"
  echo "  $0 -s \"file1.txt file2.js\" \"ファイルを更新\" # 特定のファイルだけコミット"
  echo "  $0 -p                     # プル→コミット→プッシュの順で実行"
  echo "  $0 -b feature-x \"新機能x\" # feature-xブランチで作業"
  echo -e "${BLUE}===============================${NC}"
  exit 0
}

# コマンドライン引数の解析
SHOW_DIFF=false
SPECIFIC_FILES=""
DO_PULL=false
BRANCH_NAME=""

while [[ $# -gt 0 ]]; do
  case $1 in
    -h|--help)
      show_help
      ;;
    -d|--diff)
      SHOW_DIFF=true
      shift
      ;;
    -s|--specific)
      SPECIFIC_FILES="$2"
      shift 2
      ;;
    -p|--pull)
      DO_PULL=true
      shift
      ;;
    -b|--branch)
      BRANCH_NAME="$2"
      shift 2
      ;;
    -*)
      echo -e "${RED}エラー: 不明なオプション $1${NC}"
      show_help
      ;;
    *)
      COMMIT_MESSAGE="$1"
      shift
      ;;
  esac
done

# コミットメッセージのデフォルト値
COMMIT_MESSAGE=${COMMIT_MESSAGE:-"自動更新"}

# ブランチの切り替えまたは作成
if [ ! -z "$BRANCH_NAME" ]; then
  echo -e "${YELLOW}🔀 ブランチ「$BRANCH_NAME」に切り替え/作成します...${NC}"
  git checkout $BRANCH_NAME 2>/dev/null || git checkout -b $BRANCH_NAME
fi

# 現在のブランチ名を取得
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
echo -e "${GREEN}🌿 現在のブランチ: ${CURRENT_BRANCH}${NC}"

# 変更の差分を表示
if [ "$SHOW_DIFF" = true ]; then
  echo -e "${YELLOW}📋 変更の差分:${NC}"
  git diff
  echo ""
  echo -e "${YELLOW}続行しますか？ [Y/n]${NC}"
  read answer
  if [[ "$answer" == "n" || "$answer" == "N" ]]; then
    echo -e "${RED}処理を中止しました${NC}"
    exit 0
  fi
fi

# 現在の状態を表示
echo -e "${BLUE}📊 現在の状態:${NC}"
git status

# プルの実行
if [ "$DO_PULL" = true ]; then
  echo -e "${YELLOW}⬇️ リモートから最新の変更を取得しています...${NC}"
  git pull origin $CURRENT_BRANCH
  
  # コンフリクトチェック
  if [ $? -ne 0 ]; then
    echo -e "${RED}⚠️ マージコンフリクトが発生したかもしれません。解決してから再度実行してください。${NC}"
    exit 1
  fi
fi

# 変更をステージング
echo -e "${BLUE}➕ 変更をステージングに追加しています...${NC}"
if [ ! -z "$SPECIFIC_FILES" ]; then
  # スペースで区切られたファイルリストを処理
  for file in $SPECIFIC_FILES; do
    if [ -e "$file" ]; then
      git add "$file"
      echo "  追加: $file"
    else
      echo -e "${RED}  警告: ファイル '$file' が見つかりません${NC}"
    fi
  done
else
  git add .
fi

# 変更をコミット
echo -e "${BLUE}💾 変更をコミットしています...${NC}"
git commit -m "$COMMIT_MESSAGE"

# コミットが成功したか確認
if [ $? -ne 0 ]; then
  echo -e "${RED}コミットに失敗しました。コミットするものがなかったかもしれません。${NC}"
  exit 1
fi

# GitHubにプッシュ
echo -e "${BLUE}☁️ GitHubにプッシュしています...${NC}"
git push origin $CURRENT_BRANCH || git push --set-upstream origin $CURRENT_BRANCH

echo -e "${GREEN}✅ 完了しました！${NC}" 