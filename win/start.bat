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

echo pg_sql START
"E:\Program Files\VSBEdu\pgsql\bin\pg_ctl.exe"  -D "E:\Program Files\VSBEdu\pgsql\data" start

echo idea START
start /d "E:\Program Files\JetBrains\IntelliJ IDEA 2019.1.2\bin" idea64.exe

echo VS CODE START
start /d "E:\tools\Microsoft VS Code" code.exe

echo sublime START
start /d "E:\Program Files\Sublime Text 3" sublime_text.exe

echo Chrome START
start /d "C:\Program Files (x86)\Google\Chrome\Application" chrome.exe

echo cloudmusic START
start /d "E:\Program Files (x86)\Netease\CloudMusic" cloudmusic.exe


echo javaw START
rem start /d  "E:\workspace\idea\app-cloud\" taskrunjavaw.bat

echo nginx START
start /d  "E:\tools\nginx-1.14.2\" nginx.exe  -c conf/nginx.conf

echo dbeaver START
start /d  "E:\tools\dbeaver-ee-7.2.0-win32.win32.x86_64\dbeaver" dbeaver.exe

echo dbeaver START
start /d  "E:\tools\Redis-x64-3.2.100\" redis-server.exe --service-install redis.windows-service.conf --loglevel verbose

echo vmware START
rem "E:\Program Files (x86)\VMware\VMware Workstation\vmrun.exe" start "E:\Users\Administrator\Documents\Virtual Machines\CentOS-192.168.160.75\CentOS-192.168.160.75.vmx"

echo ES START
start /d "E:\tools\elk\elasticsearch-7.5.1-master\bin"  elasticsearch.bat

start /d "E:\tools\elk\elasticsearch-7.5.1-slave1\bin"  elasticsearch.bat

start /d "E:\tools\elk\kibana-7.5.1-windows-x86_64\bin"  kibana.bat

echo jupyter START
start  E:\ProgramData\Anaconda3\python.exe E:\ProgramData\Anaconda3\cwp.py E:\ProgramData\Anaconda3\envs\tensorflow E:\ProgramData\Anaconda3\envs\tensorflow\python.exe E:\ProgramData\Anaconda3\envs\tensorflow\Scripts\jupyter-notebook-script.py E:\workspace\git
pause