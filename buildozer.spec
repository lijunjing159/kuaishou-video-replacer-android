[app]

# 应用名称
title = 快手视频替换工具

# 包名（必须是唯一的）
package.name = ksvideoReplacer

# 包域名（反向域名格式）
package.domain = org.videotools

# 源代码目录
source.dir = .

# 源文件包含模式
source.include_exts = py,png,jpg,kv,atlas

# 应用版本
version = 1.0.0

# 应用入口文件
source.main = main.py

# Android所需权限
android.permissions = WRITE_EXTERNAL_STORAGE,READ_EXTERNAL_STORAGE

# Android API版本
android.api = 31

# 最低Android API版本  
android.minapi = 21

# Android NDK版本
android.ndk = 25b

# 是否自动接受SDK许可证
android.accept_sdk_license = True

# 应用方向（竖屏）
orientation = portrait

# 全屏模式
fullscreen = 0

# Python依赖
requirements = python3,kivy

# Android架构
android.archs = arm64-v8a,armeabi-v7a

# 应用图标（如果有）
#icon.filename = %(source.dir)s/icon.png

# 启动画面（如果有）
#presplash.filename = %(source.dir)s/presplash.png

# 是否允许备份
android.allow_backup = True

[buildozer]

# 日志级别 (0 = error only, 1 = info, 2 = debug)
log_level = 2

# 警告显示
warn_on_root = 1
