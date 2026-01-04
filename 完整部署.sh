#!/bin/bash

echo "=========================================="
echo "🚀 完整部署到GitHub Pages"
echo "=========================================="
echo ""

cd /Users/luckincoffee/test

# 步骤1: 初始化Git仓库
echo "步骤1: 初始化Git仓库..."
if [ ! -d ".git" ]; then
    git init
    git branch -M main
    echo "✅ Git仓库已初始化"
else
    echo "✅ Git仓库已存在"
fi

# 步骤2: 配置远程仓库
echo ""
echo "步骤2: 配置远程仓库..."
git remote remove origin 2>/dev/null
git remote add origin https://github.com/silencetree346/tongxu.git
echo "✅ 远程仓库已配置: https://github.com/silencetree346/tongxu.git"

# 步骤3: 确保docs目录文件最新
echo ""
echo "步骤3: 更新部署文件..."
cp tongxu/实时资讯.html docs/index.html 2>/dev/null
touch docs/.nojekyll
echo "✅ 部署文件已更新"

# 步骤4: 添加文件
echo ""
echo "步骤4: 添加文件到Git..."
git add docs/ README.md *.md 2>/dev/null
git add . 2>/dev/null

# 步骤5: 提交
echo ""
echo "步骤5: 提交更改..."
git commit -m "Deploy: 部署全球智讯日报到GitHub Pages" 2>/dev/null || \
git commit -m "Deploy: 部署全球智讯日报到GitHub Pages" -a

if [ $? -eq 0 ]; then
    echo "✅ 文件已提交"
else
    echo "⚠️  提交失败或没有更改"
fi

# 步骤6: 推送
echo ""
echo "步骤6: 推送到GitHub..."
echo "（如果提示输入用户名密码，请使用GitHub用户名和Personal Access Token）"
echo ""
git push -u origin main 2>&1

if [ $? -eq 0 ]; then
    echo ""
    echo "=========================================="
    echo "✅ 代码推送成功！"
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
else
    echo ""
    echo "=========================================="
    echo "❌ 推送失败"
    echo "=========================================="
    echo ""
    echo "可能的原因："
    echo "1. 需要GitHub认证（用户名和Personal Access Token）"
    echo "2. 网络连接问题"
    echo "3. 仓库权限问题"
    echo ""
    echo "解决方法："
    echo "1. 访问 https://github.com/settings/tokens"
    echo "2. 生成新的Personal Access Token（勾选repo权限）"
    echo "3. 重新运行此脚本，推送时输入token作为密码"
    echo ""
fi

