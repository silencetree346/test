#!/bin/bash

echo "=========================================="
echo "  咖啡行业调研系统 - 安装脚本"
echo "=========================================="
echo ""

if ! command -v python3 &> /dev/null; then
    echo "❌ 未找到 Python3，请先安装 Python 3.8+"
    exit 1
fi

echo "✅ Python3 已安装: $(python3 --version)"
echo ""

echo "📦 创建虚拟环境..."
cd backend
python3 -m venv venv

echo "🔧 激活虚拟环境..."
source venv/bin/activate

echo "📥 安装依赖包..."
pip install --upgrade pip
pip install -r requirements.txt

echo ""
echo "=========================================="
echo "✅ 安装完成！"
echo "=========================================="
echo ""
echo "⚙️  下一步："
echo "1. 配置环境变量："
echo "   cp env_template.txt .env"
echo "   然后编辑 .env 文件填入 API 密钥"
echo ""
echo "2. 启动服务："
echo "   cd .."
echo "   ./start.sh"
echo ""
echo "3. 打开浏览器访问："
echo "   frontend/index.html"
echo ""




