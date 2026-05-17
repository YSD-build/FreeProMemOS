
# FreeProMemOS

A lightweight, performance-focused Linux-based operating system built on the latest stable Linux kernel.

## Features

- **Latest Stable Kernel**: Built on Linux kernel 6.8.12 (customizable)
- **Debian Compatible**: Compatible with Debian packages and applications
- **Fast & Lightweight**: Minimal footprint, optimized for performance
- **Live Boot**: Can boot directly from ISO without installation
- **GitHub Actions CI/CD**: Automatic building and releases

## Quick Start

### Download Pre-built ISO

Latest releases are available on the [GitHub Releases](https://github.com/YSD-build/FreeProMemOS/releases) page.

### Build from Source

#### Using GitHub Actions (Recommended)

1. Fork or clone this repository
2. The ISO is automatically built on every push to main branch
3. Download the built ISO from the Actions artifacts

#### Local Build

```bash
# Clone the repository
git clone https://github.com/YSD-build/FreeProMemOS.git
cd FreeProMemOS

# Run as root
sudo ./scripts/build-local.sh 6.8.12
```

## Project Structure

```
FreeProMemOS/
├── .github/
│   └── workflows/
│       └── build.yml        # GitHub Actions CI/CD
├── scripts/
│   ├── build-local.sh      # Local build script
│   └── build-rootfs.sh    # Root filesystem builder
├── rootfs/                 # Root filesystem template
├── iso/                    # Built ISO output
└── README.md
```

## System Requirements

- CPU: x86_64 (64-bit Intel/AMD)
- RAM: 512MB minimum, 1GB recommended
- Storage: 2GB available space (for build)

## Building

### Automatic Build (GitHub Actions)

The project uses GitHub Actions to automatically:

1. Download the latest Linux kernel source
2. Configure and compile the kernel
3. Build kernel modules
4. Create the ISO image
5. Upload artifacts and create releases

To trigger a build:
- Push to main branch
- Create a tag (`git tag v1.0.0 && git push origin v1.0.0`)
- Or manually trigger from GitHub Actions tab

### Custom Kernel Version

To use a different kernel version, modify the `LINUX_VERSION` in `.github/workflows/build.yml`:

```yaml
env:
  LINUX_VERSION: "6.8.12"  # Change to desired version
```

### Kernel Configuration

The kernel is configured using:
- `make defconfig` - Default configuration
- `make kvm_guest.config` - KVM guest optimizations
- Custom configs for initramfs support

## Usage

### Boot from ISO

1. Download the ISO
2. Create a bootable USB or mount the ISO
3. Boot from it (may require enabling UEFI/Legacy boot in BIOS)
4. Login as root (no password in live mode)

### Default Boot Options

- **Standard Mode**: Full system with networking
- **Safe Mode**: Single user mode for debugging

## Compatibility

This OS is designed to be **Debian compatible**, meaning:

- Can install Debian `.deb` packages
- Uses the same package management tools
- Compatible with most Debian/Ubuntu applications

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## License

MIT License - See LICENSE file for details

## Acknowledgments

- Linux Kernel Project
- Debian Project
- GNU Project

## Support

- **Issues**: [GitHub Issues](https://github.com/YSD-build/FreeProMemOS/issues)
- **Discussions**: [GitHub Discussions](https://github.com/YSD-build/FreeProMemOS/discussions)

---

**FreeProMemOS** - Performance, Stability, and Compatibility
