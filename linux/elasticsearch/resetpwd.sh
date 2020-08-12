#!/bin/bash

temppath=`pwd`
# config_file
configfile=${temppath}/config/config.conf
while read linemsg
do
    key=$(echo $linemsg | cut -d = -f 1)
    value=$(echo $linemsg | cut -d = -f 2-)
if [ "$key" = "copykey" ];then
    copykey=$value
elif [ "$key" = "dist_path" ];then
    dist_path=$value
fi
done < ${configfile}

if [ ! -n "${copykey}"  ];then
 copykey=false
fi

if [ ! -n "${dist_path}"  ];then
 dist_path=~/file
fi

# ip_file
IP_file="${temppath}/config/ip.txt"
if [ -e  "$IP_file" ];then
    echo -e "\033[1;32;40mINFO: IP file is exist \033[0m" 
else 
    echo -e "\033[1;31;40mERROR: IP file is not exist \033[0m"
    exit 2
fi

echo "------------------------------------------ reset pwd"

reset_ip=$(echo `awk -F":" '/master/{print $1}' ${IP_file}` | awk -F " " '{print $1}')
#echo "$reset_ip"

reset_port=$(echo `awk -F":" '/master/{print $2}' ${IP_file}` | awk -F " " '{print $1}')
echo "ssh -p ${reset_port} root@${reset_ip} \"cd ~; cd ${dist_path};chmod +x ${dist_path}/resetpwd.sh;${dist_path}/resetpwd.sh ${reset_ip}  ${dist_path};\""
ssh -p ${reset_port} root@${reset_ip} "cd ~; cd ${dist_path};chmod +x ${dist_path}/resetpwd.sh;${dist_path}/resetpwd.sh ${reset_ip}  ${dist_path};"
if [ $? -eq 0 ];then
    echo -e "\033[1;32;40m${IP} ssh resetpwd shell is success,path:${dist_path} \033[0m" 
else 
    echo -e "\033[1;31;40m${IP} ssh resetpwd shell is failed,path: ${dist_path}  \033[0m" 
    exit 1
fi

