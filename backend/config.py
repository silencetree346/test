import os
from typing import List

class Settings:
    PROJECT_NAME: str = "Global Intelligence Daily"
    API_VERSION: str = "v1"
    
    # 支持 OpenAI 或 DeepSeek API Key
    OPENAI_API_KEY: str = os.getenv("OPENAI_API_KEY", "")
    NEWS_API_KEY: str = os.getenv("NEWS_API_KEY", "")
    
    DAILY_REPORT_HOUR: int = 9
    DAILY_REPORT_MINUTE: int = 0
    
    EMAIL_ENABLED: bool = os.getenv("EMAIL_ENABLED", "false").lower() == "true"
    SMTP_HOST: str = os.getenv("SMTP_HOST", "smtp.gmail.com")
    SMTP_PORT: int = int(os.getenv("SMTP_PORT", "587"))
    SMTP_USER: str = os.getenv("SMTP_USER", "")
    SMTP_PASSWORD: str = os.getenv("SMTP_PASSWORD", "")
    
    RECIPIENT_EMAILS: List[str] = os.getenv("RECIPIENT_EMAILS", "").split(",")
    
    MAX_NEWS_ITEMS: int = 10
    MAX_STORED_REPORTS: int = 30

settings = Settings()

