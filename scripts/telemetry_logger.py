#!/usr/bin/env python3
"""
Automated Telemetry and Analytics Logger
Arm Workforce Development - Corstone-300 Edge AI Lab
Addresses Slide 6: "Automated Telemetry: Track build pass rates, command completion times, and compilation bottlenecks."
"""

import sys
import os
import time
import json
from datetime import datetime

class TelemetryLogger:
    def __init__(self, log_path="build/telemetry_report.json"):
        self.log_path = log_path
        self.start_time = time.time()
        self.events = []
        self.metrics = {
            "session_id": f"arm-lab-{int(self.start_time)}",
            "timestamp": datetime.utcnow().isoformat() + "Z",
            "stages": {},
            "bottlenecks": [],
            "overall_success": False,
            "total_duration_sec": 0.0
        }
        
    def log_stage(self, stage_name, duration_sec, success, details=None):
        stage_data = {
            "duration_sec": round(duration_sec, 3),
            "success": success,
            "details": details or {}
        }
        self.metrics["stages"][stage_name] = stage_data
        
        # Check for bottlenecks (e.g. any stage taking > 10 seconds)
        if duration_sec > 10.0:
            self.metrics["bottlenecks"].append({
                "stage": stage_name,
                "duration_sec": round(duration_sec, 3),
                "threshold_sec": 10.0,
                "recommendation": "Pre-compile model or optimize container volume mount"
            })
            
    def finalize(self, success=True):
        self.metrics["total_duration_sec"] = round(time.time() - self.start_time, 3)
        self.metrics["overall_success"] = success
        
        os.makedirs(os.path.dirname(self.log_path), exist_ok=True)
        with open(self.log_path, "w") as f:
            json.dump(self.metrics, f, indent=2)
            
        print("\n=================================================================")
        print("  ARM WORKFORCE LAB: POST-LAB TELEMETRY ANALYTICS REPORT        ")
        print("=================================================================")
        print(f" Session ID:           {self.metrics['session_id']}")
        print(f" Timestamp:            {self.metrics['timestamp']}")
        print(f" Total Lab Run Time:   {self.metrics['total_duration_sec']} seconds")
        print(f" Overall Build Result: {'[SUCCESS]' if success else '[FAILED]'}")
        print("\n Per-Stage Completion Times (Slide 6 Telemetry):")
        for stage, data in self.metrics["stages"].items():
            status = "PASS" if data["success"] else "FAIL"
            print(f"   - {stage:<30} : {data['duration_sec']:>6.2f}s  [{status}]")
            
        if self.metrics["bottlenecks"]:
            print("\n Detected Compilation / Execution Bottlenecks:")
            for b in self.metrics["bottlenecks"]:
                print(f"   ! {b['stage']}: {b['duration_sec']}s (Recommendation: {b['recommendation']})")
        else:
            print("\n No compilation or simulation bottlenecks detected (Sub-second dispatch).")
        print(f"\n Telemetry report saved to: {self.log_path}")
        print("=================================================================\n")

if __name__ == "__main__":
    logger = TelemetryLogger()
    logger.log_stage("Sanity Check", 0.45, True)
    logger.log_stage("Vela Model Compilation", 2.15, True, {"npu_ops": 49, "sram_kib": 21.69})
    logger.log_stage("Firmware Link & Build", 0.85, True, {"firmware_size_bytes": 124732})
    logger.log_stage("Corstone-300 Simulation", 1.20, True, {"inference_cycles": 26500})
    logger.finalize(True)
