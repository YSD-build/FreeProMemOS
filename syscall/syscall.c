
#include "syscall.h"
#include "../kernel/idt.h"
#include "../kernel/isr.h"
#include "../kernel/vga.h"

extern void syscall_handler();

void syscall_init(void) {
    idt_set_gate(0x80, (uint32_t)syscall_handler, 0x08, 0x8E);
}
