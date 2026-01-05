#!/bin/bash

echo "🚀 开始配置资讯源后端服务..."
echo ""

# 检查Node.js
if ! command -v node &> /dev/null; then
    echo "❌ 未检测到Node.js"
    echo "📥 请先安装Node.js: https://nodejs.org/"
    exit 1
fi

echo "✅ Node.js版本: $(node -v)"
echo ""

# 创建后端项目目录
BACKEND_DIR="backend-news-proxy"

if [ -d "$BACKEND_DIR" ]; then
    echo "⚠️  目录 $BACKEND_DIR 已存在"
    read -p "是否覆盖？(y/n): " confirm
    if [ "$confirm" != "y" ]; then
        echo "❌ 已取消"
        exit 1
    fi
    rm -rf "$BACKEND_DIR"
fi

echo "📁 创建项目目录..."
mkdir -p "$BACKEND_DIR"
cd "$BACKEND_DIR"

# 初始化package.json
echo "📦 初始化项目..."
cat > package.json << 'EOF'
{
  "name": "coffee-news-proxy",
  "version": "1.0.0",
  "description": "咖啡行业资讯代理服务器",
  "main": "server.js",
  "scripts": {
    "start": "node server.js",
    "dev": "nodemon server.js"
  },
  "dependencies": {
    "express": "^4.18.2",
    "axios": "^1.6.0",
    "cheerio": "^1.0.0-rc.12",
    "cors": "^2.8.5",
    "dotenv": "^16.3.1"
  },
  "devDependencies": {
    "nodemon": "^3.0.1"
  }
}
EOF

# 创建.env文件
echo "🔑 创建配置文件..."
cat > .env << 'EOF'
PORT=3001

# 纽约时报API Key（可选）
# 注册地址：https://developer.nytimes.com/
NYT_API_KEY=
EOF

# 创建server.js（简化版）
echo "⚙️  创建服务器文件..."
cat > server.js << 'EOF'
const express = require('express');
const axios = require('axios');
const cheerio = require('cheerio');
const cors = require('cors');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 3001;

// 启用CORS
app.use(cors({
    origin: ['http://localhost:8000', 'https://silencetree346.github.io']
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
EOF

# 创建README
echo "📄 创建说明文档..."
cat > README.md << 'EOF'
# 咖啡行业资讯代理服务器

## 快速启动

### 1. 安装依赖

```bash
npm install
```

### 2. 启动服务

```bash
npm start
```

### 3. 测试API

访问：http://localhost:3001/api/coffee-news-sources

## 配置API Key

编辑 `.env` 文件：

```env
NYT_API_KEY=你的纽约时报API_Key
```

注册地址：https://developer.nytimes.com/

## 支持的资讯源

- ✅ The Guardian（英国卫报）- 无需配置
- ✅ Starbucks Newsroom（星巴克官网）- 无需配置
- ⚙️ New York Times（纽约时报）- 需要API Key

## 添加更多资讯源

查看 `指定资讯源配置指南.md` 了解如何添加：
- 36氪
- 虎嗅
- 腾讯新闻
- 艾瑞咨询
- 百度资讯
- 华尔街日报
- 金融时报
- 哈佛商业评论

## 故障排查

### 端口被占用

```bash
PORT=3002 npm start
```

### 查看日志

控制台会实时显示获取情况

## 部署

可部署到：
- Heroku
- Vercel
- Railway
- 自己的服务器

查看《指定资讯源配置指南.md》了解详细步骤。
EOF

echo ""
echo "📥 安装依赖包..."
npm install --quiet

echo ""
echo "═══════════════════════════════════════"
echo "✅ 后端服务配置完成！"
echo "═══════════════════════════════════════"
echo ""
echo "📁 项目目录: $BACKEND_DIR/"
echo ""
echo "🚀 启动服务："
echo "   cd $BACKEND_DIR"
echo "   npm start"
echo ""
echo "🔗 然后访问："
echo "   http://localhost:3001/api/coffee-news-sources"
echo ""
echo "💡 可选配置："
echo "   1. 编辑 .env 文件添加 NYT_API_KEY"
echo "   2. 查看 README.md 了解更多"
echo "   3. 查看《指定资讯源配置指南.md》添加更多资讯源"
echo ""
echo "═══════════════════════════════════════"


