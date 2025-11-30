@echo off
chcp 65001 >nul
cd /d "%~dp0"

echo ========================================
echo   自动推送到GitHub
echo ========================================
echo.

REM 查找Git
set "GIT_CMD="
for %%p in ("C:\Program Files\Git\bin\git.exe" "C:\Program Files (x86)\Git\bin\git.exe" "%ProgramFiles%\Git\bin\git.exe") do (
    if exist %%p (
        set "GIT_CMD=%%~p"
        goto :found_git
    )
)

git --version >nul 2>&1
if %errorlevel% equ 0 (
    set "GIT_CMD=git"
    goto :found_git
)

echo [错误] 未找到Git，请安装后重试
pause
exit /b 1

:found_git
echo [✓] Git已找到
echo.

REM 配置Git
echo [配置] 设置Git用户信息...
"%GIT_CMD%" config user.name "lijunjing159" 2>nul
"%GIT_CMD%" config user.email "lijunjing159@users.noreply.github.com" 2>nul

REM 查看状态
echo [检查] 当前状态...
"%GIT_CMD%" status
echo.

REM 添加所有文件
echo [执行] 添加所有文件...
"%GIT_CMD%" add .
if %errorlevel% neq 0 (
    echo [错误] 添加文件失败
    pause
    exit /b 1
)

REM 提交
echo [执行] 提交代码...
"%GIT_CMD%" commit -m "fix: update GitHub Actions config for Ubuntu 24.04"
if %errorlevel% neq 0 (
    echo [提示] 可能没有新变更
)
echo.

REM 确保在main分支
echo [执行] 确保在main分支...
"%GIT_CMD%" branch -M main

REM 配置远程仓库
echo [执行] 配置远程仓库...
"%GIT_CMD%" remote remove origin 2>nul
"%GIT_CMD%" remote add origin https://github.com/lijunjing159/kuaishou-video-replacer-android.git

echo.
echo ========================================
echo   开始推送
echo ========================================
echo.
echo [提示] 推送到: https://github.com/lijunjing159/kuaishou-video-replacer-android
echo [提示] 可能需要在浏览器中登录GitHub...
echo.

REM 推送
"%GIT_CMD%" push -u origin main --force
if %errorlevel% neq 0 (
    echo.
    echo [失败] 推送失败
    echo.
    echo [建议] 使用GitHub Desktop:
    echo 1. 打开 GitHub Desktop
    echo 2. File -^> Add Local Repository -^> 选择此文件夹
    echo 3. 点击 Push origin
    echo.
    echo 下载地址: https://desktop.github.com/
    echo.
    pause
    exit /b 1
)

echo.
echo ========================================
echo   ✓ 推送成功！
echo ========================================
echo.
echo [完成] 代码已推送到GitHub
echo [自动] GitHub Actions正在构建APK...
echo.
echo 查看进度:
echo https://github.com/lijunjing159/kuaishou-video-replacer-android/actions
echo.
echo 预计15-25分钟后可下载APK
echo.

REM 自动打开浏览器
start https://github.com/lijunjing159/kuaishou-video-replacer-android/actions

pause
