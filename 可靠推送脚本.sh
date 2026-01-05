#!/bin/bash

echo "=========================================="
echo "🚀 可靠推送脚本（包含错误处理）"
echo "=========================================="
echo ""

cd /Users/luckincoffee/test

TOKEN="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"
USERNAME="silencetree346"
REPO="tongxu"

# 检查Git
if ! command -v git &> /dev/null; then
    echo "❌ Git未安装"
    echo "请先安装: xcode-select --install"
    exit 1
fi

# 初始化Git
if [ ! -d ".git" ]; then
    echo "📦 初始化Git仓库..."
    git init
    git branch -M main
fi

# 确保文件最新
echo "📋 更新部署文件..."
cp tongxu/实时资讯.html docs/index.html
touch docs/.nojekyll

# 配置远程仓库
echo "📡 配置远程仓库..."
git remote remove origin 2>/dev/null
git remote add origin "https://${TOKEN}@github.com/${USERNAME}/${REPO}.git"

# 添加文件
echo "📦 添加文件..."
git add . 2>/dev/null

# 提交
echo "💾 提交更改..."
git commit -m "Deploy: 推送项目到GitHub Pages" 2>/dev/null || \
git commit -m "Deploy: 推送项目到GitHub Pages" -a 2>/dev/null

# 方法1：尝试正常推送
echo ""
echo "🚀 尝试推送（方法1：HTTPS with Token）..."
git push -u origin main 2>&1

if [ $? -eq 0 ]; then
    echo ""
    echo "=========================================="
    echo "✅ 推送成功！"
    echo "=========================================="
    
    # 清理Token
    git remote set-url origin "https://github.com/${USERNAME}/${REPO}.git"
    
    echo ""
    echo "📝 下一步：配置GitHub Pages"
    echo "访问: https://github.com/${USERNAME}/${REPO}/settings/pages"
    exit 0
fi

# 方法2：如果失败，尝试使用credential helper
echo ""
echo "⚠️  方法1失败，尝试方法2（使用credential helper）..."
git config credential.helper osxkeychain 2>/dev/null

# 重新配置远程仓库（不带Token）
git remote set-url origin "https://github.com/${USERNAME}/${REPO}.git"

echo "请手动执行以下命令："
echo ""
echo "git push -u origin main"
echo ""
echo "当提示输入用户名时，输入: ${USERNAME}"
echo "当提示输入密码时，输入: ${TOKEN}"
echo ""

# 方法3：提供SSH方案
echo ""
echo "💡 如果仍然失败，可以尝试SSH方式："
echo ""
echo "1. 生成SSH密钥（如果还没有）："
echo "   ssh-keygen -t ed25519 -C 'your_email@example.com'"
echo ""
echo "2. 添加SSH密钥到GitHub："
echo "   cat ~/.ssh/id_ed25519.pub"
echo "   然后访问: https://github.com/settings/keys"
echo ""
echo "3. 使用SSH URL："
echo "   git remote set-url origin git@github.com:${USERNAME}/${REPO}.git"
echo "   git push -u origin main"
echo ""

exit 1


