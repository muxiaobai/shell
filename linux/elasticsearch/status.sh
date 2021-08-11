#!/bin/bash




temppath=`pwd`
# ip_file
IP_file="${temppath}/config/ip.txt"
if [ -e  "$IP_file" ];then
    echo -e "\033[1;32;40mINFO: IP file is exist \033[0m" 
else 
    echo -e "\033[1;31;40mERROR: IP file is not exist \033[0m"
    exit 2
fi



status_ip=$(echo `awk -F":" '/master/{print $1}' ${IP_file}` | awk -F " " '{print $1}')
#echo "$reset_ip"

status_port=$(echo `awk -F":" '/master/{print $2}' ${IP_file}` | awk -F " " '{print $1}')


#echo "curl -u \"elastic:elasticsearch_pwd@*))\" http://${status_ip}:19200/_cat/health?v"
resp=`curl -u "elastic:elasticsearch_pwd@*))" http://${status_ip}:19200/_cat/health?v`
echo $resp
green=`echo $resp| grep green`
yellow=`echo $resp| grep yellow`
if [ "${green}" != "" ];then
    echo -e "\033[1;32;40m elasticsearch cluster  is green  \033[0m" 
    exit 0
fi
if [ "${yellow}" != "" ];then 
    echo -e "\033[1;33;40m elasticsearch cluster  is yellow  \033[0m" 
    exit 2
else 
    echo -e "\033[1;31;40m elasticsearch cluster  is red \033[0m" 
    exit 1
fi



