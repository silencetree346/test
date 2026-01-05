#!/bin/bash

echo "🔧 更新前端代码中的云端后端URL"
echo ""

# 检查是否提供了URL参数
if [ -z "$1" ]; then
    echo "📝 使用方法："
    echo "   ./更新云端后端URL.sh https://your-backend-url.herokuapp.com"
    echo ""
    echo "💡 示例："
    echo "   ./更新云端后端URL.sh https://coffee-news-proxy.railway.app"
    echo "   ./更新云端后端URL.sh https://coffee-news-proxy.vercel.app"
    echo "   ./更新云端后端URL.sh https://coffee-news-proxy.herokuapp.com"
    echo ""
    read -p "请输入你的后端URL（不含/api/coffee-news-sources）: " BACKEND_URL
    
    if [ -z "$BACKEND_URL" ]; then
        echo "❌ URL不能为空"
        exit 1
    fi
else
    BACKEND_URL="$1"
fi

# 移除末尾的斜杠
BACKEND_URL=$(echo "$BACKEND_URL" | sed 's/\/$//')

# 构建完整的API URL
FULL_API_URL="${BACKEND_URL}/api/coffee-news-sources"

echo ""
echo "📍 后端URL: $BACKEND_URL"
echo "🔗 API地址: $FULL_API_URL"
echo ""

# 检查文件是否存在
if [ ! -f "docs/index.html" ]; then
    echo "❌ 找不到 docs/index.html 文件"
    exit 1
fi

# 备份原文件
cp docs/index.html docs/index.html.backup
echo "✅ 已备份原文件到 docs/index.html.backup"

# 更新文件中的URL
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    sed -i '' "s|https://your-backend-url.herokuapp.com/api/coffee-news-sources|$FULL_API_URL|g" docs/index.html
else
    # Linux
    sed -i "s|https://your-backend-url.herokuapp.com/api/coffee-news-sources|$FULL_API_URL|g" docs/index.html
fi

echo "✅ 已更新 docs/index.html 中的后端URL"
echo ""
echo "📋 下一步："
echo "   1. 检查更新是否正确："
echo "      grep -n '$FULL_API_URL' docs/index.html"
echo ""
echo "   2. 推送更新到GitHub："
echo "      git add docs/index.html"
echo "      git commit -m '更新云端后端URL'"
echo "      git push"
echo ""
echo "   3. 等待GitHub Pages更新（通常1-2分钟）"
echo ""
echo "   4. 访问你的GitHub Pages测试："
echo "      https://silencetree346.github.io/test/"
echo ""


