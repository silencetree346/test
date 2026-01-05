#!/bin/bash

echo "=========================================="
echo "🔍 检查并推送代码到GitHub"
echo "=========================================="
echo ""

cd /Users/luckincoffee/test

# 检查Git仓库
if [ ! -d ".git" ]; then
    echo "📦 初始化Git仓库..."
    git init
    git branch -M main
fi

# 配置远程仓库
echo "📡 配置远程仓库..."
git remote remove origin 2>/dev/null
git remote add origin https://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@github.com/silencetree346/tongxu.git 2>/dev/null || \
git remote set-url origin https://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@github.com/silencetree346/tongxu.git

# 确保文件最新
echo "📋 更新部署文件..."
cp tongxu/实时资讯.html docs/index.html
touch docs/.nojekyll

# 添加文件
echo "📦 添加文件..."
git add .

# 提交
echo "💾 提交更改..."
git commit -m "Deploy: 部署到GitHub Pages" 2>/dev/null || \
git commit -m "Deploy: 部署到GitHub Pages" -a 2>/dev/null || \
echo "⚠️  没有更改需要提交"

# 检查当前分支
current_branch=$(git branch --show-current 2>/dev/null || echo "main")
echo ""
echo "📌 当前分支: $current_branch"

# 推送
echo ""
echo "🚀 推送到GitHub..."
echo "（推送后，GitHub上就会有分支了）"
echo ""

git push -u origin $current_branch 2>&1

if [ $? -eq 0 ]; then
    echo ""
    echo "=========================================="
    echo "✅ 代码推送成功！"
    echo "=========================================="
    echo ""
    echo "📝 现在可以配置GitHub Pages了："
    echo ""
    echo "1. 访问: https://github.com/silencetree346/tongxu/settings/pages"
    echo ""
    echo "2. 刷新页面（按F5或Cmd+R）"
    echo ""
    echo "3. 现在应该可以看到分支选项了："
    echo "   - Source: Deploy from a branch"
    echo "   - Branch: 选择 '$current_branch' 或 'main'"
    echo "   - Folder: 选择 '/docs'"
    echo "   - 点击 Save"
    echo ""
    echo "4. 等待1-2分钟后，访问："
    echo "   https://silencetree346.github.io/tongxu/"
    echo ""
else
    echo ""
    echo "❌ 推送失败"
    echo ""
    echo "请检查："
    echo "1. Token是否有效"
    echo "2. 网络连接是否正常"
    echo ""
    echo "或者手动执行："
    echo "git push -u origin $current_branch"
fi

# 清理Token
echo ""
echo "🔒 清理Token信息..."
git remote set-url origin https://github.com/silencetree346/tongxu.git 2>/dev/null


