
#ifndef SYSCALL_H
#define SYSCALL_H

#include &lt;stdint.h&gt;

#define SYSCALL_EXIT 1
#define SYSCALL_WRITE 4
#define SYSCALL_READ 3

void syscall_init(void);

#endif
