#!/bin/bash
set -e
echo "=== Building FreeProMemOS Server ==="
VERSION="0.1.0-Server-BETA"
ROOTFS="/tmp/rootfs"
ISO_DIR="/tmp/iso"
ISO_NAME="FreeProMemOS-Server-BETA-${VERSION}.iso"
sudo rm -rf $ROOTFS $ISO_DIR /tmp/initramfs
sudo mkdir -p $ROOTFS $ISO_DIR
echo "=== Step 1: Building base system ==="
sudo debootstrap --include=bash,wget,vim,coreutils,apt,dpkg,systemd,systemd-sysv,udev,iproute2,iputils-ping,net-tools,procps,util-linux,less,ca-certificates --variant=minbase jammy $ROOTFS http://archive.ubuntu.com/ubuntu/
echo "=== Step 2: Configuring system ==="
echo "freepromemos-server" | sudo tee $ROOTFS/etc/hostname > /dev/null
sudo tee $ROOTFS/etc/hosts > /dev/null <<'END_OF_HOSTS'
127.0.0.1 localhost
127.0.1.1 freepromemos-server
::1     localhost ip6-localhost ip6-loopback
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
END_OF_HOSTS
sudo chroot $ROOTFS useradd -m -s /bin/bash admin || true
echo "root:freepromemos" | sudo chroot $ROOTFS chpasswd
echo "admin:freepromemos" | sudo chroot $ROOTFS chpasswd
sudo tee $ROOTFS/etc/network/interfaces > /dev/null <<'END_OF_NET'
auto lo
iface lo inet loopback
auto eth0
iface eth0 inet dhcp
END_OF_NET
sudo tee $ROOTFS/init > /dev/null <<'END_OF_INIT'
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
END_OF_INIT
sudo chmod +x $ROOTFS/init
sudo rm -rf $ROOTFS/var/cache/apt/archives/* 2>/dev/null || true
sudo rm -rf $ROOTFS/var/lib/apt/lists/* 2>/dev/null || true
echo "=== Step 3: Getting kernel ==="
KERNEL_IMG=$(ls -1 /boot/vmlinuz-* | head -1)
INITRD_IMG=$(ls -1 /boot/initrd.img-* 2>/dev/null | head -1)
SYSTEM_MAP=$(ls -1 /boot/System.map-* | head -1)
echo "Using kernel: $KERNEL_IMG"
echo "=== Step 4: Preparing ISO ==="
mkdir -p $ISO_DIR/boot/grub/i386-pc
cp $KERNEL_IMG $ISO_DIR/boot/vmlinuz
if [ -f "$INITRD_IMG" ]; then
    cp $INITRD_IMG $ISO_DIR/boot/initrd.img
else
    mkdir -p /tmp/initramfs
    sudo cp -a $ROOTFS/* /tmp/initramfs/
    sudo chmod -R 755 /tmp/initramfs
    cd /tmp/initramfs
    sudo find . -print0 | sudo cpio --null -o --format=newc | gzip -9 > $ISO_DIR/boot/initrd.img
fi
cp $SYSTEM_MAP $ISO_DIR/boot/System.map
sudo tee $ISO_DIR/boot/grub/grub.cfg > /dev/null <<'END_OF_GRUB'
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
END_OF_GRUB
echo "=== Step 6: Building ISO ==="
cd /tmp
ls -la iso/
grub-mkrescue -o $ISO_NAME iso
ls -lh $ISO_NAME
file $ISO_NAME
echo ""
echo "=== Build complete! ==="
echo "ISO created: $ISO_NAME"
