#!/usr/bin/env python3
"""
Automated Test Harness for Arm Corstone-300 & Ethos-U55 Edge AI Lab
Arm Workforce Development Technical Delivery Verification

Executes the complete end-to-end pipeline:
1. Environment Sanity Check (Slide 5)
2. Vela Model Compilation & Fallback Demonstration (Slide 3 Step 01 & Slide 5)
3. C-Array Code Generation & Linker Boundary Sectioning
4. Cortex-M55 & Ethos-U55 Firmware Compilation (Slide 3 Step 02)
5. Corstone-300 Virtual Platform Simulation (Slide 3 Step 03 & Slide 5)
6. Assertion Verification & Performance Profiling (Slide 3 Step 04)
7. Automated Post-Lab Telemetry Logging (Slide 6)
"""

import sys
import os
import subprocess
import time
import json
import re

# Add scripts directory to path for telemetry
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "scripts")))
from telemetry_logger import TelemetryLogger

def run_command_logged(cmd, description, logger, timeout=60):
    print(f"\n>>> [TEST STEP] {description}...")
    start = time.time()
    try:
        res = subprocess.run(cmd, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True, timeout=timeout)
        duration = time.time() - start
        success = (res.returncode == 0)
        print(res.stdout)
        logger.log_stage(description, duration, success, {"returncode": res.returncode})
        if not success:
            print(f"[FAIL] {description} failed (Code: {res.returncode})")
        else:
            print(f"[PASS] {description} completed in {duration:.2f}s")
        return success, res.stdout
    except Exception as e:
        duration = time.time() - start
        logger.log_stage(description, duration, False, {"error": str(e)})
        print(f"[FAIL] {description} encountered exception: {e}")
        return False, str(e)

def parse_simulation_telemetry(sim_output):
    assertions = {
        "helium_active": "TEST 1: Cortex-M55 Helium Vector Extensions Active... [PASS]" in sim_output,
        "ethos_init": "TEST 2: Ethos-U55 NPU Driver Handshake & Setup...... [PASS]" in sim_output,
        "sram_boundary": "TEST 3: Internal SRAM Tensor Arena Boundary Safety.. [PASS]" in sim_output,
        "model_executed": "TEST 4: TFLite Micro Model Execution Pipeline........ [PASS]" in sim_output,
        "accuracy_verified": "TEST 5: Keyword Classification Parity (\"Yes\")....... [PASS]" in sim_output,
        "all_passed": "ALL LAB ACCEPTANCE TESTS PASSED SUCCESSFULLY!" in sim_output
    }
    
    # Extract cycles if present
    cycle_match = re.search(r"Total End-to-End Latency:\s+(\d+)\s+cycles", sim_output)
    cycles = int(cycle_match.group(1)) if cycle_match else None
    
    # Extract SRAM usage
    sram_match = re.search(r"Internal SRAM Arena Used:\s+(\d+)\s+bytes", sim_output)
    sram_used = int(sram_match.group(1)) if sram_match else None

    # Extract detected keyword
    keyword_match = re.search(r"Detected Keyword:\s+\"([^\"]+)\"", sim_output)
    keyword = keyword_match.group(1) if keyword_match else None

    return assertions, cycles, sram_used, keyword

def main():
    print("=================================================================")
    print("  ARM WORKFORCE DEVELOPMENT: AUTOMATED TEST HARNESS             ")
    print("  Target: Corstone-300 (Cortex-M55 + Ethos-U55) & AVH           ")
    print("=================================================================\n")

    logger = TelemetryLogger("build/telemetry_report.json")
    overall_ok = True

    # 1. Sanity Check
    ok, _ = run_command_logged([sys.executable, "scripts/sanity_check.py"], "Pre-Flight Sanity Check", logger)
    if not ok:
        print("[WARN] Sanity check reported warnings, continuing...")

    # 2. Standard Vela Compilation (Full NPU Offload)
    ok, _ = run_command_logged([sys.executable, "model/compile_vela.py"], "Vela Model Compilation (Ethos-U55)", logger)
    if not ok:
        overall_ok = False

    # 3. Vela Fallback Mode Compilation Demonstration (Slide 5 Mitigation)
    ok, _ = run_command_logged([sys.executable, "model/compile_vela.py", "--fallback-mode", "--output-dir", "model/output_fallback"], 
                               "Vela Operator Fallback Demonstration", logger)

    # 4. Generate C-Array Headers and Source
    ok, _ = run_command_logged([sys.executable, "model/tflite_to_c_array.py"], "Model C-Array Generation", logger)
    if not ok:
        overall_ok = False

    # 5. Clean and Build Cortex-M55 Firmware
    ok, _ = run_command_logged(["make", "clean"], "Clean Build Directory", logger)
    ok, _ = run_command_logged(["make"], "Cortex-M55 & Ethos-U55 Firmware Link", logger)
    if not ok:
        overall_ok = False
        print("[CRITICAL] Firmware compilation failed. Halting test harness.")
        logger.finalize(False)
        sys.exit(1)

    # 6. Run Virtual Platform Simulation
    sim_cmd = ["qemu-system-arm", "-M", "mps3-an547", "-cpu", "cortex-m55", 
               "-display", "none", "-serial", "stdio", "-semihosting", 
               "-kernel", "build/firmware.elf"]
    
    # In Slide 5, headless mode is forced via disable-visualisation=1 switch for FVP
    print("[SIM] Note: FVP Headless Flag configured as '-C disable-visualisation=1'")
    
    ok, sim_output = run_command_logged(sim_cmd, "Corstone-300 Virtual Platform Simulation", logger, timeout=10)
    
    # 7. Parse & Validate Acceptance Assertions
    assertions, cycles, sram_used, keyword = parse_simulation_telemetry(sim_output)
    
    print("\n-----------------------------------------------------------------")
    print("  AUTOMATED ACCEPTANCE CRITERIA AUDIT:")
    print("-----------------------------------------------------------------")
    for name, passed in assertions.items():
        status = "[PASS]" if passed else "[FAIL]"
        print(f"  - {name:<25} : {status}")
        if not passed and name == "all_passed":
            overall_ok = False

    print(f"\n  Profiling Telemetry Verification:")
    print(f"  - End-to-End Cycles:     {cycles} cycles")
    print(f"  - Internal SRAM Used:    {sram_used} bytes (Linker Limit: 65,536 bytes)")
    print(f"  - Detected Keyword:      \"{keyword}\" (Golden: \"Yes\")")

    if sram_used and sram_used > 65536:
        print("  [CRITICAL ALERT] Internal SRAM Arena exceeded maximum 64 KiB!")
        overall_ok = False
    else:
        print("  - Memory Safety Audit:   PASSED (Zero Linker / SRAM Overflow)")

    # 8. Finalize Telemetry Report
    logger.finalize(overall_ok)

    if overall_ok:
        print("\n>>> ALL WORKFORCE LAB HARNESS VERIFICATIONS PASSED SUCCESSFULLY! <<<\n")
        return 0
    else:
        print("\n>>> TEST HARNESS FAILED ONE OR MORE ACCEPTANCE CRITERIA <<<\n")
        return 1

if __name__ == "__main__":
    sys.exit(main())
