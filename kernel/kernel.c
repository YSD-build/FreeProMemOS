
#include <stdint.h>
#include <stddef.h>
#include "vga.h"
#include "idt.h"
#include "isr.h"
#include "mm.h"
#include "process.h"
#include "syscall.h"
#include "fs/vfs.h"

void kernel_main() {
    vga_clear();
    vga_set_color(VGA_COLOR_LIGHT_GREY, VGA_COLOR_BLACK);
    vga_write_string("FreeProMemOS v1.0\n");
    vga_write_string("=================\n");
    vga_write_string("Initializing system...\n");

    idt_init();
    vga_write_string("[OK] IDT initialized\n");

    isr_init();
    vga_write_string("[OK] ISR initialized\n");

    mm_init();
    vga_write_string("[OK] Memory manager initialized\n");

    process_init();
    vga_write_string("[OK] Process manager initialized\n");

    syscall_init();
    vga_write_string("[OK] System calls initialized\n");

    vfs_init();
    vga_write_string("[OK] VFS initialized\n");

    vga_write_string("\nWelcome to FreeProMemOS!\n");
    vga_write_string("System is ready.\n");

    while (1) {
        __asm__ __volatile__ ("hlt");
    }
}
