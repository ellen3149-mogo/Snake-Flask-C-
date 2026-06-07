# 🐍 貪吃蛇遊戲（Snake Game）

C 語言期末專題：用 Flask 做網頁介面、C 語言寫遊戲核心（Linked List、malloc/free）。

---

## ⚙️ 執行前需要裝好

| 需要 | 說明 |
|---|---|
| **Python 3.10+** | [下載點](https://www.python.org/downloads/)｜安裝時記得勾 **Add Python to PATH** |
| **MinGW（gcc）** | [下載點](https://github.com/niXman/mingw-builds-binaries/releases)｜解壓到 `C:\mingw64`，把 `C:\mingw64\bin` 加到系統 PATH |

裝好後打開 CMD 確認：

```cmd
python --version
gcc --version
```

兩個都有版本號就 OK ✅

---

## 🚀 怎麼開始

### 第一次使用

**雙擊 `setup.bat`**（只需要跑一次）

它會自動幫你完成：
1. 確認 Python 和 gcc 有沒有裝好
2. 編譯 C 遊戲核心
3. 建立 Python 虛擬環境並安裝套件

看到 `Setup complete. Next: double-click run.bat` 就代表成功 ✅

### 之後每次要玩

**雙擊 `run.bat`**

瀏覽器會自動開啟 **http://127.0.0.1:5001**

1. 點 **Start Game**
2. 蛇會自動移動，用 **WASD** 或**方向鍵**控制方向
3. 關掉 CMD 視窗 = 遊戲結束

---

## 📁 專案架構

```
snake/
├── setup.bat                  # 第一次建置環境用
├── run.bat                    # 每次啟動遊戲用
├── app.py                     # Flask 伺服器，處理網頁請求
├── requirements.txt           # Python 套件清單（flask）
├── native/
│   └── snake_engine.c         # C 語言遊戲核心，處理蛇的移動、碰撞、分數
├── templates/
│   └── index.html             # 遊戲主頁面
└── static/
    ├── game.js                # 遊戲邏輯（自動 tick、鍵盤監聽、API 呼叫）
    └── style.css              # 介面樣式
```

---

## 🎓 C 核心功能（作業要求）

- `struct` 儲存遊戲狀態，Singly Linked List 管理蛇的身體
- 蛇移動 / 吃到食物時動態 `malloc` / `free`
- Python 透過 subprocess 啟動 C 程式，以 JSON 格式傳遞遊戲資料

---

## 📡 API

| 路徑 | 方法 | 說明 |
|---|---|---|
| `/api/game/start` | POST | 開始新遊戲 |
| `/api/game/move` | POST | 傳送方向 `{"key":"W"}` （W / A / S / D）|

---

Educational project｜期末專題
