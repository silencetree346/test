#!/bin/bash

echo "=========================================="
echo "🚀 一键部署到GitHub Pages"
echo "=========================================="
echo ""

# 颜色定义
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# 检查Git是否安装
if ! command -v git &> /dev/null; then
    echo -e "${RED}❌ Git未安装${NC}"
    echo "请先安装Git: https://git-scm.com/download/mac"
    exit 1
fi

# 检查是否在Git仓库中
if [ ! -d ".git" ]; then
    echo -e "${YELLOW}📦 初始化Git仓库...${NC}"
    git init
    git branch -M main
fi

# 确保docs目录存在
if [ ! -d "docs" ]; then
    echo -e "${YELLOW}📁 创建docs目录...${NC}"
    mkdir -p docs
fi

# 复制最新文件到docs目录
echo -e "${YELLOW}📋 更新docs/index.html...${NC}"
cp tongxu/实时资讯.html docs/index.html

# 确保.nojekyll文件存在
touch docs/.nojekyll

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ 文件准备完成${NC}"
else
    echo -e "${RED}❌ 文件准备失败${NC}"
    exit 1
fi

# 添加文件
echo ""
echo -e "${YELLOW}📦 添加文件到Git...${NC}"
git add docs/ README.md GITHUB_PAGES_部署说明.md 快速分享链接方案.md 2>/dev/null

# 检查是否有更改
if git diff --staged --quiet 2>/dev/null; then
    echo -e "${YELLOW}ℹ️  没有需要提交的更改${NC}"
else
    # 提交
    echo -e "${YELLOW}💾 提交更改...${NC}"
    git commit -m "Deploy: 部署到GitHub Pages" 2>/dev/null || git commit -m "Deploy: 部署到GitHub Pages"
    
    echo -e "${GREEN}✅ 本地提交完成${NC}"
fi

# 检查远程仓库
echo ""
if git remote | grep -q origin; then
    REMOTE_URL=$(git remote get-url origin 2>/dev/null)
    echo -e "${GREEN}✅ 已配置远程仓库: ${REMOTE_URL}${NC}"
    echo ""
    echo -e "${YELLOW}🚀 推送到GitHub...${NC}"
    git push -u origin main 2>&1
    
    if [ $? -eq 0 ]; then
        echo ""
        echo -e "${GREEN}=========================================="
        echo "✅ 部署成功！"
        echo "==========================================${NC}"
        echo ""
        echo "📝 下一步："
        echo "1. 访问GitHub仓库页面"
        echo "2. 进入 Settings → Pages"
        echo "3. Source选择 'Deploy from a branch'"
        echo "4. Branch选择 'main'，Folder选择 '/docs'"
        echo "5. 点击 Save"
        echo ""
        echo "等待1-2分钟后，访问："
        echo -e "${GREEN}https://$(echo $REMOTE_URL | sed 's/.*github.com[:/]\([^/]*\)\/\([^/]*\)\.git/\1.github.io\/\2/')/${NC}"
    else
        echo ""
        echo -e "${RED}❌ 推送失败${NC}"
        echo "请检查："
        echo "1. 是否已配置GitHub凭证"
        echo "2. 是否有推送权限"
        echo "3. 网络连接是否正常"
    fi
else
    echo -e "${YELLOW}⚠️  未配置远程仓库${NC}"
    echo ""
    echo "请按以下步骤操作："
    echo ""
    echo "1. 在GitHub上创建新仓库："
    echo "   https://github.com/new"
    echo ""
    echo "2. 创建后，复制仓库URL，然后运行："
    echo "   git remote add origin https://github.com/YOUR_USERNAME/REPO_NAME.git"
    echo "   git push -u origin main"
    echo ""
    echo "3. 或者直接运行以下命令（替换YOUR_USERNAME和REPO_NAME）："
    echo "   git remote add origin https://github.com/YOUR_USERNAME/REPO_NAME.git"
    echo "   git push -u origin main"
    echo ""
    read -p "请输入GitHub仓库URL（或按Enter跳过）: " repo_url
    if [ ! -z "$repo_url" ]; then
        git remote add origin "$repo_url"
        echo -e "${YELLOW}🚀 推送到GitHub...${NC}"
        git push -u origin main 2>&1
        
        if [ $? -eq 0 ]; then
            echo ""
            echo -e "${GREEN}✅ 推送成功！${NC}"
            echo ""
            echo "📝 下一步："
            echo "1. 访问GitHub仓库页面"
            echo "2. 进入 Settings → Pages"
            echo "3. Source选择 'Deploy from a branch'"
            echo "4. Branch选择 'main'，Folder选择 '/docs'"
            echo "5. 点击 Save"
        else
            echo -e "${RED}❌ 推送失败，请检查URL和权限${NC}"
        fi
    fi
fi

echo ""
echo -e "${GREEN}=========================================="
echo "📋 部署文件已准备完成"
echo "==========================================${NC}"
echo ""
echo "文件位置："
echo "  📄 docs/index.html - 主页面"
echo "  📄 docs/.nojekyll - 配置文件"
echo ""

