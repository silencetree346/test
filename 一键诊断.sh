#!/bin/bash

echo "========================================"
echo "  每日调研分析报告 - 自动诊断工具"
echo "========================================"
echo ""

# 检查 Python
echo "🔍 检查 Python..."
if command -v python3 &> /dev/null; then
    echo "✅ Python3: $(python3 --version)"
else
    echo "❌ Python3 未安装"
    exit 1
fi
echo ""

# 检查虚拟环境
echo "🔍 检查虚拟环境..."
if [ -d "backend/venv" ]; then
    echo "✅ 虚拟环境存在"
else
    echo "❌ 虚拟环境不存在，请运行: ./install.sh"
fi
echo ""

# 检查配置文件
echo "🔍 检查配置文件..."
if [ -f "backend/.env" ]; then
    echo "✅ .env 文件存在"
    
    if grep -q "OPENAI_API_KEY=sk-" backend/.env; then
        echo "✅ OPENAI_API_KEY 已配置"
    else
        echo "⚠️  OPENAI_API_KEY 未配置或格式错误"
    fi
else
    echo "❌ .env 文件不存在"
    echo "   请运行: cd backend && cp env_template.txt .env"
fi
echo ""

# 检查端口
echo "🔍 检查端口 8000..."
if lsof -Pi :8000 -sTCP:LISTEN -t >/dev/null 2>&1; then
    echo "✅ 端口 8000 有服务在运行"
    echo "   进程信息:"
    lsof -i :8000 | head -2
else
    echo "❌ 端口 8000 没有服务，后端未启动"
    echo "   请运行: ./start.sh"
fi
echo ""

# 测试 API
echo "🔍 测试 API 连接..."
if curl -s http://localhost:8000/ > /dev/null 2>&1; then
    echo "✅ API 服务正常"
    response=$(curl -s http://localhost:8000/)
    echo "   响应: $response"
else
    echo "❌ 无法连接到 API 服务"
fi
echo ""

# 检查依赖
echo "🔍 检查 Python 依赖..."
if [ -f "backend/venv/bin/activate" ]; then
    source backend/venv/bin/activate
    
    packages=("fastapi" "uvicorn" "openai" "apscheduler")
    for pkg in "${packages[@]}"; do
        if pip show $pkg > /dev/null 2>&1; then
            echo "✅ $pkg 已安装"
        else
            echo "❌ $pkg 未安装"
        fi
    done
    deactivate
fi
echo ""

# 检查文件
echo "🔍 检查关键文件..."
files=("backend/main.py" "backend/config.py" "frontend/index.html")
for file in "${files[@]}"; do
    if [ -f "$file" ]; then
        echo "✅ $file"
    else
        echo "❌ $file 缺失"
    fi
done
echo ""

# 总结
echo "========================================"
echo "  诊断完成"
echo "========================================"
echo ""
echo "💡 建议操作："
echo ""

if ! lsof -Pi :8000 -sTCP:LISTEN -t >/dev/null 2>&1; then
    echo "1. 启动后端服务:"
    echo "   ./start.sh"
    echo ""
fi

if [ ! -f "backend/.env" ]; then
    echo "2. 配置环境变量:"
    echo "   cd backend"
    echo "   cp env_template.txt .env"
    echo "   # 编辑 .env 填入 OPENAI_API_KEY"
    echo ""
fi

echo "3. 打开浏览器访问:"
echo "   frontend/index.html"
echo ""
echo "4. 按 F12 查看控制台输出"
echo ""


