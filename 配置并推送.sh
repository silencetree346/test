#!/bin/bash

echo "=========================================="
echo "🚀 配置GitHub远程仓库并推送"
echo "=========================================="
echo ""

# 检查Git是否安装
if ! command -v git &> /dev/null; then
    echo "❌ Git未安装"
    echo "请先安装Git: https://git-scm.com/download/mac"
    exit 1
fi

# 提示用户输入仓库URL
echo "请输入您的GitHub仓库URL"
echo "格式示例: https://github.com/用户名/仓库名.git"
echo ""
read -p "仓库URL: " repo_url

if [ -z "$repo_url" ]; then
    echo "❌ 未输入仓库URL"
    exit 1
fi

# 配置远程仓库
echo ""
echo "📡 配置远程仓库..."
git remote remove origin 2>/dev/null
git remote add origin "$repo_url"

if [ $? -eq 0 ]; then
    echo "✅ 远程仓库配置成功"
else
    echo "❌ 配置失败，请检查URL格式"
    exit 1
fi

# 检查当前分支
current_branch=$(git branch --show-current 2>/dev/null || echo "main")
echo ""
echo "📦 当前分支: $current_branch"

# 推送代码
echo ""
echo "🚀 推送代码到GitHub..."
echo "（如果提示输入用户名密码，请使用GitHub用户名和Personal Access Token）"
echo ""

git push -u origin $current_branch

if [ $? -eq 0 ]; then
    echo ""
    echo "=========================================="
    echo "✅ 推送成功！"
    echo "=========================================="
    echo ""
    
    # 提取用户名和仓库名
    repo_name=$(echo "$repo_url" | sed 's/.*github.com[:/][^/]*\/\([^/]*\)\.git/\1/')
    username=$(echo "$repo_url" | sed 's/.*github.com[:/]\([^/]*\)\/.*/\1/')
    
    echo "📝 下一步："
    echo "1. 访问GitHub仓库: https://github.com/$username/$repo_name"
    echo "2. 点击 Settings → Pages"
    echo "3. Source选择 'Deploy from a branch'"
    echo "4. Branch选择 '$current_branch'，Folder选择 '/docs'"
    echo "5. 点击 Save"
    echo ""
    echo "等待1-2分钟后，访问："
    echo "https://$username.github.io/$repo_name/"
    echo ""
else
    echo ""
    echo "❌ 推送失败"
    echo ""
    echo "可能的原因："
    echo "1. 需要配置GitHub凭证"
    echo "2. 网络连接问题"
    echo "3. 仓库权限问题"
    echo ""
    echo "如果提示需要认证，请："
    echo "1. 访问 https://github.com/settings/tokens"
    echo "2. 生成新的Personal Access Token（勾选repo权限）"
    echo "3. 推送时，用户名输入GitHub用户名，密码输入Token"
fi


