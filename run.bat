@echo off
chcp 65001 >nul
cd /d "%~dp0"
echo ========================================
echo   Snake - Flask + C
echo   Folder: %cd%
echo ========================================
echo.

if not exist "native\snake_engine.exe" (
    echo [1/3] Compiling C core...
    cd native
    gcc -std=c11 -Wall -Wextra -O2 -o snake_engine.exe snake_engine.c
    if errorlevel 1 (
        echo Build failed. Install MinGW gcc first.
        pause
        exit /b 1
    )
    cd ..
) else (
    echo [1/3] Found native\snake_engine.exe
)

echo [2/3] pip install...
python -m pip install -r requirements.txt -q

echo [3/3] Starting server...
echo.
echo   Open browser: http://127.0.0.1:5001
echo   Step 1: Click Start Game
echo   Step 2: Use WASD or arrow keys
echo.
start "" "http://127.0.0.1:5001"
python app.py
pause
