#!/bin/bash

echo "停止咖啡行业调研系统..."

pkill -f "python.*main.py"

if [ $? -eq 0 ]; then
    echo "✅ 服务已停止"
else
    echo "ℹ️  没有正在运行的服务"
fi




