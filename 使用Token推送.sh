#!/bin/bash

echo "=========================================="
echo "🚀 使用Token推送到GitHub"
echo "=========================================="
echo ""

cd /Users/luckincoffee/test

# Token（已提供）
TOKEN="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"
USERNAME="silencetree346"
REPO="tongxu"

# 使用Token配置远程URL
echo "📡 配置远程仓库（使用Token）..."
git remote remove origin 2>/dev/null
git remote add origin "https://${TOKEN}@github.com/${USERNAME}/${REPO}.git"

# 或者使用这种方式（更安全）
# git remote set-url origin "https://${USERNAME}:${TOKEN}@github.com/${USERNAME}/${REPO}.git"

echo "✅ 远程仓库已配置"

# 确保文件最新
echo ""
echo "📋 更新部署文件..."
cp tongxu/实时资讯.html docs/index.html 2>/dev/null
touch docs/.nojekyll

# 添加文件
echo ""
echo "📦 添加文件..."
git add . 2>/dev/null

# 提交
echo ""
echo "💾 提交更改..."
git commit -m "Deploy: 部署全球智讯日报到GitHub Pages" 2>/dev/null || \
git commit -m "Deploy: 部署全球智讯日报到GitHub Pages" -a

# 推送
echo ""
echo "🚀 推送到GitHub..."
git push -u origin main 2>&1

if [ $? -eq 0 ]; then
    echo ""
    echo "=========================================="
    echo "✅ 推送成功！"
    echo "=========================================="
    echo ""
    echo "📝 下一步：配置GitHub Pages"
    echo ""
    echo "1. 访问: https://github.com/silencetree346/tongxu/settings/pages"
    echo "2. Source选择: Deploy from a branch"
    echo "3. Branch选择: main"
    echo "4. Folder选择: /docs"
    echo "5. 点击 Save"
    echo ""
    echo "等待1-2分钟后，访问："
    echo "https://silencetree346.github.io/tongxu/"
    echo ""
    
    # 清理：移除token（安全考虑）
    echo "🔒 清理Token信息..."
    git remote set-url origin "https://github.com/${USERNAME}/${REPO}.git"
    echo "✅ Token已从远程URL中移除（安全考虑）"
    echo ""
    echo "⚠️  注意：下次推送时，Git可能会要求输入凭证"
    echo "   可以使用Git Credential Helper保存凭证"
else
    echo ""
    echo "❌ 推送失败"
    echo ""
    echo "请检查："
    echo "1. Token是否有效"
    echo "2. Token是否有repo权限"
    echo "3. 网络连接是否正常"
fi

