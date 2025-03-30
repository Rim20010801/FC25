# Git 便利チートシート

## 自動化スクリプト (git-auto.sh)

### 基本的な使い方
```bash
# 全ての変更をコミット（デフォルトメッセージ: 「自動更新」）
./git-auto.sh

# 指定したメッセージでコミット
./git-auto.sh "新機能の追加"

# 変更の差分を確認してからコミット
./git-auto.sh -d

# プルしてから変更をプッシュ（コンフリクト防止）
./git-auto.sh -p

# 特定のファイルだけをコミット
./git-auto.sh -s "file1.txt file2.js" "ファイルを更新"

# 新しいブランチを作成または切り替えてコミット
./git-auto.sh -b feature-x "新機能xを追加"
```

### ヘルプを表示
```bash
./git-auto.sh -h
```

## よく使うGitコマンド

### 基本操作
```bash
# リポジトリ初期化
git init

# 状態確認
git status

# 変更を追加
git add ファイル名
git add .         # すべての変更を追加

# 変更をコミット
git commit -m "メッセージ"

# リモートリポジトリを追加
git remote add origin リポジトリURL

# 変更をプッシュ
git push origin ブランチ名
```

### ブランチ操作
```bash
# ブランチ一覧を表示
git branch

# ブランチを作成
git branch ブランチ名

# ブランチを切り替え
git checkout ブランチ名

# ブランチを作成して切り替え（一度に）
git checkout -b ブランチ名

# ブランチをマージ
git merge ブランチ名
```

### 更新と同期
```bash
# リモートの変更を取得
git fetch

# リモートの変更を取得してマージ
git pull

# 変更を元に戻す
git reset --hard HEAD^  # 最新のコミットを取り消し
git reset --soft HEAD^  # コミットを取り消すが変更は残す
```

### 差分確認
```bash
# 変更の差分を表示
git diff

# コミット同士の差分
git diff コミットID1 コミットID2

# ステージング済みの変更の差分
git diff --staged
```

## Gitエイリアス（.gitconfigに設定済み）

以下のエイリアスが使えます：

```bash
git s        # status
git c        # commit
git ca       # commit --amend
git a        # add
git aa       # add --all
git p        # push
git pl       # pull
git co       # checkout
git cb       # checkout -b
git br       # branch
git l        # きれいなログ表示
git d        # diff
git ds       # diff --staged
git unstage  # ステージングから削除
git discard  # 変更を破棄
git auto     # 自動更新スクリプトを実行
```

## トラブルシューティング

### コンフリクトが発生した場合
1. `git status` でコンフリクトしているファイルを確認
2. コンフリクトしているファイルを編集して解決
3. `git add` でファイルを追加
4. `git commit` でコンフリクト解決をコミット

### コミットメッセージを修正したい
```bash
git commit --amend
```

### 直前のコミットを取り消したい
```bash
git reset --soft HEAD^  # 変更を残したまま取り消し
git reset --hard HEAD^  # 変更も取り消し（注意！）
```

### ブランチを間違えてコミットした
```bash
git stash              # 現在の変更を一時保存
git checkout 正しいブランチ
git stash pop          # 保存した変更を復元
``` 