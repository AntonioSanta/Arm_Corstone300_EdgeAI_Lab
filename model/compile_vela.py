#!/usr/bin/env python3
"""
Vela Compiler Automation Script for Arm Ethos-U55
Arm Workforce Development - Corstone-300 Edge AI Lab

Compiles a quantized INT8 TFLite model targeting Arm Ethos-U55 NPU.
Demonstrates standard NPU acceleration and operator fallback to Cortex-M55 CPU.
"""

import sys
import os
import subprocess
import json
import argparse
import shutil

def run_vela_compilation(input_model, output_dir, accelerator="ethos-u55-128", fallback_mode=False):
    os.makedirs(output_dir, exist_ok=True)
    
    # Locate vela executable
    vela_cmd = shutil.which("vela")
    if not vela_cmd:
        user_vela = os.path.expanduser("~/.local/bin/vela")
        if os.path.exists(user_vela):
            vela_cmd = user_vela
        else:
            vela_cmd = "vela"

    cmd = [
        vela_cmd,
        input_model,
        "--accelerator-config", accelerator,
        "--config", "Arm/vela.ini",
        "--system-config", "Ethos_U55_High_End_Embedded",
        "--memory-mode", "Shared_Sram",
        "--output-dir", output_dir,
        "--show-cpu-operations"
    ]
    
    # Slide 5 Mitigation: Fallback demonstration
    if fallback_mode:
        print("[VELA] Running with Operator Fallback demonstration (FULLY_CONNECTED ignored on NPU)...")
        cmd.extend(["--ignore-ops", "FULLY_CONNECTED"])
    else:
        print(f"[VELA] Compiling {input_model} for {accelerator} (Full NPU Acceleration)...")

    print(f"[CMD] {' '.join(cmd)}")
    result = subprocess.run(cmd, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True)
    
    print("\n--- VELA COMPILATION OUTPUT ---")
    print(result.stdout)
    print("-------------------------------\n")
    
    if result.returncode != 0:
        print(f"[ERROR] Vela compilation failed with return code {result.returncode}")
        return False, {}

    # Parse key metrics from Vela output
    metrics = {
        "accelerator": accelerator,
        "fallback_mode": fallback_mode,
        "sram_used_kib": 0.0,
        "flash_used_kib": 0.0,
        "npu_ops": 0,
        "cpu_ops": 0,
        "macs_per_batch": 0
    }
    
    for line in result.stdout.splitlines():
        line_clean = line.strip()
        if "Total SRAM used" in line_clean:
            parts = line_clean.split()
            try:
                metrics["sram_used_kib"] = float(parts[3])
            except (IndexError, ValueError):
                pass
        elif "Total Off-chip Flash used" in line_clean:
            parts = line_clean.split()
            try:
                metrics["flash_used_kib"] = float(parts[4])
            except (IndexError, ValueError):
                pass
        elif "NPU operators =" in line_clean:
            parts = line_clean.split()
            try:
                metrics["npu_ops"] = int(parts[3])
            except (IndexError, ValueError):
                pass
        elif "CPU operators =" in line_clean:
            parts = line_clean.split()
            try:
                metrics["cpu_ops"] = int(parts[3])
            except (IndexError, ValueError):
                pass
        elif "Neural network macs" in line_clean:
            parts = line_clean.split()
            try:
                metrics["macs_per_batch"] = int(parts[3])
            except (IndexError, ValueError):
                pass

    summary_file = os.path.join(output_dir, "compilation_summary.json")
    with open(summary_file, "w") as f:
        json.dump(metrics, f, indent=2)
    print(f"[INFO] Saved compilation metrics to {summary_file}")
    
    return True, metrics

def main():
    parser = argparse.ArgumentParser(description="Vela Model Compiler for Arm Corstone-300 Lab")
    parser.add_argument("--model", default="model/ds_cnn_s_quantized.tflite", help="Path to input TFLite model")
    parser.add_argument("--output-dir", default="model/output_vela", help="Output directory for compiled model")
    parser.add_argument("--accelerator", default="ethos-u55-128", choices=["ethos-u55-128", "ethos-u55-256"], help="Ethos-U MAC configuration")
    parser.add_argument("--fallback-mode", action="store_true", help="Demonstrate operator fallback to CPU")
    args = parser.parse_args()

    success, metrics = run_vela_compilation(args.model, args.output_dir, args.accelerator, args.fallback_mode)
    if not success:
        sys.exit(1)

    print(f"[SUCCESS] Vela compilation complete:")
    print(f"  - SRAM Allocation: {metrics.get('sram_used_kib')} KiB (Linker SRAM Limit: 64 KiB arena)")
    print(f"  - Flash Usage:     {metrics.get('flash_used_kib')} KiB")
    print(f"  - NPU Operators:   {metrics.get('npu_ops')}")
    print(f"  - CPU Operators:   {metrics.get('cpu_ops')} (Helium MVE / CMSIS-NN fallback)")
    print(f"  - Total MACs:      {metrics.get('macs_per_batch'):,} MACs/batch")

if __name__ == "__main__":
    main()
