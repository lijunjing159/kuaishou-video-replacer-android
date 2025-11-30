@echo off
chcp 65001 >nul
echo ================================================================
echo          快手视频替换工具 - 修复Git推送
echo ================================================================
echo.

echo [检查] 检查当前Git状态...
echo.

REM 检查是否在Git仓库中
git rev-parse --git-dir >nul 2>&1
if %errorlevel% neq 0 (
    echo [错误] 当前目录不是Git仓库
    echo [修复] 正在初始化Git仓库...
    git init
    if %errorlevel% neq 0 (
        echo [失败] Git初始化失败
        pause
        exit /b 1
    )
    echo [✓] Git仓库初始化成功
)

echo.
echo [检查] 查看当前文件状态...
git status

echo.
echo [修复] 添加所有文件...
git add .
if %errorlevel% neq 0 (
    echo [错误] 添加文件失败
    pause
    exit /b 1
)
echo [✓] 文件添加成功

echo.
echo [修复] 提交代码...
git commit -m "Initial commit: 快手视频替换工具Android版" 2>nul
if %errorlevel% neq 0 (
    echo [提示] 可能没有新的变更需要提交，或者已经提交过了
    echo [继续] 继续执行后续步骤...
) else (
    echo [✓] 代码提交成功
)

echo.
echo [检查] 查看当前分支...
for /f "tokens=*" %%i in ('git branch --show-current 2^>nul') do set CURRENT_BRANCH=%%i
if "%CURRENT_BRANCH%"=="" (
    echo [修复] 创建并切换到main分支...
    git checkout -b main
    echo [✓] 已创建main分支
) else (
    echo [✓] 当前分支: %CURRENT_BRANCH%
    if not "%CURRENT_BRANCH%"=="main" (
        echo [修复] 重命名分支为main...
        git branch -M main
        echo [✓] 分支已重命名为main
    )
)

echo.
echo [检查] 查看远程仓库配置...
git remote -v
echo.

REM 获取GitHub用户名
set USERNAME=lijunjing159
set /p CUSTOM_USERNAME="确认GitHub用户名 [%USERNAME%]: "
if not "%CUSTOM_USERNAME%"=="" set USERNAME=%CUSTOM_USERNAME%

echo.
echo [修复] 设置远程仓库...
git remote remove origin 2>nul
git remote add origin https://github.com/%USERNAME%/kuaishou-video-replacer-android.git
if %errorlevel% neq 0 (
    echo [错误] 设置远程仓库失败
    pause
    exit /b 1
)
echo [✓] 远程仓库设置成功

echo.
echo ================================================================
echo [重要提示] 推送前请确认：
echo ================================================================
echo.
echo 1. 你已经在GitHub上创建了仓库
echo    仓库地址: https://github.com/%USERNAME%/kuaishou-video-replacer-android
echo.
echo 2. 如果还没有创建，请现在创建：
echo    → 访问 https://github.com/new
echo    → Repository name: kuaishou-video-replacer-android
echo    → 选择 Public
echo    → 不要勾选任何初始化选项（不要添加README等）
echo    → 点击 Create repository
echo.
echo ================================================================
echo.

set /p CONTINUE="已创建GitHub仓库，确认推送? (y/n): "
if /i not "%CONTINUE%"=="y" (
    echo.
    echo [提示] 请先创建GitHub仓库，然后再次运行此脚本
    echo [提示] 创建地址: https://github.com/new
    echo.
    pause
    exit /b 0
)

echo.
echo [进行中] 推送到GitHub (使用 -f 强制推送)...
echo.
git push -u -f origin main
if %errorlevel% neq 0 (
    echo.
    echo ================================================================
    echo [错误] 推送失败！
    echo ================================================================
    echo.
    echo 可能的原因：
    echo 1. GitHub仓库不存在
    echo    → 访问 https://github.com/new 创建仓库
    echo.
    echo 2. 需要GitHub身份验证
    echo    → 首次推送需要输入GitHub账号密码
    echo    → 或使用Personal Access Token
    echo.
    echo 3. 网络连接问题
    echo    → 检查网络连接
    echo    → 可能需要科学上网
    echo.
    echo 解决方案：
    echo.
    echo 方案A: 使用GitHub Desktop（最简单）
    echo   1. 下载 GitHub Desktop: https://desktop.github.com/
    echo   2. 安装并登录
    echo   3. File → Add Local Repository → 选择此目录
    echo   4. Publish repository
    echo.
    echo 方案B: 手动推送
    echo   1. 确保GitHub仓库已创建
    echo   2. 运行: git push -u origin main
    echo   3. 输入GitHub账号密码
    echo.
    echo 方案C: 使用SSH（推荐）
    echo   1. 生成SSH密钥: ssh-keygen -t rsa -b 4096
    echo   2. 添加到GitHub: Settings → SSH Keys
    echo   3. 修改远程地址: 
    echo      git remote set-url origin git@github.com:%USERNAME%/kuaishou-video-replacer-android.git
    echo   4. 推送: git push -u origin main
    echo.
    pause
    exit /b 1
)

echo.
echo ================================================================
echo          🎉 推送成功！
echo ================================================================
echo.
echo 仓库地址: https://github.com/%USERNAME%/kuaishou-video-replacer-android
echo.
echo 下一步：
echo 1. 访问你的GitHub仓库
echo 2. 点击 "Actions" 标签页
echo 3. GitHub会自动开始构建APK（约15-25分钟）
echo 4. 构建完成后，在 Artifacts 中下载APK
echo.
echo 查看构建进度:
echo https://github.com/%USERNAME%/kuaishou-video-replacer-android/actions
echo.
pause
