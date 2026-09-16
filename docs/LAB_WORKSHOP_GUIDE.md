# Hands-On Lab Workshop Guide
## Deploying Secure Edge AI on Arm Corstone-300 & Virtual Hardware
**Arm Workforce Development — Technical Delivery Scenario**

---

### Executive Overview
In this practical workshop, participants act as Edge AI Systems Engineers deploying an optimized, quantized speech recognition model onto the **Arm Corstone-300** reference subsystem. You will leverage the **Arm Cortex-M55** processor (with Helium M-Profile Vector Extension) alongside the **Arm Ethos-U55 microNPU**, orchestrated within a secure **Zephyr RTOS** and **Trusted Firmware-M (TF-M)** architecture, and simulated using **Arm Virtual Hardware (AVH)**.

---

### Architecture at a Glance
```
+-------------------------------------------------------------------------------+
|                     Arm Corstone-300 Subsystem (AVH)                          |
+---------------------------------------+---------------------------------------+
|        Secure Processing (TF-M)       |     Non-Secure Application (Zephyr)   |
|  - PSA Certified Root of Trust        |  - Zephyr RTOS Kernel & Sched         |
|  - Secure Cryptographic Storage       |  - TensorFlow Lite Micro Dispatcher   |
|  - Memory Partitioning / Protection   |  - CMSIS-NN Operator Kernels          |
+---------------------------------------+---------------------------------------+
|   Cortex-M55 (Armv8.1-M + Helium MVE) |      Ethos-U55 microNPU (128 MACs)    |
|   * Vector MFCC Preprocessing         |      * Depthwise & Standard Conv2D    |
|   * Fallback Activation Kernels       |      * Direct SRAM DMA Stream         |
+---------------------------------------+---------------------------------------+
|  Internal SRAM (ISRAM): 4MB Shared Arena  |  Flash Memory: 4MB Weights / Code |
+-------------------------------------------------------------------------------+
```

---

### Hands-on Lab Journey: 4 Key Milestones

#### Step 01: Model Quantization & Vela Compilation
1. Examine the baseline Keyword Spotting model:
   ```bash
   ls -lh model/ds_cnn_s_quantized.tflite
   ```
2. Invoke the Arm Vela compiler to optimize the graph for Ethos-U55:
   ```bash
   python3 model/compile_vela.py --accelerator ethos-u55-128
   ```
   * Key Observation: Notice how Vela partitions operators:
     - NPU Operators: Conv2D, Relu, DepthwiseConv2D, AvgPool, FullyConnected
     - SRAM Footprint: ~21.69 KiB
     - Flash Footprint: ~30.52 KiB
     - Hardware Workload: 2,664,792 MACs/batch

3. [Optional Challenge]: Demonstrate CPU fallback mitigation:
   ```bash
   python3 model/compile_vela.py --fallback-mode
   ```
   Observe that unsupported or ignored operators automatically route to Cortex-M55 Helium/CMSIS-NN!

#### Step 02: Firmware Integration & Memory Boundaries
1. Convert the compiled Vela model into an aligned C byte array:
   ```bash
   python3 model/tflite_to_c_array.py
   ```
2. Inspect `src/corstone300.ld`:
   - Verify that `.sram.tensor_arena` is mapped to Corstone-300 Internal SRAM (`0x21000000`).
   - Observe the linker assertion enforcing strict 64 KiB boundary limits to prevent internal SRAM overflow.
3. Build the firmware image:
   ```bash
   make
   ```

#### Step 03: Virtual Hardware Deployment & Headless Execution
1. Deploy the firmware to the Corstone-300 virtual platform:
   ```bash
   make sim
   ```
2. When deploying on Arm Corstone-300 Fixed Virtual Platform (FVP) in cloud/headless environments, apply the mitigation switch:
   ```bash
   FVP_Corstone_SSE-300_Ethos-U55 -C disable-visualisation=1 -a build/firmware.elf
   ```

#### Step 04: Performance Profiling & Acceptance Validation
Inspect the automated profiling output on your terminal:
- **Cycle Latency:** ~26,500 total cycles (sub-millisecond execution @ 25-500 MHz)
- **SRAM Allocation:** 22,210 bytes consumed within the 65,536-byte arena
- **Classification Result:** Keyword `"Yes"` detected with high confidence INT8 score (+118)
- **Golden Parity:** 100% match against pre-trained reference vectors

---

### Live Troubleshooting Matrix (Quick Reference)

| Symptom / Error | Root Cause | Solution / Mitigation |
| :--- | :--- | :--- |
| `FVP Fatal: Cannot open X11 display` | Headless cloud container missing GUI | Pass `-C disable-visualisation=1` to force terminal console mode. |
| `Vela Error: Operator not supported on Ethos-U` | Non-quantized FP32 or custom operator | Use CMSIS-NN fallback or pass `--ignore-ops` to route to Cortex-M55 CPU. |
| `Linker Error: Section .sram.tensor_arena overflows` | Activation arena exceeds physical SRAM | Adjust Vela memory mode to `--memory-mode Shared_Sram` or optimize model resolution. |
| `HardFault at Reset_Handler` | FPU / Helium MVE coprocessors disabled | Set bits 20-23 in `SCB->CPACR` to `0xF` before issuing vector instructions. |

---

### Automated Verification
Run the master test harness to execute all validation steps automatically:
```bash
python3 tests/test_harness.py
```
Check the telemetry output in `build/telemetry_report.json`.
