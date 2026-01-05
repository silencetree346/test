#!/bin/bash

echo "🚀 启动资讯服务..."
echo ""

BACKEND_DIR="backend-news-proxy"
FRONTEND_DIR="/Users/luckincoffee/test"

# 检查后端是否存在
if [ ! -d "$BACKEND_DIR" ]; then
    echo "❌ 后端服务未配置"
    echo "📥 请先运行: ./快速配置后端.sh"
    echo ""
    read -p "现在配置？(y/n): " confirm
    if [ "$confirm" = "y" ]; then
        ./快速配置后端.sh
        echo ""
        echo "✅ 配置完成！现在启动服务..."
        echo ""
    else
        exit 1
    fi
fi

# 检查Node.js
if ! command -v node &> /dev/null; then
    echo "❌ 未检测到Node.js，无法启动后端"
    exit 1
fi

# 检查Python3
if ! command -v python3 &> /dev/null; then
    echo "❌ 未检测到Python3，无法启动前端"
    exit 1
fi

echo "═══════════════════════════════════════"
echo "🚀 启动双服务（后端 + 前端）"
echo "═══════════════════════════════════════"
echo ""

# 使用 osascript 在新终端窗口中启动后端
echo "1️⃣ 启动后端服务（端口 3001）..."
osascript <<EOF
tell application "Terminal"
    do script "cd '$FRONTEND_DIR/$BACKEND_DIR' && echo '🚀 启动后端服务...' && npm start"
    activate
end tell
EOF

sleep 2

# 使用 osascript 在新终端窗口中启动前端
echo "2️⃣ 启动前端服务（端口 8000）..."
osascript <<EOF
tell application "Terminal"
    do script "cd '$FRONTEND_DIR' && echo '🚀 启动前端服务...' && python3 -m http.server 8000"
    activate
end tell
EOF

sleep 3

echo ""
echo "═══════════════════════════════════════"
echo "✅ 服务启动完成！"
echo "═══════════════════════════════════════"
echo ""
echo "📍 服务地址："
echo "   后端API: http://localhost:3001/api/coffee-news-sources"
echo "   前端页面: http://localhost:8000/docs/"
echo ""
echo "🌐 自动打开浏览器..."
echo ""

# 等待服务启动
sleep 2

# 打开浏览器
open "http://localhost:8000/docs/"

echo "💡 提示："
echo "   • 两个终端窗口已打开（后端 + 前端）"
echo "   • 关闭终端窗口即停止服务"
echo "   • 或在终端中按 Ctrl+C 停止"
echo ""
echo "📊 使用方法："
echo "   1. 浏览器会自动打开"
echo "   2. 点击「获取最新资讯」按钮"
echo "   3. 查看智能分析和业务洞见"
echo ""
echo "═══════════════════════════════════════"


