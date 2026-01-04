#!/bin/bash

echo "=========================================="
echo "🚀 启动本地网站服务"
echo "=========================================="
echo ""

cd "$(dirname "$0")/docs"

echo "📂 当前目录: $(pwd)"
echo "📄 文件: index.html"
echo ""
echo "🌐 正在启动服务器..."
echo ""

open http://localhost:8000

python3 -m http.server 8000

echo ""
echo "服务器已关闭"

