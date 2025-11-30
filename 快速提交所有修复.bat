@echo off
chcp 65001 >nul
echo ================================================================
echo          提交所有GitHub Actions修复
echo ================================================================
echo.

cd /d "%~dp0"

echo [修复内容]
echo 1. 更新 actions/upload-artifact 从 v3 到 v4
echo 2. 移除 Ubuntu 24.04 不支持的 libtinfo5 包
echo.

echo [步骤1] 查看当前变更...
git status
echo.

echo [步骤2] 添加所有变更...
git add .
if %errorlevel% neq 0 (
    echo [错误] 添加文件失败
    pause
    exit /b 1
)
echo [✓] 文件添加成功
echo.

echo [步骤3] 提交修复...
git commit -m "修复: 更新Actions配置兼容Ubuntu 24.04"
if %errorlevel% neq 0 (
    echo [提示] 可能没有新变更
    git commit --amend -m "修复: 更新Actions配置兼容Ubuntu 24.04"
)
echo.

echo ================================================================
echo [准备推送]
echo ================================================================
echo.
echo 推送地址: https://github.com/lijunjing159/kuaishou-video-replacer-android
echo.
echo 请选择推送方式：
echo 1. 使用 GitHub Desktop（推荐，最稳定）
echo 2. 使用 Git 命令行推送
echo.
set /p CHOICE="选择 (1/2): "

if "%CHOICE%"=="1" (
    echo.
    echo [GitHub Desktop]
    echo 1. 打开 GitHub Desktop
    echo 2. 应用会自动检测到提交
    echo 3. 点击顶部的 "Push origin" 按钮
    echo.
    echo 正在打开 GitHub Desktop...
    start "" "https://desktop.github.com/"
    echo.
    echo 如果GitHub Desktop未安装，下载地址：
    echo https://desktop.github.com/
    echo.
    pause
    exit /b 0
)

if "%CHOICE%"=="2" (
    echo.
    echo [步骤4] 推送到GitHub...
    echo [提示] 可能需要身份验证...
    echo.
    
    git push
    if %errorlevel% neq 0 (
        echo.
        echo [警告] HTTPS推送失败，尝试SSH方式...
        echo.
        git remote set-url origin git@github.com:lijunjing159/kuaishou-video-replacer-android.git
        git push
        if %errorlevel% neq 0 (
            echo.
            echo [错误] 推送失败
            echo.
            echo 建议：
            echo 1. 使用 GitHub Desktop（最简单）
            echo 2. 配置 SSH 密钥后重试
            echo.
            pause
            exit /b 1
        )
    )
    
    echo.
    echo ================================================================
    echo          🎉 推送成功！
    echo ================================================================
    echo.
    echo GitHub Actions 将自动重新构建
    echo.
    echo 查看构建进度：
    echo https://github.com/lijunjing159/kuaishou-video-replacer-android/actions
    echo.
    echo 预计构建时间：15-25分钟
    echo 构建完成后从 Artifacts 下载APK
    echo.
    pause
)
