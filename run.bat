@echo off
chcp 65001 >nul
setlocal EnableDelayedExpansion
cd /d "%~dp0"
echo ========================================
echo   Snake - Flask + C
echo   Folder: %cd%
echo ========================================
echo.

call :find_gcc
if errorlevel 1 (
    echo [INFO] gcc not found. Trying to install MinGW via winget...
    where winget >nul 2>&1
    if errorlevel 1 (
        call :gcc_missing_help
        pause
        exit /b 1
    )
    winget install -e --id BrechtSanders.WinLibs.POSIX.UCRT --accept-package-agreements --accept-source-agreements --disable-interactivity
    if errorlevel 1 (
        echo [ERROR] winget install failed.
        call :gcc_missing_help
        pause
        exit /b 1
    )
    call :find_gcc
    if errorlevel 1 (
        echo [ERROR] gcc still not found after winget install.
        call :gcc_missing_help
        pause
        exit /b 1
    )
)
echo   OK: gcc = !GCC!

set "PY_CMD="
where py >nul 2>&1
if not errorlevel 1 set "PY_CMD=py -3"
if "%PY_CMD%"=="" (
    where python >nul 2>&1
    if not errorlevel 1 set "PY_CMD=python"
)
if "%PY_CMD%"=="" (
    echo [ERROR] python not found. Install Python 3.10+.
    pause
    exit /b 1
)

echo [1/4] Build C core...
if not exist "native\snake_engine.exe" (
    pushd native
    "!GCC!" -std=c11 -Wall -Wextra -O2 -o snake_engine.exe snake_engine.c
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

echo [2/4] Create Python virtual environment...
set "VENV_OK=0"
if exist ".venv" (
    call :detect_venv_py
    if not "!VENV_PY!"=="" (
        "!VENV_PY!" -c "import sys" >nul 2>&1
        if not errorlevel 1 set "VENV_OK=1"
    )
    if "!VENV_OK!"=="0" (
        echo   WARN: broken .venv detected, recreating...
        rmdir /s /q .venv
    )
)
if not exist ".venv" (
    %PY_CMD% -m venv .venv
    if errorlevel 1 (
        echo [ERROR] Failed to create .venv
        pause
        exit /b 1
    )
    echo   OK: .venv created
) else (
    echo   OK: .venv already exists
)

call :detect_venv_py
if "!VENV_PY!"=="" (
    echo [ERROR] Python not found inside .venv
    pause
    exit /b 1
)

echo [3/4] Install Python packages...
"!VENV_PY!" -m pip install --upgrade pip -q
if errorlevel 1 (
    echo [ERROR] pip upgrade failed
    pause
    exit /b 1
)
"!VENV_PY!" -m pip install "flask>=3.0,<4" -q
if errorlevel 1 (
    echo [ERROR] pip install failed
    pause
    exit /b 1
)
"!VENV_PY!" -c "import flask" >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Flask not importable after install
    pause
    exit /b 1
)
echo   OK: flask and dependencies installed

echo [4/4] Starting server...
echo.
echo   Open: http://127.0.0.1:5001
echo   1. Click Start Game
echo   2. Use WASD or arrow keys
echo.
start "" "http://127.0.0.1:5001"
"!VENV_PY!" app.py
pause
exit /b 0

:detect_venv_py
set "VENV_PY="
if exist ".venv\Scripts\python.exe" set "VENV_PY=.venv\Scripts\python.exe"
if exist ".venv\bin\python.exe" set "VENV_PY=.venv\bin\python.exe"
exit /b 0

:find_gcc
set "GCC="
where gcc >nul 2>&1
if not errorlevel 1 (
    for /f "delims=" %%G in ('where gcc 2^>nul') do (
        set "GCC=%%G"
        set "PATH=%%~dpG;!PATH!"
        exit /b 0
    )
)
for %%P in (
    "C:\Program Files (x86)\Embarcadero\Dev-Cpp\TDM-GCC-64\bin\gcc.exe"
    "C:\msys64\ucrt64\bin\gcc.exe"
    "C:\msys64\mingw64\bin\gcc.exe"
    "C:\MinGW\bin\gcc.exe"
    "C:\mingw64\bin\gcc.exe"
    "C:\winlibs64\mingw64\bin\gcc.exe"
    "C:\Program Files\WinLibs\bin\gcc.exe"
    "C:\Program Files\mingw-w64\x86_64-w64-mingw32\bin\gcc.exe"
) do (
    if exist %%P (
        set "GCC=%%~P"
        set "PATH=%%~dpP;!PATH!"
        exit /b 0
    )
)
for /d %%D in ("%LOCALAPPDATA%\Microsoft\WinGet\Packages\BrechtSanders.WinLibs*") do (
    if exist "%%D\mingw64\bin\gcc.exe" (
        set "GCC=%%D\mingw64\bin\gcc.exe"
        set "PATH=%%D\mingw64\bin;!PATH!"
        exit /b 0
    )
    for /d %%S in ("%%D\*") do (
        if exist "%%S\mingw64\bin\gcc.exe" (
            set "GCC=%%S\mingw64\bin\gcc.exe"
            set "PATH=%%S\mingw64\bin;!PATH!"
            exit /b 0
        )
    )
)
exit /b 1

:gcc_missing_help
echo.
echo [ERROR] gcc not found.
echo   Option 1: Re-run this script (it will try winget install automatically)
echo   Option 2: Manual install:
echo     winget install BrechtSanders.WinLibs.POSIX.UCRT
echo   Option 3: Install MSYS2, then run:
echo     pacman -S mingw-w64-ucrt-x86_64-gcc
echo     Add C:\msys64\ucrt64\bin to PATH
exit /b 0
