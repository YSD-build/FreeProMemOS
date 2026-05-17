
#ifndef SYSCALL_H
#define SYSCALL_H

#include <stdint.h>

#define SYSCALL_EXIT 1
#define SYSCALL_WRITE 4
#define SYSCALL_READ 3

void syscall_init(void);

#endif
