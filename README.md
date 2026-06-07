# 🐍 Snake Game（Flask + C）

C 語言期末專題：以 Flask 作為 Web UI、C 語言核心引擎（Linked List、malloc/free）實作貪吃蛇遊戲。

---

## 📁 專案架構

| 檔案 / 資料夾 | 說明 |
|---|---|
| `app.py` | Flask 路由、Session、子程序橋接 |
| `native/snake_engine.c` | C 核心：蛇移動、碰撞、食物、分數（JSON stdin/stdout） |
| `templates/` | HTML 頁面 |
| `static/` | CSS / JS 前端，含自動 tick 遊戲迴圈 |
| `run.bat` | 一鍵啟動腳本（自動編譯 + 啟動伺服器） |

---

## ⚙️ 系統需求

| 項目 | 需求 |
|---|---|
| 作業系統 | **Windows**（CMD / PowerShell） |
| Python | **3.10 或以上** |
| C 編譯器 | **MinGW gcc**（需加入 PATH） |

---

## 🚀 快速啟動（推薦）

```cmd
cd /d C:\Users\User\Downloads\snake
run.bat
```

瀏覽器開啟 **http://127.0.0.1:5001**

1. 點擊 **Start Game**
2. 蛇會自動移動，用 **WASD** 或 **方向鍵** 轉向

> ⚠️ `run.bat` 會自動：① 編譯 C 核心 → ② 安裝 Python 套件 → ③ 啟動伺服器

---

## 🔧 手動啟動（run.bat 失敗時用這個）

```cmd
cd /d C:\Users\User\Downloads\snake\native
gcc -std=c11 -Wall -Wextra -O2 -o snake_engine.exe snake_engine.c
cd ..
python -m pip install -r requirements.txt
python app.py
```

---


## 📡 API 一覽

| Endpoint | Method | 說明 |
|---|---|---|
| `/api/game/start` | POST | 開始新遊戲 |
| `/api/game/move` | POST | 傳送 `{"key":"W"}` (W/A/S/D) |

---

## 🎓 C 核心功能（作業要求）

- `struct` 遊戲狀態、Singly Linked List 蛇身體
- 移動 / 成長時動態 `malloc` / `free`
- Python 子程序透過 JSON 行協議與 C 溝通

---



---

## 授權

Educational project — 期末專題用途。
