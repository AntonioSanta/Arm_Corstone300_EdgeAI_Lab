# Arm Corstone-300 & Ethos-U55 Edge AI Makefile
# Target: Cortex-M55 (Armv8.1-M Helium) + Ethos-U55 NPU
# Virtual Platform: Arm Corstone-300 FVP / QEMU mps3-an547

CC      = arm-none-eabi-gcc
OBJCOPY = arm-none-eabi-objcopy
OBJDUMP = arm-none-eabi-objdump
SIZE    = arm-none-eabi-size
PYTHON  = python3

CFLAGS  = -mcpu=cortex-m55 -mthumb -O2 -Wall -Wextra -g \
          -ffunction-sections -fdata-sections -nostdlib -ffreestanding \
          -Isrc -Imodel

LDFLAGS = -mcpu=cortex-m55 -mthumb -nostdlib -T src/corstone300.ld \
          -Wl,--gc-sections \
          -Wl,-Map=build/firmware.map

SRCS    = src/startup_cortex_m55.c \
          src/uart_corstone.c \
          src/ethos_u_core.c \
          src/inference_engine.c \
          src/model_data.c \
          src/main.c

OBJS    = $(patsubst src/%.c, build/%.o, $(SRCS))

TARGET  = build/firmware.elf
BIN     = build/firmware.bin
ASM     = build/firmware.asm

.PHONY: all model model-fallback clean sim test

all: $(TARGET)

model:
	@echo "--- [Step 01] Quantizing & Compiling TFLite Model with Vela for Ethos-U55 ---"
	$(PYTHON) model/compile_vela.py
	$(PYTHON) model/tflite_to_c_array.py

model-fallback:
	@echo "--- [Slide 5 Mitigation] Compiling Model with CPU Fallback Operators ---"
	$(PYTHON) model/compile_vela.py --fallback-mode
	$(PYTHON) model/tflite_to_c_array.py

build:
	mkdir -p build

build/%.o: src/%.c | build
	$(CC) $(CFLAGS) -c $< -o $@

$(TARGET): $(OBJS) src/corstone300.ld
	@echo "--- [Step 02] Linking Cortex-M55 & Ethos-U55 Firmware Image ---"
	$(CC) $(LDFLAGS) $(OBJS) -o $@
	$(OBJCOPY) -O binary $@ $(BIN)
	$(OBJDUMP) -S $@ > $(ASM)
	@echo "--- Firmware Memory Footprint ---"
	$(SIZE) $@

sim: $(TARGET)
	@echo "--- [Step 03] Launching Corstone-300 Virtual Platform Simulation ---"
	timeout 5s qemu-system-arm -M mps3-an547 -cpu cortex-m55 -display none -serial stdio -semihosting -kernel $(TARGET)

test:
	@echo "--- Running Automated Workforce Lab Test Harness ---"
	$(PYTHON) tests/test_harness.py

clean:
	rm -rf build/*.o build/*.elf build/*.bin build/*.map build/*.asm
