echo start 

echo idea START
start /d "E:\Program Files\JetBrains\IntelliJ IDEA 2019.1.2\bin" idea64.exe

echo VS CODE START
start /d "E:\tools\Microsoft VS Code" code.exe

echo Chrome START
start /d "C:\Program Files (x86)\Google\Chrome\Application" chrome.exe

echo cloudmusic START
start /d "C:\Program Files (x86)\Netease\CloudMusic" cloudmusic.exe

echo javaw START
start /d  "E:\workspace\idea\app-cloud\" taskrunjavaw.bat

echo javaw START
start /d  "E:\tools\nginx-1.14.2\" nginx.exe  -c conf/nginx.conf

exit