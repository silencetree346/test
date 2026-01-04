#!/bin/bash

# 获取脚本所在目录
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$DIR"

echo "=========================================="
echo "  ☕ 每日调研分析报告"
echo "=========================================="
echo ""

# 检查配置
if [ ! -f "backend/.env" ]; then
    echo "⚠️  首次运行，需要配置..."
    echo ""
    
    if [ ! -f "backend/env_template.txt" ]; then
        echo "❌ 找不到配置模板文件"
        exit 1
    fi
    
    cp backend/env_template.txt backend/.env
    echo "✅ 已创建配置文件: backend/.env"
    echo ""
    echo "📝 请按以下步骤操作："
    echo "1. 打开 backend/.env 文件"
    echo "2. 填入你的 OPENAI_API_KEY"
    echo "3. 保存后再次运行此程序"
    echo ""
    
    # 尝试用默认编辑器打开
    if command -v open &> /dev/null; then
        open -e backend/.env
        echo "✅ 已用文本编辑器打开配置文件"
    fi
    
    echo ""
    echo "按任意键退出..."
    read -n 1
    exit 0
fi

# 检查是否配置了API密钥
if ! grep -q "OPENAI_API_KEY=sk-" backend/.env; then
    echo "⚠️  检测到 OPENAI_API_KEY 未配置！"
    echo ""
    echo "请编辑 backend/.env 文件，填入你的 OpenAI API 密钥"
    echo ""
    
    if command -v open &> /dev/null; then
        open -e backend/.env
        echo "✅ 已打开配置文件"
    fi
    
    echo ""
    echo "配置完成后，再次运行此程序"
    echo ""
    echo "按任意键退出..."
    read -n 1
    exit 0
fi

# 检查并安装依赖
if [ ! -d "backend/venv" ]; then
    echo "📦 首次运行，正在安装依赖..."
    echo ""
    
    if ! command -v python3 &> /dev/null; then
        echo "❌ 未找到 Python3，请先安装 Python 3.8+"
        echo ""
        echo "按任意键退出..."
        read -n 1
        exit 1
    fi
    
    cd backend
    python3 -m venv venv
    source venv/bin/activate
    pip install --upgrade pip -q
    pip install -r requirements.txt -q
    cd ..
    
    echo "✅ 依赖安装完成"
    echo ""
fi

# 启动服务
echo "🚀 正在启动后端服务..."
echo ""
echo "访问地址: http://localhost:8000"
echo "前端界面: 双击打开 frontend/index.html"
echo ""
echo "⚠️  不要关闭此窗口！"
echo "按 Ctrl+C 可以停止服务"
echo ""
echo "=========================================="
echo ""

cd backend
source venv/bin/activate
python main.py

