# 🗑️ 清空GitHub仓库内容

## 📋 方法1：使用GitHub Desktop（最简单）

### 步骤1：在GitHub Desktop中删除所有文件

1. **打开GitHub Desktop**
2. **确保仓库已添加**（File → Add Local Repository）
3. **在左侧文件列表中**：
   - 选择所有文件（点击 "Select all" 或逐个勾选）
   - 右键点击 → 选择 "Delete" 或 "Remove"
   - 或者直接删除文件（文件会被标记为删除）

### 步骤2：提交删除

1. **在左下角 "Summary" 输入框输入：**
   ```
   Remove all files
   ```

2. **点击 `Commit to main`**

3. **点击 `Push origin`**（右上角）

4. **等待推送完成**

**完成后，GitHub仓库将为空。**

---

## 📋 方法2：使用GitHub网页界面

### 步骤1：删除文件

1. **访问仓库**：
   ```
   https://github.com/silencetree346/tongxu
   ```

2. **逐个删除文件**：
   - 点击文件
   - 点击右上角的垃圾桶图标（Delete）
   - 输入提交信息：`Delete file`
   - 点击 "Commit changes"

3. **删除文件夹**：
   - 进入文件夹
   - 删除文件夹内的所有文件
   - 文件夹会自动删除

**注意：这个方法比较慢，如果文件很多不建议使用。**

---

## 📋 方法3：使用命令行（如果Git已安装）

### 步骤1：删除所有文件

```bash
cd /Users/luckincoffee/test

# 删除所有文件（保留.git文件夹）
git rm -r --cached .
git commit -m "Remove all files"
git push origin main
```

### 步骤2：删除本地文件（可选）

```bash
# 删除所有文件（除了.git）
find . -maxdepth 1 ! -name '.git' ! -name '.' -exec rm -rf {} +
```

---

## 📋 方法4：删除并重新创建仓库（最彻底）

### 步骤1：删除仓库

1. **访问**：https://github.com/silencetree346/tongxu/settings
2. **向下滚动到 "Danger Zone"**
3. **点击 "Delete this repository"**
4. **输入仓库名称确认**：`silencetree346/tongxu`
5. **确认删除**

### 步骤2：重新创建仓库

1. **访问**：https://github.com/new
2. **Repository name**: `tongxu`
3. **选择 Public**
4. **创建仓库**

---

## ✅ 推荐方案

### 方案A：使用GitHub Desktop（推荐）

**优点：**
- ✅ 最简单
- ✅ 图形界面操作
- ✅ 可以预览删除的文件

**步骤：**
1. 在GitHub Desktop中选择所有文件
2. 删除文件
3. 提交并推送

---

### 方案B：删除并重新创建仓库

**优点：**
- ✅ 最彻底
- ✅ 完全清空
- ✅ 重新开始

**步骤：**
1. 删除仓库
2. 创建新仓库
3. 重新推送代码

---

## 🎯 清空后重新部署

**清空仓库后，重新推送代码：**

1. **在GitHub Desktop中**：
   - 选择 `docs` 文件夹下的文件
   - 提交并推送

2. **配置GitHub Pages**：
   - Settings → Pages
   - Folder: `/docs`
   - 保存

---

## 💡 提示

- **清空前确认**：本地文件已保存（本地文件不会受影响）
- **清空后**：可以重新推送代码
- **如果只是想重新部署**：清空后重新推送即可

---

## 🎯 现在请选择

**您想使用哪种方法？**

1. **GitHub Desktop**（最简单）
2. **删除并重新创建仓库**（最彻底）
3. **命令行**（如果Git已安装）

告诉我您的选择，我会提供详细步骤！

