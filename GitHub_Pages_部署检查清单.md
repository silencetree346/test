# GitHub Pages 部署检查清单

## ✅ 部署前检查

- [ ] 已安装 GitHub Desktop
- [ ] 已登录 GitHub 账号
- [ ] 代码在 `/Users/luckincoffee/test` 目录
- [ ] 确认 `docs/index.html` 文件存在

---

## ✅ 推送代码步骤

- [ ] 打开 GitHub Desktop
- [ ] 添加本地仓库（`File` → `Add Local Repository...`）
- [ ] 查看左侧文件更改列表
- [ ] 填写提交信息（Summary 必填）
- [ ] 点击 `Commit to main`
- [ ] 点击 `Publish repository` 或 `Push origin`
- [ ] 等待上传完成

---

## ✅ GitHub Pages 配置步骤

- [ ] 访问 GitHub 仓库页面
- [ ] 点击 `Settings` 标签
- [ ] 左侧菜单点击 `Pages`
- [ ] Source 选择：`Deploy from a branch`
- [ ] Branch 设置：
  - [ ] 第一个下拉框：`main`
  - [ ] 第二个下拉框：`/docs` ⚠️ **重要！**
- [ ] 点击 `Save` 保存
- [ ] 等待 1-3 分钟部署完成

---

## ✅ 验证部署成功

- [ ] Pages 页面显示绿色 ✅
- [ ] 显示 "Your site is live at https://..."
- [ ] 访问网站链接能正常打开
- [ ] 页面标题显示：全球智讯日报
- [ ] 点击"生成今日报告"能获取到咖啡资讯
- [ ] 控制台(F12)没有严重错误

---

## ❌ 故障排查

### 问题1：网站显示 404 Not Found

**可能原因：**
- [ ] Pages 设置中文件夹选择错误（应该选 `/docs`）
- [ ] `docs/index.html` 文件不存在
- [ ] 还在部署中，需要等待几分钟

**解决方案：**
1. 检查 Settings → Pages → Branch 设置
2. 确保选择了 `/docs` 文件夹
3. 等待 3-5 分钟后再试

---

### 问题2：页面打开了但没有资讯数据

**可能原因：**
- [ ] NewsAPI Key 配额用完
- [ ] 网络连接问题
- [ ] API Key 失效

**解决方案：**
1. 按 F12 打开浏览器控制台查看错误信息
2. 如果显示 "429" 错误 = API 配额用完
3. 如果显示 "401" 错误 = API Key 失效
4. 如果显示 "426" 错误 = 协议问题（不应该出现在 HTTPS 上）

---

### 问题3：GitHub Desktop 中没有 "Publish repository" 按钮

**说明：**
- 已经连接到远程仓库了

**解决方案：**
- 直接点击右上角的 `Push origin` 按钮

---

### 问题4：提示 "This directory does not appear to be a Git repository"

**解决方案：**
1. 点击 `create a repository` 链接
2. 或点击 `Initialize Git Repository`
3. 然后继续提交和推送

---

## 📊 成功标志

部署成功后，您应该看到：

✅ GitHub Desktop 显示：
- "No local changes"（没有本地更改）
- 最后一次提交已推送

✅ GitHub 网站显示：
- Pages 页面有绿色勾选标记
- "Your site is live at ..." 

✅ 访问网站时：
- 页面正常显示
- 标题：☕ 全球智讯日报
- 点击按钮能获取咖啡资讯
- 显示智能分类和深度洞察

---

## 🎯 最终网址格式

```
https://您的GitHub用户名.github.io/仓库名/
```

例如：
- 用户名：luckincoffee
- 仓库名：coffee-intelligence-daily
- 网址：https://luckincoffee.github.io/coffee-intelligence-daily/

---

## 🔗 有用的链接

- GitHub Desktop 下载：https://desktop.github.com/
- GitHub Pages 文档：https://docs.github.com/pages
- NewsAPI 官网：https://newsapi.org

---

## 💡 提示

1. **首次部署可能需要 5 分钟**，请耐心等待
2. **后续更新只需 1-2 分钟**就能生效
3. **API Key 配额**：免费版每天 100 次请求
4. **分享链接**：可以把网址分享给任何人访问
5. **自定义域名**：可以在 Pages 设置中绑定自己的域名

---

## 📞 需要帮助？

如果遇到问题：
1. 查看浏览器控制台（F12）的错误信息
2. 查看 GitHub Actions 标签页的部署日志
3. 确认所有检查清单都已完成


