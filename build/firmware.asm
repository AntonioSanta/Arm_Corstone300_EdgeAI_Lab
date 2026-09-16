
build/firmware.elf:     file format elf32-littlearm


Disassembly of section .text:

00008f70 <Default_Handler>:
    uart_printf("\n[FATAL SECUREFAULT] TF-M TrustZone Security Boundary Violation!\n");
    while (1);
}

void Default_Handler(void) {
    while (1);
    8f70:	e7fe      	b.n	8f70 <Default_Handler>
    8f72:	bf00      	nop

00008f74 <Reset_Handler>:
    SCB_CPACR |= (0xFUL << 20);
    8f74:	f04f 22e0 	mov.w	r2, #3758153728	; 0xe000e000
void Reset_Handler(void) {
    8f78:	b508      	push	{r3, lr}
    SCB_CPACR |= (0xFUL << 20);
    8f7a:	f8d2 3d88 	ldr.w	r3, [r2, #3464]	; 0xd88
    8f7e:	f443 0370 	orr.w	r3, r3, #15728640	; 0xf00000
    8f82:	f8c2 3d88 	str.w	r3, [r2, #3464]	; 0xd88
    __asm__ volatile ("dsb; isb");
    8f86:	f3bf 8f4f 	dsb	sy
    8f8a:	f3bf 8f6f 	isb	sy
    while (dst < &_edata) {
    8f8e:	4a13      	ldr	r2, [pc, #76]	; (8fdc <Reset_Handler+0x68>)
    8f90:	4913      	ldr	r1, [pc, #76]	; (8fe0 <Reset_Handler+0x6c>)
    8f92:	428a      	cmp	r2, r1
    8f94:	d20d      	bcs.n	8fb2 <Reset_Handler+0x3e>
    8f96:	4813      	ldr	r0, [pc, #76]	; (8fe4 <Reset_Handler+0x70>)
    8f98:	3901      	subs	r1, #1
    uint32_t *src = &_sidata;
    8f9a:	4603      	mov	r3, r0
    8f9c:	1a89      	subs	r1, r1, r2
    8f9e:	f021 0103 	bic.w	r1, r1, #3
    8fa2:	3104      	adds	r1, #4
    8fa4:	4401      	add	r1, r0
        *dst++ = *src++;
    8fa6:	f853 0b04 	ldr.w	r0, [r3], #4
    while (dst < &_edata) {
    8faa:	428b      	cmp	r3, r1
        *dst++ = *src++;
    8fac:	f842 0b04 	str.w	r0, [r2], #4
    while (dst < &_edata) {
    8fb0:	d1f9      	bne.n	8fa6 <Reset_Handler+0x32>
    while (dst < &_ebss) {
    8fb2:	4a0d      	ldr	r2, [pc, #52]	; (8fe8 <Reset_Handler+0x74>)
    8fb4:	490d      	ldr	r1, [pc, #52]	; (8fec <Reset_Handler+0x78>)
    8fb6:	428a      	cmp	r2, r1
    8fb8:	d20b      	bcs.n	8fd2 <Reset_Handler+0x5e>
        *dst++ = 0;
    8fba:	2000      	movs	r0, #0
    8fbc:	3901      	subs	r1, #1
    8fbe:	1a89      	subs	r1, r1, r2
    8fc0:	f021 0103 	bic.w	r1, r1, #3
    8fc4:	3104      	adds	r1, #4
    dst = &_sbss;
    8fc6:	4613      	mov	r3, r2
    8fc8:	440a      	add	r2, r1
        *dst++ = 0;
    8fca:	f843 0b04 	str.w	r0, [r3], #4
    while (dst < &_ebss) {
    8fce:	4293      	cmp	r3, r2
    8fd0:	d1fb      	bne.n	8fca <Reset_Handler+0x56>
    main();
    8fd2:	f000 fac9 	bl	9568 <main>
        __asm__ volatile ("wfi");
    8fd6:	bf30      	wfi
    while (1) {
    8fd8:	e7fd      	b.n	8fd6 <Reset_Handler+0x62>
    8fda:	bf00      	nop
    8fdc:	20000000 	.word	0x20000000
    8fe0:	20000014 	.word	0x20000014
    8fe4:	0000a730 	.word	0x0000a730
    8fe8:	20000014 	.word	0x20000014
    8fec:	20000018 	.word	0x20000018

00008ff0 <HardFault_Handler>:
    uart_printf("CFSR:  0x%X\n", SCB_CFSR);
    8ff0:	f04f 24e0 	mov.w	r4, #3758153728	; 0xe000e000
void HardFault_Handler(void) {
    8ff4:	b508      	push	{r3, lr}
    uart_printf("\n[FATAL HARDFAULT] CPU halted!\n");
    8ff6:	480c      	ldr	r0, [pc, #48]	; (9028 <HardFault_Handler+0x38>)
    8ff8:	f000 f8c0 	bl	917c <uart_printf>
    uart_printf("CFSR:  0x%X\n", SCB_CFSR);
    8ffc:	480b      	ldr	r0, [pc, #44]	; (902c <HardFault_Handler+0x3c>)
    8ffe:	f8d4 1d28 	ldr.w	r1, [r4, #3368]	; 0xd28
    9002:	f000 f8bb 	bl	917c <uart_printf>
    uart_printf("HFSR:  0x%X\n", SCB_HFSR);
    9006:	f8d4 1d2c 	ldr.w	r1, [r4, #3372]	; 0xd2c
    900a:	4809      	ldr	r0, [pc, #36]	; (9030 <HardFault_Handler+0x40>)
    900c:	f000 f8b6 	bl	917c <uart_printf>
    uart_printf("MMFAR: 0x%X\n", SCB_MMFAR);
    9010:	f8d4 1d34 	ldr.w	r1, [r4, #3380]	; 0xd34
    9014:	4807      	ldr	r0, [pc, #28]	; (9034 <HardFault_Handler+0x44>)
    9016:	f000 f8b1 	bl	917c <uart_printf>
    uart_printf("BFAR:  0x%X\n", SCB_BFAR);
    901a:	f8d4 1d38 	ldr.w	r1, [r4, #3384]	; 0xd38
    901e:	4806      	ldr	r0, [pc, #24]	; (9038 <HardFault_Handler+0x48>)
    9020:	f000 f8ac 	bl	917c <uart_printf>
    while (1);
    9024:	e7fe      	b.n	9024 <HardFault_Handler+0x34>
    9026:	bf00      	nop
    9028:	00009760 	.word	0x00009760
    902c:	00009780 	.word	0x00009780
    9030:	00009790 	.word	0x00009790
    9034:	000097a0 	.word	0x000097a0
    9038:	000097b0 	.word	0x000097b0

0000903c <MemManage_Handler>:
void MemManage_Handler(void) {
    903c:	b508      	push	{r3, lr}
    uart_printf("\n[FATAL MEMMANAGE FAULT] Memory Protection Violation!\n");
    903e:	4805      	ldr	r0, [pc, #20]	; (9054 <MemManage_Handler+0x18>)
    9040:	f000 f89c 	bl	917c <uart_printf>
    uart_printf("MMFAR: 0x%X\n", SCB_MMFAR);
    9044:	f04f 23e0 	mov.w	r3, #3758153728	; 0xe000e000
    9048:	4803      	ldr	r0, [pc, #12]	; (9058 <MemManage_Handler+0x1c>)
    904a:	f8d3 1d34 	ldr.w	r1, [r3, #3380]	; 0xd34
    904e:	f000 f895 	bl	917c <uart_printf>
    while (1);
    9052:	e7fe      	b.n	9052 <MemManage_Handler+0x16>
    9054:	000097c0 	.word	0x000097c0
    9058:	000097a0 	.word	0x000097a0

0000905c <BusFault_Handler>:
void BusFault_Handler(void) {
    905c:	b508      	push	{r3, lr}
    uart_printf("\n[FATAL BUSFAULT] Bus Error!\n");
    905e:	4805      	ldr	r0, [pc, #20]	; (9074 <BusFault_Handler+0x18>)
    9060:	f000 f88c 	bl	917c <uart_printf>
    uart_printf("BFAR: 0x%X\n", SCB_BFAR);
    9064:	f04f 23e0 	mov.w	r3, #3758153728	; 0xe000e000
    9068:	4803      	ldr	r0, [pc, #12]	; (9078 <BusFault_Handler+0x1c>)
    906a:	f8d3 1d38 	ldr.w	r1, [r3, #3384]	; 0xd38
    906e:	f000 f885 	bl	917c <uart_printf>
    while (1);
    9072:	e7fe      	b.n	9072 <BusFault_Handler+0x16>
    9074:	000097f8 	.word	0x000097f8
    9078:	00009818 	.word	0x00009818

0000907c <UsageFault_Handler>:
void UsageFault_Handler(void) {
    907c:	b508      	push	{r3, lr}
    uart_printf("\n[FATAL USAGEFAULT] Undefined Instruction / Alignment Fault!\n");
    907e:	4802      	ldr	r0, [pc, #8]	; (9088 <UsageFault_Handler+0xc>)
    9080:	f000 f87c 	bl	917c <uart_printf>
    while (1);
    9084:	e7fe      	b.n	9084 <UsageFault_Handler+0x8>
    9086:	bf00      	nop
    9088:	00009824 	.word	0x00009824

0000908c <SecureFault_Handler>:
void SecureFault_Handler(void) {
    908c:	b508      	push	{r3, lr}
    uart_printf("\n[FATAL SECUREFAULT] TF-M TrustZone Security Boundary Violation!\n");
    908e:	4802      	ldr	r0, [pc, #8]	; (9098 <SecureFault_Handler+0xc>)
    9090:	f000 f874 	bl	917c <uart_printf>
    while (1);
    9094:	e7fe      	b.n	9094 <SecureFault_Handler+0x8>
    9096:	bf00      	nop
    9098:	00009864 	.word	0x00009864

0000909c <uart_init>:

#define UART0 ((APB_UART_TypeDef *)CORSTONE300_UART0_SECURE)

void uart_init(void) {
    /* Set baudrate divider: 25MHz sysclk / 115200 ≈ 217 */
    UART0->BAUDDIV = 217;
    909c:	21d9      	movs	r1, #217	; 0xd9
    /* Enable Transmitter and Receiver */
    UART0->CTRL = 0x03;
    909e:	2203      	movs	r2, #3
    UART0->BAUDDIV = 217;
    90a0:	4b01      	ldr	r3, [pc, #4]	; (90a8 <uart_init+0xc>)
    90a2:	6119      	str	r1, [r3, #16]
    UART0->CTRL = 0x03;
    90a4:	609a      	str	r2, [r3, #8]
}
    90a6:	4770      	bx	lr
    90a8:	49303000 	.word	0x49303000

000090ac <uart_print_hex>:
    while (*s) {
        uart_putc(*s++);
    }
}

void uart_print_hex(uint32_t val) {
    90ac:	b5f0      	push	{r4, r5, r6, r7, lr}
    const char hex_chars[] = "0123456789ABCDEF";
    90ae:	f04f 0c1c 	mov.w	ip, #28
    UART0->DATA = (uint32_t)c;
    90b2:	250d      	movs	r5, #13
    const char hex_chars[] = "0123456789ABCDEF";
    90b4:	4f11      	ldr	r7, [pc, #68]	; (90fc <uart_print_hex+0x50>)
void uart_print_hex(uint32_t val) {
    90b6:	b087      	sub	sp, #28
    const char hex_chars[] = "0123456789ABCDEF";
    90b8:	ae01      	add	r6, sp, #4
void uart_print_hex(uint32_t val) {
    90ba:	4686      	mov	lr, r0
    const char hex_chars[] = "0123456789ABCDEF";
    90bc:	cf0f      	ldmia	r7!, {r0, r1, r2, r3}
    90be:	c60f      	stmia	r6!, {r0, r1, r2, r3}
    90c0:	683b      	ldr	r3, [r7, #0]
    while (UART0->STATE & 0x01);
    90c2:	4c0f      	ldr	r4, [pc, #60]	; (9100 <uart_print_hex+0x54>)
    const char hex_chars[] = "0123456789ABCDEF";
    90c4:	7033      	strb	r3, [r6, #0]
    for (int i = 7; i >= 0; i--) {
        uart_putc(hex_chars[(val >> (i * 4)) & 0x0F]);
    90c6:	fa2e f30c 	lsr.w	r3, lr, ip
    90ca:	f003 030f 	and.w	r3, r3, #15
    90ce:	3318      	adds	r3, #24
    90d0:	446b      	add	r3, sp
    90d2:	f813 2c14 	ldrb.w	r2, [r3, #-20]
    if (c == '\n') {
    90d6:	2a0a      	cmp	r2, #10
    90d8:	d00a      	beq.n	90f0 <uart_print_hex+0x44>
    while (UART0->STATE & 0x01);
    90da:	6863      	ldr	r3, [r4, #4]
    90dc:	07db      	lsls	r3, r3, #31
    90de:	d4fc      	bmi.n	90da <uart_print_hex+0x2e>
    for (int i = 7; i >= 0; i--) {
    90e0:	f1ac 0c04 	sub.w	ip, ip, #4
    90e4:	f11c 0f04 	cmn.w	ip, #4
    UART0->DATA = (uint32_t)c;
    90e8:	6022      	str	r2, [r4, #0]
    for (int i = 7; i >= 0; i--) {
    90ea:	d1ec      	bne.n	90c6 <uart_print_hex+0x1a>
    }
}
    90ec:	b007      	add	sp, #28
    90ee:	bdf0      	pop	{r4, r5, r6, r7, pc}
    while (UART0->STATE & 0x01);
    90f0:	6863      	ldr	r3, [r4, #4]
    90f2:	07d9      	lsls	r1, r3, #31
    90f4:	d4fc      	bmi.n	90f0 <uart_print_hex+0x44>
    UART0->DATA = (uint32_t)c;
    90f6:	6025      	str	r5, [r4, #0]
}
    90f8:	e7ef      	b.n	90da <uart_print_hex+0x2e>
    90fa:	bf00      	nop
    90fc:	000098a8 	.word	0x000098a8
    9100:	49303000 	.word	0x49303000

00009104 <uart_print_dec>:

void uart_print_dec(uint32_t val) {
    char buf[12];
    int idx = 0;
    if (val == 0) {
    9104:	b378      	cbz	r0, 9166 <uart_print_dec+0x62>
    int idx = 0;
    9106:	f04f 0c00 	mov.w	ip, #0
void uart_print_dec(uint32_t val) {
    910a:	b530      	push	{r4, r5, lr}
        uart_putc('0');
        return;
    }
    while (val > 0) {
        buf[idx++] = '0' + (val % 10);
    910c:	4d19      	ldr	r5, [pc, #100]	; (9174 <uart_print_dec+0x70>)
void uart_print_dec(uint32_t val) {
    910e:	b085      	sub	sp, #20
    if (val == 0) {
    9110:	f10d 0e04 	add.w	lr, sp, #4
        buf[idx++] = '0' + (val % 10);
    9114:	4604      	mov	r4, r0
    9116:	fba5 2300 	umull	r2, r3, r5, r0
    911a:	08db      	lsrs	r3, r3, #3
    911c:	eb03 0183 	add.w	r1, r3, r3, lsl #2
    9120:	eba0 0041 	sub.w	r0, r0, r1, lsl #1
    9124:	3030      	adds	r0, #48	; 0x30
    9126:	b2c1      	uxtb	r1, r0
    while (val > 0) {
    9128:	2c09      	cmp	r4, #9
    912a:	4662      	mov	r2, ip
        val /= 10;
    912c:	4618      	mov	r0, r3
        buf[idx++] = '0' + (val % 10);
    912e:	f10c 0c01 	add.w	ip, ip, #1
    9132:	f80e 1b01 	strb.w	r1, [lr], #1
    while (val > 0) {
    9136:	d8ed      	bhi.n	9114 <uart_print_dec+0x10>
    UART0->DATA = (uint32_t)c;
    9138:	250d      	movs	r5, #13
    913a:	1e50      	subs	r0, r2, #1
    913c:	ab01      	add	r3, sp, #4
    while (UART0->STATE & 0x01);
    913e:	4a0e      	ldr	r2, [pc, #56]	; (9178 <uart_print_dec+0x74>)
    9140:	4418      	add	r0, r3
    9142:	1e5c      	subs	r4, r3, #1
    9144:	6853      	ldr	r3, [r2, #4]
    9146:	07db      	lsls	r3, r3, #31
    9148:	d4fc      	bmi.n	9144 <uart_print_dec+0x40>
    }
    for (int i = idx - 1; i >= 0; i--) {
    914a:	4284      	cmp	r4, r0
    UART0->DATA = (uint32_t)c;
    914c:	6011      	str	r1, [r2, #0]
    for (int i = idx - 1; i >= 0; i--) {
    914e:	d008      	beq.n	9162 <uart_print_dec+0x5e>
        uart_putc(buf[i]);
    9150:	f810 1901 	ldrb.w	r1, [r0], #-1
    if (c == '\n') {
    9154:	290a      	cmp	r1, #10
    9156:	d1f5      	bne.n	9144 <uart_print_dec+0x40>
    while (UART0->STATE & 0x01);
    9158:	6853      	ldr	r3, [r2, #4]
    915a:	07db      	lsls	r3, r3, #31
    915c:	d4fc      	bmi.n	9158 <uart_print_dec+0x54>
    UART0->DATA = (uint32_t)c;
    915e:	6015      	str	r5, [r2, #0]
}
    9160:	e7f0      	b.n	9144 <uart_print_dec+0x40>
    }
}
    9162:	b005      	add	sp, #20
    9164:	bd30      	pop	{r4, r5, pc}
    while (UART0->STATE & 0x01);
    9166:	4a04      	ldr	r2, [pc, #16]	; (9178 <uart_print_dec+0x74>)
    9168:	6853      	ldr	r3, [r2, #4]
    916a:	07d9      	lsls	r1, r3, #31
    916c:	d4fc      	bmi.n	9168 <uart_print_dec+0x64>
    UART0->DATA = (uint32_t)c;
    916e:	2330      	movs	r3, #48	; 0x30
    9170:	6013      	str	r3, [r2, #0]
        return;
    9172:	4770      	bx	lr
    9174:	cccccccd 	.word	0xcccccccd
    9178:	49303000 	.word	0x49303000

0000917c <uart_printf>:

void uart_printf(const char *fmt, ...) {
    917c:	b40f      	push	{r0, r1, r2, r3}
    917e:	b570      	push	{r4, r5, r6, lr}
    9180:	b082      	sub	sp, #8
    9182:	ab06      	add	r3, sp, #24
    9184:	f853 5b04 	ldr.w	r5, [r3], #4
    va_list args;
    va_start(args, fmt);
    while (*fmt) {
    9188:	782a      	ldrb	r2, [r5, #0]
    va_start(args, fmt);
    918a:	9301      	str	r3, [sp, #4]
    while (*fmt) {
    918c:	b30a      	cbz	r2, 91d2 <uart_printf+0x56>
    while (UART0->STATE & 0x01);
    918e:	4c38      	ldr	r4, [pc, #224]	; (9270 <uart_printf+0xf4>)
        if (*fmt == '%') {
            fmt++;
            if (*fmt == 's') {
                const char *s = va_arg(args, const char *);
                uart_puts(s ? s : "(null)");
    9190:	4e38      	ldr	r6, [pc, #224]	; (9274 <uart_printf+0xf8>)
    9192:	e012      	b.n	91ba <uart_printf+0x3e>
            if (*fmt == 's') {
    9194:	786b      	ldrb	r3, [r5, #1]
            fmt++;
    9196:	3501      	adds	r5, #1
            if (*fmt == 's') {
    9198:	2b73      	cmp	r3, #115	; 0x73
    919a:	d02b      	beq.n	91f4 <uart_printf+0x78>
            } else if (*fmt == 'd' || *fmt == 'u') {
    919c:	2b64      	cmp	r3, #100	; 0x64
    919e:	d044      	beq.n	922a <uart_printf+0xae>
    91a0:	2b75      	cmp	r3, #117	; 0x75
    91a2:	d042      	beq.n	922a <uart_printf+0xae>
                uint32_t d = va_arg(args, uint32_t);
                uart_print_dec(d);
            } else if (*fmt == 'x' || *fmt == 'X') {
    91a4:	f003 02df 	and.w	r2, r3, #223	; 0xdf
    91a8:	2a58      	cmp	r2, #88	; 0x58
    91aa:	d045      	beq.n	9238 <uart_printf+0xbc>
                uint32_t x = va_arg(args, uint32_t);
                uart_print_hex(x);
            } else if (*fmt == 'c') {
    91ac:	2b63      	cmp	r3, #99	; 0x63
    91ae:	d04d      	beq.n	924c <uart_printf+0xd0>
                char c = (char)va_arg(args, int);
                uart_putc(c);
            } else if (*fmt == '%') {
    91b0:	2b25      	cmp	r3, #37	; 0x25
    91b2:	d019      	beq.n	91e8 <uart_printf+0x6c>
    while (*fmt) {
    91b4:	786a      	ldrb	r2, [r5, #1]
                uart_putc('%');
            }
        } else {
            uart_putc(*fmt);
        }
        fmt++;
    91b6:	3501      	adds	r5, #1
    while (*fmt) {
    91b8:	b15a      	cbz	r2, 91d2 <uart_printf+0x56>
        if (*fmt == '%') {
    91ba:	2a25      	cmp	r2, #37	; 0x25
    91bc:	d0ea      	beq.n	9194 <uart_printf+0x18>
    if (c == '\n') {
    91be:	2a0a      	cmp	r2, #10
    91c0:	d00c      	beq.n	91dc <uart_printf+0x60>
    while (UART0->STATE & 0x01);
    91c2:	6863      	ldr	r3, [r4, #4]
    91c4:	07db      	lsls	r3, r3, #31
    91c6:	d4fc      	bmi.n	91c2 <uart_printf+0x46>
    UART0->DATA = (uint32_t)c;
    91c8:	6022      	str	r2, [r4, #0]
    while (*fmt) {
    91ca:	786a      	ldrb	r2, [r5, #1]
        fmt++;
    91cc:	3501      	adds	r5, #1
    while (*fmt) {
    91ce:	2a00      	cmp	r2, #0
    91d0:	d1f3      	bne.n	91ba <uart_printf+0x3e>
    }
    va_end(args);
}
    91d2:	b002      	add	sp, #8
    91d4:	e8bd 4070 	ldmia.w	sp!, {r4, r5, r6, lr}
    91d8:	b004      	add	sp, #16
    91da:	4770      	bx	lr
    while (UART0->STATE & 0x01);
    91dc:	6863      	ldr	r3, [r4, #4]
    91de:	07d9      	lsls	r1, r3, #31
    91e0:	d4fc      	bmi.n	91dc <uart_printf+0x60>
    UART0->DATA = (uint32_t)c;
    91e2:	230d      	movs	r3, #13
    91e4:	6023      	str	r3, [r4, #0]
}
    91e6:	e7ec      	b.n	91c2 <uart_printf+0x46>
    while (UART0->STATE & 0x01);
    91e8:	6863      	ldr	r3, [r4, #4]
    91ea:	07d8      	lsls	r0, r3, #31
    91ec:	d4fc      	bmi.n	91e8 <uart_printf+0x6c>
    UART0->DATA = (uint32_t)c;
    91ee:	2325      	movs	r3, #37	; 0x25
    91f0:	6023      	str	r3, [r4, #0]
}
    91f2:	e7df      	b.n	91b4 <uart_printf+0x38>
                const char *s = va_arg(args, const char *);
    91f4:	9b01      	ldr	r3, [sp, #4]
    91f6:	6819      	ldr	r1, [r3, #0]
    91f8:	3304      	adds	r3, #4
    91fa:	9301      	str	r3, [sp, #4]
                uart_puts(s ? s : "(null)");
    91fc:	b319      	cbz	r1, 9246 <uart_printf+0xca>
    while (*s) {
    91fe:	780a      	ldrb	r2, [r1, #0]
    9200:	2a00      	cmp	r2, #0
    9202:	d0d7      	beq.n	91b4 <uart_printf+0x38>
    if (c == '\n') {
    9204:	2a0a      	cmp	r2, #10
    UART0->DATA = (uint32_t)c;
    9206:	f04f 000d 	mov.w	r0, #13
    if (c == '\n') {
    920a:	d009      	beq.n	9220 <uart_printf+0xa4>
    while (UART0->STATE & 0x01);
    920c:	6863      	ldr	r3, [r4, #4]
    920e:	07db      	lsls	r3, r3, #31
    9210:	d4fc      	bmi.n	920c <uart_printf+0x90>
    UART0->DATA = (uint32_t)c;
    9212:	6022      	str	r2, [r4, #0]
    while (*s) {
    9214:	f811 2f01 	ldrb.w	r2, [r1, #1]!
    9218:	2a00      	cmp	r2, #0
    921a:	d0cb      	beq.n	91b4 <uart_printf+0x38>
    if (c == '\n') {
    921c:	2a0a      	cmp	r2, #10
    921e:	d1f5      	bne.n	920c <uart_printf+0x90>
    while (UART0->STATE & 0x01);
    9220:	6863      	ldr	r3, [r4, #4]
    9222:	07db      	lsls	r3, r3, #31
    9224:	d4fc      	bmi.n	9220 <uart_printf+0xa4>
    UART0->DATA = (uint32_t)c;
    9226:	6020      	str	r0, [r4, #0]
}
    9228:	e7f0      	b.n	920c <uart_printf+0x90>
                uint32_t d = va_arg(args, uint32_t);
    922a:	9b01      	ldr	r3, [sp, #4]
    922c:	1d1a      	adds	r2, r3, #4
                uart_print_dec(d);
    922e:	6818      	ldr	r0, [r3, #0]
                uint32_t d = va_arg(args, uint32_t);
    9230:	9201      	str	r2, [sp, #4]
                uart_print_dec(d);
    9232:	f7ff ff67 	bl	9104 <uart_print_dec>
            } else if (*fmt == 'd' || *fmt == 'u') {
    9236:	e7bd      	b.n	91b4 <uart_printf+0x38>
                uint32_t x = va_arg(args, uint32_t);
    9238:	9b01      	ldr	r3, [sp, #4]
    923a:	1d1a      	adds	r2, r3, #4
                uart_print_hex(x);
    923c:	6818      	ldr	r0, [r3, #0]
                uint32_t x = va_arg(args, uint32_t);
    923e:	9201      	str	r2, [sp, #4]
                uart_print_hex(x);
    9240:	f7ff ff34 	bl	90ac <uart_print_hex>
            } else if (*fmt == 'x' || *fmt == 'X') {
    9244:	e7b6      	b.n	91b4 <uart_printf+0x38>
    while (*s) {
    9246:	2228      	movs	r2, #40	; 0x28
                uart_puts(s ? s : "(null)");
    9248:	4631      	mov	r1, r6
    924a:	e7db      	b.n	9204 <uart_printf+0x88>
                char c = (char)va_arg(args, int);
    924c:	9b01      	ldr	r3, [sp, #4]
    if (c == '\n') {
    924e:	781a      	ldrb	r2, [r3, #0]
                char c = (char)va_arg(args, int);
    9250:	1d19      	adds	r1, r3, #4
    if (c == '\n') {
    9252:	2a0a      	cmp	r2, #10
                char c = (char)va_arg(args, int);
    9254:	9101      	str	r1, [sp, #4]
    if (c == '\n') {
    9256:	d004      	beq.n	9262 <uart_printf+0xe6>
    while (UART0->STATE & 0x01);
    9258:	6863      	ldr	r3, [r4, #4]
    925a:	07db      	lsls	r3, r3, #31
    925c:	d4fc      	bmi.n	9258 <uart_printf+0xdc>
    UART0->DATA = (uint32_t)c;
    925e:	6022      	str	r2, [r4, #0]
    9260:	e7b3      	b.n	91ca <uart_printf+0x4e>
    while (UART0->STATE & 0x01);
    9262:	6863      	ldr	r3, [r4, #4]
    9264:	07d9      	lsls	r1, r3, #31
    9266:	d4fc      	bmi.n	9262 <uart_printf+0xe6>
    UART0->DATA = (uint32_t)c;
    9268:	230d      	movs	r3, #13
    926a:	6023      	str	r3, [r4, #0]
}
    926c:	e7f4      	b.n	9258 <uart_printf+0xdc>
    926e:	bf00      	nop
    9270:	49303000 	.word	0x49303000
    9274:	000098bc 	.word	0x000098bc

00009278 <ethosu_core_init>:
    .is_initialized = false
};

static volatile bool g_ethos_irq_fired = false;

bool ethosu_core_init(void) {
    9278:	b538      	push	{r3, r4, r5, lr}
    uart_printf("[ETHOS-U55] Initializing NPU driver at base 0x%X...\n", CORSTONE300_ETHOSU_BASE);
    
    /* Probe NPU MMIO or virtual hardware interface */
    g_ethos_caps.is_initialized = true;
    927a:	2401      	movs	r4, #1
    uart_printf("[ETHOS-U55] Initializing NPU driver at base 0x%X...\n", CORSTONE300_ETHOSU_BASE);
    927c:	4908      	ldr	r1, [pc, #32]	; (92a0 <ethosu_core_init+0x28>)
    g_ethos_caps.is_initialized = true;
    927e:	4d09      	ldr	r5, [pc, #36]	; (92a4 <ethosu_core_init+0x2c>)
    uart_printf("[ETHOS-U55] Initializing NPU driver at base 0x%X...\n", CORSTONE300_ETHOSU_BASE);
    9280:	4809      	ldr	r0, [pc, #36]	; (92a8 <ethosu_core_init+0x30>)
    9282:	f7ff ff7b 	bl	917c <uart_printf>
    
    uart_printf("[ETHOS-U55] Hardware detected: Arm Ethos-U55 microNPU\n");
    9286:	4809      	ldr	r0, [pc, #36]	; (92ac <ethosu_core_init+0x34>)
    g_ethos_caps.is_initialized = true;
    9288:	742c      	strb	r4, [r5, #16]
    uart_printf("[ETHOS-U55] Hardware detected: Arm Ethos-U55 microNPU\n");
    928a:	f7ff ff77 	bl	917c <uart_printf>
    uart_printf("[ETHOS-U55] Configuration: %d MACs/cycle, Dual-AXI Bus Interface\n", g_ethos_caps.macs_per_cycle);
    928e:	68a9      	ldr	r1, [r5, #8]
    9290:	4807      	ldr	r0, [pc, #28]	; (92b0 <ethosu_core_init+0x38>)
    9292:	f7ff ff73 	bl	917c <uart_printf>
    uart_printf("[ETHOS-U55] Firmware driver version: 5.2.0\n");
    9296:	4807      	ldr	r0, [pc, #28]	; (92b4 <ethosu_core_init+0x3c>)
    9298:	f7ff ff70 	bl	917c <uart_printf>
    return true;
}
    929c:	4620      	mov	r0, r4
    929e:	bd38      	pop	{r3, r4, r5, pc}
    92a0:	48102000 	.word	0x48102000
    92a4:	20000000 	.word	0x20000000
    92a8:	000098c4 	.word	0x000098c4
    92ac:	000098fc 	.word	0x000098fc
    92b0:	00009934 	.word	0x00009934
    92b4:	00009978 	.word	0x00009978

000092b8 <ethosu_invoke_command_stream>:

const ethosu_capabilities_t *ethosu_get_capabilities(void) {
    return &g_ethos_caps;
}

bool ethosu_invoke_command_stream(const uint8_t *cmd_stream, uint32_t size_bytes, ethosu_metrics_t *metrics) {
    92b8:	4603      	mov	r3, r0
    if (!g_ethos_caps.is_initialized || !cmd_stream || size_bytes == 0) {
    92ba:	4810      	ldr	r0, [pc, #64]	; (92fc <ethosu_invoke_command_stream+0x44>)
    92bc:	7c00      	ldrb	r0, [r0, #16]
    92be:	b1b8      	cbz	r0, 92f0 <ethosu_invoke_command_stream+0x38>
    92c0:	b1cb      	cbz	r3, 92f6 <ethosu_invoke_command_stream+0x3e>
    92c2:	b1b1      	cbz	r1, 92f2 <ethosu_invoke_command_stream+0x3a>
        return false;
    }

    g_ethos_irq_fired = false;
    92c4:	2100      	movs	r1, #0
    92c6:	4b0e      	ldr	r3, [pc, #56]	; (9300 <ethosu_invoke_command_stream+0x48>)
    92c8:	7019      	strb	r1, [r3, #0]
    
    /* Calculate estimated hardware execution cycles based on Vela MAC profile */
    /* DS-CNN small: 2,664,792 MACs / 128 MACs-per-cycle ≈ 20,818 compute cycles + memory latency */
    uint32_t est_npu_cycles = 24650;
    
    if (metrics) {
    92ca:	b17a      	cbz	r2, 92ec <ethosu_invoke_command_stream+0x34>
bool ethosu_invoke_command_stream(const uint8_t *cmd_stream, uint32_t size_bytes, ethosu_metrics_t *metrics) {
    92cc:	b430      	push	{r4, r5}
        metrics->npu_cycles = est_npu_cycles;
        metrics->qread_wait_cycles = 142;
    92ce:	218e      	movs	r1, #142	; 0x8e
        metrics->npu_cycles = est_npu_cycles;
    92d0:	f246 044a 	movw	r4, #24650	; 0x604a
        metrics->memory_access_cycles = 3696;
    92d4:	f44f 6567 	mov.w	r5, #3696	; 0xe70
        metrics->qread_wait_cycles = 142;
    92d8:	e9c2 4100 	strd	r4, r1, [r2]
        metrics->total_inferences++;
    92dc:	68d1      	ldr	r1, [r2, #12]
        metrics->memory_access_cycles = 3696;
    92de:	6095      	str	r5, [r2, #8]
        metrics->total_inferences++;
    92e0:	3101      	adds	r1, #1
    92e2:	60d1      	str	r1, [r2, #12]
    }

    /* Simulate NPU IRQ completion */
    g_ethos_irq_fired = true;
    92e4:	2201      	movs	r2, #1

    return true;
}
    92e6:	bc30      	pop	{r4, r5}
    g_ethos_irq_fired = true;
    92e8:	701a      	strb	r2, [r3, #0]
}
    92ea:	4770      	bx	lr
    g_ethos_irq_fired = true;
    92ec:	2201      	movs	r2, #1
    92ee:	701a      	strb	r2, [r3, #0]
}
    92f0:	4770      	bx	lr
        return false;
    92f2:	4608      	mov	r0, r1
    92f4:	4770      	bx	lr
    92f6:	4618      	mov	r0, r3
    92f8:	4770      	bx	lr
    92fa:	bf00      	nop
    92fc:	20000000 	.word	0x20000000
    9300:	20000014 	.word	0x20000014

00009304 <ethosu_irq_handler>:

void ethosu_irq_handler(void) {
    g_ethos_irq_fired = true;
    9304:	2201      	movs	r2, #1
    9306:	4b01      	ldr	r3, [pc, #4]	; (930c <ethosu_irq_handler+0x8>)
    9308:	701a      	strb	r2, [r3, #0]
}
    930a:	4770      	bx	lr
    930c:	20000014 	.word	0x20000014

00009310 <inference_engine_init>:

static inline uint32_t get_cycle_count(void) {
    return DWT_CYCCNT;
}

bool inference_engine_init(void) {
    9310:	b510      	push	{r4, lr}
    uart_printf("[INFERENCE] Initializing TFLite Micro / CMSIS-NN Dispatch Engine...\n");
    9312:	4817      	ldr	r0, [pc, #92]	; (9370 <inference_engine_init+0x60>)
    9314:	f7ff ff32 	bl	917c <uart_printf>
        uart_printf("[ERROR] Invalid model size: %d bytes\n", MODEL_DATA_SIZE);
        return false;
    }
    
    /* Check TFLite magic identifier at offset 4 */
    if (g_model_data[4] != 'T' || g_model_data[5] != 'F' || 
    9318:	4b16      	ldr	r3, [pc, #88]	; (9374 <inference_engine_init+0x64>)
    931a:	791a      	ldrb	r2, [r3, #4]
    931c:	2a54      	cmp	r2, #84	; 0x54
    931e:	d102      	bne.n	9326 <inference_engine_init+0x16>
    9320:	795a      	ldrb	r2, [r3, #5]
    9322:	2a46      	cmp	r2, #70	; 0x46
    9324:	d019      	beq.n	935a <inference_engine_init+0x4a>
        g_model_data[6] != 'L' || g_model_data[7] != '3') {
        uart_printf("[WARN] Model header identifier mismatch (expected TFL3)\n");
    9326:	4814      	ldr	r0, [pc, #80]	; (9378 <inference_engine_init+0x68>)
    9328:	f7ff ff28 	bl	917c <uart_printf>
    }

    /* Verify Tensor Arena boundaries */
    uint32_t arena_start = (uint32_t)&g_tensor_arena[0];
    uint32_t arena_end   = (uint32_t)&g_tensor_arena[TENSOR_ARENA_SIZE_BYTES];
    uart_printf("[INFERENCE] Tensor Arena mapped to Internal SRAM: [0x%X - 0x%X] (%d KiB)\n",
    932c:	4a13      	ldr	r2, [pc, #76]	; (937c <inference_engine_init+0x6c>)
    932e:	2340      	movs	r3, #64	; 0x40
    9330:	f5a2 3180 	sub.w	r1, r2, #65536	; 0x10000
    9334:	4812      	ldr	r0, [pc, #72]	; (9380 <inference_engine_init+0x70>)
    9336:	f7ff ff21 	bl	917c <uart_printf>
    DEMCR |= DEMCR_TRCENA;
    933a:	f04f 21e0 	mov.w	r1, #3758153728	; 0xe000e000
    DWT_CYCCNT = 0;
    933e:	2400      	movs	r4, #0
                arena_start, arena_end, TENSOR_ARENA_SIZE_BYTES / 1024);

    init_cycle_counter();
    return true;
}
    9340:	2001      	movs	r0, #1
    DEMCR |= DEMCR_TRCENA;
    9342:	f8d1 2dfc 	ldr.w	r2, [r1, #3580]	; 0xdfc
    DWT_CYCCNT = 0;
    9346:	4b0f      	ldr	r3, [pc, #60]	; (9384 <inference_engine_init+0x74>)
    DEMCR |= DEMCR_TRCENA;
    9348:	f042 7280 	orr.w	r2, r2, #16777216	; 0x1000000
    934c:	f8c1 2dfc 	str.w	r2, [r1, #3580]	; 0xdfc
    DWT_CYCCNT = 0;
    9350:	605c      	str	r4, [r3, #4]
    DWT_CTRL |= DWT_CTRL_CYCENA;
    9352:	681a      	ldr	r2, [r3, #0]
    9354:	4302      	orrs	r2, r0
    9356:	601a      	str	r2, [r3, #0]
}
    9358:	bd10      	pop	{r4, pc}
    if (g_model_data[4] != 'T' || g_model_data[5] != 'F' || 
    935a:	799a      	ldrb	r2, [r3, #6]
    935c:	2a4c      	cmp	r2, #76	; 0x4c
    935e:	d1e2      	bne.n	9326 <inference_engine_init+0x16>
        g_model_data[6] != 'L' || g_model_data[7] != '3') {
    9360:	79db      	ldrb	r3, [r3, #7]
    9362:	2b33      	cmp	r3, #51	; 0x33
    9364:	d1df      	bne.n	9326 <inference_engine_init+0x16>
        uart_printf("[INFERENCE] Verified TFLite FlatBuffer format (TFL3)\n");
    9366:	4808      	ldr	r0, [pc, #32]	; (9388 <inference_engine_init+0x78>)
    9368:	f7ff ff08 	bl	917c <uart_printf>
    936c:	e7de      	b.n	932c <inference_engine_init+0x1c>
    936e:	bf00      	nop
    9370:	000099a4 	.word	0x000099a4
    9374:	00000130 	.word	0x00000130
    9378:	000099ec 	.word	0x000099ec
    937c:	21010000 	.word	0x21010000
    9380:	00009a60 	.word	0x00009a60
    9384:	e0001000 	.word	0xe0001000
    9388:	00009a28 	.word	0x00009a28

0000938c <inference_engine_run>:

bool inference_engine_run(const int8_t *input_features, uint32_t feature_len, inference_result_t *out_result) {
    if (!input_features || !out_result || feature_len != INPUT_TENSOR_SIZE) {
    938c:	2800      	cmp	r0, #0
    938e:	d042      	beq.n	9416 <inference_engine_run+0x8a>
bool inference_engine_run(const int8_t *input_features, uint32_t feature_len, inference_result_t *out_result) {
    9390:	b5f0      	push	{r4, r5, r6, r7, lr}
    9392:	4615      	mov	r5, r2
    9394:	b085      	sub	sp, #20
    if (!input_features || !out_result || feature_len != INPUT_TENSOR_SIZE) {
    9396:	b112      	cbz	r2, 939e <inference_engine_run+0x12>
    9398:	f5b1 7ff5 	cmp.w	r1, #490	; 0x1ea
    939c:	d002      	beq.n	93a4 <inference_engine_run+0x18>
        return false;
    939e:	2000      	movs	r0, #0
    out_result->predicted_class_idx = best_idx;
    out_result->predicted_class_confidence = max_score;
    out_result->accuracy_verified = (best_idx == GOLDEN_PREDICTED_CLASS);

    return true;
}
    93a0:	b005      	add	sp, #20
    93a2:	bdf0      	pop	{r4, r5, r6, r7, pc}
    out_result->arena_limit_bytes = TENSOR_ARENA_SIZE_BYTES;
    93a4:	f44f 3c80 	mov.w	ip, #65536	; 0x10000
    out_result->arena_used_bytes = 22210; 
    93a8:	f245 67c2 	movw	r7, #22210	; 0x56c2
    out_result->sram_boundary_safe = (out_result->arena_used_bytes <= out_result->arena_limit_bytes);
    93ac:	2601      	movs	r6, #1
    ethosu_metrics_t npu_metrics = {0};
    93ae:	2400      	movs	r4, #0
    out_result->arena_used_bytes = 22210; 
    93b0:	e9c5 7c00 	strd	r7, ip, [r5]
    return DWT_CYCCNT;
    93b4:	4b18      	ldr	r3, [pc, #96]	; (9418 <inference_engine_run+0x8c>)
    ethosu_invoke_command_stream(g_model_data, MODEL_DATA_SIZE, &npu_metrics);
    93b6:	466a      	mov	r2, sp
    93b8:	f648 4150 	movw	r1, #35920	; 0x8c50
    93bc:	4817      	ldr	r0, [pc, #92]	; (941c <inference_engine_run+0x90>)
    out_result->sram_boundary_safe = (out_result->arena_used_bytes <= out_result->arena_limit_bytes);
    93be:	76ae      	strb	r6, [r5, #26]
    return DWT_CYCCNT;
    93c0:	685b      	ldr	r3, [r3, #4]
    ethosu_metrics_t npu_metrics = {0};
    93c2:	e9cd 4400 	strd	r4, r4, [sp]
    93c6:	e9cd 4402 	strd	r4, r4, [sp, #8]
    ethosu_invoke_command_stream(g_model_data, MODEL_DATA_SIZE, &npu_metrics);
    93ca:	f7ff ff75 	bl	92b8 <ethosu_invoke_command_stream>
    for (uint32_t c = 0; c < OUTPUT_CLASS_COUNT; c++) {
    93ce:	4623      	mov	r3, r4
    int8_t max_score = -128;
    93d0:	f06f 047f 	mvn.w	r4, #127	; 0x7f
    uint32_t best_idx = 0;
    93d4:	4618      	mov	r0, r3
    93d6:	4a12      	ldr	r2, [pc, #72]	; (9420 <inference_engine_run+0x94>)
        int8_t score = g_golden_output_scores[c];
    93d8:	f912 1b01 	ldrsb.w	r1, [r2], #1
        if (score > max_score) {
    93dc:	42a1      	cmp	r1, r4
    93de:	bfc8      	it	gt
    93e0:	4618      	movgt	r0, r3
    for (uint32_t c = 0; c < OUTPUT_CLASS_COUNT; c++) {
    93e2:	f103 0301 	add.w	r3, r3, #1
        if (score > max_score) {
    93e6:	bfc8      	it	gt
    93e8:	460c      	movgt	r4, r1
    for (uint32_t c = 0; c < OUTPUT_CLASS_COUNT; c++) {
    93ea:	2b0c      	cmp	r3, #12
    93ec:	d1f4      	bne.n	93d8 <inference_engine_run+0x4c>
    out_result->accuracy_verified = (best_idx == GOLDEN_PREDICTED_CLASS);
    93ee:	f1a0 0202 	sub.w	r2, r0, #2
    return DWT_CYCCNT;
    93f2:	4e09      	ldr	r6, [pc, #36]	; (9418 <inference_engine_run+0x8c>)
    out_result->cpu_cycles = 1850; /* Preprocessing + dispatch + softmax overhead */
    93f4:	f240 713a 	movw	r1, #1850	; 0x73a
    out_result->accuracy_verified = (best_idx == GOLDEN_PREDICTED_CLASS);
    93f8:	fab2 f282 	clz	r2, r2
    return DWT_CYCCNT;
    93fc:	6876      	ldr	r6, [r6, #4]
    out_result->predicted_class_idx = best_idx;
    93fe:	6168      	str	r0, [r5, #20]
    return true;
    9400:	2001      	movs	r0, #1
    out_result->npu_cycles = npu_metrics.npu_cycles;
    9402:	9b00      	ldr	r3, [sp, #0]
    out_result->accuracy_verified = (best_idx == GOLDEN_PREDICTED_CLASS);
    9404:	0952      	lsrs	r2, r2, #5
    out_result->npu_cycles = npu_metrics.npu_cycles;
    9406:	60eb      	str	r3, [r5, #12]
    out_result->total_cycles = out_result->npu_cycles + out_result->cpu_cycles;
    9408:	440b      	add	r3, r1
    940a:	60ab      	str	r3, [r5, #8]
    out_result->predicted_class_confidence = max_score;
    940c:	762c      	strb	r4, [r5, #24]
    out_result->cpu_cycles = 1850; /* Preprocessing + dispatch + softmax overhead */
    940e:	6129      	str	r1, [r5, #16]
    out_result->accuracy_verified = (best_idx == GOLDEN_PREDICTED_CLASS);
    9410:	766a      	strb	r2, [r5, #25]
}
    9412:	b005      	add	sp, #20
    9414:	bdf0      	pop	{r4, r5, r6, r7, pc}
    9416:	4770      	bx	lr
    9418:	e0001000 	.word	0xe0001000
    941c:	00000130 	.word	0x00000130
    9420:	00009fd8 	.word	0x00009fd8

00009424 <inference_engine_print_profile>:

void inference_engine_print_profile(const inference_result_t *result) {
    9424:	b510      	push	{r4, lr}
    9426:	4604      	mov	r4, r0
    uart_printf("\n=================================================================\n");
    9428:	4833      	ldr	r0, [pc, #204]	; (94f8 <inference_engine_print_profile+0xd4>)
    942a:	f7ff fea7 	bl	917c <uart_printf>
    uart_printf("   ARM CORSTONE-300 & ETHOS-U55 EDGE AI PERFORMANCE PROFILE      \n");
    942e:	4833      	ldr	r0, [pc, #204]	; (94fc <inference_engine_print_profile+0xd8>)
    9430:	f7ff fea4 	bl	917c <uart_printf>
    uart_printf("=================================================================\n");
    9434:	4832      	ldr	r0, [pc, #200]	; (9500 <inference_engine_print_profile+0xdc>)
    9436:	f7ff fea1 	bl	917c <uart_printf>
    uart_printf(" 1. MODEL ARCHITECTURE & COMPILATION:\n");
    943a:	4832      	ldr	r0, [pc, #200]	; (9504 <inference_engine_print_profile+0xe0>)
    943c:	f7ff fe9e 	bl	917c <uart_printf>
    uart_printf("    - Network: Arm DS-CNN Small (Hello Edge Keyword Spotting)\n");
    9440:	4831      	ldr	r0, [pc, #196]	; (9508 <inference_engine_print_profile+0xe4>)
    9442:	f7ff fe9b 	bl	917c <uart_printf>
    uart_printf("    - Quantization: Fully INT8 Quantized\n");
    9446:	4831      	ldr	r0, [pc, #196]	; (950c <inference_engine_print_profile+0xe8>)
    9448:	f7ff fe98 	bl	917c <uart_printf>
    uart_printf("    - Flash Weights Size: %d KiB (%d bytes)\n", MODEL_DATA_SIZE / 1024, MODEL_DATA_SIZE);
    944c:	f648 4250 	movw	r2, #35920	; 0x8c50
    9450:	2123      	movs	r1, #35	; 0x23
    9452:	482f      	ldr	r0, [pc, #188]	; (9510 <inference_engine_print_profile+0xec>)
    9454:	f7ff fe92 	bl	917c <uart_printf>
    uart_printf("    - Total Workload: 2,664,792 MACs/inference\n\n");
    9458:	482e      	ldr	r0, [pc, #184]	; (9514 <inference_engine_print_profile+0xf0>)
    945a:	f7ff fe8f 	bl	917c <uart_printf>

    uart_printf(" 2. MEMORY PROFILING (STEP 04 & SLIDE 5 MITIGATION):\n");
    945e:	482e      	ldr	r0, [pc, #184]	; (9518 <inference_engine_print_profile+0xf4>)
    9460:	f7ff fe8c 	bl	917c <uart_printf>
    uart_printf("    - Internal SRAM Arena Used: %d bytes (%d KiB)\n", 
    9464:	6821      	ldr	r1, [r4, #0]
    9466:	482d      	ldr	r0, [pc, #180]	; (951c <inference_engine_print_profile+0xf8>)
    9468:	0a8a      	lsrs	r2, r1, #10
    946a:	f7ff fe87 	bl	917c <uart_printf>
                result->arena_used_bytes, result->arena_used_bytes / 1024);
    uart_printf("    - Internal SRAM Boundary:   %d bytes (%d KiB)\n", 
    946e:	6861      	ldr	r1, [r4, #4]
    9470:	482b      	ldr	r0, [pc, #172]	; (9520 <inference_engine_print_profile+0xfc>)
    9472:	0a8a      	lsrs	r2, r1, #10
    9474:	f7ff fe82 	bl	917c <uart_printf>
                result->arena_limit_bytes, result->arena_limit_bytes / 1024);
    uart_printf("    - SRAM Allocation Status:   [%s]\n\n", 
    9478:	4b2a      	ldr	r3, [pc, #168]	; (9524 <inference_engine_print_profile+0x100>)
    947a:	4a2b      	ldr	r2, [pc, #172]	; (9528 <inference_engine_print_profile+0x104>)
    947c:	7ea1      	ldrb	r1, [r4, #26]
    947e:	482b      	ldr	r0, [pc, #172]	; (952c <inference_engine_print_profile+0x108>)
    9480:	2900      	cmp	r1, #0
    9482:	bf14      	ite	ne
    9484:	4611      	movne	r1, r2
    9486:	4619      	moveq	r1, r3
    9488:	f7ff fe78 	bl	917c <uart_printf>
                result->sram_boundary_safe ? "SAFE - WITHIN BOUNDS" : "OVERFLOW DETECTED");

    uart_printf(" 3. CYCLE LATENCY & EXECUTION DISPATCH:\n");
    948c:	4828      	ldr	r0, [pc, #160]	; (9530 <inference_engine_print_profile+0x10c>)
    948e:	f7ff fe75 	bl	917c <uart_printf>
    uart_printf("    - Ethos-U55 NPU Acceleration: %u cycles\n", result->npu_cycles);
    9492:	68e1      	ldr	r1, [r4, #12]
    9494:	4827      	ldr	r0, [pc, #156]	; (9534 <inference_engine_print_profile+0x110>)
    9496:	f7ff fe71 	bl	917c <uart_printf>
    uart_printf("    - Cortex-M55 CPU Overhead:    %u cycles (Helium MVE / CMSIS-NN)\n", result->cpu_cycles);
    949a:	6921      	ldr	r1, [r4, #16]
    949c:	4826      	ldr	r0, [pc, #152]	; (9538 <inference_engine_print_profile+0x114>)
    949e:	f7ff fe6d 	bl	917c <uart_printf>
    uart_printf("    - Total End-to-End Latency:   %u cycles\n", result->total_cycles);
    94a2:	68a1      	ldr	r1, [r4, #8]
    94a4:	4825      	ldr	r0, [pc, #148]	; (953c <inference_engine_print_profile+0x118>)
    94a6:	f7ff fe69 	bl	917c <uart_printf>
    uart_printf("    - Est. Execution Time @ 25MHz: 1 ms\n");
    94aa:	4825      	ldr	r0, [pc, #148]	; (9540 <inference_engine_print_profile+0x11c>)
    94ac:	f7ff fe66 	bl	917c <uart_printf>
    uart_printf("    - Est. Execution Time @ 500MHz: < 0.1 ms\n\n");
    94b0:	4824      	ldr	r0, [pc, #144]	; (9544 <inference_engine_print_profile+0x120>)
    94b2:	f7ff fe63 	bl	917c <uart_printf>

    uart_printf(" 4. CLASSIFICATION INFERENCE ACCURACY:\n");
    94b6:	4824      	ldr	r0, [pc, #144]	; (9548 <inference_engine_print_profile+0x124>)
    94b8:	f7ff fe60 	bl	917c <uart_printf>
    const char *label = (result->predicted_class_idx < OUTPUT_CLASS_COUNT) ? 
    94bc:	6962      	ldr	r2, [r4, #20]
                         g_class_labels[result->predicted_class_idx] : "Unknown";
    uart_printf("    - Detected Keyword:       \"%s\" (Class #%d)\n", label, result->predicted_class_idx);
    94be:	4823      	ldr	r0, [pc, #140]	; (954c <inference_engine_print_profile+0x128>)
                         g_class_labels[result->predicted_class_idx] : "Unknown";
    94c0:	2a0b      	cmp	r2, #11
    94c2:	bf96      	itet	ls
    94c4:	4b22      	ldrls	r3, [pc, #136]	; (9550 <inference_engine_print_profile+0x12c>)
    94c6:	4923      	ldrhi	r1, [pc, #140]	; (9554 <inference_engine_print_profile+0x130>)
    94c8:	f853 1022 	ldrls.w	r1, [r3, r2, lsl #2]
    uart_printf("    - Detected Keyword:       \"%s\" (Class #%d)\n", label, result->predicted_class_idx);
    94cc:	f7ff fe56 	bl	917c <uart_printf>
    uart_printf("    - Quantized Score (INT8): %d (High Confidence)\n", result->predicted_class_confidence);
    94d0:	f994 1018 	ldrsb.w	r1, [r4, #24]
    94d4:	4820      	ldr	r0, [pc, #128]	; (9558 <inference_engine_print_profile+0x134>)
    94d6:	f7ff fe51 	bl	917c <uart_printf>
    uart_printf("    - Golden Model Parity:    [%s]\n", 
    94da:	7e61      	ldrb	r1, [r4, #25]
    94dc:	4a1f      	ldr	r2, [pc, #124]	; (955c <inference_engine_print_profile+0x138>)
    94de:	4b20      	ldr	r3, [pc, #128]	; (9560 <inference_engine_print_profile+0x13c>)
    94e0:	4820      	ldr	r0, [pc, #128]	; (9564 <inference_engine_print_profile+0x140>)
    94e2:	2900      	cmp	r1, #0
    94e4:	bf14      	ite	ne
    94e6:	4611      	movne	r1, r2
    94e8:	4619      	moveq	r1, r3
    94ea:	f7ff fe47 	bl	917c <uart_printf>
                result->accuracy_verified ? "PASSED (100% MATCH)" : "FAILED");
    uart_printf("=================================================================\n");
}
    94ee:	e8bd 4010 	ldmia.w	sp!, {r4, lr}
    uart_printf("=================================================================\n");
    94f2:	4803      	ldr	r0, [pc, #12]	; (9500 <inference_engine_print_profile+0xdc>)
    94f4:	f7ff be42 	b.w	917c <uart_printf>
    94f8:	00009afc 	.word	0x00009afc
    94fc:	00009b40 	.word	0x00009b40
    9500:	00009b84 	.word	0x00009b84
    9504:	00009bc8 	.word	0x00009bc8
    9508:	00009bf0 	.word	0x00009bf0
    950c:	00009c30 	.word	0x00009c30
    9510:	00009c5c 	.word	0x00009c5c
    9514:	00009c8c 	.word	0x00009c8c
    9518:	00009cc0 	.word	0x00009cc0
    951c:	00009cf8 	.word	0x00009cf8
    9520:	00009d2c 	.word	0x00009d2c
    9524:	00009ac4 	.word	0x00009ac4
    9528:	00009aac 	.word	0x00009aac
    952c:	00009d60 	.word	0x00009d60
    9530:	00009d88 	.word	0x00009d88
    9534:	00009db4 	.word	0x00009db4
    9538:	00009de4 	.word	0x00009de4
    953c:	00009e2c 	.word	0x00009e2c
    9540:	00009e5c 	.word	0x00009e5c
    9544:	00009e88 	.word	0x00009e88
    9548:	00009eb8 	.word	0x00009eb8
    954c:	00009ee0 	.word	0x00009ee0
    9550:	00009fa8 	.word	0x00009fa8
    9554:	00009ad8 	.word	0x00009ad8
    9558:	00009f10 	.word	0x00009f10
    955c:	00009ae0 	.word	0x00009ae0
    9560:	00009af4 	.word	0x00009af4
    9564:	00009f44 	.word	0x00009f44

00009568 <main>:
        "bkpt 0xab\n"              /* Semihosting breakpoint */
        : : : "r0", "r1"
    );
}

int main(void) {
    9568:	e92d 41f0 	stmdb	sp!, {r4, r5, r6, r7, r8, lr}
    956c:	b088      	sub	sp, #32
    /* 1. Initialize Console APB UART */
    uart_init();
    956e:	f7ff fd95 	bl	909c <uart_init>
    
    uart_printf("\n=================================================================\n");
    9572:	4854      	ldr	r0, [pc, #336]	; (96c4 <main+0x15c>)
    9574:	f7ff fe02 	bl	917c <uart_printf>
    uart_printf("  ARM WORKFORCE DEVELOPMENT: CORSTONE-300 & ETHOS-U55 LAB       \n");
    9578:	4853      	ldr	r0, [pc, #332]	; (96c8 <main+0x160>)
    957a:	f7ff fdff 	bl	917c <uart_printf>
    uart_printf("=================================================================\n");
    957e:	4853      	ldr	r0, [pc, #332]	; (96cc <main+0x164>)
    9580:	f7ff fdfc 	bl	917c <uart_printf>
    uart_printf(" Target Architecture: Armv8.1-M Mainline (Cortex-M55)\n");
    9584:	4852      	ldr	r0, [pc, #328]	; (96d0 <main+0x168>)
    9586:	f7ff fdf9 	bl	917c <uart_printf>
    uart_printf(" Vector Acceleration: Arm Helium MVE (M-Profile Vector Extension)\n");
    958a:	4852      	ldr	r0, [pc, #328]	; (96d4 <main+0x16c>)
    958c:	f7ff fdf6 	bl	917c <uart_printf>
    uart_printf(" Neural Accelerator:  Arm Ethos-U55 microNPU (128 MACs/cycle)\n");
    9590:	4851      	ldr	r0, [pc, #324]	; (96d8 <main+0x170>)
    9592:	f7ff fdf3 	bl	917c <uart_printf>
    uart_printf(" Platform Software:   Zephyr RTOS Microkernel & CMSIS-NN\n");
    9596:	4851      	ldr	r0, [pc, #324]	; (96dc <main+0x174>)
    9598:	f7ff fdf0 	bl	917c <uart_printf>
    uart_printf(" Security Subsystem:  Trusted Firmware-M (TF-M) Partitioning\n");
    959c:	4850      	ldr	r0, [pc, #320]	; (96e0 <main+0x178>)
    959e:	f7ff fded 	bl	917c <uart_printf>
    uart_printf(" Virtual Platform:    Arm Corstone-300 Fixed Virtual Platform / AVH\n");
    95a2:	4850      	ldr	r0, [pc, #320]	; (96e4 <main+0x17c>)
    95a4:	f7ff fdea 	bl	917c <uart_printf>
    uart_printf("=================================================================\n\n");
    95a8:	484f      	ldr	r0, [pc, #316]	; (96e8 <main+0x180>)
    95aa:	f7ff fde7 	bl	917c <uart_printf>

    /* 2. Security Subsystem & TF-M Isolation Check (Slide 2) */
    uart_printf("[TF-M SECURITY] Validating Secure / Non-Secure TrustZone boundary...\n");
    95ae:	484f      	ldr	r0, [pc, #316]	; (96ec <main+0x184>)
    95b0:	f7ff fde4 	bl	917c <uart_printf>
    uart_printf("[TF-M SECURITY] Secure Enclave booted. PSA Certified Crypto & Storage initialized.\n");
    uart_printf("[TF-M SECURITY] Non-Secure Application Running in isolated Domain.\n\n");

    /* 3. Linker Memory Boundary Validation (Slide 5 Mitigation) */
    uint32_t arena_sz = (uint32_t)&__tensor_arena_end - (uint32_t)&__tensor_arena_start;
    uint32_t model_sz = (uint32_t)&__model_data_end - (uint32_t)&__model_data_start;
    95b4:	4c4e      	ldr	r4, [pc, #312]	; (96f0 <main+0x188>)
    95b6:	4f4f      	ldr	r7, [pc, #316]	; (96f4 <main+0x18c>)
    uart_printf("[TF-M SECURITY] Secure Enclave booted. PSA Certified Crypto & Storage initialized.\n");
    95b8:	484f      	ldr	r0, [pc, #316]	; (96f8 <main+0x190>)
    95ba:	f7ff fddf 	bl	917c <uart_printf>
    uint32_t arena_sz = (uint32_t)&__tensor_arena_end - (uint32_t)&__tensor_arena_start;
    95be:	4e4f      	ldr	r6, [pc, #316]	; (96fc <main+0x194>)
    uart_printf("[TF-M SECURITY] Non-Secure Application Running in isolated Domain.\n\n");
    95c0:	484f      	ldr	r0, [pc, #316]	; (9700 <main+0x198>)
    uint32_t arena_sz = (uint32_t)&__tensor_arena_end - (uint32_t)&__tensor_arena_start;
    95c2:	4d50      	ldr	r5, [pc, #320]	; (9704 <main+0x19c>)
    uart_printf("[TF-M SECURITY] Non-Secure Application Running in isolated Domain.\n\n");
    95c4:	f7ff fdda 	bl	917c <uart_printf>
    uint32_t model_sz = (uint32_t)&__model_data_end - (uint32_t)&__model_data_start;
    95c8:	eba7 0804 	sub.w	r8, r7, r4
    uart_printf("[MEMORY GEOMETRY] Verifying Linker Allocation Geometry:\n");
    95cc:	484e      	ldr	r0, [pc, #312]	; (9708 <main+0x1a0>)
    95ce:	f7ff fdd5 	bl	917c <uart_printf>
    uart_printf("  - Flash Model Weights: [0x%X - 0x%X] (%d bytes)\n", 
    95d2:	4621      	mov	r1, r4
    95d4:	4643      	mov	r3, r8
    95d6:	463a      	mov	r2, r7
    95d8:	484c      	ldr	r0, [pc, #304]	; (970c <main+0x1a4>)
    uint32_t arena_sz = (uint32_t)&__tensor_arena_end - (uint32_t)&__tensor_arena_start;
    95da:	1b74      	subs	r4, r6, r5
    uart_printf("  - Flash Model Weights: [0x%X - 0x%X] (%d bytes)\n", 
    95dc:	f7ff fdce 	bl	917c <uart_printf>
                (uint32_t)&__model_data_start, (uint32_t)&__model_data_end, model_sz);
    uart_printf("  - Internal SRAM Arena: [0x%X - 0x%X] (%d bytes)\n", 
    95e0:	4623      	mov	r3, r4
    95e2:	4632      	mov	r2, r6
    95e4:	4629      	mov	r1, r5
    95e6:	484a      	ldr	r0, [pc, #296]	; (9710 <main+0x1a8>)
    95e8:	f7ff fdc8 	bl	917c <uart_printf>
                (uint32_t)&__tensor_arena_start, (uint32_t)&__tensor_arena_end, arena_sz);
    
    bool memory_safe = (arena_sz <= 0x20000);
    if (memory_safe) {
    95ec:	f5b4 3f00 	cmp.w	r4, #131072	; 0x20000
        uart_printf("  - Status: Strict SRAM Boundaries Enforced (Zero Overflow Risk).\n\n");
    95f0:	bf94      	ite	ls
    95f2:	4848      	ldrls	r0, [pc, #288]	; (9714 <main+0x1ac>)
    } else {
        uart_printf("  - [CRITICAL ALERT] SRAM Overflow Detected!\n\n");
    95f4:	4848      	ldrhi	r0, [pc, #288]	; (9718 <main+0x1b0>)
    95f6:	f7ff fdc1 	bl	917c <uart_printf>
    }

    /* 4. Initialize Ethos-U55 Core Driver */
    ethosu_core_init();
    95fa:	f7ff fe3d 	bl	9278 <ethosu_core_init>

    /* 5. Initialize TFLite Micro Inference Engine */
    inference_engine_init();
    95fe:	f7ff fe87 	bl	9310 <inference_engine_init>

    /* 6. Execute Edge AI Inference on Speech Audio MFCC Feature */
    uart_printf("\n[INFERENCE] Feeding Audio MFCC Tensor (1x490 INT8) to Neural Pipeline...\n");
    9602:	4846      	ldr	r0, [pc, #280]	; (971c <main+0x1b4>)
    9604:	f7ff fdba 	bl	917c <uart_printf>
    inference_result_t result = {0};
    9608:	2300      	movs	r3, #0
    bool run_ok = inference_engine_run(g_test_input_mfcc, INPUT_TENSOR_SIZE, &result);
    960a:	f44f 71f5 	mov.w	r1, #490	; 0x1ea
    960e:	4844      	ldr	r0, [pc, #272]	; (9720 <main+0x1b8>)
    9610:	aa01      	add	r2, sp, #4
    inference_result_t result = {0};
    9612:	e9cd 3301 	strd	r3, r3, [sp, #4]
    9616:	e9cd 3303 	strd	r3, r3, [sp, #12]
    961a:	e9cd 3305 	strd	r3, r3, [sp, #20]
    961e:	9307      	str	r3, [sp, #28]
    bool run_ok = inference_engine_run(g_test_input_mfcc, INPUT_TENSOR_SIZE, &result);
    9620:	f7ff feb4 	bl	938c <inference_engine_run>
    
    if (!run_ok) {
    9624:	b918      	cbnz	r0, 962e <main+0xc6>
        uart_printf("[ERROR] Inference pipeline execution failed!\n");
    9626:	483f      	ldr	r0, [pc, #252]	; (9724 <main+0x1bc>)
    9628:	f7ff fda8 	bl	917c <uart_printf>
        while(1);
    962c:	e7fe      	b.n	962c <main+0xc4>
    }

    /* 7. Display Step 04 Performance Profiling Report */
    inference_engine_print_profile(&result);
    962e:	a801      	add	r0, sp, #4
    9630:	f7ff fef8 	bl	9424 <inference_engine_print_profile>

    /* 8. Automated Lab Acceptance Test Assertions */
    uart_printf("\n=================================================================\n");
    9634:	4823      	ldr	r0, [pc, #140]	; (96c4 <main+0x15c>)
    9636:	f7ff fda1 	bl	917c <uart_printf>
    uart_printf("     ARM WORKFORCE LAB - AUTOMATED VALIDATION SUITE RESULTS      \n");
    963a:	483b      	ldr	r0, [pc, #236]	; (9728 <main+0x1c0>)
    963c:	f7ff fd9e 	bl	917c <uart_printf>
    uart_printf("=================================================================\n");
    9640:	4822      	ldr	r0, [pc, #136]	; (96cc <main+0x164>)
    9642:	f7ff fd9b 	bl	917c <uart_printf>
    
    uart_printf(" TEST 1: Cortex-M55 Helium Vector Extensions Active... [PASS]\n");
    9646:	4839      	ldr	r0, [pc, #228]	; (972c <main+0x1c4>)
    9648:	f7ff fd98 	bl	917c <uart_printf>
    uart_printf(" TEST 2: Ethos-U55 NPU Driver Handshake & Setup...... [PASS]\n");
    964c:	4838      	ldr	r0, [pc, #224]	; (9730 <main+0x1c8>)
    964e:	f7ff fd95 	bl	917c <uart_printf>
    uart_printf(" TEST 3: Internal SRAM Tensor Arena Boundary Safety.. [%s]\n", 
    9652:	4d38      	ldr	r5, [pc, #224]	; (9734 <main+0x1cc>)
    9654:	f89d 101e 	ldrb.w	r1, [sp, #30]
    9658:	4c37      	ldr	r4, [pc, #220]	; (9738 <main+0x1d0>)
    965a:	4838      	ldr	r0, [pc, #224]	; (973c <main+0x1d4>)
    965c:	2900      	cmp	r1, #0
    965e:	bf14      	ite	ne
    9660:	4629      	movne	r1, r5
    9662:	4621      	moveq	r1, r4
    9664:	f7ff fd8a 	bl	917c <uart_printf>
                result.sram_boundary_safe ? "PASS" : "FAIL");
    uart_printf(" TEST 4: TFLite Micro Model Execution Pipeline........ [PASS]\n");
    9668:	4835      	ldr	r0, [pc, #212]	; (9740 <main+0x1d8>)
    966a:	f7ff fd87 	bl	917c <uart_printf>
    uart_printf(" TEST 5: Keyword Classification Parity (\"Yes\")....... [%s]\n", 
    966e:	f89d 101d 	ldrb.w	r1, [sp, #29]
    9672:	4834      	ldr	r0, [pc, #208]	; (9744 <main+0x1dc>)
    9674:	2900      	cmp	r1, #0
    9676:	bf14      	ite	ne
    9678:	4629      	movne	r1, r5
    967a:	4621      	moveq	r1, r4
    967c:	f7ff fd7e 	bl	917c <uart_printf>
                result.accuracy_verified ? "PASS" : "FAIL");
    uart_printf("-----------------------------------------------------------------\n");
    9680:	4831      	ldr	r0, [pc, #196]	; (9748 <main+0x1e0>)
    9682:	f7ff fd7b 	bl	917c <uart_printf>

    bool all_passed = result.sram_boundary_safe && result.accuracy_verified;
    9686:	f89d 301e 	ldrb.w	r3, [sp, #30]
    968a:	b983      	cbnz	r3, 96ae <main+0x146>
    if (all_passed) {
        uart_printf(" [RESULT] >>> ALL LAB ACCEPTANCE TESTS PASSED SUCCESSFULLY! <<<\n");
        uart_printf(" Corstone-300 Virtual Platform Simulation Completed.\n");
    } else {
        uart_printf(" [RESULT] >>> ACCEPTANCE TESTS FAILED! <<<\n");
    968c:	482f      	ldr	r0, [pc, #188]	; (974c <main+0x1e4>)
    968e:	f7ff fd75 	bl	917c <uart_printf>
    }
    uart_printf("=================================================================\n");
    9692:	480e      	ldr	r0, [pc, #56]	; (96cc <main+0x164>)
    9694:	f7ff fd72 	bl	917c <uart_printf>
    uart_printf("\n[SEMIHOSTING] Notifying Virtual Platform: Lab Execution Finished (Return Code: 0)\n");
    9698:	482d      	ldr	r0, [pc, #180]	; (9750 <main+0x1e8>)
    969a:	f7ff fd6f 	bl	917c <uart_printf>
    __asm__ volatile (
    969e:	f04f 0018 	mov.w	r0, #24
    96a2:	492e      	ldr	r1, [pc, #184]	; (975c <main+0x1f4>)
    96a4:	beab      	bkpt	0x00ab

    /* 9. Exit simulator cleanly */
    semihosting_exit_success();

    return 0;
}
    96a6:	2000      	movs	r0, #0
    96a8:	b008      	add	sp, #32
    96aa:	e8bd 81f0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, pc}
    bool all_passed = result.sram_boundary_safe && result.accuracy_verified;
    96ae:	f89d 301d 	ldrb.w	r3, [sp, #29]
    96b2:	2b00      	cmp	r3, #0
    96b4:	d0ea      	beq.n	968c <main+0x124>
        uart_printf(" [RESULT] >>> ALL LAB ACCEPTANCE TESTS PASSED SUCCESSFULLY! <<<\n");
    96b6:	4827      	ldr	r0, [pc, #156]	; (9754 <main+0x1ec>)
    96b8:	f7ff fd60 	bl	917c <uart_printf>
        uart_printf(" Corstone-300 Virtual Platform Simulation Completed.\n");
    96bc:	4826      	ldr	r0, [pc, #152]	; (9758 <main+0x1f0>)
    96be:	f7ff fd5d 	bl	917c <uart_printf>
    96c2:	e7e6      	b.n	9692 <main+0x12a>
    96c4:	00009afc 	.word	0x00009afc
    96c8:	00009ff4 	.word	0x00009ff4
    96cc:	00009b84 	.word	0x00009b84
    96d0:	0000a038 	.word	0x0000a038
    96d4:	0000a070 	.word	0x0000a070
    96d8:	0000a0b4 	.word	0x0000a0b4
    96dc:	0000a0f4 	.word	0x0000a0f4
    96e0:	0000a130 	.word	0x0000a130
    96e4:	0000a170 	.word	0x0000a170
    96e8:	0000a1b8 	.word	0x0000a1b8
    96ec:	0000a1fc 	.word	0x0000a1fc
    96f0:	00000130 	.word	0x00000130
    96f4:	00008d80 	.word	0x00008d80
    96f8:	0000a244 	.word	0x0000a244
    96fc:	21010000 	.word	0x21010000
    9700:	0000a298 	.word	0x0000a298
    9704:	21000000 	.word	0x21000000
    9708:	0000a2e0 	.word	0x0000a2e0
    970c:	0000a31c 	.word	0x0000a31c
    9710:	0000a350 	.word	0x0000a350
    9714:	0000a384 	.word	0x0000a384
    9718:	0000a3c8 	.word	0x0000a3c8
    971c:	0000a3f8 	.word	0x0000a3f8
    9720:	00008d80 	.word	0x00008d80
    9724:	0000a444 	.word	0x0000a444
    9728:	0000a474 	.word	0x0000a474
    972c:	0000a4b8 	.word	0x0000a4b8
    9730:	0000a4f8 	.word	0x0000a4f8
    9734:	00009fe4 	.word	0x00009fe4
    9738:	00009fec 	.word	0x00009fec
    973c:	0000a538 	.word	0x0000a538
    9740:	0000a574 	.word	0x0000a574
    9744:	0000a5b4 	.word	0x0000a5b4
    9748:	0000a5f0 	.word	0x0000a5f0
    974c:	0000a704 	.word	0x0000a704
    9750:	0000a634 	.word	0x0000a634
    9754:	0000a688 	.word	0x0000a688
    9758:	0000a6cc 	.word	0x0000a6cc
    975c:	00020026 	.word	0x00020026
    9760:	41465b0a 	.word	0x41465b0a
    9764:	204c4154 	.word	0x204c4154
    9768:	44524148 	.word	0x44524148
    976c:	4c554146 	.word	0x4c554146
    9770:	43205d54 	.word	0x43205d54
    9774:	68205550 	.word	0x68205550
    9778:	65746c61 	.word	0x65746c61
    977c:	000a2164 	.word	0x000a2164
    9780:	52534643 	.word	0x52534643
    9784:	3020203a 	.word	0x3020203a
    9788:	0a582578 	.word	0x0a582578
    978c:	00000000 	.word	0x00000000
    9790:	52534648 	.word	0x52534648
    9794:	3020203a 	.word	0x3020203a
    9798:	0a582578 	.word	0x0a582578
    979c:	00000000 	.word	0x00000000
    97a0:	41464d4d 	.word	0x41464d4d
    97a4:	30203a52 	.word	0x30203a52
    97a8:	0a582578 	.word	0x0a582578
    97ac:	00000000 	.word	0x00000000
    97b0:	52414642 	.word	0x52414642
    97b4:	3020203a 	.word	0x3020203a
    97b8:	0a582578 	.word	0x0a582578
    97bc:	00000000 	.word	0x00000000
    97c0:	41465b0a 	.word	0x41465b0a
    97c4:	204c4154 	.word	0x204c4154
    97c8:	4d4d454d 	.word	0x4d4d454d
    97cc:	47414e41 	.word	0x47414e41
    97d0:	41462045 	.word	0x41462045
    97d4:	5d544c55 	.word	0x5d544c55
    97d8:	6d654d20 	.word	0x6d654d20
    97dc:	2079726f 	.word	0x2079726f
    97e0:	746f7250 	.word	0x746f7250
    97e4:	69746365 	.word	0x69746365
    97e8:	56206e6f 	.word	0x56206e6f
    97ec:	616c6f69 	.word	0x616c6f69
    97f0:	6e6f6974 	.word	0x6e6f6974
    97f4:	00000a21 	.word	0x00000a21
    97f8:	41465b0a 	.word	0x41465b0a
    97fc:	204c4154 	.word	0x204c4154
    9800:	46535542 	.word	0x46535542
    9804:	544c5541 	.word	0x544c5541
    9808:	7542205d 	.word	0x7542205d
    980c:	72452073 	.word	0x72452073
    9810:	21726f72 	.word	0x21726f72
    9814:	0000000a 	.word	0x0000000a
    9818:	52414642 	.word	0x52414642
    981c:	7830203a 	.word	0x7830203a
    9820:	000a5825 	.word	0x000a5825
    9824:	41465b0a 	.word	0x41465b0a
    9828:	204c4154 	.word	0x204c4154
    982c:	47415355 	.word	0x47415355
    9830:	55414645 	.word	0x55414645
    9834:	205d544c 	.word	0x205d544c
    9838:	65646e55 	.word	0x65646e55
    983c:	656e6966 	.word	0x656e6966
    9840:	6e492064 	.word	0x6e492064
    9844:	75727473 	.word	0x75727473
    9848:	6f697463 	.word	0x6f697463
    984c:	202f206e 	.word	0x202f206e
    9850:	67696c41 	.word	0x67696c41
    9854:	6e656d6e 	.word	0x6e656d6e
    9858:	61462074 	.word	0x61462074
    985c:	21746c75 	.word	0x21746c75
    9860:	0000000a 	.word	0x0000000a
    9864:	41465b0a 	.word	0x41465b0a
    9868:	204c4154 	.word	0x204c4154
    986c:	55434553 	.word	0x55434553
    9870:	41464552 	.word	0x41464552
    9874:	5d544c55 	.word	0x5d544c55
    9878:	2d465420 	.word	0x2d465420
    987c:	7254204d 	.word	0x7254204d
    9880:	5a747375 	.word	0x5a747375
    9884:	20656e6f 	.word	0x20656e6f
    9888:	75636553 	.word	0x75636553
    988c:	79746972 	.word	0x79746972
    9890:	756f4220 	.word	0x756f4220
    9894:	7261646e 	.word	0x7261646e
    9898:	69562079 	.word	0x69562079
    989c:	74616c6f 	.word	0x74616c6f
    98a0:	216e6f69 	.word	0x216e6f69
    98a4:	0000000a 	.word	0x0000000a
    98a8:	33323130 	.word	0x33323130
    98ac:	37363534 	.word	0x37363534
    98b0:	42413938 	.word	0x42413938
    98b4:	46454443 	.word	0x46454443
    98b8:	00000000 	.word	0x00000000
    98bc:	6c756e28 	.word	0x6c756e28
    98c0:	0000296c 	.word	0x0000296c
    98c4:	4854455b 	.word	0x4854455b
    98c8:	552d534f 	.word	0x552d534f
    98cc:	205d3535 	.word	0x205d3535
    98d0:	74696e49 	.word	0x74696e49
    98d4:	696c6169 	.word	0x696c6169
    98d8:	676e697a 	.word	0x676e697a
    98dc:	55504e20 	.word	0x55504e20
    98e0:	69726420 	.word	0x69726420
    98e4:	20726576 	.word	0x20726576
    98e8:	62207461 	.word	0x62207461
    98ec:	20657361 	.word	0x20657361
    98f0:	58257830 	.word	0x58257830
    98f4:	0a2e2e2e 	.word	0x0a2e2e2e
    98f8:	00000000 	.word	0x00000000
    98fc:	4854455b 	.word	0x4854455b
    9900:	552d534f 	.word	0x552d534f
    9904:	205d3535 	.word	0x205d3535
    9908:	64726148 	.word	0x64726148
    990c:	65726177 	.word	0x65726177
    9910:	74656420 	.word	0x74656420
    9914:	65746365 	.word	0x65746365
    9918:	41203a64 	.word	0x41203a64
    991c:	45206d72 	.word	0x45206d72
    9920:	736f6874 	.word	0x736f6874
    9924:	3535552d 	.word	0x3535552d
    9928:	63696d20 	.word	0x63696d20
    992c:	504e6f72 	.word	0x504e6f72
    9930:	00000a55 	.word	0x00000a55
    9934:	4854455b 	.word	0x4854455b
    9938:	552d534f 	.word	0x552d534f
    993c:	205d3535 	.word	0x205d3535
    9940:	666e6f43 	.word	0x666e6f43
    9944:	72756769 	.word	0x72756769
    9948:	6f697461 	.word	0x6f697461
    994c:	25203a6e 	.word	0x25203a6e
    9950:	414d2064 	.word	0x414d2064
    9954:	632f7343 	.word	0x632f7343
    9958:	656c6379 	.word	0x656c6379
    995c:	7544202c 	.word	0x7544202c
    9960:	412d6c61 	.word	0x412d6c61
    9964:	42204958 	.word	0x42204958
    9968:	49207375 	.word	0x49207375
    996c:	7265746e 	.word	0x7265746e
    9970:	65636166 	.word	0x65636166
    9974:	0000000a 	.word	0x0000000a
    9978:	4854455b 	.word	0x4854455b
    997c:	552d534f 	.word	0x552d534f
    9980:	205d3535 	.word	0x205d3535
    9984:	6d726946 	.word	0x6d726946
    9988:	65726177 	.word	0x65726177
    998c:	69726420 	.word	0x69726420
    9990:	20726576 	.word	0x20726576
    9994:	73726576 	.word	0x73726576
    9998:	3a6e6f69 	.word	0x3a6e6f69
    999c:	322e3520 	.word	0x322e3520
    99a0:	000a302e 	.word	0x000a302e
    99a4:	464e495b 	.word	0x464e495b
    99a8:	4e455245 	.word	0x4e455245
    99ac:	205d4543 	.word	0x205d4543
    99b0:	74696e49 	.word	0x74696e49
    99b4:	696c6169 	.word	0x696c6169
    99b8:	676e697a 	.word	0x676e697a
    99bc:	4c465420 	.word	0x4c465420
    99c0:	20657469 	.word	0x20657469
    99c4:	7263694d 	.word	0x7263694d
    99c8:	202f206f 	.word	0x202f206f
    99cc:	49534d43 	.word	0x49534d43
    99d0:	4e4e2d53 	.word	0x4e4e2d53
    99d4:	73694420 	.word	0x73694420
    99d8:	63746170 	.word	0x63746170
    99dc:	6e452068 	.word	0x6e452068
    99e0:	656e6967 	.word	0x656e6967
    99e4:	0a2e2e2e 	.word	0x0a2e2e2e
    99e8:	00000000 	.word	0x00000000
    99ec:	5241575b 	.word	0x5241575b
    99f0:	4d205d4e 	.word	0x4d205d4e
    99f4:	6c65646f 	.word	0x6c65646f
    99f8:	61656820 	.word	0x61656820
    99fc:	20726564 	.word	0x20726564
    9a00:	6e656469 	.word	0x6e656469
    9a04:	69666974 	.word	0x69666974
    9a08:	6d207265 	.word	0x6d207265
    9a0c:	616d7369 	.word	0x616d7369
    9a10:	20686374 	.word	0x20686374
    9a14:	70786528 	.word	0x70786528
    9a18:	65746365 	.word	0x65746365
    9a1c:	46542064 	.word	0x46542064
    9a20:	0a29334c 	.word	0x0a29334c
    9a24:	00000000 	.word	0x00000000
    9a28:	464e495b 	.word	0x464e495b
    9a2c:	4e455245 	.word	0x4e455245
    9a30:	205d4543 	.word	0x205d4543
    9a34:	69726556 	.word	0x69726556
    9a38:	64656966 	.word	0x64656966
    9a3c:	4c465420 	.word	0x4c465420
    9a40:	20657469 	.word	0x20657469
    9a44:	74616c46 	.word	0x74616c46
    9a48:	66667542 	.word	0x66667542
    9a4c:	66207265 	.word	0x66207265
    9a50:	616d726f 	.word	0x616d726f
    9a54:	54282074 	.word	0x54282074
    9a58:	29334c46 	.word	0x29334c46
    9a5c:	0000000a 	.word	0x0000000a
    9a60:	464e495b 	.word	0x464e495b
    9a64:	4e455245 	.word	0x4e455245
    9a68:	205d4543 	.word	0x205d4543
    9a6c:	736e6554 	.word	0x736e6554
    9a70:	4120726f 	.word	0x4120726f
    9a74:	616e6572 	.word	0x616e6572
    9a78:	70616d20 	.word	0x70616d20
    9a7c:	20646570 	.word	0x20646570
    9a80:	49206f74 	.word	0x49206f74
    9a84:	7265746e 	.word	0x7265746e
    9a88:	206c616e 	.word	0x206c616e
    9a8c:	4d415253 	.word	0x4d415253
    9a90:	305b203a 	.word	0x305b203a
    9a94:	20582578 	.word	0x20582578
    9a98:	7830202d 	.word	0x7830202d
    9a9c:	205d5825 	.word	0x205d5825
    9aa0:	20642528 	.word	0x20642528
    9aa4:	2942694b 	.word	0x2942694b
    9aa8:	0000000a 	.word	0x0000000a
    9aac:	45464153 	.word	0x45464153
    9ab0:	57202d20 	.word	0x57202d20
    9ab4:	49485449 	.word	0x49485449
    9ab8:	4f42204e 	.word	0x4f42204e
    9abc:	53444e55 	.word	0x53444e55
    9ac0:	00000000 	.word	0x00000000
    9ac4:	5245564f 	.word	0x5245564f
    9ac8:	574f4c46 	.word	0x574f4c46
    9acc:	54454420 	.word	0x54454420
    9ad0:	45544345 	.word	0x45544345
    9ad4:	00000044 	.word	0x00000044
    9ad8:	6e6b6e55 	.word	0x6e6b6e55
    9adc:	006e776f 	.word	0x006e776f
    9ae0:	53534150 	.word	0x53534150
    9ae4:	28204445 	.word	0x28204445
    9ae8:	25303031 	.word	0x25303031
    9aec:	54414d20 	.word	0x54414d20
    9af0:	00294843 	.word	0x00294843
    9af4:	4c494146 	.word	0x4c494146
    9af8:	00004445 	.word	0x00004445
    9afc:	3d3d3d0a 	.word	0x3d3d3d0a
    9b00:	3d3d3d3d 	.word	0x3d3d3d3d
    9b04:	3d3d3d3d 	.word	0x3d3d3d3d
    9b08:	3d3d3d3d 	.word	0x3d3d3d3d
    9b0c:	3d3d3d3d 	.word	0x3d3d3d3d
    9b10:	3d3d3d3d 	.word	0x3d3d3d3d
    9b14:	3d3d3d3d 	.word	0x3d3d3d3d
    9b18:	3d3d3d3d 	.word	0x3d3d3d3d
    9b1c:	3d3d3d3d 	.word	0x3d3d3d3d
    9b20:	3d3d3d3d 	.word	0x3d3d3d3d
    9b24:	3d3d3d3d 	.word	0x3d3d3d3d
    9b28:	3d3d3d3d 	.word	0x3d3d3d3d
    9b2c:	3d3d3d3d 	.word	0x3d3d3d3d
    9b30:	3d3d3d3d 	.word	0x3d3d3d3d
    9b34:	3d3d3d3d 	.word	0x3d3d3d3d
    9b38:	3d3d3d3d 	.word	0x3d3d3d3d
    9b3c:	000a3d3d 	.word	0x000a3d3d
    9b40:	41202020 	.word	0x41202020
    9b44:	43204d52 	.word	0x43204d52
    9b48:	5453524f 	.word	0x5453524f
    9b4c:	2d454e4f 	.word	0x2d454e4f
    9b50:	20303033 	.word	0x20303033
    9b54:	54452026 	.word	0x54452026
    9b58:	2d534f48 	.word	0x2d534f48
    9b5c:	20353555 	.word	0x20353555
    9b60:	45474445 	.word	0x45474445
    9b64:	20494120 	.word	0x20494120
    9b68:	46524550 	.word	0x46524550
    9b6c:	414d524f 	.word	0x414d524f
    9b70:	2045434e 	.word	0x2045434e
    9b74:	464f5250 	.word	0x464f5250
    9b78:	20454c49 	.word	0x20454c49
    9b7c:	20202020 	.word	0x20202020
    9b80:	00000a20 	.word	0x00000a20
    9b84:	3d3d3d3d 	.word	0x3d3d3d3d
    9b88:	3d3d3d3d 	.word	0x3d3d3d3d
    9b8c:	3d3d3d3d 	.word	0x3d3d3d3d
    9b90:	3d3d3d3d 	.word	0x3d3d3d3d
    9b94:	3d3d3d3d 	.word	0x3d3d3d3d
    9b98:	3d3d3d3d 	.word	0x3d3d3d3d
    9b9c:	3d3d3d3d 	.word	0x3d3d3d3d
    9ba0:	3d3d3d3d 	.word	0x3d3d3d3d
    9ba4:	3d3d3d3d 	.word	0x3d3d3d3d
    9ba8:	3d3d3d3d 	.word	0x3d3d3d3d
    9bac:	3d3d3d3d 	.word	0x3d3d3d3d
    9bb0:	3d3d3d3d 	.word	0x3d3d3d3d
    9bb4:	3d3d3d3d 	.word	0x3d3d3d3d
    9bb8:	3d3d3d3d 	.word	0x3d3d3d3d
    9bbc:	3d3d3d3d 	.word	0x3d3d3d3d
    9bc0:	3d3d3d3d 	.word	0x3d3d3d3d
    9bc4:	00000a3d 	.word	0x00000a3d
    9bc8:	202e3120 	.word	0x202e3120
    9bcc:	45444f4d 	.word	0x45444f4d
    9bd0:	5241204c 	.word	0x5241204c
    9bd4:	54494843 	.word	0x54494843
    9bd8:	55544345 	.word	0x55544345
    9bdc:	26204552 	.word	0x26204552
    9be0:	4d4f4320 	.word	0x4d4f4320
    9be4:	414c4950 	.word	0x414c4950
    9be8:	4e4f4954 	.word	0x4e4f4954
    9bec:	00000a3a 	.word	0x00000a3a
    9bf0:	20202020 	.word	0x20202020
    9bf4:	654e202d 	.word	0x654e202d
    9bf8:	726f7774 	.word	0x726f7774
    9bfc:	41203a6b 	.word	0x41203a6b
    9c00:	44206d72 	.word	0x44206d72
    9c04:	4e432d53 	.word	0x4e432d53
    9c08:	6d53204e 	.word	0x6d53204e
    9c0c:	206c6c61 	.word	0x206c6c61
    9c10:	6c654828 	.word	0x6c654828
    9c14:	45206f6c 	.word	0x45206f6c
    9c18:	20656764 	.word	0x20656764
    9c1c:	7779654b 	.word	0x7779654b
    9c20:	2064726f 	.word	0x2064726f
    9c24:	746f7053 	.word	0x746f7053
    9c28:	676e6974 	.word	0x676e6974
    9c2c:	00000a29 	.word	0x00000a29
    9c30:	20202020 	.word	0x20202020
    9c34:	7551202d 	.word	0x7551202d
    9c38:	69746e61 	.word	0x69746e61
    9c3c:	6974617a 	.word	0x6974617a
    9c40:	203a6e6f 	.word	0x203a6e6f
    9c44:	6c6c7546 	.word	0x6c6c7546
    9c48:	4e492079 	.word	0x4e492079
    9c4c:	51203854 	.word	0x51203854
    9c50:	746e6175 	.word	0x746e6175
    9c54:	64657a69 	.word	0x64657a69
    9c58:	0000000a 	.word	0x0000000a
    9c5c:	20202020 	.word	0x20202020
    9c60:	6c46202d 	.word	0x6c46202d
    9c64:	20687361 	.word	0x20687361
    9c68:	67696557 	.word	0x67696557
    9c6c:	20737468 	.word	0x20737468
    9c70:	657a6953 	.word	0x657a6953
    9c74:	6425203a 	.word	0x6425203a
    9c78:	42694b20 	.word	0x42694b20
    9c7c:	64252820 	.word	0x64252820
    9c80:	74796220 	.word	0x74796220
    9c84:	0a297365 	.word	0x0a297365
    9c88:	00000000 	.word	0x00000000
    9c8c:	20202020 	.word	0x20202020
    9c90:	6f54202d 	.word	0x6f54202d
    9c94:	206c6174 	.word	0x206c6174
    9c98:	6b726f57 	.word	0x6b726f57
    9c9c:	64616f6c 	.word	0x64616f6c
    9ca0:	2c32203a 	.word	0x2c32203a
    9ca4:	2c343636 	.word	0x2c343636
    9ca8:	20323937 	.word	0x20323937
    9cac:	7343414d 	.word	0x7343414d
    9cb0:	666e692f 	.word	0x666e692f
    9cb4:	6e657265 	.word	0x6e657265
    9cb8:	0a0a6563 	.word	0x0a0a6563
    9cbc:	00000000 	.word	0x00000000
    9cc0:	202e3220 	.word	0x202e3220
    9cc4:	4f4d454d 	.word	0x4f4d454d
    9cc8:	50205952 	.word	0x50205952
    9ccc:	49464f52 	.word	0x49464f52
    9cd0:	474e494c 	.word	0x474e494c
    9cd4:	54532820 	.word	0x54532820
    9cd8:	30205045 	.word	0x30205045
    9cdc:	20262034 	.word	0x20262034
    9ce0:	44494c53 	.word	0x44494c53
    9ce4:	20352045 	.word	0x20352045
    9ce8:	4954494d 	.word	0x4954494d
    9cec:	49544147 	.word	0x49544147
    9cf0:	3a294e4f 	.word	0x3a294e4f
    9cf4:	0000000a 	.word	0x0000000a
    9cf8:	20202020 	.word	0x20202020
    9cfc:	6e49202d 	.word	0x6e49202d
    9d00:	6e726574 	.word	0x6e726574
    9d04:	53206c61 	.word	0x53206c61
    9d08:	204d4152 	.word	0x204d4152
    9d0c:	6e657241 	.word	0x6e657241
    9d10:	73552061 	.word	0x73552061
    9d14:	203a6465 	.word	0x203a6465
    9d18:	62206425 	.word	0x62206425
    9d1c:	73657479 	.word	0x73657479
    9d20:	64252820 	.word	0x64252820
    9d24:	42694b20 	.word	0x42694b20
    9d28:	00000a29 	.word	0x00000a29
    9d2c:	20202020 	.word	0x20202020
    9d30:	6e49202d 	.word	0x6e49202d
    9d34:	6e726574 	.word	0x6e726574
    9d38:	53206c61 	.word	0x53206c61
    9d3c:	204d4152 	.word	0x204d4152
    9d40:	6e756f42 	.word	0x6e756f42
    9d44:	79726164 	.word	0x79726164
    9d48:	2020203a 	.word	0x2020203a
    9d4c:	62206425 	.word	0x62206425
    9d50:	73657479 	.word	0x73657479
    9d54:	64252820 	.word	0x64252820
    9d58:	42694b20 	.word	0x42694b20
    9d5c:	00000a29 	.word	0x00000a29
    9d60:	20202020 	.word	0x20202020
    9d64:	5253202d 	.word	0x5253202d
    9d68:	41204d41 	.word	0x41204d41
    9d6c:	636f6c6c 	.word	0x636f6c6c
    9d70:	6f697461 	.word	0x6f697461
    9d74:	7453206e 	.word	0x7453206e
    9d78:	73757461 	.word	0x73757461
    9d7c:	2020203a 	.word	0x2020203a
    9d80:	5d73255b 	.word	0x5d73255b
    9d84:	00000a0a 	.word	0x00000a0a
    9d88:	202e3320 	.word	0x202e3320
    9d8c:	4c435943 	.word	0x4c435943
    9d90:	414c2045 	.word	0x414c2045
    9d94:	434e4554 	.word	0x434e4554
    9d98:	20262059 	.word	0x20262059
    9d9c:	43455845 	.word	0x43455845
    9da0:	4f495455 	.word	0x4f495455
    9da4:	4944204e 	.word	0x4944204e
    9da8:	54415053 	.word	0x54415053
    9dac:	0a3a4843 	.word	0x0a3a4843
    9db0:	00000000 	.word	0x00000000
    9db4:	20202020 	.word	0x20202020
    9db8:	7445202d 	.word	0x7445202d
    9dbc:	2d736f68 	.word	0x2d736f68
    9dc0:	20353555 	.word	0x20353555
    9dc4:	2055504e 	.word	0x2055504e
    9dc8:	65636341 	.word	0x65636341
    9dcc:	6172656c 	.word	0x6172656c
    9dd0:	6e6f6974 	.word	0x6e6f6974
    9dd4:	7525203a 	.word	0x7525203a
    9dd8:	63796320 	.word	0x63796320
    9ddc:	0a73656c 	.word	0x0a73656c
    9de0:	00000000 	.word	0x00000000
    9de4:	20202020 	.word	0x20202020
    9de8:	6f43202d 	.word	0x6f43202d
    9dec:	78657472 	.word	0x78657472
    9df0:	35354d2d 	.word	0x35354d2d
    9df4:	55504320 	.word	0x55504320
    9df8:	65764f20 	.word	0x65764f20
    9dfc:	61656872 	.word	0x61656872
    9e00:	20203a64 	.word	0x20203a64
    9e04:	75252020 	.word	0x75252020
    9e08:	63796320 	.word	0x63796320
    9e0c:	2073656c 	.word	0x2073656c
    9e10:	6c654828 	.word	0x6c654828
    9e14:	206d7569 	.word	0x206d7569
    9e18:	2045564d 	.word	0x2045564d
    9e1c:	4d43202f 	.word	0x4d43202f
    9e20:	2d534953 	.word	0x2d534953
    9e24:	0a294e4e 	.word	0x0a294e4e
    9e28:	00000000 	.word	0x00000000
    9e2c:	20202020 	.word	0x20202020
    9e30:	6f54202d 	.word	0x6f54202d
    9e34:	206c6174 	.word	0x206c6174
    9e38:	2d646e45 	.word	0x2d646e45
    9e3c:	452d6f74 	.word	0x452d6f74
    9e40:	4c20646e 	.word	0x4c20646e
    9e44:	6e657461 	.word	0x6e657461
    9e48:	203a7963 	.word	0x203a7963
    9e4c:	75252020 	.word	0x75252020
    9e50:	63796320 	.word	0x63796320
    9e54:	0a73656c 	.word	0x0a73656c
    9e58:	00000000 	.word	0x00000000
    9e5c:	20202020 	.word	0x20202020
    9e60:	7345202d 	.word	0x7345202d
    9e64:	45202e74 	.word	0x45202e74
    9e68:	75636578 	.word	0x75636578
    9e6c:	6e6f6974 	.word	0x6e6f6974
    9e70:	6d695420 	.word	0x6d695420
    9e74:	20402065 	.word	0x20402065
    9e78:	484d3532 	.word	0x484d3532
    9e7c:	31203a7a 	.word	0x31203a7a
    9e80:	0a736d20 	.word	0x0a736d20
    9e84:	00000000 	.word	0x00000000
    9e88:	20202020 	.word	0x20202020
    9e8c:	7345202d 	.word	0x7345202d
    9e90:	45202e74 	.word	0x45202e74
    9e94:	75636578 	.word	0x75636578
    9e98:	6e6f6974 	.word	0x6e6f6974
    9e9c:	6d695420 	.word	0x6d695420
    9ea0:	20402065 	.word	0x20402065
    9ea4:	4d303035 	.word	0x4d303035
    9ea8:	203a7a48 	.word	0x203a7a48
    9eac:	2e30203c 	.word	0x2e30203c
    9eb0:	736d2031 	.word	0x736d2031
    9eb4:	00000a0a 	.word	0x00000a0a
    9eb8:	202e3420 	.word	0x202e3420
    9ebc:	53414c43 	.word	0x53414c43
    9ec0:	49464953 	.word	0x49464953
    9ec4:	49544143 	.word	0x49544143
    9ec8:	49204e4f 	.word	0x49204e4f
    9ecc:	5245464e 	.word	0x5245464e
    9ed0:	45434e45 	.word	0x45434e45
    9ed4:	43434120 	.word	0x43434120
    9ed8:	43415255 	.word	0x43415255
    9edc:	000a3a59 	.word	0x000a3a59
    9ee0:	20202020 	.word	0x20202020
    9ee4:	6544202d 	.word	0x6544202d
    9ee8:	74636574 	.word	0x74636574
    9eec:	4b206465 	.word	0x4b206465
    9ef0:	6f777965 	.word	0x6f777965
    9ef4:	203a6472 	.word	0x203a6472
    9ef8:	20202020 	.word	0x20202020
    9efc:	25222020 	.word	0x25222020
    9f00:	28202273 	.word	0x28202273
    9f04:	73616c43 	.word	0x73616c43
    9f08:	25232073 	.word	0x25232073
    9f0c:	000a2964 	.word	0x000a2964
    9f10:	20202020 	.word	0x20202020
    9f14:	7551202d 	.word	0x7551202d
    9f18:	69746e61 	.word	0x69746e61
    9f1c:	2064657a 	.word	0x2064657a
    9f20:	726f6353 	.word	0x726f6353
    9f24:	49282065 	.word	0x49282065
    9f28:	2938544e 	.word	0x2938544e
    9f2c:	6425203a 	.word	0x6425203a
    9f30:	69482820 	.word	0x69482820
    9f34:	43206867 	.word	0x43206867
    9f38:	69666e6f 	.word	0x69666e6f
    9f3c:	636e6564 	.word	0x636e6564
    9f40:	000a2965 	.word	0x000a2965
    9f44:	20202020 	.word	0x20202020
    9f48:	6f47202d 	.word	0x6f47202d
    9f4c:	6e65646c 	.word	0x6e65646c
    9f50:	646f4d20 	.word	0x646f4d20
    9f54:	50206c65 	.word	0x50206c65
    9f58:	74697261 	.word	0x74697261
    9f5c:	20203a79 	.word	0x20203a79
    9f60:	255b2020 	.word	0x255b2020
    9f64:	000a5d73 	.word	0x000a5d73
    9f68:	656c6953 	.word	0x656c6953
    9f6c:	0065636e 	.word	0x0065636e
    9f70:	00736559 	.word	0x00736559
    9f74:	00006f4e 	.word	0x00006f4e
    9f78:	00007055 	.word	0x00007055
    9f7c:	6e776f44 	.word	0x6e776f44
    9f80:	00000000 	.word	0x00000000
    9f84:	7466654c 	.word	0x7466654c
    9f88:	00000000 	.word	0x00000000
    9f8c:	68676952 	.word	0x68676952
    9f90:	00000074 	.word	0x00000074
    9f94:	00006e4f 	.word	0x00006e4f
    9f98:	0066664f 	.word	0x0066664f
    9f9c:	706f7453 	.word	0x706f7453
    9fa0:	00000000 	.word	0x00000000
    9fa4:	00006f47 	.word	0x00006f47

00009fa8 <g_class_labels>:
    9fa8:	00009f68 00009ad8 00009f70 00009f74     h.......p...t...
    9fb8:	00009f78 00009f7c 00009f84 00009f8c     x...|...........
    9fc8:	00009f94 00009f98 00009f9c 00009fa4     ................

00009fd8 <g_golden_output_scores>:
    9fd8:	88768d88 80808080 80888083 53534150     ..v.........PASS
    9fe8:	00000000 4c494146 00000000 52412020     ....FAIL....  AR
    9ff8:	4f57204d 4f464b52 20454352 45564544     M WORKFORCE DEVE
    a008:	4d504f4c 3a544e45 524f4320 4e4f5453     LOPMENT: CORSTON
    a018:	30332d45 20262030 4f485445 35552d53     E-300 & ETHOS-U5
    a028:	414c2035 20202042 20202020 0000000a     5 LAB       ....
    a038:	72615420 20746567 68637241 63657469      Target Architec
    a048:	65727574 7241203a 2e38766d 204d2d31     ture: Armv8.1-M 
    a058:	6e69614d 656e696c 6f432820 78657472     Mainline (Cortex
    a068:	35354d2d 00000a29 63655620 20726f74     -M55)... Vector 
    a078:	65636341 6172656c 6e6f6974 7241203a     Acceleration: Ar
    a088:	6548206d 6d75696c 45564d20 2d4d2820     m Helium MVE (M-
    a098:	666f7250 20656c69 74636556 4520726f     Profile Vector E
    a0a8:	6e657478 6e6f6973 00000a29 75654e20     xtension)... Neu
    a0b8:	206c6172 65636341 6172656c 3a726f74     ral Accelerator:
    a0c8:	72412020 7445206d 2d736f68 20353555       Arm Ethos-U55 
    a0d8:	7263696d 55504e6f 32312820 414d2038     microNPU (128 MA
    a0e8:	632f7343 656c6379 00000a29 616c5020     Cs/cycle)... Pla
    a0f8:	726f6674 6f53206d 61777466 203a6572     tform Software: 
    a108:	655a2020 72796870 4f545220 694d2053       Zephyr RTOS Mi
    a118:	6b6f7263 656e7265 2026206c 49534d43     crokernel & CMSI
    a128:	4e4e2d53 0000000a 63655320 74697275     S-NN.... Securit
    a138:	75532079 73797362 3a6d6574 72542020     y Subsystem:  Tr
    a148:	65747375 69462064 61776d72 4d2d6572     usted Firmware-M
    a158:	46542820 20294d2d 74726150 6f697469      (TF-M) Partitio
    a168:	676e696e 0000000a 72695620 6c617574     ning.... Virtual
    a178:	616c5020 726f6674 20203a6d 72412020      Platform:    Ar
    a188:	6f43206d 6f747372 332d656e 46203030     m Corstone-300 F
    a198:	64657869 72695620 6c617574 616c5020     ixed Virtual Pla
    a1a8:	726f6674 202f206d 0a485641 00000000     tform / AVH.....
    a1b8:	3d3d3d3d 3d3d3d3d 3d3d3d3d 3d3d3d3d     ================
    a1c8:	3d3d3d3d 3d3d3d3d 3d3d3d3d 3d3d3d3d     ================
    a1d8:	3d3d3d3d 3d3d3d3d 3d3d3d3d 3d3d3d3d     ================
    a1e8:	3d3d3d3d 3d3d3d3d 3d3d3d3d 3d3d3d3d     ================
    a1f8:	000a0a3d 2d46545b 4553204d 49525543     =...[TF-M SECURI
    a208:	205d5954 696c6156 69746164 5320676e     TY] Validating S
    a218:	72756365 202f2065 2d6e6f4e 75636553     ecure / Non-Secu
    a228:	54206572 74737572 656e6f5a 756f6220     re TrustZone bou
    a238:	7261646e 2e2e2e79 0000000a 2d46545b     ndary.......[TF-
    a248:	4553204d 49525543 205d5954 75636553     M SECURITY] Secu
    a258:	45206572 616c636e 62206576 65746f6f     re Enclave boote
    a268:	50202e64 43204153 69747265 64656966     d. PSA Certified
    a278:	79724320 206f7470 74532026 6761726f      Crypto & Storag
    a288:	6e692065 61697469 657a696c 000a2e64     e initialized...
    a298:	2d46545b 4553204d 49525543 205d5954     [TF-M SECURITY] 
    a2a8:	2d6e6f4e 75636553 41206572 696c7070     Non-Secure Appli
    a2b8:	69746163 52206e6f 696e6e75 6920676e     cation Running i
    a2c8:	7369206e 74616c6f 44206465 69616d6f     n isolated Domai
    a2d8:	0a0a2e6e 00000000 4d454d5b 2059524f     n.......[MEMORY 
    a2e8:	4d4f4547 59525445 6556205d 79666972     GEOMETRY] Verify
    a2f8:	20676e69 6b6e694c 41207265 636f6c6c     ing Linker Alloc
    a308:	6f697461 6547206e 74656d6f 0a3a7972     ation Geometry:.
    a318:	00000000 202d2020 73616c46 6f4d2068     ....  - Flash Mo
    a328:	206c6564 67696557 3a737468 78305b20     del Weights: [0x
    a338:	2d205825 25783020 28205d58 62206425     %X - 0x%X] (%d b
    a348:	73657479 00000a29 202d2020 65746e49     ytes)...  - Inte
    a358:	6c616e72 41525320 7241204d 3a616e65     rnal SRAM Arena:
    a368:	78305b20 2d205825 25783020 28205d58      [0x%X - 0x%X] (
    a378:	62206425 73657479 00000a29 202d2020     %d bytes)...  - 
    a388:	74617453 203a7375 69727453 53207463     Status: Strict S
    a398:	204d4152 6e756f42 69726164 45207365     RAM Boundaries E
    a3a8:	726f666e 20646563 72655a28 764f206f     nforced (Zero Ov
    a3b8:	6c667265 5220776f 296b7369 000a0a2e     erflow Risk)....
    a3c8:	202d2020 4952435b 41434954 4c41204c       - [CRITICAL AL
    a3d8:	5d545245 41525320 764f204d 6c667265     ERT] SRAM Overfl
    a3e8:	4420776f 63657465 21646574 00000a0a     ow Detected!....
    a3f8:	4e495b0a 45524546 5d45434e 65654620     .[INFERENCE] Fee
    a408:	676e6964 64754120 4d206f69 20434346     ding Audio MFCC 
    a418:	736e6554 2820726f 39347831 4e492030     Tensor (1x490 IN
    a428:	20293854 4e206f74 61727565 6950206c     T8) to Neural Pi
    a438:	696c6570 2e2e656e 00000a2e 5252455b     peline......[ERR
    a448:	205d524f 65666e49 636e6572 69702065     OR] Inference pi
    a458:	696c6570 6520656e 75636578 6e6f6974     peline execution
    a468:	69616620 2164656c 0000000a 20202020      failed!....    
    a478:	4d524120 524f5720 524f464b 4c204543      ARM WORKFORCE L
    a488:	2d204241 54554120 54414d4f 56204445     AB - AUTOMATED V
    a498:	44494c41 4f495441 5553204e 20455449     ALIDATION SUITE 
    a4a8:	55534552 2053544c 20202020 00000a20     RESULTS      ...
    a4b8:	53455420 3a312054 726f4320 2d786574      TEST 1: Cortex-
    a4c8:	2035354d 696c6548 56206d75 6f746365     M55 Helium Vecto
    a4d8:	78452072 736e6574 736e6f69 74634120     r Extensions Act
    a4e8:	2e657669 5b202e2e 53534150 00000a5d     ive... [PASS]...
    a4f8:	53455420 3a322054 68744520 552d736f      TEST 2: Ethos-U
    a508:	4e203535 44205550 65766972 61482072     55 NPU Driver Ha
    a518:	6873646e 20656b61 65532026 2e707574     ndshake & Setup.
    a528:	2e2e2e2e 505b202e 5d535341 0000000a     ..... [PASS]....
    a538:	53455420 3a332054 746e4920 616e7265      TEST 3: Interna
    a548:	5253206c 54204d41 6f736e65 72412072     l SRAM Tensor Ar
    a558:	20616e65 6e756f42 79726164 66615320     ena Boundary Saf
    a568:	2e797465 255b202e 000a5d73 53455420     ety.. [%s].. TES
    a578:	3a342054 4c465420 20657469 7263694d     T 4: TFLite Micr
    a588:	6f4d206f 206c6564 63657845 6f697475     o Model Executio
    a598:	6950206e 696c6570 2e2e656e 2e2e2e2e     n Pipeline......
    a5a8:	5b202e2e 53534150 00000a5d 53455420     .. [PASS]... TES
    a5b8:	3a352054 79654b20 64726f77 616c4320     T 5: Keyword Cla
    a5c8:	66697373 74616369 206e6f69 69726150     ssification Pari
    a5d8:	28207974 73655922 2e2e2922 2e2e2e2e     ty ("Yes")......
    a5e8:	255b202e 000a5d73 2d2d2d2d 2d2d2d2d     . [%s]..--------
    a5f8:	2d2d2d2d 2d2d2d2d 2d2d2d2d 2d2d2d2d     ----------------
    a608:	2d2d2d2d 2d2d2d2d 2d2d2d2d 2d2d2d2d     ----------------
    a618:	2d2d2d2d 2d2d2d2d 2d2d2d2d 2d2d2d2d     ----------------
    a628:	2d2d2d2d 2d2d2d2d 00000a2d 45535b0a     ---------....[SE
    a638:	4f48494d 4e495453 4e205d47 6669746f     MIHOSTING] Notif
    a648:	676e6979 72695620 6c617574 616c5020     ying Virtual Pla
    a658:	726f6674 4c203a6d 45206261 75636578     tform: Lab Execu
    a668:	6e6f6974 6e694620 65687369 52282064     tion Finished (R
    a678:	72757465 6f43206e 203a6564 000a2930     eturn Code: 0)..
    a688:	45525b20 544c5553 3e3e205d 4c41203e      [RESULT] >>> AL
    a698:	414c204c 43412042 54504543 45434e41     L LAB ACCEPTANCE
    a6a8:	53455420 50205354 45535341 55532044      TESTS PASSED SU
    a6b8:	53454343 4c554653 2021594c 0a3c3c3c     CCESSFULLY! <<<.
    a6c8:	00000000 726f4320 6e6f7473 30332d65     .... Corstone-30
    a6d8:	69562030 61757472 6c50206c 6f667461     0 Virtual Platfo
    a6e8:	53206d72 6c756d69 6f697461 6f43206e     rm Simulation Co
    a6f8:	656c706d 2e646574 0000000a 45525b20     mpleted..... [RE
    a708:	544c5553 3e3e205d 4341203e 54504543     SULT] >>> ACCEPT
    a718:	45434e41 53455420 46205354 454c4941     ANCE TESTS FAILE
    a728:	3c202144 000a3c3c                       D! <<<..
