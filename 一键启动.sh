#!/bin/bash

echo "=========================================="
echo "  ☕ 每日调研分析报告 - 一键启动"
echo "=========================================="
echo ""

cd "$(dirname "$0")"

# 1. 配置 DeepSeek API Key
if [ ! -f "backend/.env" ]; then
    echo "📝 配置 DeepSeek API Key..."
    cd backend
    cat > .env << 'ENVEOF'
OPENAI_API_KEY=sk-ccdd9f2eaf13482d83966584e38b446a
NEWS_API_KEY=

EMAIL_ENABLED=false
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=
SMTP_PASSWORD=
RECIPIENT_EMAILS=

DAILY_REPORT_HOUR=9
DAILY_REPORT_MINUTE=0
ENVEOF
    cd ..
    echo "✅ 配置完成"
    echo ""
fi

# 2. 检查虚拟环境
if [ ! -d "backend/venv" ]; then
    echo "📦 安装依赖..."
    cd backend
    python3 -m venv venv
    source venv/bin/activate
    pip install -q --upgrade pip
    pip install -q -r requirements.txt
    cd ..
    echo "✅ 依赖安装完成"
    echo ""
fi

# 3. 启动后端服务
echo "🚀 启动后端服务..."
echo ""
cd backend
source venv/bin/activate
python main.py &
BACKEND_PID=$!
cd ..

echo "✅ 后端服务已启动 (PID: $BACKEND_PID)"
echo ""

# 4. 等待服务启动
echo "⏳ 等待服务就绪..."
sleep 3

for i in {1..10}; do
    if curl -s http://localhost:8000/ > /dev/null 2>&1; then
        echo "✅ 后端服务就绪！"
        break
    fi
    sleep 1
done

echo ""

# 5. 打开浏览器
echo "🌐 打开浏览器..."
open frontend/index.html

echo ""
echo "=========================================="
echo "  ✅ 启动完成！"
echo "=========================================="
echo ""
echo "前端页面已在浏览器打开"
echo "后端服务: http://localhost:8000"
echo ""
echo "按 Ctrl+C 停止服务"
echo ""

# 保持脚本运行
wait $BACKEND_PID


