
[BITS 16]
[ORG 0x1000]

start:
    mov si, msg_stage2
    call print_string

    cli
    lgdt [gdt_descriptor]
    mov eax, cr0
    or eax, 1
    mov cr0, eax
    jmp CODE_SEG:protected_mode

[BITS 32]
protected_mode:
    mov ax, DATA_SEG
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    mov ebp, 0x90000
    mov esp, ebp

    jmp KERNEL_OFFSET

%include "gdt.s"

print_string:
    mov ah, 0x0E
.next:
    lodsb
    cmp al, 0
    je .done
    int 0x10
    jmp .next
.done:
    ret

msg_stage2 db 'Entering protected mode...', 0x0D, 0x0A, 0
KERNEL_OFFSET equ 0x100000
CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start
