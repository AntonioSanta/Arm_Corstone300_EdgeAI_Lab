# Arm Workforce Development: Secure Edge AI on Arm Corstone-300

Hands-on workshop repository for deploying INT8 Speech Keyword Spotting on the **Arm Corstone-300** reference platform (Cortex-M55 CPU + Ethos-U55 microNPU) using bare-metal C, CMSIS-NN, Arm Vela, and local virtual hardware (Arm Fast Models FVP & QEMU).

---

## 🚀 Quick Start for Attendees (3 Ways to Run)

After cloning the repository:
```bash
git clone https://github.com/AntonioSanta/Arm_Corstone300_EdgeAI_Lab.git
cd Arm_Corstone300_EdgeAI_Lab
```

### Option 1: Instant In-Browser Speech Recognition (0 Setup / Any Laptop)
No compilers, Python, or virtual hardware needed!
1. Double-click or open `slides/index.html` (or `slides/presentation.html`) in Google Chrome or Microsoft Edge.
   *(Or visit the live web link: [https://antoniosanta.github.io/Arm_Corstone300_EdgeAI_Lab/](https://antoniosanta.github.io/Arm_Corstone300_EdgeAI_Lab/))*
2. Press keyboard key **`A`** (or click **"Live Audio Testbench"** in the top navigation).
3. Click **"🎤 Start Live Speech Test"** and say *"Yes"* or *"No"*.
4. The built-in client-side Web Audio DSP extracts 490 INT8 MFCC features and classifies your voice in real time with simulated Corstone-300 cycle metrics!

---

### Option 2: 1-Command Virtual Silicon Acceptance Test (WSL / Ubuntu — 3.5s)
For attendees on Linux or Windows WSL:
```bash
# 1. One-time host package install (if not already installed)
sudo apt update && sudo apt install -y gcc-arm-none-eabi qemu-system-arm python3-pip make
pip install ethos-u-vela==5.2.0

# 2. Run the automated CI acceptance test harness
python3 tests/test_harness.py
```
**What happens in ~3.6 seconds:**
- **Audits toolchain:** Validates `arm-none-eabi-gcc 10.3+`, Vela 5.2.0, and virtual platform executables.
- **Compiles model:** Compiles the authentic Arm ML-Zoo DS-CNN model with Vela for Ethos-U55 (128 MACs/cycle).
- **Links firmware:** Builds the bare-metal C executable `build/firmware.elf`.
- **Boots simulator:** Runs the Corstone-300 virtual platform simulator.
- **Verifies assertions:** Validates 5/5 hardware assertions (108.1x speedup, SRAM budget safety, golden keyword parity).

---

### Option 3: Full Hardware-in-the-Loop Live Voice Test (FVP + Mic)
To stream your real microphone audio straight into the virtual Cortex-M55 & Ethos-U55 silicon:
1. Start the live Python bridge server:
   ```bash
   python3 scripts/live_bridge_server.py
   ```
2. Open `slides/index.html` in your browser. The connection badge in the top-right turns green:
   `🟢 Arm FVP & QEMU Active (127.0.0.1:8080)`.
3. Press **`A`**, speak *"Yes"* or *"No"*. The audio is dynamically ingested into Cortex-M55 internal SRAM via ARM Semihosting (`BKPT 0xAB`), accelerated on Ethos-U55 in 24,650 cycles (0.98 ms), and real APB UART telemetry displays live on your screen!

---

## 📊 Master Acceptance Test Scorecard Output

```text
=================================================================
  ARM WORKFORCE DEVELOPMENT: AUTOMATED TEST HARNESS             
  Target: Corstone-300 (Cortex-M55 + Ethos-U55) & AVH           
=================================================================

>>> [TEST STEP] Pre-Flight Sanity Check...
  [PASS] Host Python Environment             : Python 3.10+
  [PASS] Arm Vela NPU Compiler (Ethos-U)     : FOUND (5.2.0)
  [PASS] Arm GNU Embedded Toolchain (GCC)    : FOUND (arm-none-eabi-gcc 10.3.1)
  [PASS] Arm GNU Toolchain Cortex-M55 Target : SUPPORTED (Armv8.1-M Helium)
  [PASS] Virtual Platform (QEMU Corstone-300): SUPPORTED (mps3-an547 Cortex-M55)
  [PASS] Arm ML-Zoo Model Asset              : FOUND (47,616 bytes)

>>> [TEST STEP] Vela Model Compilation (Ethos-U55)...
  - Total SRAM used:     21.69 KiB (66.1% headroom out of 64 KiB)
  - Total Flash used:    30.52 KiB
  - NPU Operators:       49 (100.0%)
  - Total Workload:      2,664,792 MACs/inference

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
 Corstone-300 Virtual Platform Simulation Completed in 3.69s.
=================================================================
```

---

## 📁 Repository Map

```text
Arm_Corstone300_EdgeAI_Lab/
├── index.html                   # Redirects to slides
├── model/
│   ├── ds_cnn_s_quantized.tflite # Pre-quantized Arm ML-Zoo DS-CNN model
│   └── output_vela/             # Vela command stream & layer metrics
├── src/
│   ├── startup_cortex_m55.c     # Reset vector & IRQ table
│   ├── uart_corstone.c          # APB UART driver (0x49303000)
│   ├── ethos_u_core.c           # Ethos-U55 NPU driver & DMA
│   ├── inference_engine.c       # TFLM / CMSIS-NN dispatch
│   ├── main.c                   # Semihosting audio ingestion & main loop
│   └── corstone300.ld           # Linker script with SRAM budget guards
├── scripts/
│   ├── sanity_check.py          # Pre-flight environment check
│   └── live_bridge_server.py    # REST bridge (browser <-> FVP)
├── tests/
│   └── test_harness.py          # 7-stage CI validation suite
├── slides/
│   ├── index.html               # Presentation deck
│   ├── presentation.html        # Interactive 6-slide deck with mic testbench
│   ├── PRESENTATION_IMPROVED.md # Full transcript with speaker talking points
│   └── corstone300_subsystem_diagram.svg # Interconnect schematic
└── Makefile                     # GNU Make build system
```
