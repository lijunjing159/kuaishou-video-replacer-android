@echo off
chcp 65001 >nul
echo ================================================================
echo          使用SSH方式推送到GitHub（解决网络问题）
echo ================================================================
echo.

cd /d "%~dp0"

echo [提示] HTTPS方式可能因网络问题失败
echo [方案] 使用SSH方式可以解决大部分连接问题
echo.

REM 检查是否已有SSH密钥
if exist "%USERPROFILE%\.ssh\id_rsa.pub" (
    echo [✓] 检测到已有SSH密钥
    goto :show_key
)

echo [步骤1] 生成SSH密钥...
echo [提示] 按3次回车使用默认设置
echo.
ssh-keygen -t rsa -b 4096 -C "lijunjing159@users.noreply.github.com"
if %errorlevel% neq 0 (
    echo [错误] SSH密钥生成失败
    pause
    exit /b 1
)
echo [✓] SSH密钥生成成功
echo.

:show_key
echo [步骤2] 复制SSH公钥...
echo.
echo 你的SSH公钥内容（请复制）：
echo ================================================================
type "%USERPROFILE%\.ssh\id_rsa.pub"
echo ================================================================
echo.
echo [步骤3] 添加SSH密钥到GitHub：
echo 1. 正在打开GitHub SSH设置页面...
start https://github.com/settings/ssh/new
echo 2. 在打开的页面中：
echo    - Title: 填写 "My Computer" 或其他名称
echo    - Key: 粘贴上面的SSH公钥内容
echo    - 点击 "Add SSH key"
echo.
set /p ADDED="已添加SSH密钥到GitHub? (输入 y 继续): "
if /i not "%ADDED%"=="y" (
    echo [取消] 请先添加SSH密钥到GitHub
    pause
    exit /b 0
)

echo.
echo [步骤4] 测试SSH连接...
ssh -T git@github.com
echo.

echo [步骤5] 切换远程地址为SSH...
git remote remove origin 2>nul
git remote add origin git@github.com:lijunjing159/kuaishou-video-replacer-android.git
echo [✓] 已切换到SSH方式
echo.

echo [步骤6] 推送到GitHub...
git push -u origin main
if %errorlevel% neq 0 (
    echo.
    echo [尝试] 强制推送...
    git push -u -f origin main
    if %errorlevel% neq 0 (
        echo [错误] 推送失败
        pause
        exit /b 1
    )
)

echo.
echo ================================================================
echo          🎉 推送成功！
echo ================================================================
echo.
echo 仓库地址: https://github.com/lijunjing159/kuaishou-video-replacer-android
echo Actions: https://github.com/lijunjing159/kuaishou-video-replacer-android/actions
echo.
pause
