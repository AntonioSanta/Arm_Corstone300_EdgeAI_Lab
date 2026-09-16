#!/usr/bin/env bash
set -e

echo "================================================================="
echo "  Arm Workforce Development Lab Runner"
echo "  Deploying Secure Edge AI on Arm Corstone-300 & Virtual Hardware"
echo "================================================================="
echo ""

LAB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$LAB_DIR"

echo "[1/2] Running Environment Sanity Check..."
python3 scripts/sanity_check.py

echo ""
echo "[2/2] Running Automated Lab Test Harness..."
python3 tests/test_harness.py

echo ""
echo "================================================================="
echo "  Lab Execution Finished Successfully!"
echo "================================================================="
