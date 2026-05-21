#!/bin/bash
set -e

# Build FreeProMemOS Server
echo "=== Building FreeProMemOS Server ==="

# Variables
KERNEL_VERSION="6.8.12"
VERSION="0.1.0-Server-BETA"
ROOTFS="/tmp/rootfs"
ISO_DIR="/tmp/iso"

# Clean up
sudo rm -rf $ROOTFS $ISO_DIR /tmp/initramfs
sudo mkdir -p $ROOTFS $ISO_DIR

# Build base system
echo "=== Creating base system with debootstrap ==="
sudo debootstrap \
  --include=bash,wget,vim,coreutils,apt,dpkg \
  --variant=minbase \
  jammy $ROOTFS http://archive.ubuntu.com/ubuntu/

# Setup hostname and hosts
echo "freepromemos-server" | sudo tee $ROOTFS/etc/hostname > /dev/null
sudo tee $ROOTFS/etc/hosts > /dev/null <<EOF
127.0.0.1 localhost
127.0.1.1 freepromemos-server
EOF

# Create users
sudo chroot $ROOTFS useradd -m -s /bin/bash admin || true
echo "root:freepromemos" | sudo chroot $ROOTFS chpasswd
echo "admin:freepromemos" | sudo chroot $ROOTFS chpasswd

# Create init script
sudo tee $ROOTFS/init > /dev/null <<'EOF'
#!/bin/bash
set -e
mount -t proc proc /proc 2>/dev/null || true
mount -t sysfs sysfs /sys 2>/dev/null || true
mount -t devtmpfs devtmpfs /dev 2>/dev/null || true
mount -t tmpfs tmpfs /tmp 2>/dev/null || true
clear
echo ""
echo "=========================================="
echo "  FreeProMemOS Server BETA v0.1.0"
echo "=========================================="
echo ""
echo "Linux kernel $(uname -r)"
echo "System architecture: $(uname -m)"
echo "Hostname: freepromemos-server"
echo ""
echo "Welcome to FreeProMemOS Server!"
echo ""
echo "This is a minimal base system."
echo "Use apt to install additional packages."
echo ""
echo "Default accounts:"
echo "  - root: freepromemos"
echo "  - admin: freepromemos"
echo ""
exec /bin/bash
EOF
sudo chmod +x $ROOTFS/init

# Clean up
sudo rm -rf $ROOTFS/var/cache/apt/archives/* 2>/dev/null || true
sudo rm -rf $ROOTFS/var/lib/apt/lists/* 2>/dev/null || true

# Get host kernel
echo "=== Using host system kernel ==="
KERNEL_IMG=$(ls -1 /boot/vmlinuz-* | head -1)
SYSTEM_MAP=$(ls -1 /boot/System.map-* | head -1)
echo "Using kernel: $KERNEL_IMG"

# Prepare ISO
mkdir -p $ISO_DIR/boot/grub/i386-pc
cp $KERNEL_IMG $ISO_DIR/boot/vmlinuz
cp $SYSTEM_MAP $ISO_DIR/boot/System.map

# Create initramfs
mkdir -p /tmp/initramfs
sudo cp -a $ROOTFS/* /tmp/initramfs/
sudo chmod -R 755 /tmp/initramfs 2>/dev/null || true
cd /tmp/initramfs
sudo find . -print0 | sudo cpio --null -o --format=newc | gzip -9 > $ISO_DIR/boot/initrd.img
ls -lh $ISO_DIR/boot/

# Create GRUB config
sudo tee $ISO_DIR/boot/grub/grub.cfg > /dev/null <<'EOF'
set timeout=10
set default=0

menuentry "FreeProMemOS Server BETA v0.1.0" {
    linux /boot/vmlinuz root=/dev/ram0 rw init=/init
    initrd /boot/initrd.img
}

menuentry "FreeProMemOS Server BETA v0.1.0 (Safe Mode)" {
    linux /boot/vmlinuz root=/dev/ram0 rw init=/init single
    initrd /boot/initrd.img
}
EOF

# Create ISO
cd /tmp
ls -la iso/
grub-mkrescue -o FreeProMemOS-Server-BETA-${VERSION}.iso iso
ls -lh FreeProMemOS-Server-BETA-${VERSION}.iso
file FreeProMemOS-Server-BETA-${VERSION}.iso

echo "=== Build complete! ==="
