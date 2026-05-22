from __future__ import annotations
import json
import os
import subprocess
from pathlib import Path
from flask import Flask, jsonify, render_template, request, session

APP_ROOT = Path(__file__).resolve().parent
CORE_EXE = os.environ.get("SNAKE_CORE", str(APP_ROOT / "native" / "snake_engine.exe"))
app = Flask(__name__)
app.secret_key = os.environ.get("FLASK_SECRET_KEY", "snake-dev-change-me")

def run_core(payload: dict) -> dict:
    if not Path(CORE_EXE).is_file():
        return {"ok": False, "error": f"C core not built: missing {CORE_EXE}"}
    proc = subprocess.run(
        [CORE_EXE],
        input=json.dumps(payload, separators=(",", ":")).encode("utf-8"),
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        timeout=5,
        check=False,
    )
    if proc.returncode != 0:
        err = proc.stderr.decode("utf-8", errors="replace").strip()
        return {"ok": False, "error": err or f"exit {proc.returncode}"}
    lines = proc.stdout.decode("utf-8", errors="replace").strip().splitlines()
    if not lines:
        return {"ok": False, "error": "empty stdout from C core"}
    try:
        return json.loads(lines[-1])
    except json.JSONDecodeError as e:
        return {"ok": False, "error": f"invalid json from core: {e}"}

def save(result: dict) -> None:
    session["width"] = int(result["width"])
    session["height"] = int(result["height"])
    session["score"] = int(result.get("score", 0))
    session["game_over"] = bool(result.get("game_over"))
    session["food_x"] = int(result.get("food_x", 0))
    session["food_y"] = int(result.get("food_y", 0))
    session["dir"] = result.get("dir", "U")
    session["snake"] = result.get("snake") or []

def payload(cmd: str, key: str | None = None) -> dict:
    p = {
        "cmd": cmd,
        "width": session["width"],
        "height": session["height"],
        "score": session.get("score", 0),
        "game_over": 1 if session.get("game_over") else 0,
        "food_x": session.get("food_x", 0),
        "food_y": session.get("food_y", 0),
        "dir": session.get("dir", "U"),
        "snake": session.get("snake") or [],
    }
    if key:
        p["key"] = key
    return p

@app.get("/")
def index():
    return render_template("index.html")

@app.post("/api/game/start")
def game_start():
    result = run_core({"cmd": "new"})
    if not result.get("ok"):
        return jsonify(result), 400
    save(result)
    return jsonify(result)

@app.post("/api/game/move")
def game_move():
    if "width" not in session:
        return jsonify({"ok": False, "error": "請先按「開始遊戲」"}), 400
    if session.get("game_over"):
        return jsonify({"ok": False, "error": "遊戲已結束，請重新開始"}), 400
    body = request.get_json(silent=True) or {}
    key = str(body.get("key", "")).upper()
    if key not in ("W", "A", "S", "D"):
        return jsonify({"ok": False, "error": "按鍵須為 W/A/S/D"}), 400
    result = run_core(payload("move", key))
    if not result.get("ok"):
        return jsonify(result), 400
    save(result)
    return jsonify(result)

if __name__ == "__main__":
    app.run(host="127.0.0.1", port=5001, debug=False)