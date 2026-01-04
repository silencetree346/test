# GitHub Pages 部署后端指南 🌐

## ⚠️ 重要说明

**GitHub Pages 只能托管静态网站，无法运行后端服务！**

要在 GitHub Pages 上获取真实数据，需要：
1. ✅ 前端部署到 GitHub Pages（已完成）
2. ✅ 后端部署到云端服务（需要配置）
3. ✅ 更新前端代码中的后端URL

---

## 🚀 方案1：部署到 Railway（推荐，最简单）

### 优点
- ✅ 免费额度充足
- ✅ 自动部署
- ✅ 支持 Node.js
- ✅ 提供 HTTPS URL

### 步骤

#### 1. 注册 Railway 账号
访问：https://railway.app/
使用 GitHub 账号登录

#### 2. 创建新项目
1. 点击 "New Project"
2. 选择 "Deploy from GitHub repo"
3. 选择你的仓库（`test`）
4. 选择根目录：`backend-news-proxy`

#### 3. 配置环境变量
在 Railway 项目设置中添加：
```
PORT=3001
NYT_API_KEY=你的API_Key（可选）
```

#### 4. 获取部署URL
部署完成后，Railway 会提供一个 URL，例如：
```
https://coffee-news-proxy-production.up.railway.app
```

#### 5. 更新前端代码
编辑 `docs/index.html`，找到：
```javascript
const cloudBackendUrl = 'https://your-backend-url.herokuapp.com/api/coffee-news-sources';
```

替换为你的 Railway URL：
```javascript
const cloudBackendUrl = 'https://coffee-news-proxy-production.up.railway.app/api/coffee-news-sources';
```

#### 6. 更新 CORS 配置
编辑 `backend-news-proxy/server.js`，更新 CORS：
```javascript
app.use(cors({
    origin: [
        'http://localhost:8000', 
        'https://silencetree346.github.io',
        'https://你的GitHub用户名.github.io'
    ]
}));
```

#### 7. 推送更新
```bash
git add .
git commit -m "更新后端URL为Railway地址"
git push
```

---

## 🚀 方案2：部署到 Vercel（推荐，免费）

### 优点
- ✅ 完全免费
- ✅ 自动部署
- ✅ 支持 Node.js
- ✅ 全球CDN加速

### 步骤

#### 1. 安装 Vercel CLI
```bash
npm install -g vercel
```

#### 2. 登录 Vercel
```bash
cd /Users/luckincoffee/test/backend-news-proxy
vercel login
```

#### 3. 部署
```bash
vercel
```

按提示操作：
- 选择项目目录：`backend-news-proxy`
- 是否覆盖设置：`N`
- 是否部署：`Y`

#### 4. 获取部署URL
部署完成后会显示 URL，例如：
```
https://coffee-news-proxy.vercel.app
```

#### 5. 更新前端代码
编辑 `docs/index.html`：
```javascript
const cloudBackendUrl = 'https://coffee-news-proxy.vercel.app/api/coffee-news-sources';
```

#### 6. 更新 CORS 配置
编辑 `backend-news-proxy/server.js`：
```javascript
app.use(cors({
    origin: [
        'http://localhost:8000', 
        'https://silencetree346.github.io'
    ]
}));
```

---

## 🚀 方案3：部署到 Heroku（传统方案）

### 优点
- ✅ 稳定可靠
- ✅ 免费额度（有限）
- ✅ 支持 Node.js

### 步骤

#### 1. 安装 Heroku CLI
```bash
# macOS
brew install heroku/brew/heroku
```

#### 2. 登录 Heroku
```bash
heroku login
```

#### 3. 创建应用
```bash
cd /Users/luckincoffee/test/backend-news-proxy
heroku create coffee-news-proxy
```

#### 4. 配置环境变量
```bash
heroku config:set NYT_API_KEY=你的API_Key
```

#### 5. 部署
```bash
git init
git add .
git commit -m "Initial commit"
git push heroku main
```

#### 6. 获取部署URL
```bash
heroku info
```

会显示 URL，例如：
```
https://coffee-news-proxy.herokuapp.com
```

#### 7. 更新前端代码
编辑 `docs/index.html`：
```javascript
const cloudBackendUrl = 'https://coffee-news-proxy.herokuapp.com/api/coffee-news-sources';
```

---

## 🔧 更新前端代码

### 方法1：手动更新

编辑 `docs/index.html`，找到：
```javascript
const cloudBackendUrl = 'https://your-backend-url.herokuapp.com/api/coffee-news-sources';
```

替换为你的实际后端URL：
```javascript
const cloudBackendUrl = 'https://你的后端URL/api/coffee-news-sources';
```

### 方法2：使用环境变量（高级）

如果需要更灵活的配置，可以使用构建工具，但 GitHub Pages 是静态托管，建议直接修改代码。

---

## ✅ 验证部署

### 1. 测试后端API
在浏览器中访问：
```
https://你的后端URL/api/coffee-news-sources
```

应该返回JSON格式的资讯数据。

### 2. 测试前端
访问 GitHub Pages：
```
https://silencetree346.github.io/test/
```

点击"获取最新资讯"，应该能获取到真实数据。

### 3. 检查浏览器控制台
打开开发者工具（F12），查看：
- ✅ 是否有CORS错误
- ✅ 是否成功调用后端API
- ✅ 是否获取到资讯数据

---

## 🐛 故障排查

### 问题1：CORS 错误

**错误信息：**
```
Access to XMLHttpRequest at 'https://...' from origin 'https://silencetree346.github.io' has been blocked by CORS policy
```

**解决方案：**
更新 `backend-news-proxy/server.js` 中的 CORS 配置，添加你的 GitHub Pages 域名：
```javascript
app.use(cors({
    origin: [
        'http://localhost:8000', 
        'https://silencetree346.github.io',
        'https://你的GitHub用户名.github.io'
    ]
}));
```

### 问题2：后端返回404

**检查清单：**
1. ✅ 后端URL是否正确？
2. ✅ API路径是否为 `/api/coffee-news-sources`？
3. ✅ 后端服务是否正常运行？

### 问题3：获取不到数据

**检查清单：**
1. ✅ 后端日志是否有错误？
2. ✅ 资讯源API是否正常？
3. ✅ 网络连接是否正常？

---

## 📊 部署架构

```
┌─────────────────┐
│  GitHub Pages   │  ← 前端（静态网站）
│  (前端代码)      │
└────────┬────────┘
         │ HTTPS请求
         ▼
┌─────────────────┐
│  Railway/Vercel │  ← 后端（Node.js服务）
│  (后端API)      │
└────────┬────────┘
         │ 获取资讯
         ▼
┌─────────────────┐
│  资讯源网站      │  ← 外部API/网站
│  (The Guardian) │
└─────────────────┘
```

---

## 💡 推荐方案

**对于初学者：** Railway（最简单，自动部署）
**对于有经验者：** Vercel（免费，性能好）
**对于企业用户：** Heroku（稳定，功能全）

---

## 🎯 快速开始

1. ✅ 选择部署平台（推荐 Railway）
2. ✅ 部署后端服务
3. ✅ 获取后端URL
4. ✅ 更新前端代码中的 `cloudBackendUrl`
5. ✅ 更新后端 CORS 配置
6. ✅ 推送更新到 GitHub
7. ✅ 测试 GitHub Pages 是否能获取数据

---

**部署完成后，GitHub Pages 就能获取真实资讯数据了！** 🎉✨

