
#ifndef VFS_H
#define VFS_H

#include &lt;stdint.h&gt;
#include &lt;stddef.h&gt;

#define FS_FILE 0x1
#define FS_DIRECTORY 0x2

typedef struct vfs_node {
    char name[128];
    uint32_t flags;
    uint32_t inode;
    uint32_t length;
    struct vfs_node *child;
    struct vfs_node *next;
    struct vfs_node *parent;
} vfs_node_t;

vfs_node_t *vfs_root;

vfs_node_t *vfs_find(const char *path);
uint32_t vfs_read(vfs_node_t *node, uint32_t offset, uint32_t size, uint8_t *buffer);
uint32_t vfs_write(vfs_node_t *node, uint32_t offset, uint32_t size, uint8_t *buffer);
void vfs_init(void);

#endif
