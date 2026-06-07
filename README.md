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

## 🆘 無法啟動？逐步排查

### ❶ 先確認你的 Python 版本

```cmd
python --version
```

✅ 正常：顯示 `Python 3.10.x` 或以上  
❌ 錯誤 / 顯示 `Python 2.x`：請至 https://www.python.org/downloads/ 下載 3.10+，安裝時勾選 **Add Python to PATH**

---

### ❷ 確認 gcc 是否安裝並加入 PATH

```cmd
gcc --version
```

✅ 正常：顯示 `gcc (MinGW...) x.x.x`  
❌ 顯示「不是內部或外部命令」：

**安裝步驟：**

1. 下載 MinGW：https://github.com/niXman/mingw-builds-binaries/releases  
   → 選 `x86_64-...-release-win32-seh-msvcrt-rt_v12-rev0.7z`（64 位元）
2. 解壓縮到 `C:\mingw64`
3. 將 `C:\mingw64\bin` 加入系統環境變數 PATH：  
   開始 → 搜尋「環境變數」→ 系統內容 → 進階 → 環境變數 → Path → 新增 → 輸入 `C:\mingw64\bin`
4. **重新開啟 CMD**，再執行 `gcc --version`

---

### ❸ 手動編譯 C 核心

```cmd
cd /d C:\Users\User\Downloads\snake\native
gcc -std=c11 -Wall -Wextra -O2 -o snake_engine.exe snake_engine.c
```

✅ 成功：沒有錯誤訊息，資料夾內出現 `snake_engine.exe`  
❌ 出現 `error:` 訊息：
- 確認 `snake_engine.c` 在 `native\` 資料夾內
- 確認 gcc 版本 ≥ 9（`gcc --version`）

---

### ❹ 安裝 Python 套件

```cmd
python -m pip install flask
```

或完整安裝：

```cmd
python -m pip install -r requirements.txt
```

❌ pip 連不上網路 / 公司/學校有防火牆：

```cmd
python -m pip install flask --trusted-host pypi.org --trusted-host files.pythonhosted.org
```

---

### ❺ Port 5001 被佔用

啟動時若出現 `Address already in use` 或 `OSError: [WinError 10048]`：

**查看哪個程式佔用 5001：**

```cmd
netstat -ano | findstr :5001
```

**強制終止（把 PID 換成上面查到的數字）：**

```cmd
taskkill /PID 你的PID /F
```

然後重新執行 `python app.py`。

---

### ❻ 路徑含有中文或空格

如果你的下載路徑是像 `C:\Users\王小明\Downloads\snake`（含中文）或 `C:\My Projects\snake`（含空格），`run.bat` 可能出錯。

**解法：** 把整個 `snake` 資料夾搬到 `C:\snake`，再執行：

```cmd
cd /d C:\snake
run.bat
```

---

### ❼ 瀏覽器開啟後畫面空白 / 無法連線

1. 確認 CMD 視窗還開著（關掉就代表伺服器停了）
2. 確認網址是 `http://127.0.0.1:5001`（不是 https，不是 5000）
3. 防火牆詢問時選「允許存取」
4. 試試用 **Edge** 或 **Chrome** 開啟（不要用 IE）

---

### ❽ 完整重置（以上都試過還是不行）

```cmd
cd /d C:\snake\native
del snake_engine.exe
cd ..
python -m pip install --upgrade flask
python -m pip install -r requirements.txt
cd native
gcc -std=c11 -O2 -o snake_engine.exe snake_engine.c
cd ..
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

## 📋 常見錯誤對照表

| 錯誤訊息 | 原因 | 解法 |
|---|---|---|
| `'gcc' 不是內部或外部命令` | MinGW 未安裝或未加 PATH | 見 ❷ |
| `ModuleNotFoundError: No module named 'flask'` | Flask 未安裝 | 見 ❹ |
| `OSError: [WinError 10048]` | Port 5001 被佔用 | 見 ❺ |
| `snake_engine.exe` 不存在 | C 未編譯 | 見 ❸ |
| 畫面空白 / ERR_CONNECTION_REFUSED | 伺服器未啟動 | 確認 CMD 視窗還在執行 |
| Build failed（run.bat 內） | gcc 找不到 | 見 ❷，重開 CMD 再試 |

---

## 授權

Educational project — 期末專題用途。
