# GitHub Pages 配置步骤

## 📋 配置GitHub Pages Settings

### 步骤1：访问仓库设置页面

1. 打开浏览器，访问您的仓库：
   ```
   https://github.com/silencetree346/tongxu
   ```

2. 点击仓库页面右上角的 **"Settings"**（设置）按钮

### 步骤2：进入Pages设置

1. 在左侧菜单栏中，找到并点击 **"Pages"**（页面）
   - 位置：Settings → 左侧菜单 → Pages

### 步骤3：配置发布源

在 **"Source"**（源）部分：

1. 点击下拉菜单，选择：**"Deploy from a branch"**（从分支部署）

2. 在 **"Branch"**（分支）部分：
   - 选择分支：**"main"**（或 "master"，取决于您的默认分支）
   - 选择文件夹：**"/docs"**（重要！必须选择docs文件夹）

3. 点击 **"Save"**（保存）按钮

### 步骤4：等待部署

1. 保存后，页面会显示：
   ```
   Your site is ready to be published at https://silencetree346.github.io/tongxu/
   ```

2. 等待 **1-2分钟**，GitHub会自动构建和部署

3. 部署完成后，绿色提示会变为：
   ```
   Your site is live at https://silencetree346.github.io/tongxu/
   ```

---

## ✅ 配置完成后的访问链接

部署成功后，您的网站地址是：

```
https://silencetree346.github.io/tongxu/
```

---

## 🔍 配置截图说明

### Source配置示例：
```
Source
┌─────────────────────────────┐
│ Deploy from a branch   ▼    │  ← 选择这个
└─────────────────────────────┘

Branch
┌─────────────────────────────┐
│ main                    ▼   │  ← 选择 main
└─────────────────────────────┘

Folder
┌─────────────────────────────┐
│ /docs                  ▼   │  ← 选择 /docs
└─────────────────────────────┘

[Save]  ← 点击保存
```

---

## ⚠️ 重要提示

1. **必须选择 `/docs` 文件夹**，因为我们的网站文件在 `docs/index.html`

2. **分支名称**：
   - 如果您的默认分支是 `main`，选择 `main`
   - 如果您的默认分支是 `master`，选择 `master`

3. **如果看不到Pages选项**：
   - 确保代码已经推送到GitHub
   - 确保仓库是Public（公开）
   - 刷新页面重试

4. **如果显示404错误**：
   - 检查是否选择了正确的文件夹 `/docs`
   - 确认 `docs/index.html` 文件存在
   - 等待1-2分钟让GitHub更新

---

## 🆘 常见问题

### Q: 找不到Pages选项？
A: 确保：
- 代码已经推送到GitHub
- 仓库是Public（公开仓库）
- 刷新页面

### Q: 显示"GitHub Pages is currently disabled"？
A: 需要先推送代码到GitHub，然后才能启用Pages

### Q: 部署后显示404？
A: 
- 检查Folder是否选择了 `/docs`
- 确认 `docs/index.html` 文件存在
- 等待1-2分钟

### Q: 如何更新网站内容？
A: 
- 修改本地文件
- 运行 `./推送到GitHub.sh` 或手动推送
- GitHub会自动重新部署

---

## 📝 配置检查清单

- [ ] 代码已推送到GitHub
- [ ] 进入 Settings → Pages
- [ ] Source选择 "Deploy from a branch"
- [ ] Branch选择 "main"（或 "master"）
- [ ] Folder选择 "/docs"
- [ ] 点击 Save
- [ ] 等待1-2分钟
- [ ] 访问 https://silencetree346.github.io/tongxu/

---

## 🎉 完成！

配置完成后，您就可以：
- ✅ 在任何设备上访问网站
- ✅ 分享链接给其他人
- ✅ 更新内容后自动重新部署


