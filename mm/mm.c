
#include "mm.h"
#include &lt;string.h&gt;

uint32_t *frames;
uint32_t nframes;

extern uint32_t placement_address;
page_directory_t *kernel_directory;
page_directory_t *current_directory;

#define INDEX_FROM_BIT(a) (a/(8*4))
#define OFFSET_FROM_BIT(a) (a%(8*4))

static void set_frame(uint32_t frame_addr) {
    uint32_t frame = frame_addr / 0x1000;
    uint32_t idx = INDEX_FROM_BIT(frame);
    uint32_t off = OFFSET_FROM_BIT(frame);
    frames[idx] |= (0x1 &lt;&lt; off);
}

static void clear_frame(uint32_t frame_addr) {
    uint32_t frame = frame_addr / 0x1000;
    uint32_t idx = INDEX_FROM_BIT(frame);
    uint32_t off = OFFSET_FROM_BIT(frame);
    frames[idx] &amp;= ~(0x1 &lt;&lt; off);
}

static uint32_t test_frame(uint32_t frame_addr) {
    uint32_t frame = frame_addr / 0x1000;
    uint32_t idx = INDEX_FROM_BIT(frame);
    uint32_t off = OFFSET_FROM_BIT(frame);
    return (frames[idx] &amp; (0x1 &lt;&lt; off));
}

static uint32_t first_frame() {
    for (uint32_t i = 0; i &lt; INDEX_FROM_BIT(nframes); i++) {
        if (frames[i] != 0xFFFFFFFF) {
            for (uint32_t j = 0; j &lt; 32; j++) {
                uint32_t toTest = 0x1 &lt;&lt; j;
                if (!(frames[i] &amp; toTest)) {
                    return i * 4 * 8 + j;
                }
            }
        }
    }
    return 0;
}

void alloc_frame(page_t *page, int is_kernel, int is_writeable) {
    if (page-&gt;frame != 0) {
        return;
    } else {
        uint32_t idx = first_frame();
        if (idx == (uint32_t)-1) {
            while (1) ;
        }
        set_frame(idx * 0x1000);
        page-&gt;present = 1;
        page-&gt;rw = (is_writeable) ? 1 : 0;
        page-&gt;user = (is_kernel) ? 0 : 1;
        page-&gt;frame = idx;
    }
}

void free_frame(page_t *page) {
    uint32_t frame;
    if (!(frame = page-&gt;frame)) {
        return;
    } else {
        clear_frame(frame * 0x1000);
        page-&gt;frame = 0;
    }
}

void mm_init(void) {
    uint32_t mem_end_page = 0x1000000;
    nframes = mem_end_page / 0x1000;
    frames = (uint32_t*)kmalloc(INDEX_FROM_BIT(nframes));
    memset(frames, 0, INDEX_FROM_BIT(nframes));

    kernel_directory = (page_directory_t*)kmalloc_a(sizeof(page_directory_t));
    memset(kernel_directory, 0, sizeof(page_directory_t));
    kernel_directory-&gt;physicalAddr = (uint32_t)kernel_directory-&gt;tablesPhysical;

    uint32_t i = 0;
    while (i &lt; placement_address) {
        alloc_frame(get_page(i, 1, kernel_directory), 0, 0);
        i += 0x1000;
    }

    switch_page_directory(kernel_directory);
}

void switch_page_directory(page_directory_t *dir) {
    current_directory = dir;
    __asm__ __volatile__("mov %0, %%cr3":: "r"(dir-&gt;physicalAddr));
}

page_t *get_page(uint32_t address, int make, page_directory_t *dir) {
    address /= 0x1000;
    uint32_t table_idx = address / 1024;
    if (dir-&gt;tables[table_idx]) {
        return &amp;dir-&gt;tables[table_idx]-&gt;pages[address % 1024];
    } else if (make) {
        uint32_t tmp;
        dir-&gt;tables[table_idx] = (page_table_t*)kmalloc_ap(sizeof(page_table_t), &amp;tmp);
        memset(dir-&gt;tables[table_idx], 0, 0x1000);
        dir-&gt;tablesPhysical[table_idx] = tmp | 0x7;
        return &amp;dir-&gt;tables[table_idx]-&gt;pages[address % 1024];
    } else {
        return 0;
    }
}
