#include "uart_corstone.h"
#include <stdarg.h>

/* CMSDK APB UART Register Layout */
typedef struct {
    volatile uint32_t DATA;   /* Offset 0x00: Data Register */
    volatile uint32_t STATE;  /* Offset 0x04: Status Register (Bit 0: TX Full, Bit 1: RX Full) */
    volatile uint32_t CTRL;   /* Offset 0x08: Control Register (Bit 0: TX En, Bit 1: RX En) */
    volatile uint32_t INTSTATUS; /* Offset 0x0C: Interrupt Status */
    volatile uint32_t BAUDDIV;   /* Offset 0x10: Baudrate Divider */
} APB_UART_TypeDef;

#define UART0 ((APB_UART_TypeDef *)CORSTONE300_UART0_SECURE)

void uart_init(void) {
    /* Set baudrate divider: 25MHz sysclk / 115200 ≈ 217 */
    UART0->BAUDDIV = 217;
    /* Enable Transmitter and Receiver */
    UART0->CTRL = 0x03;
}

void uart_putc(char c) {
    if (c == '\n') {
        uart_putc('\r');
    }
    /* Wait until TX FIFO is not full */
    while (UART0->STATE & 0x01);
    UART0->DATA = (uint32_t)c;
}

void uart_puts(const char *s) {
    while (*s) {
        uart_putc(*s++);
    }
}

void uart_print_hex(uint32_t val) {
    const char hex_chars[] = "0123456789ABCDEF";
    for (int i = 7; i >= 0; i--) {
        uart_putc(hex_chars[(val >> (i * 4)) & 0x0F]);
    }
}

void uart_print_dec(uint32_t val) {
    char buf[12];
    int idx = 0;
    if (val == 0) {
        uart_putc('0');
        return;
    }
    while (val > 0) {
        buf[idx++] = '0' + (val % 10);
        val /= 10;
    }
    for (int i = idx - 1; i >= 0; i--) {
        uart_putc(buf[i]);
    }
}

void uart_printf(const char *fmt, ...) {
    va_list args;
    va_start(args, fmt);
    while (*fmt) {
        if (*fmt == '%') {
            fmt++;
            if (*fmt == 's') {
                const char *s = va_arg(args, const char *);
                uart_puts(s ? s : "(null)");
            } else if (*fmt == 'd' || *fmt == 'u') {
                uint32_t d = va_arg(args, uint32_t);
                uart_print_dec(d);
            } else if (*fmt == 'x' || *fmt == 'X') {
                uint32_t x = va_arg(args, uint32_t);
                uart_print_hex(x);
            } else if (*fmt == 'c') {
                char c = (char)va_arg(args, int);
                uart_putc(c);
            } else if (*fmt == '%') {
                uart_putc('%');
            }
        } else {
            uart_putc(*fmt);
        }
        fmt++;
    }
    va_end(args);
}
