@echo off
chcp 65001 >nul
cd /d "%~dp0"
echo ========================================
echo   Snake - Setup
echo   Folder: %cd%
echo ========================================
echo.

where gcc >nul 2>&1
if errorlevel 1 (
    echo [ERROR] gcc not found. Install MinGW and add it to PATH.
    pause
    exit /b 1
)

where python >nul 2>&1
if errorlevel 1 (
    echo [ERROR] python not found. Install Python 3.10+.
    pause
    exit /b 1
)

echo [1/3] Build C core...
if not exist "native\snake_engine.exe" (
    pushd native
    gcc -std=c11 -Wall -Wextra -O2 -o snake_engine.exe snake_engine.c
    if errorlevel 1 (
        echo [ERROR] Build failed.
        popd
        pause
        exit /b 1
    )
    popd
    echo   OK: native\snake_engine.exe
) else (
    echo   OK: native\snake_engine.exe already exists
)

echo [2/3] Create Python virtual environment...
if not exist ".venv" (
    python -m venv .venv
    if errorlevel 1 (
        echo [ERROR] Failed to create .venv
        pause
        exit /b 1
    )
    echo   OK: .venv created
) else (
    echo   OK: .venv already exists
)

set "VENV_PY="
if exist ".venv\Scripts\python.exe" set "VENV_PY=.venv\Scripts\python.exe"
if exist ".venv\bin\python.exe" set "VENV_PY=.venv\bin\python.exe"
if "%VENV_PY%"=="" (
    echo [ERROR] Python not found inside .venv
    pause
    exit /b 1
)

echo [3/3] Install Python packages...
"%VENV_PY%" -m pip install -r requirements.txt -q
if errorlevel 1 (
    echo [ERROR] pip install failed
    pause
    exit /b 1
)

echo.
echo ========================================
echo   Setup complete.
echo   Next: double-click run.bat
echo ========================================
pause
