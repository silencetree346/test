#!/usr/bin/env python3
"""
一键部署到GitHub Pages
使用GitHub API直接推送代码
"""

import os
import subprocess
import json
import base64
from pathlib import Path

# 配置信息
TOKEN = "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"
USERNAME = "silencetree346"
REPO = "tongxu"
BRANCH = "main"

def check_git():
    """检查Git是否安装"""
    try:
        subprocess.run(["git", "--version"], check=True, capture_output=True)
        return True
    except:
        return False

def init_repo():
    """初始化Git仓库"""
    os.chdir("/Users/luckincoffee/test")
    
    if not os.path.exists(".git"):
        subprocess.run(["git", "init"], check=True)
        subprocess.run(["git", "branch", "-M", "main"], check=True)
        print("✅ Git仓库已初始化")
    else:
        print("✅ Git仓库已存在")

def prepare_files():
    """准备部署文件"""
    os.makedirs("docs", exist_ok=True)
    
    # 复制文件
    source_file = "tongxu/实时资讯.html"
    target_file = "docs/index.html"
    
    if os.path.exists(source_file):
        with open(source_file, "r", encoding="utf-8") as f:
            content = f.read()
        with open(target_file, "w", encoding="utf-8") as f:
            f.write(content)
        print(f"✅ 已复制 {source_file} 到 {target_file}")
    
    # 创建.nojekyll文件
    nojekyll_file = "docs/.nojekyll"
    Path(nojekyll_file).touch()
    print("✅ 已创建 .nojekyll 文件")

def commit_and_push():
    """提交并推送代码"""
    try:
        # 配置远程仓库
        subprocess.run(["git", "remote", "remove", "origin"], 
                      capture_output=True)
        remote_url = f"https://{TOKEN}@github.com/{USERNAME}/{REPO}.git"
        subprocess.run(["git", "remote", "add", "origin", remote_url], check=True)
        print("✅ 远程仓库已配置")
        
        # 添加文件
        subprocess.run(["git", "add", "."], check=True)
        print("✅ 文件已添加")
        
        # 提交
        subprocess.run(["git", "commit", "-m", "Deploy: 部署到GitHub Pages"], 
                      check=True)
        print("✅ 已提交")
        
        # 推送
        subprocess.run(["git", "push", "-u", "origin", BRANCH, "--force"], check=True)
        print("✅ 已推送到GitHub")
        
        # 清理Token
        subprocess.run(["git", "remote", "set-url", "origin", 
                       f"https://github.com/{USERNAME}/{REPO}.git"], check=True)
        print("✅ Token已清理")
        
        return True
    except subprocess.CalledProcessError as e:
        print(f"❌ 错误: {e}")
        return False

def main():
    print("=" * 50)
    print("🚀 一键部署到GitHub Pages")
    print("=" * 50)
    print()
    
    # 检查Git
    if not check_git():
        print("❌ Git未安装")
        print("请先安装: xcode-select --install")
        return
    
    # 初始化仓库
    init_repo()
    
    # 准备文件
    prepare_files()
    
    # 提交并推送
    if commit_and_push():
        print()
        print("=" * 50)
        print("✅ 部署成功！")
        print("=" * 50)
        print()
        print("📝 下一步：配置GitHub Pages")
        print()
        print("1. 访问: https://github.com/silencetree346/tongxu/settings/pages")
        print("2. Source: Deploy from a branch")
        print("3. Branch: main")
        print("4. Folder: /docs")
        print("5. 点击 Save")
        print()
        print("等待1-2分钟后，访问：")
        print("https://silencetree346.github.io/tongxu/")
        print()
    else:
        print()
        print("❌ 部署失败")
        print("请检查错误信息或使用GitHub Desktop手动推送")

if __name__ == "__main__":
    main()

