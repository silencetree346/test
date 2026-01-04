#!/bin/bash

echo "=========================================="
echo "🔍 诊断推送失败原因"
echo "=========================================="
echo ""

cd /Users/luckincoffee/test

# 检查Git
echo "1. 检查Git安装..."
if command -v git &> /dev/null; then
    git_version=$(git --version 2>&1)
    echo "✅ Git已安装: $git_version"
else
    echo "❌ Git未安装"
    echo "   解决方法: xcode-select --install"
    exit 1
fi

# 检查网络连接
echo ""
echo "2. 检查网络连接..."
if ping -c 1 github.com &> /dev/null; then
    echo "✅ 可以连接到GitHub"
else
    echo "⚠️  无法连接到GitHub（可能是网络问题）"
fi

# 检查Git配置
echo ""
echo "3. 检查Git配置..."
if [ -d ".git" ]; then
    echo "✅ Git仓库已初始化"
    
    # 检查远程仓库
    if git remote get-url origin &>/dev/null; then
        remote_url=$(git remote get-url origin)
        echo "✅ 远程仓库: $remote_url"
        
        # 检查是否包含Token
        if [[ "$remote_url" == *"ghp_"* ]]; then
            echo "✅ URL中包含Token"
        else
            echo "⚠️  URL中不包含Token，可能需要认证"
        fi
    else
        echo "⚠️  未配置远程仓库"
    fi
else
    echo "⚠️  Git仓库未初始化"
fi

# 检查文件
echo ""
echo "4. 检查部署文件..."
if [ -f "docs/index.html" ]; then
    file_size=$(ls -lh docs/index.html | awk '{print $5}')
    echo "✅ docs/index.html 存在 (大小: $file_size)"
else
    echo "❌ docs/index.html 不存在"
fi

if [ -f "docs/.nojekyll" ]; then
    echo "✅ docs/.nojekyll 存在"
else
    echo "⚠️  docs/.nojekyll 不存在"
fi

# 检查是否有未提交的更改
echo ""
echo "5. 检查Git状态..."
if [ -d ".git" ]; then
    git status --short 2>&1 | head -10
    echo ""
    echo "（如果有文件显示，说明有未提交的更改）"
fi

echo ""
echo "=========================================="
echo "💡 推送解决方案"
echo "=========================================="
echo ""

