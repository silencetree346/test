咖啡行业每日调研推送系统

【功能】
- 每日自动抓取咖啡行业相关新闻
- AI深度分析行业趋势
- 生成战略建议
- 可视化管理后台
- 邮件推送功能

【启动步骤】

1. 配置API密钥
   - 复制 backend/.env.example 为 backend/.env
   - 填入 OPENAI_API_KEY（必需）
   - 填入 NEWS_API_KEY（可选，用于获取真实新闻）
   - 配置邮件服务（可选）

2. 启动后端
   方式1：使用脚本
   chmod +x start.sh
   ./start.sh

   方式2：手动启动
   cd backend
   python3 -m venv venv
   source venv/bin/activate
   pip install -r requirements.txt
   python main.py

3. 访问前端
   打开浏览器访问: frontend/index.html
   或在 VSCode 中使用 Live Server 打开

【API端点】
- GET  /api/reports         - 获取所有报告
- GET  /api/reports/latest  - 获取最新报告
- POST /api/reports/generate - 手动生成报告
- GET  /api/news            - 获取最新新闻

【定时任务】
系统默认每天上午9:00自动生成报告
可在 config.py 中修改时间

【邮件推送】
在 .env 中配置:
EMAIL_ENABLED=true
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=your-email@gmail.com
SMTP_PASSWORD=your-app-password
RECIPIENT_EMAILS=email1@example.com,email2@example.com

【技术栈】
后端: FastAPI + APScheduler + OpenAI + BeautifulSoup
前端: Vue 3 + Axios




