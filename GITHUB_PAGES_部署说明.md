# GitHub Pages 部署说明

## 📋 部署步骤

### 1. 创建GitHub仓库

1. 登录GitHub，点击右上角 `+` → `New repository`
2. 仓库名称：`global-intelligence-daily`（或您喜欢的名称）
3. 设置为 **Public**（GitHub Pages免费版需要公开仓库）
4. 点击 `Create repository`

### 2. 上传代码到GitHub

在项目根目录执行以下命令：

```bash
# 初始化Git仓库（如果还没有）
git init

# 添加所有文件
git add .

# 提交
git commit -m "Initial commit: Global Intelligence Daily"

# 添加远程仓库（替换YOUR_USERNAME为您的GitHub用户名）
git remote add origin https://github.com/YOUR_USERNAME/global-intelligence-daily.git

# 推送到GitHub
git branch -M main
git push -u origin main
```

### 3. 启用GitHub Pages

1. 进入GitHub仓库页面
2. 点击 `Settings`（设置）
3. 左侧菜单找到 `Pages`
4. 在 `Source` 部分：
   - 选择 `Deploy from a branch`
   - Branch选择 `main`
   - Folder选择 `/docs`
5. 点击 `Save`

### 4. 访问网站

等待1-2分钟后，访问：
```
https://YOUR_USERNAME.github.io/global-intelligence-daily/
```

## 📁 项目结构

```
项目根目录/
├── docs/                    # GitHub Pages部署目录
│   ├── index.html          # 主页面（实时资讯版）
│   └── .nojekyll           # 禁用Jekyll处理
├── tongxu/
│   └── 实时资讯.html       # 源文件
└── 其他文件...
```

## 🔄 更新部署

每次修改后，执行：

```bash
# 复制最新文件到docs目录
cp tongxu/实时资讯.html docs/index.html

# 提交并推送
git add docs/index.html
git commit -m "Update: 更新实时资讯内容"
git push origin main
```

推送后，GitHub Pages会自动更新（通常1-2分钟）。

## ⚙️ 高级配置

### 使用GitHub Actions自动部署（可选）

创建 `.github/workflows/deploy.yml`：

```yaml
name: Deploy to GitHub Pages

on:
  push:
    branches:
      - main

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Deploy
        uses: peaceiris/actions-gh-pages@v3
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ./docs
```

## 📝 注意事项

1. **公开仓库**：GitHub Pages免费版需要公开仓库
2. **文件大小**：单个文件建议不超过100MB
3. **CDN资源**：项目使用CDN加载Vue.js等库，无需担心依赖问题
4. **API限制**：NewsAPI免费版有请求限制，建议配置自己的API Key

## 🐛 常见问题

### 页面404错误
- 检查 `Settings` → `Pages` 配置是否正确
- 确认 `docs/index.html` 文件存在
- 等待1-2分钟让GitHub Pages更新

### 样式或功能异常
- 检查浏览器控制台是否有错误
- 确认CDN资源加载正常
- 清除浏览器缓存后重试

## 📞 技术支持

如有问题，请检查：
- GitHub Pages状态：https://www.githubstatus.com/
- 仓库设置中的Pages配置
- 浏览器控制台错误信息


