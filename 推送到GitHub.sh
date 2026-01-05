#!/bin/bash

echo "=========================================="
echo "🚀 推送到GitHub: silencetree346/tongxu"
echo "=========================================="
echo ""

cd /Users/luckincoffee/test

# 配置远程仓库
echo "📡 配置远程仓库..."
git remote remove origin 2>/dev/null
git remote add origin https://github.com/silencetree346/tongxu.git

if [ $? -eq 0 ]; then
    echo "✅ 远程仓库配置成功"
    git remote -v
else
    echo "❌ 配置失败"
    exit 1
fi

echo ""
echo "🚀 推送代码到GitHub..."
echo "（如果提示输入用户名密码，请使用GitHub用户名和Personal Access Token）"
echo ""

# 检查当前分支
current_branch=$(git branch --show-current 2>/dev/null || echo "main")

# 推送代码
git push -u origin $current_branch

if [ $? -eq 0 ]; then
    echo ""
    echo "=========================================="
    echo "✅ 推送成功！"
    echo "=========================================="
    echo ""
    echo "📝 下一步："
    echo "1. 访问: https://github.com/silencetree346/tongxu"
    echo "2. 点击 Settings → Pages"
    echo "3. Source选择 'Deploy from a branch'"
    echo "4. Branch选择 '$current_branch'，Folder选择 '/docs'"
    echo "5. 点击 Save"
    echo ""
    echo "等待1-2分钟后，访问："
    echo "https://silencetree346.github.io/tongxu/"
    echo ""
else
    echo ""
    echo "❌ 推送失败"
    echo ""
    echo "如果提示需要认证，请："
    echo "1. 访问 https://github.com/settings/tokens"
    echo "2. 生成新的Personal Access Token（勾选repo权限）"
    echo "3. 推送时，用户名输入: silencetree346"
    echo "4. 密码输入: 刚才生成的Token"
    echo ""
    echo "或者重新运行此脚本"
fi


