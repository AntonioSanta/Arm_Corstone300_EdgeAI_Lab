# Arm Corstone-300 & Ethos-U55 Edge AI Makefile
# Target: Cortex-M55 (Armv8.1-M Helium) + Ethos-U55 NPU
# Dual-Target: Simulation (Fast Models FVP / QEMU) vs Physical Silicon (Arm MPS3 FPGA / Alif)

CC      = arm-none-eabi-gcc
OBJCOPY = arm-none-eabi-objcopy
OBJDUMP = arm-none-eabi-objdump
SIZE    = arm-none-eabi-size
PYTHON  = python3

# Target configuration: 'sim' (default) or 'hw'
TARGET_PLATFORM ?= sim

CFLAGS  = -mcpu=cortex-m55 -mthumb -O2 -Wall -Wextra -g \
          -ffunction-sections -fdata-sections -nostdlib -ffreestanding \
          -Isrc -Imodel

ifeq ($(TARGET_PLATFORM),hw)
  CFLAGS  += -DTARGET_HARDWARE=1
  TARGET   = build/firmware_hw.elf
  BIN      = build/firmware_hw.bin
  ASM      = build/firmware_hw.asm
  MAP      = build/firmware_hw.map
else
  CFLAGS  += -DTARGET_SIMULATION=1
  TARGET   = build/firmware.elf
  BIN      = build/firmware.bin
  ASM      = build/firmware.asm
  MAP      = build/firmware.map
endif

LDFLAGS = -mcpu=cortex-m55 -mthumb -nostdlib -T src/corstone300.ld \
          -Wl,--gc-sections \
          -Wl,-Map=$(MAP)

SRCS    = src/startup_cortex_m55.c \
          src/uart_corstone.c \
          src/ethos_u_core.c \
          src/inference_engine.c \
          src/model_data.c \
          src/mfcc_dsp.c \
          src/main.c

# Distinguish object files per target platform
OBJS    = $(patsubst src/%.c, build/%_$(TARGET_PLATFORM).o, $(SRCS))

.PHONY: all model model-fallback clean sim test sim-build hw-build

all: $(TARGET)

sim-build:
	$(MAKE) TARGET_PLATFORM=sim

hw-build:
	$(MAKE) TARGET_PLATFORM=hw

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

build/%_$(TARGET_PLATFORM).o: src/%.c | build
	$(CC) $(CFLAGS) -c $< -o $@

$(TARGET): $(OBJS) src/corstone300.ld
	@echo "--- Linking Cortex-M55 & Ethos-U55 Image [Platform: $(TARGET_PLATFORM)] ---"
	$(CC) $(LDFLAGS) $(OBJS) -o $@
	$(OBJCOPY) -O binary $@ $(BIN)
	$(OBJDUMP) -S $@ > $(ASM)
	@echo "--- Firmware Memory Footprint ($(TARGET)) ---"
	$(SIZE) $@
	@echo "Binary created: $(BIN)"

sim: $(TARGET)
	@echo "--- Launching Corstone-300 Virtual Platform Simulation ---"
	timeout 5s qemu-system-arm -M mps3-an547 -cpu cortex-m55 -display none -serial stdio -semihosting -kernel $(TARGET)

test:
	@echo "--- Running Automated Workforce Lab Test Harness ---"
	$(PYTHON) tests/test_harness.py

clean:
	rm -rf build/*.o build/*.elf build/*.bin build/*.map build/*.asm
