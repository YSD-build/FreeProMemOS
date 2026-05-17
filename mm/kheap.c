
#include "kheap.h"

uint32_t placement_address = 0x100000;

void *kmalloc(size_t size) {
    void *tmp = (void*)placement_address;
    placement_address += size;
    return tmp;
}

void *kmalloc_a(size_t size) {
    if (placement_address &amp; 0xFFFFF000) {
        placement_address &amp;= 0xFFFFF000;
        placement_address += 0x1000;
    }
    void *tmp = (void*)placement_address;
    placement_address += size;
    return tmp;
}

void *kmalloc_p(size_t size, uint32_t *phys) {
    *phys = placement_address;
    void *tmp = (void*)placement_address;
    placement_address += size;
    return tmp;
}

void *kmalloc_ap(size_t size, uint32_t *phys) {
    if (placement_address &amp; 0xFFFFF000) {
        placement_address &amp;= 0xFFFFF000;
        placement_address += 0x1000;
    }
    *phys = placement_address;
    void *tmp = (void*)placement_address;
    placement_address += size;
    return tmp;
}

void kfree(void *ptr) {
}
