#!/bin/bash

echo "=========================================="
echo "🚀 部署到GitHub Pages"
echo "=========================================="
echo ""

# 检查是否在Git仓库中
if [ ! -d ".git" ]; then
    echo "⚠️  当前目录不是Git仓库"
    echo "正在初始化Git仓库..."
    git init
fi

# 复制最新文件到docs目录
echo "📋 更新docs/index.html..."
cp tongxu/实时资讯.html docs/index.html

if [ $? -eq 0 ]; then
    echo "✅ 文件复制成功"
else
    echo "❌ 文件复制失败"
    exit 1
fi

# 检查是否有远程仓库
if ! git remote | grep -q origin; then
    echo ""
    echo "⚠️  未配置远程仓库"
    echo "请先执行以下命令配置远程仓库："
    echo "  git remote add origin https://github.com/YOUR_USERNAME/REPO_NAME.git"
    echo ""
    read -p "是否现在配置远程仓库？(y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        read -p "请输入GitHub仓库URL: " repo_url
        git remote add origin "$repo_url"
    else
        echo "跳过远程仓库配置"
    fi
fi

# 添加文件
echo ""
echo "📦 添加文件到Git..."
git add docs/index.html docs/.nojekyll

# 检查是否有更改
if git diff --staged --quiet; then
    echo "ℹ️  没有需要提交的更改"
else
    # 提交
    echo "💾 提交更改..."
    git commit -m "Update: 更新GitHub Pages部署文件"
    
    # 推送到GitHub
    echo "🚀 推送到GitHub..."
    git push origin main
    
    if [ $? -eq 0 ]; then
        echo ""
        echo "=========================================="
        echo "✅ 部署成功！"
        echo "=========================================="
        echo ""
        echo "📝 下一步："
        echo "1. 访问GitHub仓库页面"
        echo "2. 进入 Settings → Pages"
        echo "3. Source选择 'Deploy from a branch'"
        echo "4. Branch选择 'main'，Folder选择 '/docs'"
        echo "5. 点击 Save"
        echo ""
        echo "等待1-2分钟后，访问："
        echo "https://YOUR_USERNAME.github.io/REPO_NAME/"
        echo ""
    else
        echo ""
        echo "❌ 推送失败"
        echo "请检查："
        echo "1. 是否已配置远程仓库"
        echo "2. 是否有推送权限"
        echo "3. 网络连接是否正常"
    fi
fi

