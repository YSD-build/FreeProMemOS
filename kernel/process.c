
#include "process.h"
#include "mm.h"
#include &lt;string.h&gt;

process_t *current_process;
process_t *process_list;
uint32_t next_pid = 1;

void process_init(void) {
    current_process = 0;
    process_list = 0;
}

process_t *create_process(void (*entry)(void), char *name) {
    process_t *new_process = (process_t*)kmalloc(sizeof(process_t));
    new_process-&gt;id = next_pid++;
    strncpy(new_process-&gt;name, name, 31);
    new_process-&gt;name[31] = '\0';
    new_process-&gt;page_dir = (page_directory_t*)kmalloc_a(sizeof(page_directory_t));
    memset(new_process-&gt;page_dir, 0, sizeof(page_directory_t));
    new_process-&gt;kernel_stack = (uint32_t)kmalloc_a(KERNEL_STACK_SIZE);
    new_process-&gt;state = 1;
    new_process-&gt;eip = (uint32_t)entry;
    new_process-&gt;esp = new_process-&gt;kernel_stack + KERNEL_STACK_SIZE;
    new_process-&gt;ebp = new_process-&gt;esp;
    new_process-&gt;next = process_list;
    process_list = new_process;
    return new_process;
}

void schedule(void) {
    if (!current_process) {
        current_process = process_list;
        if (!current_process) return;
    } else {
        current_process = current_process-&gt;next;
        if (!current_process) {
            current_process = process_list;
        }
    }
}

void exit_process(void) {
    if (current_process) {
        current_process-&gt;state = 0;
        schedule();
    }
}
