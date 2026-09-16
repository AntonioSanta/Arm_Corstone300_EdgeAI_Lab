# Arm Workforce Development: Post-Lab Pulse Survey
**Topic:** Deploying Secure Edge AI on Arm Corstone-300 & Virtual Hardware  
**Slide 6 Alignment:** 4-Question Qualitative Pulse Check

---

### Question 1: Setup & Environment Friction
*How frictionless was your initial environment bring-up (Docker container / Hosted AVH instance / Local CLI)?*
- [ ] **1 - High Friction:** Blocked by dependency errors, path issues, or missing permissions (> 30 mins)
- [ ] **2 - Moderate Friction:** Encountered 1-2 minor hiccups resolved by sanity script
- [ ] **3 - Smooth:** Up and running in < 10 minutes with minimal configuration
- [ ] **4 - Flawless (Instant):** Container or AVH cloud instance launched immediately with zero errors

*Notes / Specific blockers encountered:*
`____________________________________________________________________`

---

### Question 2: Arm Architectural Concept Clarity
*How clearly did the lab convey the interplay between the Cortex-M55 CPU (Helium MVE) and Ethos-U55 microNPU?*
- [ ] **1 - Unclear:** Hard to understand which operators ran on the CPU vs NPU
- [ ] **2 - Partially Clear:** Understood the split, but unclear on how CMSIS-NN and Vela coordinate
- [ ] **3 - Very Clear:** Grasped why INT8 quantization and command stream compilation are required
- [ ] **4 - Mastered:** Confident in explaining operator fallback and shared SRAM tiling to other engineers

*Notes / Clarifications needed:*
`____________________________________________________________________`

---

### Question 3: Toolchain & Workflow Confidence
*How confident do you feel using the Arm Vela compiler and West/CMake build system independently?*
- [ ] **1 - Low:** Would need step-by-step guidance to compile another model
- [ ] **2 - Moderate:** Could compile supported models, but might struggle with unsupported operator fallbacks
- [ ] **3 - High:** Comfortable tuning `--accelerator-config`, memory modes, and inspecting output graphs
- [ ] **4 - Autonomous:** Ready to deploy custom TensorFlow Lite Micro models to Corstone-300 silicon/AVH

*Notes / Desired tools or deeper documentation:*
`____________________________________________________________________`

---

### Question 4: Virtual Platform (AVH / FVP) Pedagogical Value
*Did developing and profiling on Arm Virtual Hardware give you sufficient confidence for physical silicon parity?*
- [ ] **1 - Disagree:** Prefer physical hardware; simulation felt detached from real-world embedded constraints
- [ ] **2 - Neutral:** Good for basic logic, but still worried about timing, DMA, and real board quirks
- [ ] **3 - Agree:** Excellent development speed; cycle counters and SRAM metrics matched expectation
- [ ] **4 - Strongly Agree:** AVH accelerated development exponentially; cycle-accurate profiling was invaluable

*Suggestions for improving the next iteration:*
`____________________________________________________________________`
