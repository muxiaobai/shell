#!/bin/sh


cat /logs/log_info.log | grep xxx | cut -c 24- | uniq -c | sort -rn | head -n 20

egrep "xxx|xxx" 或者匹配
cut -c 24-  从第24列进行截取到最后一位  -c 按照字符 默认从1开始
uniq -c 去重 生成    数量  数据 两列
sort -r 倒序 -n 按数字  -h k/b/m/g排序   -k 2/4 第几列
sort -r 按照第一行进行排序

head -n 20 输出前20行

cat /logs/log_info.log | grep xxx | cut -c 24- | uniq -c | sort -rn | wc

wc 统计结果 行数 word数 字符数

cat /logs/log_info.log | grep xxx | cut -c 24- | uniq -c | awk '{print $1}'

awk '{print $1}' 以空格分隔 输出第一列 -F "/" 以/分隔

awk '{num +=$1}END{print num}'  打印第一列的数字和

# 大于500M的文件，按数值大小倒序
find . -type f -size +500M  -print0 | xargs -0 du -h | sort -rh

#crontab -e
#将auto-del-30-days-ago-log.sh执行脚本加入到系统计划任务，到点自动执行  凌晨0点10分
#10 0 * * * /opt/soft/log/auto-del-7-days-ago-log.sh >/dev/null 2>&1