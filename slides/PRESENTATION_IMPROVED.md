# Edge AI Speech Recognition on Arm Corstone-300
**Arm Workforce Development — Curriculum & Hands-On Technical Lab Scenario**
*Updated & Grounded Presentation Deck for Technical Delivery & Self-Guided Learners*

---

## Slide 1: Lab Mission & Target Platform

### On-Slide Content:
* **Header Tag:** ARM WORKFORCE DEVELOPMENT &bull; TECHNICAL LAB SCENARIO
* **Title:** Edge AI Speech Recognition on Arm Corstone-300
* **Subtitle:** A practical, hands-on lab: Model compilation with Vela, bare-metal Cortex-M55 & Ethos-U55 NPU co-design, and real-time voice inference on local virtual platforms.
* **Lab Mission:** *Bridging the Embedded AI Skills Gap: Empowering engineers to optimize neural networks with Arm Vela, enforce strict SRAM memory boundaries, and validate live keyword spotting on local cycle-approximate virtual hardware.*
* **Architectural & Lab Triad:**
  - **Target Hardware:** Cortex-M55 (Armv8.1-M Helium MVE) & Ethos-U55 microNPU (128 MACs/cycle)
  - **AI Workload:** DS-CNN Speech Keyword Spotting (INT8 Quantized, 2.66M MACs)
  - **Execution Engines:** Local Arm Fast Models FVP & QEMU (No cloud subscription needed)
  - **Software & Toolchain:** Bare-Metal C Runtime, GNU Make, `arm-none-eabi-gcc`, CMSIS-NN

### Speaker Talking Points (Your Script):
> *"Good morning / afternoon members of the panel. Today I am presenting a hands-on technical lab scenario: **Edge AI Speech Recognition on Arm Corstone-300**.*
>
> *Rather than presenting an abstract deployment pitch, this lab is a concrete, reproducible engineering test. We focus on a real-world edge AI task: speech keyword spotting using an INT8-quantized Depthwise Separable Convolutional Neural Network (DS-CNN).*
>
> *We walk learners through the entire silicon bring-up cycle—optimizing graph operators with the Arm Vela compiler, enforcing memory safety in bare-metal C with linker guards, and executing the workload on local cycle-approximate virtual hardware using both the official Arm Fast Models FVP and QEMU. Everything runs natively on the learner's workstation with zero cloud subscription fees or physical board logistics friction."*

---

## Slide 2: Arm Corstone-300 Subsystem & Dual-AXI microNPU Architecture

### On-Slide Content:
* **Header Tag:** HARDWARE CO-DESIGN &bull; BUS MATRIX &amp; MEMORY TOPOLOGY
* **Title:** Arm Corstone-300 Subsystem & Dual-AXI microNPU Architecture
* **Subtitle:** *Silicon-level topology: Multi-layer 64-bit AXI5 crossbar with autonomous dual-channel DMA weight & activation streaming.*
* **Visual Schematic:** *Embedded Silicon Interconnect & Bus Matrix Diagram showing Cortex-M55, Ethos-U55 Dual-AXI master ports (M0 Flash read, M1 SRAM R/W), AXI5 crossbar, Flash, SRAM (64 KiB Tensor Arena), and CMSDK APB UART.*
* **Core Pillars:**
  1. **Compute Co-Design:**
     - **Cortex-M55 CPU with Helium MVE:** Vector-accelerated DSP processing raw 16 kHz audio into Mel-Frequency Cepstral Coefficients (MFCC), plus CPU fallback for non-NPU operators.
     - **Ethos-U55 microNPU:** Dedicated 128 MACs/cycle matrix engine executing dense convolutions.
  2. **Dual-AXI Master DMA:**
     - **Port M0 (Read-Only Flash):** Dedicated to streaming pre-compiled Vela command streams and quantized INT8 weights (`0x00000000`).
     - **Port M1 (Read/Write SRAM):** Dedicated high-speed DMA reading of input feature maps and writing intermediate layer activations into internal SRAM (`0x21010000`).
     - *Simultaneous Fetch & Write:* Eliminates memory bus arbitration stalls between weights and activations.
  3. **Memory & TrustZone:**
     - **Internal Shared SRAM (`0x21000000`):** Linker-partitioned 64 KiB Tensor Arena.
     - **Memory Protection Controllers (MPC):** Bus-level hardware checking; unauthorized NPU DMA writes trigger an immediate `SecureFault`.
* **Hardware Interconnect Insight:** The 64-bit multi-layer AXI5 crossbar allows the CPU and NPU to access separate memory banks concurrently without bus contention.

### Speaker Talking Points (Your Script):
> *"In Slide 2, we examine the underlying silicon architecture that makes this workload viable on a microcontroller.*
>
> *Looking at our embedded interconnect diagram, you can see how the chip is partitioned. A central question in embedded AI is: 'If we have an Ethos-U NPU, why do we need Helium vector extensions on the Cortex-M55?' The answer is the audio signal chain: raw microphone audio must first be windowed, transformed with an FFT, and passed through Mel filterbanks. Helium MVE vectorizes this DSP preprocessing, preventing the CPU from becoming the bottleneck before tensors ever reach the NPU.*
>
> *Crucially, notice the Ethos-U55 bus connections: it is not a passive peripheral. It is an autonomous AXI bus master with **two independent 64-bit AXI ports**: Port M0 streams model weights from Flash, while Port M1 writes activation scratchpads into SRAM simultaneously. This dual-master architecture over a multi-layer AXI5 crossbar ensures the NPU compute units never stall waiting on bus arbitration."*

---

## Slide 3: Live Speech to Virtual Silicon: Experiment Logic Flow

### On-Slide Content:
* **Header Tag:** LIVE DEMONSTRATION ARCHITECTURE &bull; HARDWARE-IN-THE-LOOP TESTBENCH
* **Title:** Live Speech to Virtual Silicon: Experiment Sequence Flow
* **Subtitle:** *Simplified logical sequence tracing microphone capture, REST transport, and neural execution on virtual hardware.*
* **3-Phase Conceptual Breadcrumb Flow:**
  - **Phase 1: Audio DSP Preprocessing** — Web Audio API records 16 kHz PCM ➔ 490 INT8 MFCC tensor.
  - **Phase 2: Semihosting DMA Ingestion** — Cortex-M55 executes `BKPT 0xAB` ➔ pulls `live_tensor.bin` into SRAM Arena (`0x21010000`).
  - **Phase 3: Silicon Acceleration** — Ethos-U55 executes 24.6k cycles ➔ APB UART telemetry stream to UI.
* **Visual Schematic:** *Interactive Visual Sequence Diagram with 5 lifelines and 7 sequential data flow arrows (Browser → Python Bridge → Cortex-M55 CPU → Ethos-U55 NPU → UART & Telemetry → Browser UI).*
* **The 5-Actor Architecture & Sequence Flow:**
  1. **Web Browser (HTML5 Web Audio & DSP):** Captures 1-second 16 kHz PCM microphone audio and computes 40-band Mel-Scale Filterbanks + DCT into a 490-byte INT8 MFCC spectrogram.
  2. **Python Bridge Server (`scripts/live_bridge_server.py` on Port 8080):** Receives HTTP POST `/predict`, writes `build/live_tensor.bin`, and launches the Corstone-300 Fast Models FVP.
  3. **Cortex-M55 CPU (Host Controller / `firmware.elf`):** The master processor boots `firmware.elf`, executes Semihosting trap (`BKPT 0xAB`) to load `live_tensor.bin` directly into the SRAM Tensor Arena (`0x21010000`), emulating physical DMA ingestion.
  4. **Ethos-U55 microNPU (Hardware Neural Co-Processor):** Cortex-M55 configures and dispatches the compiled neural model command stream across the 64-bit AXI bus. Ethos-U executes 49/49 convolution layers in 24,650 cycles and signals completion back to Cortex-M55.
  5. **UART & UI Telemetry:** Cortex-M55 prints classification ("Yes", "No", "Silence") and cycle metrics to CMSDK APB UART (`0x49303000`). Bridge server forwards results as SSE/JSON back to the Browser UI.
* **Interactive Live Mic Prompt:** Press `M` or click "Live Mic Test" to record live audio from your microphone!

### Speaker Talking Points (Your Script):
> *"Slide 3 illustrates the complete end-to-end experiment architecture. Notice how the flow is partitioned into three distinct phases across the top breadcrumb bar.*
>
> *In Phase 1, when I speak into the browser, the Web Audio DSP pipeline converts the speech into a 490-byte INT8 MFCC spectrogram and sends it to our local Python bridge.*
>
> *In Phase 2, the bridge writes `live_tensor.bin` and boots the Arm Corstone-300 simulator. And here is the crucial embedded design point: **the Cortex-M55 CPU is the host brain of the chip**. The Cortex-M55 firmware boots, executes an Arm Semihosting trap (`BKPT 0xAB`), and ingests the audio tensor directly into its internal SRAM Arena at `0x21010000`—exactly emulating how physical DMA transfers I2S/PDM digital microphone data without requiring any code recompilation.*
>
> *In Phase 3, once the input tensor is sitting in SRAM, the Cortex-M55 dispatches the neural model command stream to the **Ethos-U55 NPU** over the 64-bit AXI bus. The Ethos-U55 executes all matrix multiplications in just 24,650 cycles and interrupts the Cortex-M55.*
>
> *Finally, the Cortex-M55 reads the predictions, formats the output, and transmits it over the APB UART console at `0x49303000`, which our bridge captures and presents live on the screen."*

---

## Slide 4: Operative Lab Guide (Part 1) — Setup, Online Sources & Build Pipeline

### On-Slide Content:
* **Header Tag:** OPERATIVE LAB GUIDE (PART 1) &bull; SETUP, SOURCES &amp; REPOSITORY LAYOUT
* **Title:** Operative Lab Guide (Part 1) — Setup, Online Sources &amp; Build Pipeline
* **Subtitle:** *Where to obtain models and tooling, repository layout, operations pipeline, and step-by-step firmware build.*
* **Prerequisites Strip:** Target: Arm Corstone-300 (MPS3-AN547) | OS: Ubuntu 20.04+ / WSL2 | Toolchain: `arm-none-eabi-gcc 10.3+` | Python: 3.8+ | Compiler: Arm Vela 5.2.0 | Simulators: Arm FVP & QEMU.
* **Official Online Sources & Software Downloads Hub:**
  - **Lab Git Repository (Complete Source & Slides):** [`https://github.com/AntonioSanta/Arm_Corstone300_EdgeAI_Lab`](https://github.com/AntonioSanta/Arm_Corstone300_EdgeAI_Lab) (All bare-metal C drivers, Python bridge, test harness, pre-quantized model, and presentation slides)
  - **Pre-Trained Neural Network (Arm ML-Zoo):** [`https://github.com/ARM-software/ML-zoo`](https://github.com/ARM-software/ML-zoo) (DS-CNN Small INT8 model for keyword spotting)
  - **Arm Corstone-300 FVP (Virtual Hardware):** [`https://developer.arm.com/downloads/-/arm-ecosystem-fvps`](https://developer.arm.com/downloads/-/arm-ecosystem-fvps) (Official free cycle-approximate simulator: `FVP_Corstone_SSE-300_Ethos-U55`)
  - **Arm GNU Embedded Toolchain:** [`https://developer.arm.com/downloads/-/arm-gnu-toolchain-downloads`](https://developer.arm.com/downloads/-/arm-gnu-toolchain-downloads) (`arm-none-eabi-gcc 10.3+` / `sudo apt install gcc-arm-none-eabi`)
  - **Arm Vela NPU Compiler:** [`https://pypi.org/project/ethos-u-vela/`](https://pypi.org/project/ethos-u-vela/) (`pip install ethos-u-vela==5.2.0`)
  - **QEMU Machine Emulator:** [`https://www.qemu.org/download/`](https://www.qemu.org/download/) (`sudo apt install qemu-system-arm`)
* **Attendee Fast Clone Bar (Run on Your Laptop):**
  ```bash
  git clone https://github.com/AntonioSanta/Arm_Corstone300_EdgeAI_Lab.git && cd Arm_Corstone300_EdgeAI_Lab
  ```
  *💡 Zero-Install Test: Open `slides/presentation.html` in browser & press key **A**!*
* **Operations Pipeline Flowchart (Visual Diagram):**
  - `[1. Pre-Flight Audit]` ➔ `[2. Vela Model Compiler]` ➔ `[3. GCC Firmware Link]` ➔ `[4. FVP Test Harness]` ➔ `[5. Live Voice Testbench]`
* **Repository Source Tree:**
  ```text
  Arm_Corstone300_EdgeAI_Lab/
  ├── model/
  │   ├── ds_cnn_s_quantized.tflite   # Arm ML-Zoo KWS Model (Bundled in repo)
  │   └── output_vela/                # Vela command stream & CSV
  ├── src/
  │   ├── startup_cortex_m55.c        # Reset vector & IRQs
  │   ├── uart_corstone.c             # APB UART driver (0x49303000)
  │   ├── ethos_u_core.c              # Ethos-U55 NPU driver & DMA
  │   ├── inference_engine.c          # TFLM / CMSIS-NN dispatch
  │   ├── main.c                      # Semihosting & test harness
  │   └── corstone300.ld              # Linker script & SRAM guards
  ├── scripts/
  │   ├── sanity_check.py             # Pre-flight environment check
  │   └── live_bridge_server.py       # REST bridge (browser <-> FVP)
  ├── tests/
  │   └── test_harness.py             # 7-stage automated validation
  ├── slides/                         # Web presentation & mic demo
  └── Makefile                        # GNU Make build system
  ```
* **The 5 Step-by-Step Operative Commands (with 1-Click Copy & IO Badges):**
  1. `python3 scripts/sanity_check.py` — [IN: Host OS & Python 3.8+ / OUT: System Audit PASS]. Audits GNU Arm GCC 10.3+, Vela 5.2.0, FVP binary, and QEMU.
  2. `vela model/ds_cnn_s_quantized.tflite --accelerator-config ethos-u55-128 --output-dir model/output_vela` — [IN: `model/ds_cnn_s_quantized.tflite` / OUT: `model/output_vela/` (30.5 KB)]. Uses the pre-packaged Arm ML-Zoo reference model; compiles 49/49 ops for Ethos-U55 (21.7 KiB SRAM arena, 30.5 KiB Flash).
  3. `make clean && make` — [IN: `src/*.c` & `corstone300.ld` / OUT: `build/firmware.elf`]. Compiles target firmware with `arm-none-eabi-gcc`. Produces `build/firmware.elf` (text: 43.3 KB, BSS: 82.4 KB) loaded into virtual Flash memory.
  4. `python3 tests/test_harness.py` — [IN: `build/firmware.elf` / OUT: 5/5 Hardware UART Assertions]. Automated CI test runner: launches the Arm FVP simulator with `build/firmware.elf`, executes inference, and validates 5/5 hardware assertions in ~3.6s.
  5. `python3 scripts/live_bridge_server.py` — [IN: Browser Mic (16 kHz PCM) / OUT: Live Dual FVP & QEMU Telemetry]. Starts the live audio bridge on port 8080: dynamically feeds browser mic audio to `build/firmware.elf` running in FVP and QEMU via semihosting audio ingestion. *(From Windows PowerShell: `wsl -d Ubuntu-22.04 -- bash -c "cd /mnt/e/Arm_Corstone300_EdgeAI_Lab && python3 scripts/live_bridge_server.py"` or double-click `start_live_bridge.bat`)*.

### Speaker Talking Points (Your Script):
> *"Slide 4 provides the complete setup blueprint for anyone approaching this lab for the first time.*
>
> *Notice our Online Sources & Downloads Hub at the top: the very first entry is the **Lab Git Repository** on GitHub (`https://github.com/AntonioSanta/Arm_Corstone300_EdgeAI_Lab.git`). With a single `git clone`, attendees receive the entire codebase—bare-metal C drivers, linker scripts, Python bridge utilities, pre-quantized DS-CNN model, and the interactive slide deck itself.*
>
> *We also link directly to the upstream official sources: the Arm ML-Zoo repository, the Arm Developer portal for the Corstone-300 Fast Models FVP and GNU toolchain, PyPI for Vela, and QEMU. Nothing is proprietary or locked behind enterprise paywalls.*
>
> *The 5 sequential build commands take learners step-by-step from pre-flight sanity checks to compiling the neural model with Vela and producing `build/firmware.elf` with GNU Make.*
>
> *Now let's proceed to Slide 5 to see how anyone in the audience can run the speech recognition test on their own laptop."*

---

## Slide 5: Operative Lab Guide (Part 2) — Console Demonstration Playbook & Facilitator Notes

### On-Slide Content:
* **Header Tag:** OPERATIVE LAB GUIDE (PART 2) &bull; CONSOLE PLAYBOOK &amp; FACILITATOR MATRIX
* **Title:** Console Demonstration Playbook &amp; Facilitator Troubleshooting Matrix
* **Subtitle:** *Concrete console execution options for evaluators, reproducible local strategy, and common embedded mitigations.*
* **Host Setup & Environment Strip:**
  - **Attendee Git Clone & Enter:** `git clone https://github.com/AntonioSanta/Arm_Corstone300_EdgeAI_Lab.git && cd Arm_Corstone300_EdgeAI_Lab`
  - **One-Time Host Package Install:** `sudo apt update && sudo apt install -y gcc-arm-none-eabi qemu-system-arm python3-pip make && pip install ethos-u-vela==5.2.0`
* **Attendee Laptop Playbook (2 Ways to Run):**
  - **Mode 1: Instant In-Browser Speech Recognition (Zero Installs):** Open `slides/presentation.html` in Chrome or Edge, press key **A** (or click "Live Audio Testbench"), speak *"Yes"* or *"No"*, and watch real-time keyword spotting with client-side Web Audio DSP!
  - **Mode 2: Full Virtual Silicon Testbench (WSL / Linux):** Clone the repo and execute Option A or Option C below.
* **Live Console Demonstration Playbook (The 3 Evaluator Options):**
  - **Option A: The "All-in-One" Acceptance Demo (Recommended — 3.5s):**
    ```bash
    python3 tests/test_harness.py
    ```
    *Executes full CI: Vela compilation, GCC link, boots official Arm Corstone-300 FVP, prints UART telemetry, and validates 5/5 hardware assertions.*
  - **Option B: Step-by-Step Developer Workflow & Direct Simulator Launch:**
    ```bash
    # 1. Pre-flight check & firmware build
    python3 scripts/sanity_check.py && make clean && make

    # 2. Run directly on Official Arm Corstone-300 FVP
    FVP_Corstone_SSE-300_Ethos-U55 \
      -a build/firmware.elf \
      -C mps3_board.visualisation.disable-visualisation=1 \
      -C cpu0.semihosting-enable=1 \
      -C mps3_board.uart0.out_file=- \
      -C mps3_board.uart0.unbuffered_output=1 \
      --timelimit 10

    # 3. (Alternative) Run on QEMU Corstone-300
    qemu-system-arm -M mps3-an547 -cpu cortex-m55 -display none -serial stdio -semihosting -kernel build/firmware.elf
    ```
  - **Option C: Live Browser Voice Testbench Bridge:**
    ```bash
    # Inside WSL / Linux:
    python3 scripts/live_bridge_server.py

    # From Windows PowerShell / CMD:
    wsl -d Ubuntu-22.04 -- bash -c "cd /mnt/e/Arm_Corstone300_EdgeAI_Lab && python3 scripts/live_bridge_server.py"
    ```
    *Starts REST bridge on port 8080 (or double-click `start_live_bridge.bat` in Windows); press key **A** in browser to record live voice ("Yes"/"No") and stream to virtual silicon.*
* **Pillar 1: Reproducible Local Setup Strategy:**
  - **Native Local Execution (No Docker / Cloud):** Runs directly in Linux or Windows WSL with standard packages (`arm-none-eabi-gcc`, Python 3). Eliminates container hypervisor overhead, Docker VPN permission issues, and AWS cloud bills.
  - **ARM Semihosting Dynamic Ingestion:** In virtual hardware, `bkpt 0xab` semihosting ingests dynamic live audio into SRAM without needing to recompile `firmware.elf` on every spoken word.
  - **Automated Pre-Flight Sanity Script:** Single command (`python3 scripts/sanity_check.py`) audits toolchain binaries and simulator executables before exercises start.
* **Pillar 2: Expected Technical Mitigations:**
  - **FVP Launch Headless Errors:** Force terminal-only execution to prevent X11 GUI window crashes in headless environments:
    `-C disable-visualisation=1 -C cpu0.semihosting-enable=1`
  - **Vela Operator Fallbacks:** Route unsupported operations (e.g., custom activations) to Cortex-M55 Helium MVE via CMSIS-NN:
    `--ignore-ops FULLY_CONNECTED`
  - **Memory Region Overflow:** Hard compile-time safety check guarding against SRAM buffer overflow:
    `ASSERT((__tensor_arena_end - __tensor_arena_start) <= 0x10000)`

### Speaker Talking Points (Your Script):
> *"Slide 5 is the console execution playbook and troubleshooting guide.*
>
> *For participants attending today's presentation who want to follow along on their own laptops, there are two distinct ways to run:*
> * *If you want an **instant, zero-install experience**, simply open `slides/presentation.html` in Chrome or Edge, hit key **A**, and speak 'Yes' or 'No'. Our presentation includes a built-in client-side Web Audio DSP engine that performs Mel-frequency extraction and keyword classification right inside your browser.*
> * *If you want the **full virtual silicon experience** with the official Arm Corstone-300 FVP, clone the repository, run the one-line package setup, and execute **Option A** (`python3 tests/test_harness.py`). In 3.5 seconds, it will compile the model, link the firmware, boot the virtual FVP platform, and assert that all 5 hardware metrics PASS.*
> * *If you want to bridge your live microphone into the virtual silicon, launch **Option C** (`python3 scripts/live_bridge_server.py`) on port 8080. Every spoken word is dynamically loaded into Cortex-M55 SRAM via ARM semihosting and accelerated on Ethos-U55 in under 1 millisecond.*
>
> *At the bottom, we document the facilitator's local strategy—native execution without Docker friction, semihosting dynamic memory ingestion—and the three crucial mitigations: headless FVP flags, Vela CMSIS-NN fallbacks, and compile-time SRAM linker assertions."*

---

## Slide 6: Hardware Performance Profiling & Acceptance Scorecard

### On-Slide Content:
* **Header Tag:** BENCHMARKING &amp; VERIFICATION &bull; REAL HARDWARE TELEMETRY
* **Title:** Hardware Performance Profiling & Acceptance Scorecard
* **Subtitle:** *Measured cycle latency, SRAM memory safety, and 100% automated acceptance test suite results.*
* **Visual Benchmarks & Telemetry:**
  - **Inference Latency & Cycle Benchmark:**
    - Cortex-M55 CPU Baseline: 2,664,792 cycles (106.6 ms @ 25 MHz)
    - Ethos-U55 microNPU Acceleration: **24,650 cycles (0.98 ms @ 25 MHz, <0.1 ms @ 500 MHz)**
    - **Speedup: 108.1x faster execution (99.07% cycle reduction)**
  - **Internal SRAM Arena Budget:**
    - Consumed: 22,210 bytes (21.7 KiB) out of 65,536 bytes (64 KiB boundary)
    - Safety Margin: **66.1% headroom remaining**
    - Flash Footprint: 30.5 KiB Vela clustered weights

* **Direct Head-to-Head Hardware Performance Comparison (Cortex-M55 Alone vs. Cortex-M55 + Ethos-U55 NPU):**
  | Architectural Dimension | Cortex-M55 Alone (Helium + CMSIS-NN) | Cortex-M55 + Ethos-U55 NPU (Vela) | Hardware Advantage & Impact |
  | :--- | :--- | :--- | :--- |
  | **Inference Cycles** | `2,664,792 cycles` | `24,650 cycles` | **108.1x Speedup** (-99.07% cycle reduction) |
  | **Latency @ 25 MHz (FVP Reference)** | `106.59 ms` | `0.986 ms` (< 1 ms) | **105.6 ms Saved** (Sub-millisecond real-time response) |
  | **Latency @ 500 MHz (Silicon Clock)** | `5.33 ms` | `0.049 ms` (49.3 &mu;s) | **Instantaneous Keyword Detection** |
  | **Compute Parallelism (MAC Density)** | `~4 MACs/cycle` (128-bit Helium SIMD) | `128 MACs/cycle` (Tensor Engine) | **32x Higher MAC Density per Cycle** |
  | **Interconnect & Bus Contention** | Single Master (Bus contention for code/data) | Dual-AXI Master (M0 Flash Read + M1 SRAM R/W) | **Zero Bus Stalls** (Concurrent DMA streaming) |
  | **CPU Utilization & Active Energy** | **100% CPU Saturated** for 106.6 ms (High drain) | **< 1% CPU Active** (CPU enters `WFI` sleep; NPU gated) | **> 99% Active Energy Savings** |
  | **Real-Time Speech Audio Viability** | **FAILED OVERRUN:** 106.6 ms > 100 ms frame stride | **GUARANTEED REAL-TIME:** Consumes <1% of frame window | **Zero Dropped Audio;** 99.0 ms free for DSP / network |

* **Automated Test Scorecard (5/5 PASS):**
  - Test 1: M55 Helium Vector Extensions Active [PASS]
  - Test 2: Ethos-U55 NPU Driver Handshake & Setup [PASS]
  - Test 3: Internal SRAM Boundary Safety [PASS]
  - Test 4: TFLite Micro Execution Pipeline [PASS]
  - Test 5: Keyword Classification Parity ("Yes" / "No" / "Silence") [PASS]
* **Stage Durations:** Total lab run time ~3.69s (Sanity: 0.70s, Vela: 0.70s, Firmware Link: 0.71s, FVP Sim: 1.34s).

### Speaker Talking Points (Your Script):
> *"Slide 6 concludes our presentation with concrete hardware profiling data and our final acceptance scorecard.*
>
> *Looking at our direct head-to-head comparison: running this 2.66 million MAC neural network on the Cortex-M55 CPU alone requires **2,664,792 cycles**, taking **106.6 milliseconds** at 25 MHz. Because audio frames arrive every 100 ms, CPU-only inference causes a fatal buffer overrun—it is physically impossible to keep up in real time.*
>
> *With the Ethos-U55 microNPU enabled, inference collapses to **24,650 cycles**—just **0.98 milliseconds**. That is an authentic **108.1x speedup**, saving 105.6 ms per inference.*
>
> *Because the NPU handles the convolutions autonomously via its Dual-AXI DMA ports, the Cortex-M55 CPU remains active for less than 1% of the time, slashing active energy by over 99% and leaving 99 milliseconds of headroom per frame for application tasks.*
>
> *Finally, our memory gauge confirms that the entire tensor arena occupies just 21.7 KiB of our 64 KiB SRAM budget, and our automated acceptance test harness validates 5 out of 5 hardware assertions with 100% golden keyword parity.*
>
> *Thank you, and I look forward to taking your questions or demonstrating any part of the console playbook live."*

## Appendix: Technical Acronyms & Terminology Reference

*Accessible in the HTML Presentation deck via the top-bar button `📖 Glossary (G)` or by pressing keyboard key `G` from any slide.*

| Acronym | Full Form | Domain / Category | Context & Role in this Lab |
| :--- | :--- | :--- | :--- |
| **FVP** | **Fixed Virtual Platform** | Virtual Simulation | Arm's cycle-approximate, pre-configured software model (`FVP_Corstone_SSE-300_Ethos-U55`). Simulates the complete Corstone-300 SoC locally without physical silicon. |
| **AVH** | **Arm Virtual Hardware** | Cloud & Simulation Ecosystem | Arm's umbrella platform and technology suite offering virtual targets (Corstone-300, Cortex-M, Ethos-U) for cloud CI/CD and automated firmware testing. |
| **NPU** | **Neural Processing Unit** | Specialized Hardware IP | Dedicated ML acceleration core (Arm Ethos-U55) configured with 128 MACs/cycle for high-throughput, low-power INT8 convolution inference. |
| **MVE** | **M-Profile Vector Extension** | CPU Architecture IP | Arm Helium vector processing extension inside the Cortex-M55 CPU. Accelerates 128-bit SIMD DSP audio preprocessing (FFT, Mel filterbanks, MFCC). |
| **AXI** | **Advanced eXtensible Interface** | On-Chip Bus Interconnect | Arm AMBA high-performance multi-layer 64-bit interconnect crossbar. Ethos-U55 features Dual-AXI master ports: M0 (Flash weight read) & M1 (SRAM activation R/W). |
| **APB** | **Advanced Peripheral Bus** | Peripheral Interconnect | Lower-power AMBA bus used for control registers and peripheral communication, connecting UART0 at base `0x49303000` for test log capture. |
| **QEMU** | **Quick EMUlator** | Emulation Tooling | Fast open-source machine emulator (`-M mps3-an547 -cpu cortex-m55`) used for rapid instruction-accurate emulation, functional testing, and MVE debugging. |
| **TFLM** | **TensorFlow Lite for Microcontrollers** | Embedded ML Runtime | Google & Arm's lightweight C++ runtime designed to run quantized neural network models within bare-metal microcontrollers without dynamic heap allocation. |
| **CMSIS-NN** | **Cortex Microcontroller Software Interface Standard &ndash; Neural Network** | Optimized Compute Kernels | Arm-optimized DSP and vector assembly kernels tuned for Cortex-M processors with Helium (MVE) vector instructions, serving as fallback when operators bypass the NPU. |
| **DS-CNN** | **Depthwise Separable Convolutional Neural Network** | Neural Model Architecture | Compact, parameter-efficient CNN topology that decomposes standard 2D convolution into depthwise and pointwise stages for low-latency keyword spotting (2.66M MACs). |
| **MFCC** | **Mel-Frequency Cepstral Coefficients** | DSP & Feature Extraction | Standard speech acoustic feature representation. Audio frames are converted to frequency spectrum, warped to Mel scale, and transformed into 490 INT8 spectrogram values. |
| **TF-M** | **Trusted Firmware-M** | Platform Security | Reference implementation of PSA Certified Level 2 security architecture on Armv8.1-M, enforcing hardware isolation via TrustZone for secure boot and key storage. |
| **MPC** | **Memory Protection Controller** | Hardware Security IP | Bus-level access controller gating memory regions. Unauthorized NPU DMA accesses to protected memory trigger an instant hardware `SecureFault`. |
| **PPU** | **Power Policy Unit** | System Power Management | Hardware logic controlling power domain transitions (ON, OFF, RETENTION) across Corstone-300 compute clusters to minimize static leakage during idle periods. |
| **WAV** | **Waveform Audio File Format** | Audio Signal Processing | Linear pulse-code modulation (PCM) uncompressed digital audio format (16 kHz, 16-bit mono) captured from the browser microphone and streamed to the virtual testbench. |
| **ELF** | **Executable and Linkable Format** | Binary Toolchain | The linked binary container (`build/firmware.elf`) containing executable machine code, initialized data sections, vector tables, and debug symbols loaded into FVP memory. |

