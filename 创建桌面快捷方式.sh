#!/bin/bash

# 获取脚本所在目录
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# 创建 AppleScript 应用
echo "正在创建桌面快捷方式..."

# 创建启动应用的 AppleScript
cat > /tmp/launch_coffee_system.scpt << 'EOF'
tell application "Terminal"
    do script "cd '" & (do shell script "dirname " & quoted form of (POSIX path of (path to me))) & "' && ./启动服务.command"
    activate
end tell
EOF

# 编译为应用
osacompile -o ~/Desktop/"☕️ 咖啡调研系统.app" /tmp/launch_coffee_system.scpt 2>/dev/null

if [ -d ~/Desktop/"☕️ 咖啡调研系统.app" ]; then
    echo "✅ 已在桌面创建「☕️ 咖啡调研系统.app」"
    echo ""
    echo "双击桌面图标即可启动系统！"
else
    echo "⚠️  创建应用失败，请直接双击「启动服务.command」使用"
fi

# 清理临时文件
rm -f /tmp/launch_coffee_system.scpt

echo ""
echo "按任意键退出..."
read -n 1





