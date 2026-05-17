
[GLOBAL idt_load]
[EXTERN idtp]

idt_load:
    lidt [idtp]
    sti
    ret
