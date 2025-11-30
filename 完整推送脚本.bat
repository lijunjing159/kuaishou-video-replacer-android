@echo off
chcp 65001 >nul
echo ================================================================
echo          Git推送到GitHub - 完整版
echo ================================================================
echo.

REM 尝试查找Git的安装路径
set GIT_CMD=git
set GIT_PATHS=^
"C:\Program Files\Git\bin\git.exe";^
"C:\Program Files (x86)\Git\bin\git.exe";^
"%LOCALAPPDATA%\Programs\Git\bin\git.exe";^
"%ProgramFiles%\Git\bin\git.exe"

REM 检测系统是否能直接找到git
git --version >nul 2>&1
if %errorlevel% equ 0 (
    echo [✓] Git已就绪
    goto :start_push
)

REM 尝试从常见路径找Git
echo [检测] 正在查找Git安装位置...
for %%p in (%GIT_PATHS%) do (
    if exist %%~p (
        set GIT_CMD=%%~p
        echo [✓] 找到Git: %%~p
        goto :start_push
    )
)

echo [错误] 未找到Git！
echo.
echo 可能的原因：
echo 1. Git刚安装，需要重启命令行窗口
echo 2. Git没有正确安装
echo.
echo 解决方案：
echo 1. 关闭此窗口
echo 2. 重新打开一个新的PowerShell或CMD窗口
echo 3. 再次运行此脚本
echo.
echo 或者访问 https://git-scm.com/download/win 重新安装Git
echo.
pause
exit /b 1

:start_push
echo.
echo ================================================================
echo 开始配置Git和推送项目
echo ================================================================
echo.

REM 进入项目目录
cd /d "%~dp0"
echo [当前目录] %CD%
echo.

REM 配置Git用户信息
echo [配置] Git用户信息...
%GIT_CMD% config --global user.name "lijunjing159"
%GIT_CMD% config --global user.email "lijunjing159@users.noreply.github.com"
echo [✓] 配置完成
echo.

REM 初始化或检查Git仓库
echo [步骤1] 初始化Git仓库...
%GIT_CMD% rev-parse --git-dir >nul 2>&1
if %errorlevel% neq 0 (
    %GIT_CMD% init
    echo [✓] Git仓库初始化完成
) else (
    echo [✓] Git仓库已存在
)
echo.

REM 添加所有文件
echo [步骤2] 添加项目文件...
%GIT_CMD% add .
if %errorlevel% neq 0 (
    echo [错误] 添加文件失败
    pause
    exit /b 1
)
echo [✓] 文件添加成功
echo.

REM 查看状态
echo [检查] 当前文件状态：
%GIT_CMD% status --short
echo.

REM 创建提交
echo [步骤3] 提交代码...
%GIT_CMD% commit -m "Initial commit: 快手视频替换工具Android版"
if %errorlevel% neq 0 (
    echo [提示] 可能没有新变更或已提交
)
echo.

REM 确保在main分支
echo [步骤4] 设置主分支为main...
%GIT_CMD% branch -M main
echo [✓] 已设置main分支
echo.

REM 配置远程仓库
echo [步骤5] 配置远程仓库...
%GIT_CMD% remote remove origin 2>nul
%GIT_CMD% remote add origin https://github.com/lijunjing159/kuaishou-video-replacer-android.git
if %errorlevel% neq 0 (
    echo [错误] 配置远程仓库失败
    pause
    exit /b 1
)
echo [✓] 远程仓库配置成功
echo.

REM 显示远程仓库信息
echo [信息] 远程仓库：
%GIT_CMD% remote -v
echo.

echo ================================================================
echo [重要提示] 准备推送到GitHub
echo ================================================================
echo.
echo 推送地址: https://github.com/lijunjing159/kuaishou-video-replacer-android
echo.
echo 请确认：
echo 1. 你已经在GitHub上创建了这个仓库
echo    如果没有，请访问: https://github.com/new
echo    - Repository name: kuaishou-video-replacer-android
echo    - 选择 Public (公开)
echo    - 不要添加README等文件
echo.
echo 2. 首次推送会弹出登录窗口
echo    - 使用GitHub账号登录
echo    - 授权访问
echo.
set /p CONFIRM="确认推送? (输入 y 继续): "
if /i not "%CONFIRM%"=="y" (
    echo [取消] 已取消推送
    pause
    exit /b 0
)

echo.
echo [步骤6] 推送到GitHub...
echo [提示] 可能需要登录GitHub账号...
echo.

REM 推送到GitHub
%GIT_CMD% push -u origin main
if %errorlevel% neq 0 (
    echo.
    echo ================================================================
    echo [推送失败] 尝试强制推送...
    echo ================================================================
    echo.
    %GIT_CMD% push -u -f origin main
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
        echo 2. 身份验证失败
        echo    → 需要输入GitHub账号密码
        echo    → 或配置Personal Access Token
        echo.
        echo 3. 网络问题
        echo    → 检查网络连接
        echo.
        echo 推荐：使用GitHub Desktop（最简单）
        echo → 下载: https://desktop.github.com/
        echo → 查看教程: 使用GitHub Desktop上传（最简单）.txt
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
echo 仓库地址: https://github.com/lijunjing159/kuaishou-video-replacer-android
echo.
echo 下一步：
echo 1. 访问: https://github.com/lijunjing159/kuaishou-video-replacer-android
echo 2. 点击 "Actions" 标签页
echo 3. 等待自动构建（15-25分钟）
echo 4. 从 Artifacts 下载APK
echo.
echo 构建进度: https://github.com/lijunjing159/kuaishou-video-replacer-android/actions
echo.
pause
