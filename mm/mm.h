
#ifndef MM_H
#define MM_H

#include &lt;stdint.h&gt;
#include &lt;stddef.h&gt;

#define PAGE_SIZE 4096
#define PAGE_PRESENT 0x1
#define PAGE_RW 0x2
#define PAGE_USER 0x4

typedef struct page {
    uint32_t present  : 1;
    uint32_t rw       : 1;
    uint32_t user     : 1;
    uint32_t accessed : 1;
    uint32_t dirty    : 1;
    uint32_t unused   : 7;
    uint32_t frame    : 20;
} page_t;

typedef struct page_table {
    page_t pages[1024];
} page_table_t;

typedef struct page_directory {
    page_table_t *tables[1024];
    uint32_t tablesPhysical[1024];
    uint32_t physicalAddr;
} page_directory_t;

void mm_init(void);
page_t *get_page(uint32_t address, int make, page_directory_t *dir);
void alloc_frame(page_t *page, int is_kernel, int is_writeable);
void free_frame(page_t *page);
void *kmalloc(size_t size);
void kfree(void *ptr);

#endif
