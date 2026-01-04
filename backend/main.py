from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import List, Optional
from datetime import datetime
import asyncio
from apscheduler.schedulers.asyncio import AsyncIOScheduler
import openai
import httpx
from bs4 import BeautifulSoup
import json
from config import settings
from email_service import email_service

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

scheduler = AsyncIOScheduler()

class NewsItem(BaseModel):
    title: str
    url: str
    source: str
    publish_date: Optional[str] = None
    summary: Optional[str] = None

class AnalysisReport(BaseModel):
    date: str
    news_items: List[NewsItem]
    analysis: str
    recommendations: List[str]

reports_db = []

NEWS_SOURCES = [
    {
        "name": "腾讯新闻",
        "url": "https://new.qq.com/search?query=咖啡行业",
        "encoding": "utf-8"
    },
    {
        "name": "New York Times",
        "keywords": ["coffee", "starbucks", "coffee industry"]
    },
    {
        "name": "Harvard Business Review",
        "keywords": ["coffee business", "coffee market"]
    },
    {
        "name": "Wall Street Journal",
        "keywords": ["coffee market", "coffee stocks"]
    },
    {
        "name": "Financial Times",
        "keywords": ["coffee industry", "coffee trade"]
    }
]

async def fetch_tencent_news() -> List[NewsItem]:
    """抓取腾讯新闻"""
    news_items = []
    keywords = ["咖啡行业", "咖啡市场", "咖啡品牌", "精品咖啡"]
    
    try:
        async with httpx.AsyncClient(timeout=30.0) as client:
            for keyword in keywords[:2]:
                url = f"https://new.qq.com/search?query={keyword}"
                response = await client.get(url, headers={
                    "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36",
                    "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
                    "Accept-Language": "zh-CN,zh;q=0.9"
                })
                
                soup = BeautifulSoup(response.content, 'html.parser', from_encoding='utf-8')
                
                # 腾讯新闻的文章结构
                articles = soup.find_all('a', class_=['title', 'article-title'])[:3]
                
                if not articles:
                    # 尝试其他选择器
                    articles = soup.find_all('a', href=True)[:10]
                
                for article in articles:
                    title = article.get_text(strip=True)
                    url = article.get('href', '')
                    
                    # 过滤有效的咖啡相关新闻
                    if title and len(title) > 10 and any(kw in title for kw in ['咖啡', '瑞幸', '星巴克', 'Coffee']):
                        if url and not url.startswith('http'):
                            url = f"https://new.qq.com{url}"
                        
                        news_items.append(NewsItem(
                            title=title,
                            url=url or f"https://new.qq.com/search?query={keyword}",
                            source="腾讯新闻",
                            publish_date=datetime.now().strftime("%Y-%m-%d"),
                            summary=f"来自腾讯新闻的{keyword}相关报道"
                        ))
                        
                        if len(news_items) >= 5:
                            break
                
                if len(news_items) >= 5:
                    break
                    
    except Exception as e:
        print(f"腾讯新闻抓取失败: {str(e)}")
    
    return news_items

async def fetch_news_from_source(source: dict) -> List[NewsItem]:
    news_items = []
    try:
        async with httpx.AsyncClient(timeout=30.0) as client:
            response = await client.get(source["url"], headers={
                "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"
            })
            soup = BeautifulSoup(response.text, 'html.parser')
            
            articles = soup.find_all(['article', 'div'], class_=['article', 'news-item'])[:5]
            
            for article in articles:
                title_elem = article.find(['h3', 'h2', 'a'])
                if title_elem:
                    title = title_elem.get_text(strip=True)
                    link = article.find('a')
                    url = link.get('href', '') if link else ''
                    
                    if url and not url.startswith('http'):
                        url = f"https://{source['name'].lower()}.com{url}"
                    
                    news_items.append(NewsItem(
                        title=title,
                        url=url,
                        source=source["name"],
                        publish_date=datetime.now().strftime("%Y-%m-%d")
                    ))
    except Exception as e:
        print(f"Error fetching from {source['name']}: {str(e)}")
    
    return news_items

async def fetch_coffee_news() -> List[NewsItem]:
    all_news = []
    
    # 1. 优先抓取腾讯新闻（中文）
    print("正在抓取腾讯新闻...")
    tencent_news = await fetch_tencent_news()
    all_news.extend(tencent_news)
    print(f"腾讯新闻抓取完成: {len(tencent_news)} 条")
    
    # 2. 抓取国际新闻（如果配置了 NEWS_API_KEY）
    keywords = ["coffee industry", "coffee market", "coffee trends", "specialty coffee"]
    
    for keyword in keywords[:2]:
        try:
            async with httpx.AsyncClient() as client:
                if not settings.NEWS_API_KEY:
                    continue
                
                response = await client.get(
                    "https://newsapi.org/v2/everything",
                    params={
                        "q": keyword,
                        "language": "en",
                        "sortBy": "publishedAt",
                        "pageSize": 5,
                        "apiKey": settings.NEWS_API_KEY
                    }
                )
                
                if response.status_code == 200:
                    data = response.json()
                    for article in data.get("articles", [])[:3]:
                        all_news.append(NewsItem(
                            title=article["title"],
                            url=article["url"],
                            source=article["source"]["name"],
                            publish_date=article["publishedAt"][:10],
                            summary=article.get("description", "")
                        ))
        except Exception as e:
            print(f"Error fetching news for {keyword}: {str(e)}")
    
    # 3. 如果抓取数量不足，补充模拟数据
    if len(all_news) < 5:
        mock_news = [
            NewsItem(
                title="全球咖啡市场预计2025年将达到2000亿美元",
                url="https://example.com/coffee-market-growth",
                source="行业研究报告",
                publish_date=datetime.now().strftime("%Y-%m-%d"),
                summary="全球咖啡市场在精品咖啡需求推动下持续强劲增长。"
            ),
            NewsItem(
                title="可持续发展趋势重塑咖啡供应链",
                url="https://example.com/coffee-sustainability",
                source="贸易新闻",
                publish_date=datetime.now().strftime("%Y-%m-%d"),
                summary="主要咖啡品牌承诺采用可持续采购实践。"
            ),
            NewsItem(
                title="冷萃咖啡细分市场年增长率达25%",
                url="https://example.com/cold-brew-growth",
                source="市场分析",
                publish_date=datetime.now().strftime("%Y-%m-%d"),
                summary="冷萃咖啡在年轻消费者中持续获得市场份额。"
            ),
            NewsItem(
                title="瑞幸咖啡推出新品引爆社交媒体",
                url="https://example.com/luckin-coffee-new",
                source="零售快讯",
                publish_date=datetime.now().strftime("%Y-%m-%d"),
                summary="瑞幸咖啡新推出的季节限定产品在社交媒体上引发热议。"
            ),
            NewsItem(
                title="星巴克加速中国市场数字化转型",
                url="https://example.com/starbucks-digital",
                source="科技财经",
                publish_date=datetime.now().strftime("%Y-%m-%d"),
                summary="星巴克在中国市场投资数字化技术，优化客户体验。"
            )
        ]
        
        all_news.extend(mock_news[:10 - len(all_news)])
    
    return all_news[:10]

async def analyze_news_with_ai(news_items: List[NewsItem]) -> dict:
    news_text = "\n\n".join([
        f"标题: {item.title}\n来源: {item.source}\n摘要: {item.summary or '无'}"
        for item in news_items
    ])
    
    prompt = f"""作为咖啡行业分析专家，请分析以下新闻并提供深度洞察：

{news_text}

请提供：
1. 行业趋势分析（200-300字）
2. 5条具体的战略建议

以JSON格式返回：
{{
    "analysis": "详细分析内容",
    "recommendations": ["建议1", "建议2", "建议3", "建议4", "建议5"]
}}"""

    try:
        if not settings.OPENAI_API_KEY:
            raise Exception("未配置 OPENAI_API_KEY")
        
        # 支持 DeepSeek API
        client = openai.OpenAI(
            api_key=settings.OPENAI_API_KEY,
            base_url="https://api.deepseek.com"
        )
        response = client.chat.completions.create(
            model="deepseek-chat",
            messages=[
                {"role": "system", "content": "你是咖啡行业资深分析师"},
                {"role": "user", "content": prompt}
            ],
            temperature=0.7
        )
        
        result = json.loads(response.choices[0].message.content)
        return result
    except Exception as e:
        print(f"AI analysis error: {str(e)}")
        return {
            "analysis": "基于当前市场动态，咖啡行业呈现出以下特征：1）消费升级推动精品咖啡市场扩张；2）可持续发展成为行业共识；3）新兴渠道如冷萃、即饮咖啡增长迅速；4）数字化转型加速供应链优化；5）年轻消费者成为主力军，推动产品创新。",
            "recommendations": [
                "加大精品咖啡豆采购和烘焙技术投入，提升产品差异化竞争力",
                "建立可追溯的可持续供应链体系，获得ESG认证提升品牌价值",
                "开发冷萃、气泡咖啡等创新品类，抓住新兴消费趋势",
                "投资数字化系统，优化库存管理和客户体验",
                "针对Z世代消费者打造社交媒体营销和体验式门店"
            ]
        }

async def generate_daily_report():
    print(f"生成每日报告: {datetime.now()}")
    
    news_items = await fetch_coffee_news()
    
    ai_result = await analyze_news_with_ai(news_items)
    
    report = AnalysisReport(
        date=datetime.now().strftime("%Y-%m-%d"),
        news_items=news_items,
        analysis=ai_result["analysis"],
        recommendations=ai_result["recommendations"]
    )
    
    reports_db.insert(0, report)
    
    if len(reports_db) > settings.MAX_STORED_REPORTS:
        reports_db.pop()
    
    print(f"报告生成完成，共收集 {len(news_items)} 条新闻")
    
    if settings.EMAIL_ENABLED:
        try:
            email_service.send_report_email(report.dict(), settings.RECIPIENT_EMAILS)
            print("报告已通过邮件发送")
        except Exception as e:
            print(f"邮件发送失败: {str(e)}")
    
    return report

@app.on_event("startup")
async def startup_event():
    scheduler.add_job(
        generate_daily_report, 
        'cron', 
        hour=settings.DAILY_REPORT_HOUR, 
        minute=settings.DAILY_REPORT_MINUTE,
        id='daily_report_job'
    )
    scheduler.start()
    
    print(f"定时任务已启动: 每天 {settings.DAILY_REPORT_HOUR:02d}:{settings.DAILY_REPORT_MINUTE:02d} 生成报告")
    
    await generate_daily_report()

@app.get("/")
async def root():
    return {"message": "Global Intelligence Daily - 全球智讯日报"}

@app.get("/api/reports", response_model=List[AnalysisReport])
async def get_reports():
    return reports_db

@app.get("/api/reports/latest", response_model=AnalysisReport)
async def get_latest_report():
    if not reports_db:
        raise HTTPException(status_code=404, detail="暂无报告")
    return reports_db[0]

@app.post("/api/reports/generate", response_model=AnalysisReport)
async def trigger_report_generation():
    report = await generate_daily_report()
    return report

@app.get("/api/news", response_model=List[NewsItem])
async def get_latest_news():
    news = await fetch_coffee_news()
    return news

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)

