import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
from typing import List
from config import settings
from datetime import datetime

class EmailService:
    
    @staticmethod
    def send_report_email(report_data: dict, recipients: List[str]):
        if not settings.EMAIL_ENABLED:
            print("邮件功能未启用")
            return
        
        if not recipients:
            recipients = settings.RECIPIENT_EMAILS
        
        html_content = EmailService._generate_html_report(report_data)
        
        msg = MIMEMultipart('alternative')
        msg['Subject'] = f"咖啡行业每日调研报告 - {report_data['date']}"
        msg['From'] = settings.SMTP_USER
        msg['To'] = ', '.join(recipients)
        
        html_part = MIMEText(html_content, 'html')
        msg.attach(html_part)
        
        try:
            with smtplib.SMTP(settings.SMTP_HOST, settings.SMTP_PORT) as server:
                server.starttls()
                server.login(settings.SMTP_USER, settings.SMTP_PASSWORD)
                server.send_message(msg)
            print(f"报告已发送至: {', '.join(recipients)}")
        except Exception as e:
            print(f"邮件发送失败: {str(e)}")
    
    @staticmethod
    def _generate_html_report(report_data: dict) -> str:
        news_html = ""
        for i, news in enumerate(report_data['news_items'], 1):
            news_html += f"""
            <div style="background: #f7fafc; padding: 20px; margin-bottom: 15px; border-radius: 8px; border-left: 4px solid #667eea;">
                <h3 style="margin: 0 0 10px 0; color: #2d3748;">
                    <a href="{news['url']}" style="color: #2d3748; text-decoration: none;">{news['title']}</a>
                </h3>
                <p style="margin: 0; color: #718096; font-size: 0.9em;">
                    📌 {news['source']} · 🕒 {news['publish_date']}
                </p>
                {f'<p style="margin-top: 10px; color: #4a5568;">{news["summary"]}</p>' if news.get('summary') else ''}
            </div>
            """
        
        recommendations_html = ""
        for i, rec in enumerate(report_data['recommendations'], 1):
            recommendations_html += f"""
            <div style="background: white; padding: 20px; margin-bottom: 15px; border-radius: 8px; border-left: 4px solid #48bb78; display: flex; gap: 15px;">
                <div style="background: linear-gradient(135deg, #48bb78 0%, #38a169 100%); color: white; width: 35px; height: 35px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: bold; flex-shrink: 0;">
                    {i}
                </div>
                <div style="flex: 1; color: #2d3748; line-height: 1.6;">
                    {rec}
                </div>
            </div>
            """
        
        html = f"""
        <!DOCTYPE html>
        <html>
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
        </head>
        <body style="font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Arial, sans-serif; background: #f7fafc; padding: 20px; margin: 0;">
            <div style="max-width: 800px; margin: 0 auto; background: white; border-radius: 20px; overflow: hidden; box-shadow: 0 10px 40px rgba(0,0,0,0.1);">
                <div style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 40px; text-align: center;">
                    <h1 style="margin: 0; font-size: 2em;">☕ 咖啡行业每日调研报告</h1>
                    <p style="margin: 10px 0 0 0; opacity: 0.9;">{report_data['date']}</p>
                </div>
                
                <div style="padding: 40px;">
                    <div style="margin-bottom: 40px;">
                        <h2 style="color: #2d3748; margin: 0 0 20px 0; font-size: 1.5em; display: flex; align-items: center; gap: 10px;">
                            📰 今日要闻
                        </h2>
                        {news_html}
                    </div>
                    
                    <div style="margin-bottom: 40px;">
                        <h2 style="color: #2d3748; margin: 0 0 20px 0; font-size: 1.5em; display: flex; align-items: center; gap: 10px;">
                            📊 深度分析
                        </h2>
                        <div style="background: linear-gradient(135deg, #f7fafc 0%, #edf2f7 100%); border-radius: 12px; padding: 25px; line-height: 1.8; color: #2d3748;">
                            {report_data['analysis']}
                        </div>
                    </div>
                    
                    <div>
                        <h2 style="color: #2d3748; margin: 0 0 20px 0; font-size: 1.5em; display: flex; align-items: center; gap: 10px;">
                            💡 战略建议
                        </h2>
                        {recommendations_html}
                    </div>
                </div>
                
                <div style="background: #f7fafc; padding: 20px; text-align: center; color: #718096; font-size: 0.9em;">
                    <p style="margin: 0;">本报告由咖啡行业调研系统自动生成</p>
                </div>
            </div>
        </body>
        </html>
        """
        
        return html

email_service = EmailService()




