#!/bin/bash
set -e

# Build FreeProMemOS Server - Simplified Ubuntu-style
echo "=== Building FreeProMemOS Server ==="

VERSION="0.1.0-Server-BETA"
ROOTFS="/tmp/rootfs"
ISO_DIR="/tmp/iso"
ISO_NAME="FreeProMemOS-Server-BETA-${VERSION}.iso"

# Clean up
sudo rm -rf $ROOTFS $ISO_DIR /tmp/initramfs
sudo mkdir -p $ROOTFS $ISO_DIR

# Step 1: Build minimal base system
echo "=== Step 1: Building base system ==="
sudo debootstrap \
  --include=bash,wget,vim,coreutils,apt,dpkg,systemd,systemd-sysv,udev,iproute2,iputils-ping,net-tools,procps,util-linux,less,ca-certificates \
  --variant=minbase \
  jammy $ROOTFS http://archive.ubuntu.com/ubuntu/

# Step 2: Configure system
echo "=== Step 2: Configuring system ==="
sudo tee $ROOTFS/etc/hostname &gt; /dev/null &lt;&lt;'EOF'
freepromemos-server
EOF
sudo tee $ROOTFS/etc/hosts &gt; /dev/null &lt;&lt;'EOF'
127.0.0.1 localhost
127.0.1.1 freepromemos-server
::1     localhost ip6-localhost ip6-loopback
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
EOF

# Create users
sudo chroot $ROOTFS useradd -m -s /bin/bash admin || true
echo "root:freepromemos" | sudo chroot $ROOTFS chpasswd
echo "admin:freepromemos" | sudo chroot $ROOTFS chpasswd

# Enable networking
sudo tee $ROOTFS/etc/network/interfaces &gt; /dev/null &lt;&lt;'EOF'
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet dhcp
EOF

# Create init script
sudo tee $ROOTFS/init &gt; /dev/null &lt;&lt;'EOF'
#!/bin/bash
set -e
mount -t proc proc /proc
mount -t sysfs sysfs /sys
mount -t devtmpfs devtmpfs /dev
mount -t tmpfs tmpfs /tmp
clear
echo ""
echo "=========================================="
echo "  FreeProMemOS Server BETA v0.1.0"
echo "=========================================="
echo ""
echo "Welcome to FreeProMemOS!"
echo ""
echo "Default accounts:"
echo "  - root: freepromemos"
echo "  - admin: freepromemos"
echo ""
exec /bin/bash
EOF
sudo chmod +x $ROOTFS/init

# Clean up
sudo rm -rf $ROOTFS/var/cache/apt/archives/* 2&gt;/dev/null || true
sudo rm -rf $ROOTFS/var/lib/apt/lists/* 2&gt;/dev/null || true

# Step 3: Get host kernel and modules
echo "=== Step 3: Getting kernel ==="
KERNEL_IMG=$(ls -1 /boot/vmlinuz-* | head -1)
INITRD_IMG=$(ls -1 /boot/initrd.img-* 2&gt;/dev/null | head -1)
SYSTEM_MAP=$(ls -1 /boot/System.map-* | head -1)
KERNEL_VERSION=$(echo $KERNEL_IMG | sed 's|.*/vmlinuz-||')
echo "Using kernel: $KERNEL_VERSION"

# Step 4: Prepare ISO directory
echo "=== Step 4: Preparing ISO ==="
mkdir -p $ISO_DIR/boot/grub/i386-pc
cp $KERNEL_IMG $ISO_DIR/boot/vmlinuz
if [ -f "$INITRD_IMG" ]; then
    cp $INITRD_IMG $ISO_DIR/boot/initrd.img
else
    # Create our own initrd from rootfs
    mkdir -p /tmp/initramfs
    sudo cp -a $ROOTFS/* /tmp/initramfs/
    sudo chmod -R 755 /tmp/initramfs
    cd /tmp/initramfs
    sudo find . -print0 | sudo cpio --null -o --format=newc | gzip -9 &gt; $ISO_DIR/boot/initrd.img
fi
cp $SYSTEM_MAP $ISO_DIR/boot/System.map

# Step 5: Create GRUB config
sudo tee $ISO_DIR/boot/grub/grub.cfg &gt; /dev/null &lt;&lt;'EOF'
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

# Step 6: Build ISO
echo "=== Step 6: Building ISO ==="
cd /tmp
ls -la iso/
grub-mkrescue -o $ISO_NAME iso
ls -lh $ISO_NAME
file $ISO_NAME

echo ""
echo "=== Build complete! ==="
echo "ISO created: $ISO_NAME"
