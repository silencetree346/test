#!/bin/bash

# 一键启动本地服务器
# 双击此文件即可运行

echo "======================================"
echo "  咖啡行业智讯日报 - 本地服务器"
echo "======================================"
echo ""

# 获取脚本所在目录
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DOCS_DIR="$SCRIPT_DIR/docs"

# 检查开发工具
echo "🔍 检查系统环境..."
if ! command -v python3 &> /dev/null; then
    echo "❌ 未找到 Python3"
    echo ""
    echo "请先安装 Xcode 命令行工具："
    echo "  xcode-select --install"
    echo ""
    read -p "按回车键退出..."
    exit 1
fi

# 尝试运行 python3
if ! python3 --version &> /dev/null; then
    echo "❌ Python3 无法运行（缺少开发者工具）"
    echo ""
    echo "解决方案："
    echo "1. 在终端运行：xcode-select --install"
    echo "2. 或双击打开：演示版-双击即用.html"
    echo "3. 或部署到 GitHub Pages（推荐）"
    echo ""
    read -p "按回车键退出..."
    exit 1
fi

echo "✅ Python3 可用"
echo ""

# 切换到 docs 目录
cd "$DOCS_DIR" || exit 1

echo "🚀 正在启动服务器..."
echo "📂 工作目录：$DOCS_DIR"
echo ""

# 启动服务器
python3 -m http.server 8000 &
SERVER_PID=$!

# 等待服务器启动
sleep 2

# 检查服务器是否运行
if ps -p $SERVER_PID > /dev/null; then
    echo "✅ 服务器启动成功！"
    echo ""
    echo "======================================"
    echo "  请在浏览器中访问："
    echo "  http://localhost:8000"
    echo "======================================"
    echo ""
    echo "💡 提示："
    echo "  - 服务器正在运行中..."
    echo "  - 关闭此窗口将停止服务器"
    echo "  - 或按 Ctrl+C 停止"
    echo ""
    
    # 尝试自动打开浏览器
    if command -v open &> /dev/null; then
        echo "🌐 正在打开浏览器..."
        sleep 1
        open "http://localhost:8000"
    fi
    
    # 保持运行
    wait $SERVER_PID
else
    echo "❌ 服务器启动失败"
    echo ""
    echo "请查看错误信息或尝试手动启动："
    echo "  cd $DOCS_DIR"
    echo "  python3 -m http.server 8000"
    echo ""
    read -p "按回车键退出..."
    exit 1
fi

echo ""
echo "服务器已停止"
read -p "按回车键退出..."


