const express = require('express');
const axios = require('axios');
const cheerio = require('cheerio');
const cors = require('cors');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 3001;

// 启用CORS
app.use(cors({
    origin: function (origin, callback) {
        // 允许的域名列表
        const allowedOrigins = [
            'http://localhost:8000',
            'http://127.0.0.1:8000',
            'https://silencetree346.github.io'
        ];
        
        // 允许所有GitHub Pages域名（*.github.io）
        if (origin && origin.endsWith('.github.io')) {
            callback(null, true);
        } else if (!origin || allowedOrigins.includes(origin)) {
            callback(null, true);
        } else {
            callback(new Error('Not allowed by CORS'));
        }
    },
    credentials: true
}));

// 健康检查
app.get('/health', (req, res) => {
    res.json({ status: 'ok', message: '服务运行正常' });
});

// 主API：获取所有资讯源
app.get('/api/coffee-news-sources', async (req, res) => {
    console.log('\n📡 收到资讯获取请求...');
    const startTime = Date.now();
    
    try {
        // 并发获取所有资讯源
        const results = await Promise.allSettled([
            fetchGuardian(),    // The Guardian（最稳定）
            fetchStarbucks(),   // 星巴克官网
            fetchNYT(),         // 纽约时报
        ]);
        
        // 合并结果
        const allNews = [];
        results.forEach((result, index) => {
            if (result.status === 'fulfilled') {
                allNews.push(...result.value);
            }
        });
        
        const duration = ((Date.now() - startTime) / 1000).toFixed(2);
        console.log(`✅ 共获取 ${allNews.length} 条资讯，耗时 ${duration}秒`);
        
        res.json(allNews);
        
    } catch (error) {
        console.error('❌ 获取资讯失败:', error.message);
        res.status(500).json({ error: error.message });
    }
});

// The Guardian（最可靠）
async function fetchGuardian() {
    console.log('🔍 获取 The Guardian...');
    
    try {
        const response = await axios.get('https://content.guardianapis.com/search', {
            params: {
                q: 'coffee OR starbucks OR cafe',
                'show-fields': 'headline,byline,thumbnail',
                'page-size': 10,
                'api-key': 'test' // 公共测试Key
            },
            timeout: 8000
        });
        
        const news = response.data.response.results.map(article => ({
            title: article.webTitle,
            url: article.webUrl,
            source: 'The Guardian',
            publishedAt: article.webPublicationDate,
            summary: article.webTitle
        }));
        
        console.log(`✅ The Guardian: ${news.length} 条`);
        return news;
    } catch (error) {
        console.error('❌ The Guardian 失败:', error.message);
        return [];
    }
}

// 星巴克官网
async function fetchStarbucks() {
    console.log('🔍 获取星巴克官网...');
    
    try {
        const response = await axios.get('https://stories.starbucks.com/', {
            headers: { 
                'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36'
            },
            timeout: 8000
        });
        
        const $ = cheerio.load(response.data);
        const news = [];
        
        // 根据实际HTML结构调整选择器
        $('article, .story, .news-item').each((i, elem) => {
            if (i < 5) {
                const title = $(elem).find('h2, h3, .title').text().trim();
                const link = $(elem).find('a').attr('href');
                
                if (title) {
                    news.push({
                        title,
                        url: link?.startsWith('http') ? link : `https://stories.starbucks.com${link}`,
                        source: 'Starbucks Newsroom',
                        publishedAt: new Date().toISOString(),
                        summary: title
                    });
                }
            }
        });
        
        console.log(`✅ 星巴克: ${news.length} 条`);
        return news;
    } catch (error) {
        console.error('❌ 星巴克 失败:', error.message);
        return [];
    }
}

// 纽约时报（需要API Key）
async function fetchNYT() {
    console.log('🔍 获取纽约时报...');
    
    const apiKey = process.env.NYT_API_KEY;
    if (!apiKey) {
        console.log('⚠️  未配置 NYT_API_KEY，跳过');
        return [];
    }
    
    try {
        const response = await axios.get('https://api.nytimes.com/svc/search/v2/articlesearch.json', {
            params: {
                q: 'coffee starbucks',
                fq: 'section_name:("Business")',
                sort: 'newest',
                'api-key': apiKey
            },
            timeout: 8000
        });
        
        const news = response.data.response.docs.slice(0, 5).map(article => ({
            title: article.headline.main,
            url: article.web_url,
            source: 'New York Times',
            publishedAt: article.pub_date,
            summary: article.abstract || article.snippet
        }));
        
        console.log(`✅ 纽约时报: ${news.length} 条`);
        return news;
    } catch (error) {
        console.error('❌ 纽约时报 失败:', error.message);
        return [];
    }
}

// 启动服务
app.listen(PORT, () => {
    console.log('');
    console.log('═══════════════════════════════════════');
    console.log('🚀 资讯代理服务器已启动');
    console.log('═══════════════════════════════════════');
    console.log(`📍 本地地址: http://localhost:${PORT}`);
    console.log(`🔗 API地址: http://localhost:${PORT}/api/coffee-news-sources`);
    console.log(`🏥 健康检查: http://localhost:${PORT}/health`);
    console.log('');
    console.log('📋 当前支持的资讯源：');
    console.log('   • The Guardian（英国卫报）');
    console.log('   • Starbucks Newsroom（星巴克官网）');
    console.log('   • New York Times（纽约时报，需配置API Key）');
    console.log('');
    console.log('💡 提示：');
    console.log('   1. 查看 .env 文件配置API Key');
    console.log('   2. 查看《指定资讯源配置指南.md》了解更多');
    console.log('   3. 按 Ctrl+C 停止服务');
    console.log('═══════════════════════════════════════');
    console.log('');
});

