
ARCH = i386
CC = gcc
AS = nasm
LD = ld
QEMU = qemu-system-i386

CFLAGS = -ffreestanding -m32 -fno-pic -fno-stack-protector -Wall -Wextra
LDFLAGS = -m elf_i386 -T linker.ld -nostdlib
ASFLAGS = -f elf32

SOURCES_C = kernel/kernel.c kernel/vga.c kernel/idt.c kernel/isr.c kernel/process.c mm/mm.c mm/kheap.c fs/vfs.c syscall/syscall.c libc/string.c
SOURCES_ASM = kernel/kernel_entry.s kernel/idt_load.s kernel/isr.s syscall/syscall.s
OBJ = $(SOURCES_C:.c=.o) $(SOURCES_ASM:.s=.o)

.PHONY: all clean buildiso qemu

all: kernel.bin iso/boot/kernel.bin buildiso

kernel.bin: $(OBJ)
	$(LD) $(LDFLAGS) -o $@ $^

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

%.o: %.s
	$(AS) $(ASFLAGS) $< -o $@

iso/boot/kernel.bin: kernel.bin
	cp kernel.bin iso/boot/kernel.bin

boot/boot.bin: boot/boot.s
	$(AS) $< -f bin -o $@

buildiso: boot/boot.bin iso/boot/kernel.bin
	mkdir -p iso/boot/isolinux
	cp /usr/lib/ISOLINUX/isolinux.bin iso/boot/isolinux/ 2>/dev/null || true
	cp /usr/lib/syslinux/modules/bios/ldlinux.c32 iso/boot/isolinux/ 2>/dev/null || true
	printf 'default kernel\nlabel kernel\n  kernel /boot/kernel.bin\n' > iso/boot/isolinux/isolinux.cfg
	mkisofs -R -b boot/isolinux/isolinux.bin -no-emul-boot -boot-load-size 4 -boot-info-table -o FreeProMemOS.iso iso/ 2>/dev/null || \
	xorriso -as mkisofs -R -b boot/isolinux/isolinux.bin -no-emul-boot -boot-load-size 4 -boot-info-table -o FreeProMemOS.iso iso/

qemu: FreeProMemOS.iso
	$(QEMU) -cdrom FreeProMemOS.iso -m 512

clean:
	rm -f $(OBJ) kernel.bin boot/boot.bin iso/boot/kernel.bin FreeProMemOS.iso
