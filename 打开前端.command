#!/bin/bash

# 获取脚本所在目录
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# 检查后端是否运行
if ! curl -s http://localhost:8000/ > /dev/null 2>&1; then
    osascript -e 'display dialog "⚠️ 后端服务未启动！\n\n请先双击运行「启动服务.command」" buttons {"确定"} default button "确定" with icon stop'
    exit 1
fi

# 在默认浏览器中打开
open "$DIR/frontend/index.html"

echo "✅ 已在浏览器中打开前端界面"




