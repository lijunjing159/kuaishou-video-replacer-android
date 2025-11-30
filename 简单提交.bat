@echo off
chcp 65001 >nul
cd /d "%~dp0"

echo Fixing GitHub Actions...
echo.

git add .github/workflows/build-apk.yml
git commit -m "fix: update actions and remove libtinfo5"

echo.
echo Use GitHub Desktop to push:
echo 1. Open GitHub Desktop
echo 2. Click "Push origin"
echo.

start https://desktop.github.com/
pause
