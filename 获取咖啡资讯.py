#!/usr/bin/env python3
import asyncio
import httpx
import feedparser
from datetime import datetime, timedelta
from bs4 import BeautifulSoup
import json

class CoffeeNewsCollector:
    def __init__(self):
        self.news_items = []
        self.headers = {
            "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36"
        }
    
    async def fetch_36kr(self):
        """获取36氪RSS"""
        try:
            feed_url = "https://36kr.com/feed"
            async with httpx.AsyncClient(timeout=30.0) as client:
                response = await client.get(feed_url, headers=self.headers)
                feed = feedparser.parse(response.text)
                
                count = 0
                for entry in feed.entries[:20]:
                    title = entry.get('title', '')
                    link = entry.get('link', '')
                    published = entry.get('published', '')
                    summary = entry.get('summary', '')
                    
                    if self._is_coffee_related(title + ' ' + summary):
                        self.news_items.append({
                            'title': title,
                            'url': link,
                            'source': '36氪',
                            'date': published,
                            'summary': BeautifulSoup(summary, 'html.parser').get_text()[:200]
                        })
                        count += 1
                
                print(f"✅ 36氪: 获取到 {count} 条咖啡相关资讯")
        except Exception as e:
            print(f"❌ 36氪获取失败: {str(e)}")
    
    async def fetch_huxiu(self):
        """获取虎嗅RSS"""
        try:
            feed_url = "https://www.huxiu.com/rss/0.xml"
            async with httpx.AsyncClient(timeout=30.0) as client:
                response = await client.get(feed_url, headers=self.headers)
                feed = feedparser.parse(response.text)
                
                count = 0
                for entry in feed.entries[:20]:
                    title = entry.get('title', '')
                    link = entry.get('link', '')
                    published = entry.get('published', '')
                    summary = entry.get('summary', '')
                    
                    if self._is_coffee_related(title + ' ' + summary):
                        self.news_items.append({
                            'title': title,
                            'url': link,
                            'source': '虎嗅',
                            'date': published,
                            'summary': BeautifulSoup(summary, 'html.parser').get_text()[:200]
                        })
                        count += 1
                
                print(f"✅ 虎嗅: 获取到 {count} 条咖啡相关资讯")
        except Exception as e:
            print(f"❌ 虎嗅获取失败: {str(e)}")
    
    async def fetch_tmtpost(self):
        """获取钛媒体RSS"""
        try:
            feed_url = "https://www.tmtpost.com/rss.xml"
            async with httpx.AsyncClient(timeout=30.0) as client:
                response = await client.get(feed_url, headers=self.headers)
                feed = feedparser.parse(response.text)
                
                count = 0
                for entry in feed.entries[:20]:
                    title = entry.get('title', '')
                    link = entry.get('link', '')
                    published = entry.get('published', '')
                    summary = entry.get('summary', '')
                    
                    if self._is_coffee_related(title + ' ' + summary):
                        self.news_items.append({
                            'title': title,
                            'url': link,
                            'source': '钛媒体',
                            'date': published,
                            'summary': BeautifulSoup(summary, 'html.parser').get_text()[:200]
                        })
                        count += 1
                
                print(f"✅ 钛媒体: 获取到 {count} 条咖啡相关资讯")
        except Exception as e:
            print(f"❌ 钛媒体获取失败: {str(e)}")
    
    def _is_coffee_related(self, text):
        """检查是否为咖啡相关内容"""
        keywords = [
            '咖啡', '星巴克', '瑞幸', 'luckin', 'starbucks',
            'manner', 'seesaw', 'costa', '雀巢', 
            'coffee', 'cafe', 'espresso', 'latte'
        ]
        text_lower = text.lower()
        return any(keyword in text_lower for keyword in keywords)
    
    async def collect_all_news(self):
        """并发获取所有新闻源"""
        print("🔄 开始获取咖啡行业资讯...\n")
        
        tasks = [
            self.fetch_36kr(),
            self.fetch_huxiu(),
            self.fetch_tmtpost()
        ]
        
        await asyncio.gather(*tasks, return_exceptions=True)
        
        print(f"\n📊 共获取到 {len(self.news_items)} 条咖啡相关资讯")
        
        return self.news_items
    
    def display_results(self):
        """显示结果"""
        if not self.news_items:
            print("\n⚠️  未获取到咖啡相关资讯")
            return
        
        print("\n" + "="*80)
        print(f"📰 咖啡行业资讯汇总 - {datetime.now().strftime('%Y年%m月%d日')}")
        print("="*80 + "\n")
        
        for idx, item in enumerate(self.news_items, 1):
            print(f"{idx}. 【{item['source']}】{item['title']}")
            print(f"   🔗 {item['url']}")
            if item.get('summary'):
                print(f"   💬 {item['summary']}")
            print()
        
        self.save_to_file()
    
    def save_to_file(self):
        """保存到文件"""
        filename = f"咖啡资讯_{datetime.now().strftime('%Y%m%d_%H%M%S')}.json"
        with open(filename, 'w', encoding='utf-8') as f:
            json.dump(self.news_items, f, ensure_ascii=False, indent=2)
        print(f"✅ 资讯已保存到: {filename}")

async def main():
    collector = CoffeeNewsCollector()
    await collector.collect_all_news()
    collector.display_results()

if __name__ == "__main__":
    asyncio.run(main())

