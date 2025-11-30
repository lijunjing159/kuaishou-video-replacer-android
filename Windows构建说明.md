# Windows环境下构建Android APK说明

由于Buildozer主要支持Linux环境，在Windows下构建需要使用WSL（Windows Subsystem for Linux）。

## 方法1: 使用WSL构建（推荐）

### 1. 安装WSL

打开PowerShell（管理员权限），运行：

```powershell
wsl --install
```

重启电脑后，WSL将自动完成安装。

### 2. 在WSL中安装依赖

打开WSL终端（在开始菜单搜索"Ubuntu"），运行：

```bash
# 更新系统
sudo apt-get update
sudo apt-get upgrade -y

# 安装必要工具
sudo apt-get install -y python3 python3-pip git zip unzip
sudo apt-get install -y openjdk-11-jdk autoconf libtool pkg-config

# 安装Buildozer和Cython
pip3 install --upgrade pip
pip3 install buildozer cython
```

### 3. 复制项目到WSL

在WSL中运行：

```bash
# 创建工作目录
cd ~
mkdir projects
cd projects

# 从Windows复制文件到WSL
# Windows路径会映射到 /mnt/c/
cp -r /mnt/c/Users/Administrator/Desktop/shuchu/android_app ./
cd android_app
```

### 4. 构建APK

```bash
# 首次构建（会自动下载SDK、NDK等，约15-30分钟）
buildozer -v android debug

# 构建完成后，APK位于 bin/ 目录
ls -lh bin/
```

### 5. 获取APK文件

APK文件会生成在WSL的项目目录中，你可以通过以下方式访问：

- 在Windows文件资源管理器中输入：`\\wsl$\Ubuntu\home\你的用户名\projects\android_app\bin\`
- 或复制到Windows：`cp bin/*.apk /mnt/c/Users/Administrator/Desktop/`

## 方法2: 使用Docker（无需WSL）

### 1. 安装Docker Desktop

从 [Docker官网](https://www.docker.com/products/docker-desktop/) 下载并安装Docker Desktop for Windows。

### 2. 构建APK

在PowerShell中运行：

```powershell
# 进入项目目录
cd C:\Users\Administrator\Desktop\shuchu\android_app

# 使用Docker构建
docker run --rm -v ${PWD}:/app kivy/buildozer android debug
```

构建完成后，APK会在当前目录的 `bin` 文件夹中。

## 方法3: 使用在线服务

### GitHub Actions自动构建

1. 在GitHub上创建新仓库
2. 上传项目文件
3. 创建 `.github/workflows/build.yml`：

```yaml
name: Build APK
on: [push, workflow_dispatch]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Set up Python
        uses: actions/setup-python@v4
        with:
          python-version: '3.10'
      
      - name: Install Buildozer
        run: |
          pip install buildozer cython
          
      - name: Build APK
        run: |
          buildozer android debug
          
      - name: Upload APK
        uses: actions/upload-artifact@v3
        with:
          name: apk-debug
          path: bin/*.apk
```

4. 推送代码后，在GitHub Actions标签页下载构建好的APK

## 常见问题

### Q: WSL构建失败怎么办？

A: 常见解决方案：
```bash
# 清理构建缓存
buildozer android clean

# 更新Buildozer
pip3 install --upgrade buildozer

# 检查Java版本
java -version  # 应该是11或更高
```

### Q: Docker构建很慢？

A: Docker首次构建需要下载镜像和SDK，可能需要30-60分钟。建议使用WSL方式。

### Q: 没有Linux环境怎么办？

A: 可以使用在线CI/CD服务（如GitHub Actions），或者请有Linux环境的朋友帮忙构建。

### Q: 构建后的APK能直接安装吗？

A: 可以。Debug版本的APK可以直接安装，但需要：
1. 在手机上启用"允许安装未知来源应用"
2. 安装后授予存储权限

## 预构建APK（如果有）

如果你不想自己构建，可以：
1. 向项目维护者索要已构建的APK
2. 使用其他构建服务

## 技术支持

如果遇到构建问题，可以：
1. 查看Buildozer日志：`buildozer -v android debug`
2. 访问Kivy官方文档：https://kivy.org/doc/stable/guide/packaging-android.html
3. 查看Buildozer文档：https://buildozer.readthedocs.io/

## 快速开始（WSL）

如果你已经安装了WSL，只需运行以下命令：

```bash
# 1. 打开WSL终端
wsl

# 2. 安装依赖（只需一次）
sudo apt-get update && sudo apt-get install -y python3-pip git zip unzip openjdk-11-jdk
pip3 install buildozer cython

# 3. 复制项目
cp -r /mnt/c/Users/Administrator/Desktop/shuchu/android_app ~/
cd ~/android_app

# 4. 构建
buildozer android debug

# 5. 复制APK到Windows桌面
cp bin/*.apk /mnt/c/Users/Administrator/Desktop/
```

完成！APK文件会出现在你的Windows桌面上。
