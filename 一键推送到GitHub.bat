@echo off
chcp 65001 >nul
echo ================================================================
echo          快手视频替换工具 - 一键推送到GitHub
echo ================================================================
echo.

REM 检查是否安装了Git
where git >nul 2>&1
if %errorlevel% neq 0 (
    echo [错误] 未检测到Git！
    echo.
    echo 请先安装Git：
    echo 1. 访问 https://git-scm.com/download/win
    echo 2. 下载并安装Git for Windows
    echo 3. 重新运行此脚本
    echo.
    pause
    exit /b 1
)

echo [✓] Git已安装
echo.

REM 获取GitHub用户名
set /p USERNAME="lijunjing159"
if "%USERNAME%"=="" (
    echo [错误] 用户名不能为空
    pause
    exit /b 1
)

echo.
echo [信息] 将创建仓库：https://github.com/%USERNAME%/kuaishou-video-replacer-android
echo.

REM 获取仓库名称（可自定义）
set REPO_NAME=kuaishou-video-replacer-android
set /p CUSTOM_REPO="使用默认仓库名 '%REPO_NAME%' 吗? (直接回车使用默认，或输入新名称): "
if not "%CUSTOM_REPO%"=="" set REPO_NAME=%CUSTOM_REPO%

echo.
echo ================================================================
echo 开始初始化Git仓库...
echo ================================================================
echo.

REM 检查是否已经初始化
if exist .git (
    echo [警告] Git仓库已存在
    set /p REINIT="是否重新初始化? (y/n): "
    if /i "%REINIT%"=="y" (
        rmdir /s /q .git
        echo [✓] 已删除旧的Git仓库
    ) else (
        echo [跳过] 保留现有Git仓库
        goto :skip_init
    )
)

REM 初始化Git仓库
git init
if %errorlevel% neq 0 (
    echo [错误] Git初始化失败
    pause
    exit /b 1
)
echo [✓] Git仓库初始化成功

:skip_init

REM 添加所有文件
echo.
echo [进行中] 添加文件...
git add .
if %errorlevel% neq 0 (
    echo [错误] 添加文件失败
    pause
    exit /b 1
)
echo [✓] 文件添加成功

REM 提交
echo.
echo [进行中] 提交代码...
git commit -m "Initial commit: 快手视频替换工具Android版"
if %errorlevel% neq 0 (
    echo [警告] 提交失败（可能没有变更）
)
echo [✓] 代码提交成功

REM 设置远程仓库
echo.
echo [进行中] 设置远程仓库...
git remote remove origin 2>nul
git remote add origin https://github.com/%USERNAME%/%REPO_NAME%.git
if %errorlevel% neq 0 (
    echo [错误] 设置远程仓库失败
    pause
    exit /b 1
)
echo [✓] 远程仓库设置成功

REM 设置分支名称
echo.
echo [进行中] 设置主分支...
git branch -M main
echo [✓] 主分支设置为 main

REM 推送到GitHub
echo.
echo ================================================================
echo 准备推送到GitHub...
echo ================================================================
echo.
echo [重要] 即将推送到: https://github.com/%USERNAME%/%REPO_NAME%
echo.
echo 请确保你已经在GitHub上创建了该仓库！
echo 如果还没有创建，请：
echo   1. 访问 https://github.com/new
echo   2. 仓库名称填写: %REPO_NAME%
echo   3. 选择 Public (公开)
echo   4. 点击 Create repository
echo.
set /p CONTINUE="确认继续推送? (y/n): "
if /i not "%CONTINUE%"=="y" (
    echo [取消] 已取消推送操作
    pause
    exit /b 0
)

echo.
echo [进行中] 推送代码到GitHub...
echo.
git push -u origin main
if %errorlevel% neq 0 (
    echo.
    echo [错误] 推送失败！
    echo.
    echo 可能的原因：
    echo 1. GitHub仓库不存在 - 请先在GitHub上创建仓库
    echo 2. 认证失败 - 请检查GitHub账号和密码
    echo 3. 网络问题 - 请检查网络连接
    echo.
    echo 你可以稍后手动推送：
    echo   git push -u origin main
    echo.
    pause
    exit /b 1
)

echo.
echo ================================================================
echo          🎉 成功推送到GitHub！
echo ================================================================
echo.
echo 仓库地址: https://github.com/%USERNAME%/%REPO_NAME%
echo.
echo 接下来：
echo 1. 访问 https://github.com/%USERNAME%/%REPO_NAME%
echo 2. 点击 "Actions" 标签
echo 3. GitHub会自动开始构建APK（约15-25分钟）
echo 4. 构建完成后，在Artifacts中下载APK
echo.
echo 详细说明请查看: GitHub自动构建教程.md
echo.
pause
