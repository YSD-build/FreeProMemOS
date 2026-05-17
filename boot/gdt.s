
gdt_start:

gdt_null:
    dd 0x0
    dd 0x0

gdt_code:
    dw 0xffff
    dw 0x0
    db 0x0
    db 0x9a
    db 0xcf
    db 0x0

gdt_data:
    dw 0xffff
    dw 0x0
    db 0x0
    db 0x92
    db 0xcf
    db 0x0

gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1
    dd gdt_start
