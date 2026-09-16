@echo off
setlocal
echo =================================================================
echo   Arm Workforce Development Lab Runner
echo   Deploying Secure Edge AI on Arm Corstone-300 & Virtual Hardware
echo =================================================================
echo.

:: Ensure D: drive mapping
if not exist "D:\" (
    subst D: E:\ >nul 2>&1
)

echo [1/3] Checking execution environment...
where wsl >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] WSL is required to run the Arm toolchain on this host.
    pause
    exit /b 1
)

echo [2/3] Running Automated Pre-Flight and Test Harness in WSL...
echo -----------------------------------------------------------------
pushd C:\
wsl -d Ubuntu-22.04 -- bash -c "cd /mnt/e/Arm_Corstone300_EdgeAI_Lab && python3 tests/test_harness.py"
if %errorlevel% neq 0 (
    popd
    echo.
    echo [ERROR] Lab test harness reported failures. Check logs above.
    pause
    exit /b 1
)
popd

echo.
echo [3/3] Lab Verification Passed 100%%!
echo -----------------------------------------------------------------
echo Telemetry report generated at: D:\Arm_Corstone300_EdgeAI_Lab\build\telemetry_report.json
echo Interactive presentation available at: D:\Arm_Corstone300_EdgeAI_Lab\slides\presentation.html
echo.
echo =================================================================
echo   Lab Execution Finished Successfully!
echo =================================================================
pause
