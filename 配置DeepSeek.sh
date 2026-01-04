#!/bin/bash

echo "=========================================="
echo "  每日调研分析报告 - 配置 DeepSeek API Key"
echo "=========================================="
echo ""

cd "$(dirname "$0")/backend"

cat > .env << 'EOF'
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
EOF

echo "✅ DeepSeek API Key 配置完成！"
echo ""
echo "API Key: sk-ccdd9f2eaf13482d83966584e38b446a"
echo "模型: deepseek-chat"
echo "API 地址: https://api.deepseek.com"
echo ""
echo "=========================================="
echo ""
echo "下一步："
echo "1. 运行: cd .. && ./启动服务.command"
echo "2. 或双击「启动服务.command」文件"
echo ""


