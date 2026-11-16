@echo off
chcp 65001 > nul
echo ========================================================
echo  KHOI DONG HE THONG QUAN LY CUA HANG BACH HOA (qlCuaHang4)
echo ========================================================
echo.
echo [1/2] Dang kiem tra va don dep tien trinh cu tren cong 8080...
for /f "tokens=5" %%a in ('netstat -aon ^| findstr :8080 ^| findstr LISTENING') do (
    echo Tat tien trinh PID %%a
    taskkill /f /pid %%a >nul 2>&1
)
echo.
echo [2/2] Dang khoi dong Web Server...
echo.
echo ========================================================
echo   Web dang chay tai: http://localhost:8080/
echo   Moi lan thoat cua so nay hoac tat server, phien
echo   dang nhap se duoc reset va yeu cau dang nhap lai.
echo ========================================================
echo.
python app.py
pause
