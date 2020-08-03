#!/bin/sh
find /opt/soft/log/ -mtime +30 -name "*.log" -exec rm -rf {} \;


#crontab -e
#将auto-del-30-days-ago-log.sh执行脚本加入到系统计划任务，到点自动执行
#10 0 * * * /opt/soft/log/auto-del-7-days-ago-log.sh >/dev/null 2>&1