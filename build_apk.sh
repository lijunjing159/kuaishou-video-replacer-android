#!/bin/bash

# 快手视频替换工具 - APK构建脚本
# 适用于 Linux/WSL 环境

echo "================================================"
echo "  快手视频替换工具 - Android APK 构建工具"
echo "================================================"
echo ""

# 检查是否在正确的目录
if [ ! -f "buildozer.spec" ]; then
    echo "错误: 未找到 buildozer.spec 文件"
    echo "请确保在 android_app 目录中运行此脚本"
    exit 1
fi

# 检查 buildozer 是否安装
if ! command -v buildozer &> /dev/null; then
    echo "错误: buildozer 未安装"
    echo "请先运行: pip3 install buildozer"
    exit 1
fi

# 询问构建类型
echo "请选择构建类型:"
echo "1) Debug版本（调试版，可以直接安装）"
echo "2) Release版本（发布版，需要签名）"
echo ""
read -p "请输入选择 [1/2]: " choice

case $choice in
    1)
        echo ""
        echo "开始构建 Debug 版本..."
        echo "这可能需要15-30分钟（首次构建）"
        echo ""
        buildozer -v android debug
        ;;
    2)
        echo ""
        echo "开始构建 Release 版本..."
        echo "这可能需要15-30分钟（首次构建）"
        echo ""
        buildozer -v android release
        ;;
    *)
        echo "无效的选择"
        exit 1
        ;;
esac

# 检查构建是否成功
if [ $? -eq 0 ]; then
    echo ""
    echo "================================================"
    echo "  构建成功！"
    echo "================================================"
    echo ""
    echo "APK文件位置: bin/"
    ls -lh bin/*.apk
    echo ""
    echo "将APK文件传输到Android设备并安装即可使用"
else
    echo ""
    echo "================================================"
    echo "  构建失败！"
    echo "================================================"
    echo ""
    echo "常见问题:"
    echo "1. 检查Java JDK是否已安装（java -version）"
    echo "2. 检查Python版本是否正确（python3 --version）"
    echo "3. 尝试清理缓存后重试: buildozer android clean"
    echo ""
    exit 1
fi
