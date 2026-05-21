
# FreeProMemOS Server BETA v0.1.0

一个轻量级、高性能的Linux服务器操作系统，基于最新的稳定Linux内核构建。

## 关于Server版

这是FreeProMemOS的服务器版本，专为服务器环境优化，包含完整的SSH服务器和各种服务器管理工具。

### Server版特性

- **最新稳定内核** - 基于Linux内核6.8.12
- **SSH服务器** - 内置OpenSSH服务
- **Debian兼容** - 完全兼容Debian/Ubuntu软件包
- **服务器工具集** - 包含git、curl、htop、iptables等
- **系统管理** - systemd、udev完整支持
- **Live启动** - 可直接从ISO启动，无需安装
- **GitHub Actions CI/CD** - 自动构建和发布

### 包含的软件包

**基础工具：**
- bash, vim, nano, less
- coreutils, util-linux, procps
- wget, curl
- dpkg, apt

**网络工具：**
- iproute2, iputils-ping, net-tools
- dnsutils, tcpdump
- iptables

**服务器工具：**
- openssh-server, openssh-client
- rsync
- git
- htop
- gnupg
- lsb-release, software-properties-common, apt-utils

**系统管理：**
- systemd, udev

### 默认账户

- **root**: 密码 `freepromemos`
- **admin**: 密码 `freepromemos` (sudo用户)

## 快速开始

### 下载Server版

最新的Server BETA版可以从GitHub Actions的Artifacts中获取。

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

### 使用SSH

启动后可以通过SSH连接：
```bash
ssh admin@<服务器IP
# 或
ssh root@<服务器IP>
```

## 反馈与贡献

这是一个Server BETA测试版，我们非常期待您的反馈！

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

**FreeProMemOS Server** - 为服务器而生！
