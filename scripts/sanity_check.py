#!/usr/bin/env python3
"""
Pre-Flight Toolchain & Environment Sanity Check Script
Arm Workforce Development - Corstone-300 Edge AI Lab
Addresses Slide 5: "Sanity Scripts: Automated check script validating toolchain paths prior to exercise execution."
"""

import sys
import os
import shutil
import subprocess
import json

def check_command(cmd, name, version_arg="--version"):
    exe = shutil.which(cmd)
    if not exe:
        # Check ~/.local/bin
        user_bin = os.path.expanduser(f"~/.local/bin/{cmd}")
        if os.path.exists(user_bin):
            exe = user_bin
            
    if not exe:
        print(f"  [FAIL] {name:<35} : NOT FOUND in PATH")
        return False, None
        
    try:
        res = subprocess.run([exe, version_arg], stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True, timeout=5)
        ver = res.stdout.splitlines()[0] if res.stdout else "Available"
        print(f"  [PASS] {name:<35} : FOUND ({ver[:40]})")
        return True, exe
    except Exception as e:
        print(f"  [WARN] {name:<35} : FOUND at {exe} (Check error: {e})")
        return True, exe

def check_gcc_cortex_m55(gcc_exe):
    if not gcc_exe:
        return False
    try:
        res = subprocess.run([gcc_exe, "-mcpu=cortex-m55", "-E", "-"], input="", stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        if res.returncode == 0:
            print(f"  [PASS] {'Arm GNU Toolchain Cortex-M55 Target':<35} : SUPPORTED (Armv8.1-M Helium)")
            return True
        else:
            print(f"  [FAIL] {'Arm GNU Toolchain Cortex-M55 Target':<35} : -mcpu=cortex-m55 rejected")
            return False
    except Exception as e:
        print(f"  [FAIL] {'Arm GNU Toolchain Cortex-M55 Target':<35} : Error: {e}")
        return False

def check_virtual_platform():
    # Check for Arm FVP or QEMU
    fvp = shutil.which("FVP_Corstone_SSE-300_Ethos-U55") or shutil.which("FVP_Corstone_SSE-300")
    if fvp:
        print(f"  [PASS] {'Arm Virtual Hardware (Corstone-300 FVP)':<35} : FOUND ({fvp})")
        return True, "FVP"
        
    qemu = shutil.which("qemu-system-arm")
    if qemu:
        # Check mps3-an547
        res = subprocess.run([qemu, "-M", "help"], stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        if "mps3-an547" in res.stdout:
            print(f"  [PASS] {'Virtual Platform (QEMU Corstone-300)':<35} : SUPPORTED (mps3-an547 Cortex-M55)")
            return True, "QEMU"
    print(f"  [FAIL] {'Virtual Platform Simulator':<35} : Neither FVP nor QEMU mps3-an547 found")
    return False, None

def main():
    print("=================================================================")
    print("  ARM WORKFORCE LAB: PRE-FLIGHT ENVIRONMENT SANITY CHECK         ")
    print("=================================================================")
    print(" Validating prerequisites before participant exercise execution...\n")
    
    results = {}
    
    # 1. Python Environment
    py_ok = sys.version_info >= (3, 8)
    py_ver = f"Python {sys.version_info.major}.{sys.version_info.minor}.{sys.version_info.micro}"
    if py_ok:
        print(f"  [PASS] {'Host Python Environment':<35} : {py_ver}")
    else:
        print(f"  [FAIL] {'Host Python Environment':<35} : {py_ver} (Requires 3.8+)")
    results["python"] = py_ok
    
    # 2. Arm Vela Compiler (Slide 3 Step 01 & Slide 4)
    vela_ok, _ = check_command("vela", "Arm Vela NPU Compiler (Ethos-U)")
    results["vela"] = vela_ok
    
    # 3. Arm GNU Toolchain (Slide 4)
    gcc_ok, gcc_path = check_command("arm-none-eabi-gcc", "Arm GNU Embedded Toolchain (GCC)")
    m55_ok = check_gcc_cortex_m55(gcc_path)
    results["gcc_m55"] = m55_ok
    
    # 4. Make & Build Tools
    make_ok, _ = check_command("make", "GNU Make Build System")
    results["make"] = make_ok

    # 5. Virtual Hardware Platform (Slide 4 & Slide 5)
    vp_ok, vp_type = check_virtual_platform()
    results["virtual_platform"] = vp_ok

    # 6. Model Asset Check
    model_path = "model/ds_cnn_s_quantized.tflite"
    if os.path.exists(model_path):
        size = os.path.getsize(model_path)
        print(f"  [PASS] {'Arm ML-Zoo Model Asset':<35} : FOUND ({model_path}, {size} bytes)")
        results["model_asset"] = True
    else:
        print(f"  [FAIL] {'Arm ML-Zoo Model Asset':<35} : MISSING ({model_path})")
        results["model_asset"] = False

    print("\n-----------------------------------------------------------------")
    all_ok = all(results.values())
    if all_ok:
        print(" [SANITY STATUS] >>> ALL SANITY CHECKS PASSED: READY FOR LAB <<<")
        print(" Platform, compiler, Vela, and virtual hardware are fully validated.")
    else:
        print(" [SANITY STATUS] >>> WARNING: ENVIRONMENT ISSUES DETECTED <<<")
        print(" Review failed items above before starting participant session.")
    print("=================================================================\n")

    os.makedirs("build", exist_ok=True)
    with open("build/sanity_status.json", "w") as f:
        json.dump({"ready": all_ok, "details": results}, f, indent=2)

    return 0 if all_ok else 1

if __name__ == "__main__":
    sys.exit(main())
