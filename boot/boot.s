
[BITS 16]
[ORG 0x7C00]

start:
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00

    mov si, msg_boot
    call print_string

    mov ah, 0x02
    mov al, 32
    mov ch, 0
    mov cl, 2
    mov dh, 0
    mov dl, 0
    mov bx, 0x1000
    int 0x13

    jc error
    jmp 0x1000

error:
    mov si, msg_error
    call print_string
    jmp $

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

msg_boot db 'FreeProMemOS Bootloader v1.0', 0x0D, 0x0A, 0
msg_error db 'Boot Error!', 0x0D, 0x0A, 0

times 510 - ($ - $$) db 0
dw 0xAA55
