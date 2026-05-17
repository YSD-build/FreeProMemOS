
#include "vga.h"

static const size_t VGA_WIDTH = 80;
static const size_t VGA_HEIGHT = 25;

static size_t terminal_row;
static size_t terminal_column;
static uint8_t terminal_color;
static uint16_t* terminal_buffer;

static inline uint8_t vga_entry_color(enum vga_color fg, enum vga_color bg) {
    return fg | bg &lt;&lt; 4;
}

static inline uint16_t vga_entry(unsigned char uc, uint8_t color) {
    return (uint16_t) uc | (uint16_t) color &lt;&lt; 8;
}

void vga_init(void) {
    terminal_row = 0;
    terminal_column = 0;
    terminal_color = vga_entry_color(VGA_COLOR_LIGHT_GREY, VGA_COLOR_BLACK);
    terminal_buffer = (uint16_t*) 0xB8000;
    vga_clear();
}

void vga_clear(void) {
    for (size_t y = 0; y &lt; VGA_HEIGHT; y++) {
        for (size_t x = 0; x &lt; VGA_WIDTH; x++) {
            const size_t index = y * VGA_WIDTH + x;
            terminal_buffer[index] = vga_entry(' ', terminal_color);
        }
    }
}

void vga_set_color(uint8_t foreground, uint8_t background) {
    terminal_color = vga_entry_color(foreground, background);
}

void vga_put_char(char c) {
    unsigned char uc = c;
    if (uc == '\n') {
        terminal_column = 0;
        if (++terminal_row == VGA_HEIGHT) {
            terminal_row = 0;
        }
        return;
    }

    const size_t index = terminal_row * VGA_WIDTH + terminal_column;
    terminal_buffer[index] = vga_entry(uc, terminal_color);
    if (++terminal_column == VGA_WIDTH) {
        terminal_column = 0;
        if (++terminal_row == VGA_HEIGHT) {
            terminal_row = 0;
        }
    }
}

void vga_write(const char* data, size_t size) {
    for (size_t i = 0; i &lt; size; i++) {
        vga_put_char(data[i]);
    }
}

void vga_write_string(const char* data) {
    size_t i = 0;
    while (data[i]) {
        vga_put_char(data[i++]);
    }
}
