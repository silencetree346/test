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

