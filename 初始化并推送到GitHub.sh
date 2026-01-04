#!/bin/bash

echo "=========================================="
echo "🚀 初始化Git仓库并推送到GitHub"
echo "=========================================="
echo ""

cd /Users/luckincoffee/test

TOKEN="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"
USERNAME="silencetree346"
REPO="tongxu"

# 检查Git是否安装
if ! command -v git &> /dev/null; then
    echo "❌ Git未安装"
    echo "请先安装: xcode-select --install"
    exit 1
fi

# 步骤1: 初始化Git仓库
echo "步骤1: 初始化Git仓库..."
if [ -d ".git" ]; then
    echo "⚠️  Git仓库已存在，跳过初始化"
else
    git init
    echo "✅ Git仓库已初始化"
fi

# 设置默认分支为main
git branch -M main 2>/dev/null || echo "分支设置完成"

# 步骤2: 确保docs目录和文件存在
echo ""
echo "步骤2: 准备部署文件..."
if [ ! -d "docs" ]; then
    mkdir -p docs
    echo "✅ 创建docs目录"
fi

cp tongxu/实时资讯.html docs/index.html
touch docs/.nojekyll
echo "✅ 部署文件已准备"

# 步骤3: 配置Git用户信息（如果需要）
echo ""
echo "步骤3: 配置Git..."
git config user.name "${USERNAME}" 2>/dev/null || true
git config user.email "${USERNAME}@users.noreply.github.com" 2>/dev/null || true

# 步骤4: 配置远程仓库
echo ""
echo "步骤4: 配置远程仓库..."
git remote remove origin 2>/dev/null
git remote add origin "https://${TOKEN}@github.com/${USERNAME}/${REPO}.git"
echo "✅ 远程仓库已配置: https://github.com/${USERNAME}/${REPO}.git"

# 步骤5: 添加文件
echo ""
echo "步骤5: 添加文件到Git..."
git add .
echo "✅ 文件已添加"

# 步骤6: 提交
echo ""
echo "步骤6: 提交更改..."
git commit -m "Initial commit: 部署全球智讯日报到GitHub Pages" 2>/dev/null || \
git commit -m "Initial commit: 部署全球智讯日报到GitHub Pages" -a 2>/dev/null

if [ $? -eq 0 ]; then
    echo "✅ 提交成功"
else
    echo "⚠️  提交失败或没有更改"
fi

# 步骤7: 推送到GitHub
echo ""
echo "步骤7: 推送到GitHub..."
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
    echo "1. Token无效或过期"
    echo "2. 网络连接问题"
    echo "3. 仓库权限问题"
    echo ""
    echo "请手动执行以下命令："
    echo ""
    echo "cd /Users/luckincoffee/test"
    echo "git push -u origin main"
    echo ""
    echo "如果提示输入用户名和密码："
    echo "  用户名: ${USERNAME}"
    echo "  密码: ${TOKEN}"
fi

echo ""

