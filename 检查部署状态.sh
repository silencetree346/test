#!/bin/bash

echo "=========================================="
echo "🔍 检查GitHub Pages部署状态"
echo "=========================================="
echo ""

cd /Users/luckincoffee/test

# 检查本地文件
echo "📁 检查本地文件..."
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

echo ""

# 检查Git配置
echo "🔧 检查Git配置..."
if [ -d ".git" ]; then
    echo "✅ Git仓库已初始化"
    
    if git remote get-url origin &>/dev/null; then
        remote_url=$(git remote get-url origin)
        echo "✅ 远程仓库: $remote_url"
        
        # 检查是否匹配目标仓库
        if [[ "$remote_url" == *"silencetree346/tongxu"* ]]; then
            echo "✅ 远程仓库配置正确"
        else
            echo "⚠️  远程仓库不匹配，应该是: https://github.com/silencetree346/tongxu.git"
        fi
    else
        echo "❌ 未配置远程仓库"
        echo "   运行: git remote add origin https://github.com/silencetree346/tongxu.git"
    fi
    
    # 检查是否有未提交的更改
    if git diff --quiet docs/index.html 2>/dev/null; then
        echo "✅ docs/index.html 已提交"
    else
        echo "⚠️  docs/index.html 有未提交的更改"
    fi
    
    # 检查本地提交
    commit_count=$(git log --oneline 2>/dev/null | wc -l | tr -d ' ')
    if [ "$commit_count" -gt 0 ]; then
        echo "✅ 本地有 $commit_count 个提交"
        echo "   最新提交: $(git log -1 --oneline 2>/dev/null)"
    else
        echo "⚠️  本地没有提交记录"
    fi
else
    echo "❌ Git仓库未初始化"
    echo "   运行: git init"
fi

echo ""
echo "=========================================="
echo "🌐 GitHub仓库状态检查"
echo "=========================================="
echo ""
echo "请访问以下链接检查："
echo ""
echo "1. 仓库页面:"
echo "   https://github.com/silencetree346/tongxu"
echo ""
echo "2. Pages设置:"
echo "   https://github.com/silencetree346/tongxu/settings/pages"
echo ""
echo "3. 网站地址（如果已部署）:"
echo "   https://silencetree346.github.io/tongxu/"
echo ""

# 尝试检查GitHub Pages状态
echo "🔍 检查GitHub Pages部署状态..."
echo ""
echo "如果网站已部署，应该可以访问："
echo "   https://silencetree346.github.io/tongxu/"
echo ""
echo "如果显示404或无法访问，可能的原因："
echo "   1. 代码还未推送到GitHub"
echo "   2. GitHub Pages未配置"
echo "   3. 配置了错误的文件夹（应该是 /docs）"
echo "   4. 部署还在进行中（等待1-2分钟）"
echo ""

# 检查清单
echo "=========================================="
echo "✅ 部署检查清单"
echo "=========================================="
echo ""
echo "[ ] 本地文件已准备好 (docs/index.html)"
echo "[ ] Git仓库已初始化"
echo "[ ] 远程仓库已配置"
echo "[ ] 代码已推送到GitHub"
echo "[ ] GitHub Pages已配置 (Source: branch, Folder: /docs)"
echo "[ ] 网站可以访问 (https://silencetree346.github.io/tongxu/)"
echo ""
echo "=========================================="
echo "📝 下一步操作"
echo "=========================================="
echo ""

if [ ! -d ".git" ]; then
    echo "1. 初始化Git仓库:"
    echo "   git init"
    echo "   git branch -M main"
    echo ""
fi

if ! git remote get-url origin &>/dev/null; then
    echo "2. 配置远程仓库:"
    echo "   git remote add origin https://github.com/silencetree346/tongxu.git"
    echo ""
fi

echo "3. 推送代码:"
echo "   git add ."
echo "   git commit -m 'Deploy to GitHub Pages'"
echo "   git push -u origin main"
echo ""
echo "4. 配置GitHub Pages:"
echo "   访问: https://github.com/silencetree346/tongxu/settings/pages"
echo "   Source: Deploy from a branch"
echo "   Branch: main, Folder: /docs"
echo "   点击 Save"
echo ""

