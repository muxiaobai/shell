@echo off
for /f "tokens=5" %%i in ('netstat -aon ^| findstr ":18003"') do (
    set n=%%i
)
echo %n%
taskkill /f /pid %n%
pause
