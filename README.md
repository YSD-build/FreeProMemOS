
# FreeProMemOS

FreeProMemOS - A free, open-source operating system designed for performance and stability.

## Features

- Custom kernel written from scratch
- 32-bit protected mode support
- Paging and virtual memory management
- Interrupt handling
- VGA text mode console
- Process scheduling
- Virtual filesystem
- Debian compatibility layer (coming soon)

## Building

### Prerequisites

- GCC cross-compiler or gcc-multilib
- NASM
- QEMU (for testing)
- xorriso or mkisofs (for ISO creation)
- ISOLINUX/Syslinux

### Build Steps

1. Clone the repository:
```bash
git clone https://github.com/YSD-build/FreeProMemOS.git
cd FreeProMemOS
```

2. Build:
```bash
make all
```

3. Test in QEMU:
```bash
make qemu
```

## Project Structure

```
FreeProMemOS/
├── boot/              # Bootloader code
├── kernel/            # Kernel core
├── mm/                # Memory management
├── fs/                # File system
├── syscall/           # System calls
├── libc/              # C standard library
├── compat/            # Debian compatibility layer
├── userland/          # User space programs
├── iso/               # ISO build directory
└── scripts/           # Build scripts
```

## GitHub Actions

This project uses GitHub Actions to automatically build and release ISOs on every push and pull request.

## License

MIT License
