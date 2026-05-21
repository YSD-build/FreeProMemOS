
# FreeProMemOS Server BETA v0.1.0 (Minimal)

一个轻量级、高性能的Linux服务器操作系统，基于最新的稳定Linux内核构建。

## 关于这个版本

这是一个**最小化空壳系统**，只包含最基本的组件。需要什么包用apt安装即可。

### 包含的最小化软件包

只包含以下核心包：
- bash (Shell)
- wget (下载)
- vim (编辑器)
- coreutils (基础工具)
- apt (包管理器)
- dpkg (包管理器底层)

### 默认账户

- **root**: 密码 `freepromemos`
- **admin**: 密码 `freepromemos`

## 快速开始

### 下载

从GitHub Actions的Artifacts中获取最新的构建版本。

### 安装额外软件

启动后使用apt安装你需要的包：

```bash
apt update
apt install openssh-server git htop curl -y
```

## 构建说明

### 使用GitHub Actions（推荐）

1. 复刻或克隆此仓库
2. 每次推送到main分支时会自动构建ISO
3. 从Actions的Artifacts中下载构建好的ISO

### 本地构建

```bash
# 克隆仓库
git clone https://github.com/YSD-build/FreeProMemOS.git
cd FreeProMemOS

# 以root运行
sudo ./scripts/build-local.sh 6.8.12
```

## 系统要求

- **CPU**: x86_64 (64位Intel/AMD)
- **RAM**: 最小512MB，推荐1GB
- **存储**: 2GB可用空间（用于构建）

## 项目结构

```
FreeProMemOS/
├── .github/
│   └── workflows/
│       └── build.yml        # GitHub Actions CI/CD
├── scripts/
│   ├── build-local.sh      # 本地构建脚本
│   └── build-rootfs.sh    # 根文件系统构建
├── VERSION                # 版本信息
└── README.md
```

## 使用说明

### 从ISO启动

1. 下载ISO
2. 创建可启动的USB或挂载ISO
3. 从中启动（可能需要在BIOS中启用UEFI/Legacy启动）
4. 使用默认账户登录

## 反馈与贡献

- **问题报告**: [GitHub Issues](https://github.com/YSD-build/FreeProMemOS/issues)
- **讨论**: [GitHub Discussions](https://github.com/YSD-build/FreeProMemOS/discussions)

## 许可

MIT License - 详见LICENSE文件

## 致谢

- Linux内核项目
- Ubuntu项目
- Debian项目
- GNU项目

---

**FreeProMemOS Server** - 从最小开始！
