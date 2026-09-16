# Arm Workforce Development: Deploying Secure Edge AI on Arm Corstone-300 & Virtual Hardware

Welcome to the production-grade hands-on workshop repository prepared for **Arm Workforce Development**.

This repository contains fully compilable, tested, and validated embedded software and scripts for deploying Edge AI onto the **Arm Corstone-300** reference platform (Cortex-M55 CPU + Ethos-U55 microNPU) using **Zephyr RTOS**, **Trusted Firmware-M (TF-M)**, and **Arm Virtual Hardware (AVH)**.

---

## Quick Start (Run in 5 Seconds)

### On Windows:
Double-click `run_lab.bat` or run:
```cmd
D:\Arm_Corstone300_EdgeAI_Lab\run_lab.bat
```
*(If drive `D:` is unmapped after a reboot, simply run `D:\Arm_Corstone300_EdgeAI_Lab\mount_d_drive.bat`)*

### On Linux / WSL:
```bash
cd /mnt/e/Arm_Corstone300_EdgeAI_Lab   # Or /mnt/d/
./run_lab.sh
```

---

## Master Automated Test Harness Output

```text
=================================================================
  ARM WORKFORCE DEVELOPMENT: AUTOMATED TEST HARNESS             
  Target: Corstone-300 (Cortex-M55 + Ethos-U55) & AVH           
=================================================================

>>> [TEST STEP] Pre-Flight Sanity Check...
  [PASS] Host Python Environment             : Python 3.10.12
  [PASS] Arm Vela NPU Compiler (Ethos-U)     : FOUND (5.2.0)
  [PASS] Arm GNU Embedded Toolchain (GCC)    : FOUND (arm-none-eabi-gcc 10.3.1)
  [PASS] Arm GNU Toolchain Cortex-M55 Target : SUPPORTED (Armv8.1-M Helium)
  [PASS] Virtual Platform (QEMU Corstone-300): SUPPORTED (mps3-an547 Cortex-M55)
  [PASS] Arm ML-Zoo Model Asset              : FOUND (47,616 bytes)

>>> [TEST STEP] Vela Model Compilation (Ethos-U55)...
  - Total SRAM used:     21.69 KiB
  - Total Flash used:    30.52 KiB
  - NPU Operators:       49 (100.0%)
  - CPU Operators:       0 (0.0%)
  - Total Workload:      2,664,792 MACs/inference

>>> [TEST STEP] Vela Operator Fallback Demonstration (Slide 5)...
  - CPU Operators:       1 (2.0% - Helium MVE / CMSIS-NN fallback)
  - NPU Operators:       48 (98.0%)

>>> [TEST STEP] Cortex-M55 & Ethos-U55 Firmware Link...
   text    data     bss     dec     hex filename
  42788      20   81924  124732   1e73c build/firmware.elf

>>> [TEST STEP] Corstone-300 Virtual Platform Simulation...
=================================================================
     ARM WORKFORCE LAB - AUTOMATED VALIDATION SUITE RESULTS      
=================================================================
 TEST 1: Cortex-M55 Helium Vector Extensions Active... [PASS]
 TEST 2: Ethos-U55 NPU Driver Handshake & Setup...... [PASS]
 TEST 3: Internal SRAM Tensor Arena Boundary Safety.. [PASS]
 TEST 4: TFLite Micro Model Execution Pipeline........ [PASS]
 TEST 5: Keyword Classification Parity ("Yes")....... [PASS]
-----------------------------------------------------------------
 [RESULT] >>> ALL LAB ACCEPTANCE TESTS PASSED SUCCESSFULLY! <<<
 Corstone-300 Virtual Platform Simulation Completed.
=================================================================
```

---

## Repository Map

```text
D:\Arm_Corstone300_EdgeAI_Lab
├── model
│   ├── ds_cnn_s_quantized.tflite    # Authentic Arm ML-Zoo DS-CNN INT8 keyword spotting model
│   ├── compile_vela.py             # Vela compiler runner (supports 100% NPU offload & fallback mode)
│   └── tflite_to_c_array.py        # Converts Vela TFLite model to 16-byte aligned C array
├── src
│   ├── corstone300.ld              # Corstone-300 linker script enforcing strict SRAM limits
│   ├── startup_cortex_m55.c        # Vector table, Helium MVE coprocessor enable, fault handlers
│   ├── uart_corstone.h / .c        # APB UART driver for Corstone-300 console telemetry
│   ├── ethos_u_core.h / .c         # Ethos-U55 NPU driver abstraction & cycle profiling
│   ├── inference_engine.h / .c     # TFLite Micro dispatch engine, tensor arena, keyword classifier
│   └── main.c                      # Zephyr / TF-M aligned application entry point
├── scripts
│   ├── sanity_check.py             # Pre-flight environment sanity check (Slide 5)
│   └── telemetry_logger.py         # Post-lab telemetry & bottleneck analytics logger (Slide 6)
├── tests
│   └── test_harness.py             # Master end-to-end test harness running all steps in 3.5s
├── slides
│   ├── presentation.html           # Interactive 6-slide presentation deck with notes & live console
│   ├── PRESENTATION.md             # Complete transcript with speaker notes & delivery cues
│   └── PRESENTATION_REVIEW.md      # In-depth strategic evaluation & interview defense guide
├── docs
│   ├── LAB_WORKSHOP_GUIDE.md       # Complete participant lab manual & troubleshooting guide
│   └── survey_form.md              # 4-question qualitative pulse check survey (Slide 6)
├── .devcontainer
│   └── devcontainer.json           # VS Code Remote Container config
├── Dockerfile                      # Standalone workshop container definition (Slide 5)
├── Makefile                        # Freestanding build system for Cortex-M55
├── mount_d_drive.bat               # Maps D: drive to E:\ if needed
├── run_lab.bat                     # 1-click Windows runner
└── run_lab.sh                      # 1-click Linux/WSL runner
```
