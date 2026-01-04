#!/bin/bash

echo "=========================================="
echo "🚀 推送项目到GitHub仓库"
echo "=========================================="
echo ""

cd /Users/luckincoffee/test

# Token和仓库信息
TOKEN="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"
USERNAME="silencetree346"
REPO="tongxu"

# 步骤1: 初始化Git仓库
echo "步骤1: 初始化Git仓库..."
if [ ! -d ".git" ]; then
    git init
    git branch -M main
    echo "✅ Git仓库已初始化"
else
    echo "✅ Git仓库已存在"
    git branch -M main 2>/dev/null
fi

# 步骤2: 配置远程仓库
echo ""
echo "步骤2: 配置远程仓库..."
git remote remove origin 2>/dev/null
git remote add origin "https://${TOKEN}@github.com/${USERNAME}/${REPO}.git"
echo "✅ 远程仓库已配置: https://github.com/${USERNAME}/${REPO}.git"

# 步骤3: 确保部署文件最新
echo ""
echo "步骤3: 更新部署文件..."
cp tongxu/实时资讯.html docs/index.html
touch docs/.nojekyll
echo "✅ 部署文件已更新"

# 步骤4: 添加文件
echo ""
echo "步骤4: 添加文件到Git..."
git add .
echo "✅ 文件已添加"

# 步骤5: 提交
echo ""
echo "步骤5: 提交更改..."
git commit -m "Deploy: 推送项目到GitHub Pages" 2>/dev/null || \
git commit -m "Deploy: 推送项目到GitHub Pages" -a 2>/dev/null || \
echo "⚠️  没有更改需要提交或提交失败"

# 步骤6: 推送
echo ""
echo "步骤6: 推送到GitHub..."
echo "（正在推送，请稍候...）"
echo ""

git push -u origin main 2>&1

if [ $? -eq 0 ]; then
    echo ""
    echo "=========================================="
    echo "✅ 推送成功！"
    echo "=========================================="
    echo ""
    echo "📝 下一步：配置GitHub Pages"
    echo ""
    echo "1. 访问: https://github.com/${USERNAME}/${REPO}/settings/pages"
    echo ""
    echo "2. 配置："
    echo "   - Source: Deploy from a branch"
    echo "   - Branch: main"
    echo "   - Folder: /docs"
    echo "   - 点击 Save"
    echo ""
    echo "3. 等待1-2分钟后，访问："
    echo "   https://${USERNAME}.github.io/${REPO}/"
    echo ""
    
    # 清理Token（安全考虑）
    echo "🔒 清理Token信息..."
    git remote set-url origin "https://github.com/${USERNAME}/${REPO}.git"
    echo "✅ Token已从远程URL中移除"
else
    echo ""
    echo "=========================================="
    echo "❌ 推送失败"
    echo "=========================================="
    echo ""
    echo "可能的原因："
    echo "1. Git未安装（需要先安装Git）"
    echo "2. Token无效或过期"
    echo "3. 网络连接问题"
    echo ""
    echo "解决方法："
    echo "1. 安装Git: xcode-select --install"
    echo "2. 检查Token是否有效"
    echo "3. 检查网络连接"
    echo ""
    echo "或者手动执行以下命令："
    echo ""
    echo "cd /Users/luckincoffee/test"
    echo "git init"
    echo "git branch -M main"
    echo "git remote add origin https://${TOKEN}@github.com/${USERNAME}/${REPO}.git"
    echo "cp tongxu/实时资讯.html docs/index.html"
    echo "touch docs/.nojekyll"
    echo "git add ."
    echo "git commit -m 'Deploy to GitHub Pages'"
    echo "git push -u origin main"
fi

echo ""

