
# FreeProMemOS BETA v0.1.0

一个轻量级、注重性能的基于Linux的操作系统，构建于最新的稳定Linux内核。

## 关于BETA测试版

这是FreeProMemOS的第一个公开BETA测试版本。此版本经过优化以确保稳定性，适合早期采用者测试和试用。

### BETA测试版特性

- **最新稳定内核**: 基于Linux内核6.8.12构建
- **Debian兼容**: 兼容Debian软件包和应用程序
- **快速轻量**: 极小的系统占用，优化的性能表现
- **Live启动**: 可直接从ISO启动，无需安装
- **GitHub Actions CI/CD**: 自动化构建和发布

### 包含的软件包

- bash (命令行shell)
- wget (网络下载工具)
- vim (文本编辑器)
- coreutils (基础Linux工具)
- iproute2, iputils-ping, net-tools (网络工具)
- procps, util-linux (系统工具)
- dpkg, apt (Debian包管理)
- 等等...

## 快速开始

### 下载BETA测试版

最新的BETA测试版可以从GitHub Actions的Artifacts中获取，或者从发布页面下载（如果有的话）。

### 默认账户

- **root**: 密码 `root`
- **user**: 密码 `user`

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

这是一个BETA测试版，我们非常期待您的反馈！

- **问题报告**: [GitHub Issues](https://github.com/YSD-build/FreeProMemOS/issues)
- **讨论**: [GitHub Discussions](https://github.com/YSD-build/FreeProMemOS/discussions)

## 许可

MIT License - 详见LICENSE文件

## 致谢

- Linux内核项目
- Debian项目
- GNU项目

---

**FreeProMemOS** - 性能、稳定与兼容性
