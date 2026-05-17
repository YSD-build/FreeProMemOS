
#!/bin/bash
# FreeProMemOS Local Build Script
# Usage: ./scripts/build-local.sh [kernel_version]
# Default kernel version: 6.8.12

set -e

KERNEL_VERSION=${1:-"6.8.12"}
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

echo "========================================"
echo "FreeProMemOS Build Script"
echo "========================================"
echo "Kernel Version: $KERNEL_VERSION"
echo "Project Directory: $PROJECT_DIR"
echo ""

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root (sudo)"
    exit 1
fi

# Install dependencies
echo "Installing build dependencies..."
apt-get update
apt-get install -y \
    build-essential \
    bc \
    bison \
    flex \
    libssl-dev \
    libelf-dev \
    dwarves \
    zstd \
    kmod \
    cpio \
    rsync \
    wget \
    xz-utils \
    grub2-common \
    grub-pc-bin \
    parted \
    dosfstools \
    sudo

cd "$PROJECT_DIR"

# Download kernel
if [ ! -f "linux-$KERNEL_VERSION.tar.xz" ]; then
    echo "Downloading Linux kernel $KERNEL_VERSION..."
    wget -q "https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-$KERNEL_VERSION.tar.xz"
fi

# Extract kernel
if [ ! -d "linux-$KERNEL_VERSION" ]; then
    echo "Extracting Linux kernel..."
    tar xf "linux-$KERNEL_VERSION.tar.xz"
fi

# Configure kernel
cd "linux-$KERNEL_VERSION"
echo "Configuring kernel..."
make defconfig
make kvm_guest.config

# Add our custom configuration
cat >> .config << EOF
CONFIG_INITRAMFS_SOURCE="$PROJECT_DIR/rootfs"
CONFIG_INITRAMFS_ROOT_UID=0
CONFIG_INITRAMFS_COMPRESSION_GZIP=y
CONFIG_DEBUG_INFO=n
CONFIG_FRAME_POINTER=n
EOF

make olddefconfig

# Build kernel
echo "Building kernel (this may take a while)..."
make -j$(nproc) bzImage modules

# Install modules
echo "Installing modules..."
make modules_install INSTALL_MOD_PATH="$PROJECT_DIR/build/modules"

# Build ISO
cd "$PROJECT_DIR"
echo "Building ISO image..."

mkdir -p iso/boot/grub
mkdir -p iso/boot/kernel

cp "linux-$KERNEL_VERSION/arch/x86/boot/bzImage" iso/boot/kernel/vmlinuz-$KERNEL_VERSION
cp "linux-$KERNEL_VERSION/System.map" iso/boot/kernel/System.map-$KERNEL_VERSION

# Create GRUB configuration
cat > iso/boot/grub/grub.cfg << 'EOF'
set timeout=5
set default=0

menuentry 'FreeProMemOS' {
    linux /boot/kernel/vmlinuz root=/dev/ram0 rw console=ttyS0 console=tty0
    initrd /boot/initrd.img
}

menuentry 'FreeProMemOS (Safe Mode)' {
    linux /boot/kernel/vmlinuz root=/dev/ram0 rw console=ttyS0 console=tty0 single
    initrd /boot/initrd.img
}
EOF

# Create initramfs
cd "linux-$KERNEL_VERSION"
find . -name '*.ko' 2>/dev/null | cpio --create --format='newc' | gzip > "$PROJECT_DIR/iso/boot/initrd.img"

# Build ISO using grub-mkrescue
cd "$PROJECT_DIR/iso"
grub-mkrescue -o "FreeProMemOS-$KERNEL_VERSION.iso" . 2>/dev/null || \
xorriso -as mkisofs -R -b boot/grub/bios.img -no-emul-boot -boot-load-size 2048 -boot-info-table -o "FreeProMemOS-$KERNEL_VERSION.iso" .

echo ""
echo "========================================"
echo "Build Complete!"
echo "========================================"
echo "ISO Location: $PROJECT_DIR/iso/FreeProMemOS-$KERNEL_VERSION.iso"
echo ""
ls -lh "FreeProMemOS-$KERNEL_VERSION.iso"
