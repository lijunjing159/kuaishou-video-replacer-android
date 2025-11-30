# 快手视频替换工具 - Android版本

这是桌面版的Android移植版本，可以直接在Android手机上运行，无需电脑和ADB。

## 功能特点

✅ **直接在手机上操作** - 不需要电脑，不需要ADB  
✅ **5种替换模式** - 支持单个目录和批量替换  
✅ **一键全部替换** - 自动完成所有替换操作  
✅ **友好的界面** - 简洁易用的Android原生界面  
✅ **实时日志** - 查看每个操作的详细过程  

## 构建APK方法

### 方法1: 使用Linux/WSL构建（推荐）

在Linux或WSL环境中执行：

```bash
# 1. 安装依赖
sudo apt-get update
sudo apt-get install -y python3-pip git zip unzip openjdk-11-jdk autoconf libtool
pip3 install --upgrade buildozer cython

# 2. 进入项目目录
cd android_app

# 3. 初始化buildozer（首次运行）
buildozer android debug

# 4. 构建APK
buildozer -v android debug

# 生成的APK位于: bin/快手视频替换工具-1.0.0-arm64-v8a-debug.apk
```

### 方法2: 使用在线服务构建

1. 访问 [https://github.com/kivy/python-for-android](https://github.com/kivy/python-for-android)
2. 按照官方文档使用GitHub Actions自动构建

### 方法3: 使用Docker构建

```bash
# 使用官方Buildozer Docker镜像
docker run --rm -v "$PWD":/app kivy/buildozer android debug
```

## 手动安装APK

1. 将生成的APK文件传输到Android设备
2. 在设备上打开APK文件进行安装
3. 如果提示"未知来源"，需要在设置中允许安装未知来源的应用
4. 安装完成后，授予应用存储权限

## 使用方法

1. **打开应用**
   - 首次打开会请求存储权限，必须授予

2. **选择视频**
   - 点击"选择视频文件"按钮
   - 浏览并选择要用于替换的视频文件

3. **选择替换模式**
   - **替换 .record_cache_dir** - 替换单个目录的视频
   - **批量替换 .post 目录** - 批量替换.post目录所有子文件夹的视频
   - **批量替换 .encoding 目录** - 批量替换.encoding目录所有子文件夹的视频
   - **批量替换 workspace 目录** - 批量替换workspace目录两层子文件夹的视频
   - **★ 一键全部替换 ★** - 自动执行以上所有操作

4. **查看日志**
   - 日志区域会实时显示操作进度和结果

## 目标路径

应用会操作以下路径下的视频文件：

```
/storage/emulated/0/Android/data/com.smile.gifmaker/files/
├── .record_cache_dir/
├── .post/
├── .encoding_output_path/
└── workspace/
```

## 注意事项

⚠️ **重要提示**：
- 确保手机已安装快手APP（包名：com.smile.gifmaker）
- 首次使用前，确保目标目录存在
- 建议先备份重要视频文件
- 替换操作不可逆，请谨慎操作
- 需要授予应用存储权限

## 技术栈

- **Python 3** - 编程语言
- **Kivy** - 跨平台UI框架
- **Buildozer** - Android打包工具
- **Python-for-Android** - Python到Android的桥接

## 与桌面版的区别

| 特性 | 桌面版 | Android版 |
|------|--------|-----------|
| 运行环境 | Windows/Mac/Linux | Android手机 |
| 连接方式 | 通过ADB连接手机 | 直接在手机上运行 |
| 文件操作 | 通过ADB命令 | 直接使用Python文件API |
| 界面 | Tkinter GUI | Kivy GUI |
| 便携性 | 需要电脑 | 仅需手机 |

## 故障排除

### 构建失败
- 确保Java JDK已安装（版本11或更高）
- 检查Python版本（建议3.8-3.10）
- 尝试清理构建缓存：`buildozer android clean`

### 安装失败
- 检查设备存储空间是否充足
- 确认已允许安装未知来源应用
- 尝试卸载旧版本后重新安装

### 权限问题
- 在系统设置中手动授予应用存储权限
- Android 11+需要"所有文件访问权限"

### 目录不存在
- 确保快手APP已安装且已运行过
- 检查目标路径是否正确

## 开发者信息

本项目基于原桌面版工具改造而成，保留了所有核心功能。

## 许可证

本项目仅供学习和个人使用。
