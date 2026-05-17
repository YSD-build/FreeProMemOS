
#ifndef PROCESS_H
#define PROCESS_H

#include &lt;stdint.h&gt;
#include "mm.h"

#define KERNEL_STACK_SIZE 8192
#define MAX_PROCESSES 128

typedef struct process {
    uint32_t id;
    char name[32];
    page_directory_t *page_dir;
    uint32_t esp;
    uint32_t ebp;
    uint32_t eip;
    uint32_t kernel_stack;
    uint32_t state;
    struct process *next;
} process_t;

void process_init(void);
void schedule(void);
process_t *create_process(void (*entry)(void), char *name);
void exit_process(void);

#endif
