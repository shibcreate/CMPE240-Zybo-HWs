@echo off
REM ============================================================
REM  setup_vitis_app.bat
REM  Copies source files (Step 6) and bitstream (Step 7) into
REM  your Vitis workspace for the zybo_project application.
REM ============================================================

setlocal

REM --- Determine repo root (parent of this script's directory) ---
set "SCRIPT_DIR=%~dp0"
set "REPO_ROOT=%SCRIPT_DIR%.."

REM --- Source locations ---
set "SRC_DIR=%REPO_ROOT%\my_vitis_ws\zybo_project\src"
set "BIT_FILE=%REPO_ROOT%\prebuilt\system_wrapper.bit"

REM --- Validate source exists ---
if not exist "%SRC_DIR%" (
    echo ERROR: Source directory not found: %SRC_DIR%
    echo Make sure you are on the 'project' branch.
    pause
    exit /b 1
)
if not exist "%BIT_FILE%" (
    echo ERROR: Bitstream not found: %BIT_FILE%
    echo Make sure prebuilt/system_wrapper.bit exists.
    pause
    exit /b 1
)

REM --- Get workspace path from user ---
if "%~1"=="" (
    echo.
    echo Usage: setup_vitis_app.bat ^<VITIS_WORKSPACE_PATH^>
    echo.
    echo Example:
    echo   setup_vitis_app.bat C:\Users\shini\Final_Zybo_Proj\WORKSPACETEST
    echo.
    set /p "WS_PATH=Enter your Vitis workspace path: "
) else (
    set "WS_PATH=%~1"
)

REM --- Validate workspace ---
if not exist "%WS_PATH%\zybo_project\src" (
    echo ERROR: Could not find %WS_PATH%\zybo_project\src
    echo Make sure you have already created the zybo_project application in Vitis.
    pause
    exit /b 1
)

REM --- Step 6: Copy source files ---
echo.
echo [Step 6] Copying source files to %WS_PATH%\zybo_project\src\ ...
xcopy /E /Y /I "%SRC_DIR%\*" "%WS_PATH%\zybo_project\src\" >nul
if %ERRORLEVEL% neq 0 (
    echo ERROR: Failed to copy source files.
    pause
    exit /b 1
)
echo Done.

REM --- Step 7: Copy bitstream ---
echo.
echo [Step 7] Copying bitstream to %WS_PATH%\zybo_project\_ide\bitstream\ ...
if not exist "%WS_PATH%\zybo_project\_ide\bitstream" (
    mkdir "%WS_PATH%\zybo_project\_ide\bitstream"
)
copy /Y "%BIT_FILE%" "%WS_PATH%\zybo_project\_ide\bitstream\" >nul
if %ERRORLEVEL% neq 0 (
    echo ERROR: Failed to copy bitstream.
    pause
    exit /b 1
)
echo Done.

REM --- Step 4 Fix: Patch GP1 APER_CLK register in all ps7_init.tcl files ---
echo.
echo [Step 4 Fix] Patching GP1 APER_CLK (0xF800012C) in ps7_init.tcl files...
set "PATCH_COUNT=0"
for /r "%WS_PATH%" %%F in (ps7_init.tcl) do (
    findstr /C:"0x01EC044D" "%%F" >nul 2>&1
    if not errorlevel 1 (
        powershell -Command "(Get-Content '%%F') -replace '0x01EC044D', '0x01FC044D' | Set-Content '%%F'"
        echo       Patched: %%F
        set /a PATCH_COUNT+=1
    )
)
if %PATCH_COUNT%==0 (
    echo       All ps7_init.tcl files already patched (or not found yet).
    echo       NOTE: If you haven't built the platform yet, run this script
    echo       again after building the platform in Vitis.
) else (
    echo       Done. Patched GP1 clock enable in ps7_init.tcl files.
)

REM --- Fix launch.json ps7_init path if needed ---
set "LAUNCH_JSON=%WS_PATH%\zybo_project\_ide\launch.json"
if exist "%LAUNCH_JSON%" (
    findstr /C:"dynclk.tcl" "%LAUNCH_JSON%" >nul 2>&1
    if not errorlevel 1 (
        echo.
        echo [Fix] launch.json references dynclk.tcl instead of ps7_init.tcl.
        echo       Patching launch.json...
        powershell -Command "(Get-Content '%LAUNCH_JSON%') -replace 'dynclk.tcl', 'ps7_init.tcl' | Set-Content '%LAUNCH_JSON%'"
        echo       Fixed.
    )
)

echo.
echo ============================================================
echo  Setup complete!
echo.
echo  Next steps in Vitis:
echo    1. Right-click zybo_project ^> Refresh
echo    2. Build (hammer icon)
echo    3. Run As ^> Launch Hardware
echo ============================================================
echo.
pause
