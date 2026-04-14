#!/bin/bash
cd D:/github/winner-XW.github.io  # 改成你自己路径

# 拉最新
git pull origin main

# 今天日期
today=$(date +%Y-%m-%d)

# 检查今天是否已生成
if ls source/_posts/$today-*.md 1>/dev/null 2>&1; then
  echo "今天已生成，退出"
  exit 0
fi

# 用 Cursor AI 生成文章
cursor agent -p "
按 .cursorrules 和 blog-prompt.txt 生成 Hexo 博客
文件名: source/_posts/${today}-技术博客.md
"

# Git 提交推送
git add source/_posts/
git commit -m "auto blog $today"
git push origin HEAD:main --force-with-lease