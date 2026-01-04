#!/bin/bash

echo "=========================================="
echo "🔧 修复GitHub Pages 404错误"
echo "=========================================="
echo ""

cd /Users/luckincoffee/test

# 检查本地文件
echo "📁 检查本地文件..."
if [ -f "docs/index.html" ]; then
    file_size=$(ls -lh docs/index.html | awk '{print $5}')
    echo "✅ docs/index.html 存在 (大小: $file_size)"
else
    echo "❌ docs/index.html 不存在，正在创建..."
    cp tongxu/实时资讯.html docs/index.html
    touch docs/.nojekyll
fi

# 检查Git状态
echo ""
echo "🔍 检查Git状态..."
if [ -d ".git" ]; then
    echo "✅ Git仓库已初始化"
    
    # 检查远程仓库
    if git remote get-url origin &>/dev/null; then
        remote_url=$(git remote get-url origin)
        echo "✅ 远程仓库: $remote_url"
    else
        echo "⚠️  未配置远程仓库，正在配置..."
        git remote add origin https://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@github.com/silencetree346/tongxu.git 2>/dev/null || \
        git remote set-url origin https://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@github.com/silencetree346/tongxu.git
    fi
else
    echo "⚠️  Git仓库未初始化，正在初始化..."
    git init
    git branch -M main
    git remote add origin https://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@github.com/silencetree346/tongxu.git
fi

# 确保文件最新
echo ""
echo "📋 更新部署文件..."
cp tongxu/实时资讯.html docs/index.html
touch docs/.nojekyll

# 添加文件
echo ""
echo "📦 添加文件到Git..."
git add docs/ README.md *.md 2>/dev/null
git add . 2>/dev/null

# 提交
echo ""
echo "💾 提交更改..."
git commit -m "Fix: 修复GitHub Pages 404错误" 2>/dev/null || \
git commit -m "Fix: 修复GitHub Pages 404错误" -a 2>/dev/null || \
echo "⚠️  没有更改需要提交"

# 推送
echo ""
echo "🚀 推送到GitHub..."
git push -u origin main 2>&1

if [ $? -eq 0 ]; then
    echo ""
    echo "=========================================="
    echo "✅ 代码推送成功！"
    echo "=========================================="
    echo ""
    echo "📝 重要：现在需要配置GitHub Pages"
    echo ""
    echo "请按以下步骤操作："
    echo ""
    echo "1. 访问: https://github.com/silencetree346/tongxu/settings/pages"
    echo ""
    echo "2. 在 'Source' 部分："
    echo "   - 选择: Deploy from a branch"
    echo "   - Branch: main"
    echo "   - Folder: /docs  ⚠️ 必须选择 /docs"
    echo "   - 点击 Save"
    echo ""
    echo "3. 等待1-2分钟，然后访问："
    echo "   https://silencetree346.github.io/tongxu/"
    echo ""
    echo "⚠️  如果仍然404，请检查："
    echo "   - GitHub Pages配置中Folder是否选择了 /docs"
    echo "   - 仓库中是否有 docs/index.html 文件"
    echo "   - 等待几分钟让GitHub更新"
    echo ""
else
    echo ""
    echo "❌ 推送失败"
    echo ""
    echo "可能的原因："
    echo "1. 需要GitHub认证"
    echo "2. 网络连接问题"
    echo ""
    echo "请手动执行："
    echo "git push -u origin main"
fi

# 清理Token（安全考虑）
echo ""
echo "🔒 清理Token信息..."
git remote set-url origin https://github.com/silencetree346/tongxu.git 2>/dev/null
echo "✅ Token已从远程URL中移除"

echo ""
echo "=========================================="
echo "📋 404错误常见原因和解决方案"
echo "=========================================="
echo ""
echo "1. GitHub Pages未配置"
echo "   解决：访问 Settings → Pages，配置 Source 和 Folder"
echo ""
echo "2. Folder配置错误"
echo "   解决：必须选择 /docs，不是 / 或 /root"
echo ""
echo "3. 代码未推送"
echo "   解决：确保代码已推送到GitHub"
echo ""
echo "4. 文件路径错误"
echo "   解决：确保 docs/index.html 存在"
echo ""
echo "5. 部署还在进行中"
echo "   解决：等待1-2分钟后再访问"
echo ""

