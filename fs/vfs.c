
#include "vfs.h"
#include "../mm/kheap.h"
#include &lt;string.h&gt;

vfs_node_t *vfs_root = 0;

void vfs_init(void) {
    vfs_root = (vfs_node_t*)kmalloc(sizeof(vfs_node_t));
    strcpy(vfs_root-&gt;name, "/");
    vfs_root-&gt;flags = FS_DIRECTORY;
    vfs_root-&gt;inode = 0;
    vfs_root-&gt;length = 0;
    vfs_root-&gt;child = 0;
    vfs_root-&gt;next = 0;
    vfs_root-&gt;parent = 0;
}

vfs_node_t *vfs_find(const char *path) {
    if (!vfs_root || strcmp(path, "/") == 0) {
        return vfs_root;
    }
    return 0;
}

uint32_t vfs_read(vfs_node_t *node, uint32_t offset, uint32_t size, uint8_t *buffer) {
    return 0;
}

uint32_t vfs_write(vfs_node_t *node, uint32_t offset, uint32_t size, uint8_t *buffer) {
    return 0;
}
