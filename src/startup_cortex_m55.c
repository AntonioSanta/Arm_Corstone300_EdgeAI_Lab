/*
 * Startup code and vector table for Arm Cortex-M55 & Corstone-300
 * Supports TrustZone TF-M isolation and Armv8.1-M Helium Vector Extensions.
 */

#include <stdint.h>
#include "uart_corstone.h"

/* Linker symbols */
extern uint32_t _sidata;
extern uint32_t _sdata;
extern uint32_t _edata;
extern uint32_t _sbss;
extern uint32_t _ebss;
extern uint32_t _stack_top;

extern int main(void);
extern void ethosu_irq_handler(void);

/* SCB CPACR (Coprocessor Access Control Register) for FPU & Helium MVE */
#define SCB_CPACR   (*(volatile uint32_t *)0xE000ED88UL)

/* Fault Status Registers */
#define SCB_CFSR    (*(volatile uint32_t *)0xE000ED28UL)
#define SCB_HFSR    (*(volatile uint32_t *)0xE000ED2CUL)
#define SCB_MMFAR   (*(volatile uint32_t *)0xE000ED34UL)
#define SCB_BFAR    (*(volatile uint32_t *)0xE000ED38UL)

void Reset_Handler(void) {
    /* 1. Enable Cortex-M55 Helium MVE Vector Extensions & FPU (CP10 and CP11 full access) */
    SCB_CPACR |= (0xFUL << 20);
    __asm__ volatile ("dsb; isb");

    /* 2. Copy initialized data from Flash to DTCM */
    uint32_t *src = &_sidata;
    uint32_t *dst = &_sdata;
    while (dst < &_edata) {
        *dst++ = *src++;
    }

    /* 3. Zero out BSS section in DTCM */
    dst = &_sbss;
    while (dst < &_ebss) {
        *dst++ = 0;
    }

    /* 4. Call Main application */
    main();

    /* 5. Graceful hang or semihosting exit */
    while (1) {
        __asm__ volatile ("wfi");
    }
}

void HardFault_Handler(void) {
    uart_printf("\n[FATAL HARDFAULT] CPU halted!\n");
    uart_printf("CFSR:  0x%X\n", SCB_CFSR);
    uart_printf("HFSR:  0x%X\n", SCB_HFSR);
    uart_printf("MMFAR: 0x%X\n", SCB_MMFAR);
    uart_printf("BFAR:  0x%X\n", SCB_BFAR);
    while (1);
}

void MemManage_Handler(void) {
    uart_printf("\n[FATAL MEMMANAGE FAULT] Memory Protection Violation!\n");
    uart_printf("MMFAR: 0x%X\n", SCB_MMFAR);
    while (1);
}

void BusFault_Handler(void) {
    uart_printf("\n[FATAL BUSFAULT] Bus Error!\n");
    uart_printf("BFAR: 0x%X\n", SCB_BFAR);
    while (1);
}

void UsageFault_Handler(void) {
    uart_printf("\n[FATAL USAGEFAULT] Undefined Instruction / Alignment Fault!\n");
    while (1);
}

void SecureFault_Handler(void) {
    uart_printf("\n[FATAL SECUREFAULT] TF-M TrustZone Security Boundary Violation!\n");
    while (1);
}

void Default_Handler(void) {
    while (1);
}

/* Cortex-M55 & Corstone-300 Interrupt Vector Table */
__attribute__((section(".vectors"), used))
void (* const g_pfnVectors[])(void) = {
    (void (*)(void))(&_stack_top),      /* Initial Stack Pointer (SP) */
    Reset_Handler,                      /* Reset Handler */
    Default_Handler,                    /* NMI */
    HardFault_Handler,                  /* Hard Fault */
    MemManage_Handler,                  /* Memory Management Fault */
    BusFault_Handler,                   /* Bus Fault */
    UsageFault_Handler,                 /* Usage Fault */
    SecureFault_Handler,                /* Secure Fault (TrustZone) */
    0, 0, 0,                            /* Reserved */
    Default_Handler,                    /* SVCall */
    Default_Handler,                    /* Debug Monitor */
    0,                                  /* Reserved */
    Default_Handler,                    /* PendSV */
    Default_Handler,                    /* SysTick */

    /* External Interrupts (Corstone-300 Peripherals) */
    Default_Handler, Default_Handler, Default_Handler, Default_Handler, /* IRQ 0-3 */
    Default_Handler, Default_Handler, Default_Handler, Default_Handler, /* IRQ 4-7 */
    Default_Handler, Default_Handler, Default_Handler, Default_Handler, /* IRQ 8-11 */
    Default_Handler, Default_Handler, Default_Handler, Default_Handler, /* IRQ 12-15 */
    Default_Handler, Default_Handler, Default_Handler, Default_Handler, /* IRQ 16-19 */
    Default_Handler, Default_Handler, Default_Handler, Default_Handler, /* IRQ 20-23 */
    Default_Handler, Default_Handler, Default_Handler, Default_Handler, /* IRQ 24-27 */
    Default_Handler, Default_Handler, Default_Handler, Default_Handler, /* IRQ 28-31 */
    Default_Handler, Default_Handler, Default_Handler, Default_Handler, /* IRQ 32-35 */
    Default_Handler, Default_Handler, Default_Handler, Default_Handler, /* IRQ 36-39 */
    Default_Handler, Default_Handler, Default_Handler, Default_Handler, /* IRQ 40-43 */
    Default_Handler, Default_Handler, Default_Handler, Default_Handler, /* IRQ 44-47 */
    Default_Handler, Default_Handler, Default_Handler, Default_Handler, /* IRQ 48-51 */
    Default_Handler, Default_Handler, Default_Handler, Default_Handler, /* IRQ 52-55 */
    ethosu_irq_handler,                                                 /* IRQ 56: Ethos-U55 NPU IRQ */
};
