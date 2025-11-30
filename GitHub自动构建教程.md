# GitHub Actions 自动构建APK教程

## 🎯 简介

使用GitHub Actions，你可以完全自动化APK构建过程，无需安装任何本地工具！

## ✨ 优势

- ✅ **完全自动化** - 推送代码即自动构建
- ✅ **无需本地环境** - 不需要WSL、Docker或Linux
- ✅ **免费使用** - GitHub Actions对公开仓库免费
- ✅ **构建快速** - 利用GitHub的强大服务器
- ✅ **历史记录** - 保留所有构建历史和APK

## 📋 步骤一：创建GitHub仓库

### 1. 登录GitHub

访问 [github.com](https://github.com) 并登录你的账号（如果没有，需要先注册）

### 2. 创建新仓库

1. 点击右上角的 "+" → "New repository"
2. 填写仓库信息：
   - **Repository name**: `kuaishou-video-replacer-android`
   - **Description**: `快手视频替换工具 Android版`
   - **Public** (公开仓库才能使用免费的Actions)
3. 点击 "Create repository"

## 📋 步骤二：上传项目到GitHub

### 方法A: 使用Git命令行（推荐）

在项目目录打开PowerShell：

```powershell
# 进入项目目录
cd C:\Users\Administrator\Desktop\shuchu\android_app

# 初始化Git仓库
git init

# 添加所有文件
git add .

# 提交代码
git commit -m "Initial commit: 快手视频替换工具Android版"

# 添加远程仓库（替换成你的用户名）
git remote add origin https://github.com/你的用户名/kuaishou-video-replacer-android.git

# 推送代码
git push -u origin master
```

### 方法B: 使用GitHub Desktop（图形界面）

1. 下载并安装 [GitHub Desktop](https://desktop.github.com/)
2. 打开GitHub Desktop，登录你的账号
3. 点击 "File" → "Add Local Repository"
4. 选择项目目录：`C:\Users\Administrator\Desktop\shuchu\android_app`
5. 点击 "Publish repository"

### 方法C: 网页上传（最简单但不推荐）

1. 打开你创建的GitHub仓库页面
2. 点击 "uploading an existing file"
3. 将所有项目文件拖拽到页面上
4. 点击 "Commit changes"

## 📋 步骤三：触发自动构建

### 自动触发

推送代码后，GitHub Actions会自动开始构建！

### 手动触发

1. 进入你的GitHub仓库
2. 点击 "Actions" 标签页
3. 选择左侧的 "自动构建APK"
4. 点击右侧的 "Run workflow" → "Run workflow"

## 📋 步骤四：查看构建进度

1. 在 "Actions" 标签页中
2. 点击正在运行的工作流
3. 查看实时日志输出
4. 等待构建完成（约15-25分钟）

## 📋 步骤五：下载APK

### 方式1：从Artifacts下载

1. 构建完成后，在工作流页面底部找到 "Artifacts"
2. 点击 "快手视频替换工具-APK" 下载
3. 解压ZIP文件，得到APK

### 方式2：从Releases下载（需要创建Tag）

如果你创建了Git Tag，APK会自动发布到Releases：

```powershell
# 创建版本标签
git tag v1.0.0
git push origin v1.0.0
```

然后在仓库的 "Releases" 页面下载APK。

## 🔧 工作流配置说明

`.github/workflows/build-apk.yml` 配置文件包含：

### 触发条件

```yaml
on:
  push:
    branches: [ main, master ]  # 推送到main/master分支时触发
  workflow_dispatch:             # 允许手动触发
```

### 构建步骤

1. **检出代码** - 获取你的项目文件
2. **设置环境** - Python 3.10 + Java 11
3. **安装依赖** - 系统包和Python包
4. **构建APK** - 使用Buildozer编译
5. **上传APK** - 保存到Artifacts

## 💡 高级用法

### 修改应用版本

编辑 `buildozer.spec` 文件：

```ini
version = 1.0.1  # 修改版本号
```

提交并推送，会自动构建新版本。

### 自定义构建

修改 `.github/workflows/build-apk.yml`：

```yaml
# 只在周末构建
on:
  schedule:
    - cron: '0 0 * * 0'  # 每周日0点

# 构建Release版本
- name: 构建APK
  run: buildozer android release
```

### 缓存加速构建

在工作流中添加缓存步骤（已包含在配置中）：

```yaml
- name: 缓存Buildozer
  uses: actions/cache@v3
  with:
    path: ~/.buildozer
    key: buildozer-${{ hashFiles('buildozer.spec') }}
```

## 📊 构建时间

- **首次构建**: 15-25分钟（需要下载SDK、NDK）
- **后续构建**: 10-15分钟（有部分缓存）
- **使用完整缓存**: 5-10分钟

## ❓ 常见问题

### Q: 构建失败怎么办？

**A**: 查看Actions日志：
1. 进入失败的工作流
2. 点击失败的步骤
3. 查看详细错误信息
4. 根据错误修改代码后重新推送

### Q: Actions分钟数用完了？

**A**: GitHub免费用户有：
- 公开仓库：无限制
- 私有仓库：每月2000分钟

如果是私有仓库且用完了，可以：
1. 改为公开仓库
2. 升级到付费账号
3. 使用自托管运行器

### Q: 下载的ZIP里没有APK？

**A**: 构建可能失败了，检查：
1. 查看Actions日志
2. 确认所有文件都已上传
3. 检查buildozer.spec配置是否正确

### Q: 能构建Release版本吗？

**A**: 可以，修改工作流文件：

```yaml
- name: 构建APK
  run: buildozer android release  # 改为release
```

但Release版本需要签名才能安装。

## 🔐 添加密钥签名（高级）

如果要发布到Google Play，需要签名：

1. 生成密钥库：
```bash
keytool -genkey -v -keystore my-release-key.keystore -alias my-key-alias -keyalg RSA -keysize 2048 -validity 10000
```

2. 在GitHub仓库设置中添加Secrets：
   - `KEYSTORE_PASSWORD`
   - `KEY_ALIAS`
   - `KEY_PASSWORD`

3. 修改buildozer.spec：
```ini
[app]
android.release_artifact = apk
```

## 📞 获取帮助

- **GitHub Actions文档**: https://docs.github.com/actions
- **Buildozer文档**: https://buildozer.readthedocs.io/
- **Kivy文档**: https://kivy.org/doc/stable/

## 🎉 完成！

现在你只需要：
1. 修改代码
2. `git push`
3. 等待自动构建
4. 下载APK

完全自动化，无需手动操作！
