@echo off
title Arm Corstone-300 Live Bridge Server (Port 8080)
echo =================================================================
echo   Arm Corstone-300 Live Audio Bridge Server
echo   Target: Cortex-M55 + Ethos-U55 (Arm Fast Models FVP & QEMU)
echo   Listening on: http://127.0.0.1:8080
echo =================================================================
echo.
echo Starting live speech bridge server in WSL...
echo Keep this window open during your presentation or live demo.
echo (Press Ctrl+C or close this window when finished)
echo.
wsl -d Ubuntu-22.04 -- bash -c "cd /mnt/e/Arm_Corstone300_EdgeAI_Lab && python3 scripts/live_bridge_server.py"
pause
