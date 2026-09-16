#ifndef UART_CORSTONE_H
#define UART_CORSTONE_H

#include <stdint.h>

/* Arm Corstone-300 APB UART Base Addresses */
#define CORSTONE300_UART0_SECURE     0x49303000UL
#define CORSTONE300_UART0_NONSECURE  0x41303000UL

void uart_init(void);
void uart_putc(char c);
void uart_puts(const char *s);
void uart_print_hex(uint32_t val);
void uart_print_dec(uint32_t val);
void uart_printf(const char *fmt, ...);

#endif /* UART_CORSTONE_H */
