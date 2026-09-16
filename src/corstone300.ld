/*
 * Linker script for Arm Corstone-300 (Cortex-M55 & Ethos-U55)
 * Enforces strict memory boundaries to prevent Internal SRAM Overflow.
 * (Slide 5: Memory Region Overflow Mitigation)
 */

MEMORY
{
    /* Corstone-300 Code Memory (ITCM / Flash) */
    FLASH (rx)  : ORIGIN = 0x00000000, LENGTH = 4M
    
    /* Cortex-M55 Fast Data TCM */
    DTCM  (rwx) : ORIGIN = 0x20000000, LENGTH = 512K
    
    /* Corstone-300 Shared Internal SRAM (for Ethos-U55 Tensor Arena & Activations) */
    ISRAM (rwx) : ORIGIN = 0x21000000, LENGTH = 2M
}

/* Entry point */
ENTRY(Reset_Handler)

/* Stack configuration */
_stack_size = 0x4000;   /* 16 KB Stack */
_heap_size  = 0x4000;   /* 16 KB Heap */

SECTIONS
{
    /* Cortex-M55 Vector Table at Flash Origin */
    .vectors :
    {
        KEEP(*(.vectors))
    } > FLASH

    /* Dedicated section for Vela-compiled model weights in Flash (16-byte aligned for NPU DMA) */
    .rodata.model :
    {
        . = ALIGN(16);
        __model_data_start = .;
        *(.rodata.model*)
        __model_data_end = .;
        . = ALIGN(16);
    } > FLASH

    .rodata.input :
    {
        . = ALIGN(16);
        *(.rodata.input*)
        . = ALIGN(16);
    } > FLASH

    /* Program Code and generic read-only constants */
    .text :
    {
        . = ALIGN(4);
        *(.text*)
        *(.rodata*)
        . = ALIGN(4);
    } > FLASH

    /* Initialized Data (loaded from Flash into DTCM) */
    _sidata = LOADADDR(.data);
    .data :
    {
        . = ALIGN(4);
        _sdata = .;
        *(.data*)
        . = ALIGN(4);
        _edata = .;
    } > DTCM AT > FLASH

    /* Zero-initialized BSS */
    .bss :
    {
        . = ALIGN(4);
        _sbss = .;
        *(.bss*)
        *(COMMON)
        . = ALIGN(4);
        _ebss = .;
    } > DTCM

    /* Stack section in DTCM */
    .stack (NOLOAD) :
    {
        . = ALIGN(8);
        . = . + _stack_size;
        _stack_top = .;
    } > DTCM

    /*
     * Strictly bounded Internal SRAM Section for TFLite Micro Tensor Arena.
     * Prevents activations from spilling into unmapped memory or causing bus faults.
     */
    .sram.tensor_arena (NOLOAD) :
    {
        . = ALIGN(16);
        __tensor_arena_start = .;
        *(.sram.tensor_arena*)
        __tensor_arena_end = .;
        . = ALIGN(16);
    } > ISRAM

    /* Strict Linker Assertion: Guard Internal SRAM allocation */
    ASSERT((__tensor_arena_end - __tensor_arena_start) <= 0x20000, 
           "CRITICAL ERROR: Internal SRAM Tensor Arena exceeded 128 KiB limit! Adjust Vela tiling or reduce model architecture.")
}
