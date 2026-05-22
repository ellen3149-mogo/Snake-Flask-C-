# Snake Game (Flask + C)

C language final project: Snake game with Flask web UI and C core engine (linked list, malloc/free).

## Architecture

- **Flask** (`app.py`): Web routes, session, subprocess bridge
- **C core** (`native/snake_engine.c`): Snake movement, collision, food, score via JSON stdin/stdout
- **Frontend** (`templates/`, `static/`): Browser UI, auto-tick game loop

## Requirements

- Windows CMD
- Python 3.10+
- MinGW `gcc` in PATH

## Quick start (CMD)

```cmd
cd /d C:\Users\User\Downloads\snake
run.bat
```

Open **http://127.0.0.1:5001** (port 5001 to avoid conflict with other Flask apps).

1. Click **Start Game**
2. Snake moves automatically; use **WASD** or arrow keys to turn

## Manual build

```cmd
cd native
gcc -std=c11 -Wall -Wextra -O2 -o snake_engine.exe snake_engine.c
cd ..
python -m pip install -r requirements.txt
python app.py
```

## API

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/api/game/start` | POST | New game |
| `/api/game/move` | POST | Body: `{"key":"W"}` (W/A/S/D) |

## C core features (assignment)

- `struct` game state, singly linked list snake body
- `malloc` / `free` on move and grow
- JSON line protocol for Python subprocess

## License

Educational project.