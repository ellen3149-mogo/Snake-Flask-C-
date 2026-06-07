@echo off
chcp 65001 >nul
cd /d "%~dp0"
echo ========================================
echo   Snake - Flask + C
echo   Folder: %cd%
echo ========================================
echo.

set "VENV_PY="
if exist ".venv\Scripts\python.exe" set "VENV_PY=.venv\Scripts\python.exe"
if exist ".venv\bin\python.exe" set "VENV_PY=.venv\bin\python.exe"
if "%VENV_PY%"=="" (
    echo [ERROR] Setup not done. Run setup.bat first.
    pause
    exit /b 1
)

if not exist "native\snake_engine.exe" (
    echo [ERROR] native\snake_engine.exe missing. Run setup.bat first.
    pause
    exit /b 1
)

echo Starting server...
echo.
echo   Open: http://127.0.0.1:5001
echo   1. Click Start Game
echo   2. Use WASD or arrow keys
echo.
start "" "http://127.0.0.1:5001"
"%VENV_PY%" app.py
pause
