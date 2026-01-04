#!/bin/bash

echo "正在启动本地HTTP服务器..."
echo "如果提示xcode-select错误,请安装命令行工具: xcode-select --install"
echo ""

cd "$(dirname "$0")/docs"

# 尝试使用python3
if command -v python3 &> /dev/null; then
    echo "使用Python3启动服务器..."
    python3 -m http.server 8000 &
    SERVER_PID=$!
    echo "服务器PID: $SERVER_PID"
    sleep 2
    echo ""
    echo "✅ 服务器已启动！"
    echo "📱 请在浏览器中访问: http://localhost:8000"
    echo ""
    echo "按 Ctrl+C 停止服务器"
    wait $SERVER_PID
# 尝试使用php
elif command -v php &> /dev/null; then
    echo "使用PHP启动服务器..."
    php -S localhost:8000 &
    SERVER_PID=$!
    echo "服务器PID: $SERVER_PID"
    sleep 2
    echo ""
    echo "✅ 服务器已启动！"
    echo "📱 请在浏览器中访问: http://localhost:8000"
    echo ""
    echo "按 Ctrl+C 停止服务器"
    wait $SERVER_PID
else
    echo "❌ 错误：未找到Python3或PHP"
    echo ""
    echo "解决方案："
    echo "1. 安装Xcode命令行工具: xcode-select --install"
    echo "2. 或者直接双击打开 docs/index.html（功能受限）"
fi

