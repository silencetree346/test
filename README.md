# Global Intelligence Daily - 全球智讯日报

> 聚全球之势 · 析深层之理 · 领未来之道

## 🌟 项目简介

全球智讯日报是一个智能资讯分析系统，专注于咖啡行业的深度洞察和战略规划。系统聚合国内外主流资讯平台的最新资讯，通过AI智能分析，提供结构化的行业洞察和可落地的优化建议。

## ✨ 核心功能

- 📰 **实时资讯聚合**：整合36氪、艾瑞咨询、虎嗅、钛媒体等国内平台 + 国际主流媒体
- 🤖 **AI深度分析**：基于"人、货、场"框架的行业/市场/公司三维分析
- 💡 **战略规划**：营销增长、供应链、门店运营三大维度的优化路径
- 📊 **智能分类**：自动按公司动态、行业趋势、市场变化分类
- 📥 **PDF导出**：一键生成包含完整内容的PDF报告

## 🚀 快速开始

### 在线访问

访问GitHub Pages部署的版本：
```
https://YOUR_USERNAME.github.io/global-intelligence-daily/
```

### 本地运行

1. 克隆仓库
```bash
git clone https://github.com/YOUR_USERNAME/global-intelligence-daily.git
cd global-intelligence-daily
```

2. 打开网页
```bash
# macOS
open docs/index.html

# Windows
start docs/index.html

# Linux
xdg-open docs/index.html
```

## 📁 项目结构

```
.
├── docs/                    # GitHub Pages部署目录
│   ├── index.html          # 主页面
│   └── .nojekyll           # 禁用Jekyll
├── tongxu/                  # 源文件目录
│   └── 实时资讯.html       # 实时资讯版本
├── backend/                 # 后端服务（可选）
│   ├── main.py             # FastAPI服务
│   └── requirements.txt    # Python依赖
└── README.md               # 项目说明
```

## 🛠️ 技术栈

- **前端**：Vue.js 3 + HTML5 + CSS3
- **PDF生成**：html2canvas + jsPDF
- **HTTP请求**：Axios
- **数据源**：NewsAPI + 国内主流平台

## 📖 使用说明

1. **获取资讯**
   - 点击"获取最新资讯"按钮
   - 系统自动获取最近24小时的国内外资讯

2. **查看分析**
   - 今日要闻：按公司/行业/市场分类
   - AI深度分析：行业/市场/公司 × 人货场表格
   - 战略规划：营销增长/供应链/门店运营

3. **导出PDF**
   - 点击"下载PDF报告"按钮
   - 等待生成完成，PDF自动下载

## 🌐 数据源

### 国内平台
- 36氪（科技创投）
- 艾瑞咨询（行业研究）
- 虎嗅（商业科技）
- 钛媒体（科技财经）

### 国际平台
- NewsAPI（新闻聚合）
- 华尔街日报、哈佛商业评论、金融时报等

## 📝 部署到GitHub Pages

详细部署说明请查看：[GITHUB_PAGES_部署说明.md](./GITHUB_PAGES_部署说明.md)

## 🔧 配置说明

### NewsAPI配置（可选）

如需使用真实国际资讯，需要配置NewsAPI Key：

1. 访问 https://newsapi.org/ 注册账号
2. 获取API Key
3. 修改 `docs/index.html` 中的 `apiKey` 变量

## 📄 许可证

MIT License

## 👥 贡献

欢迎提交Issue和Pull Request！

## 📞 联系方式

如有问题或建议，请通过GitHub Issues反馈。

---

**注意**：本项目使用CDN加载外部资源，需要网络连接。部分功能（如NewsAPI）可能需要配置API Key。

