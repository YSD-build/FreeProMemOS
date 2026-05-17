
[GLOBAL syscall_handler]
[EXTERN syscall_dispatch]

syscall_handler:
    cli
    pusha
    push ds
    push es
    push fs
    push gs
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov eax, esp
    push eax
    call syscall_dispatch
    pop eax
    pop gs
    pop fs
    pop es
    pop ds
    popa
    iret
