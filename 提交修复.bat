@echo off
chcp 65001 >nul
echo ================================================================
echo          提交GitHub Actions修复
echo ================================================================
echo.

cd /d "%~dp0"

echo [修复] 已更新 actions/upload-artifact 从 v3 到 v4
echo.

echo [步骤1] 添加修改的文件...
git add .github/workflows/build-apk.yml
if %errorlevel% neq 0 (
    echo [错误] 添加文件失败
    pause
    exit /b 1
)
echo [✓] 文件添加成功
echo.

echo [步骤2] 提交修改...
git commit -m "修复: 更新 upload-artifact 到 v4 版本"
if %errorlevel% neq 0 (
    echo [提示] 可能没有变更
)
echo.

echo [步骤3] 推送到GitHub...
echo [提示] 如果HTTPS失败，建议使用GitHub Desktop
echo.

REM 先尝试普通推送
git push
if %errorlevel% neq 0 (
    echo.
    echo [失败] HTTPS推送失败
    echo.
    echo 请选择：
    echo 1. 使用 GitHub Desktop 推送（推荐）
    echo 2. 使用 SSH 方式推送
    echo 3. 手动推送
    echo.
    set /p CHOICE="选择 (1/2/3): "
    
    if "%CHOICE%"=="1" (
        echo.
        echo 请打开 GitHub Desktop：
        echo 1. File → Add Local Repository
        echo 2. 选择此目录
        echo 3. 点击 "Push origin"
        echo.
        start "" "https://desktop.github.com/"
        pause
        exit /b 0
    )
    
    if "%CHOICE%"=="2" (
        echo.
        echo 正在切换到SSH方式...
        git remote set-url origin git@github.com:lijunjing159/kuaishou-video-replacer-android.git
        git push
        if %errorlevel% neq 0 (
            echo [错误] SSH推送失败，请配置SSH密钥
            echo 运行: 使用SSH推送.bat
            pause
            exit /b 1
        )
    )
    
    if "%CHOICE%"=="3" (
        echo.
        echo 手动推送命令：
        echo   git push
        echo.
        pause
        exit /b 0
    )
)

echo.
echo ================================================================
echo          🎉 修复已推送到GitHub！
echo ================================================================
echo.
echo GitHub Actions会自动重新构建
echo 访问: https://github.com/lijunjing159/kuaishou-video-replacer-android/actions
echo.
pause
