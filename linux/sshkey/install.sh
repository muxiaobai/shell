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
elif [ "$key" = "run_shell" ];then
    run_shell=$value
elif [ "$key" = "service_url" ];then
    service_url=$value
fi
done < ${configfile}

if [ ! -n "${copykey}"  ];then
 copykey=false
fi

if [ ! -n "${dist_path}"  ];then
 dist_path=~/file
fi

if [ ! -n "${run_shell}"  ];then
 run_shell=" echo \"hello\" "
fi
# ip_file
IP_file="${temppath}/config/ip.txt"
if [ -e  "$IP_file" ];then
    echo -e "\033[1;32;40mINFO:IP file is exist \033[0m" 
else 
    echo -e "\033[1;31;40mERROR:IP file is not exist \033[0m"
    exit 2
fi

expect_status=`rpm -q expect | wc -l`
if [ $expect_status -eq 0 ];then
${temppath}/bin/check_net_status.sh
if [ $? -ne 0 ];then
    echo -e "\033[1;31;40mERROR:NETWORK  \033[0m"
exit 1
fi
yum -y install expect 
fi

# ssh key gen
gensshkey(){
${temppath}/bin/gensshkey.exp 
}
# copy ssh key 
# and sftp file to other host
copysshkey(){
for i in $(cat ${IP_file})
do 
IP=$(echo "${i}" |awk -F":" '{print $1}')  
PORT=$(echo "${i}" |awk -F":" '{print $2}')  
USER=$(echo "${i}" |awk -F":" '{print $3}')  
PW=$(echo "${i}" |awk -F":" '{print $4}')
${temppath}/bin/copysshkey.exp $IP $PW $PORT
#echo "------${IP} ${PW}"
if [ $? -eq 0 ];then 
  echo "----------------------$IP add sshkey is ok " 
else
  echo "----------------------$IP add sshkey failed" 
fi
done
}

if [ $copykey == "true" ];then
  echo "gen sshkey and copy sshkey "
  gensshkey
  copysshkey
  sed -i "s@copykey=true@copykey=false@g" ${configfile}
# change file copykey=false
else
  echo "sshkey been copied"
  #sed -i "s@copykey=false@copykey=true@g" ${configfile}
fi

# ssh aotologin success 

beforescp(){

${temppath}/file/gencert.sh ${temppath}/file

}
beforescp
# and sftp file to other hos
if [ $? -eq 0 ];then
    echo -e "\033[1;32;40mINFO `basename $0` before scp file,run gencert.sh path: ${temppath} success \033[0m" 
else 
    echo -e "\033[1;31;40mERROR `basename $0`  before scp file,run gencert.sh path: ${temppath} failed \033[0m" 
    exit 2
fi

echo "------------------------------------------start scp file"
# -r file system copy
for j in $(cat ${IP_file})
do 
IP=$(echo "${j}" |awk -F":" '{print $1}') 
PORT=$(echo "${j}" |awk -F":" '{print $2}')  
 
ssh -p ${PORT} root@${IP} "netstat -tlnp | grep 19200 | awk '{print \$7}' | awk -F / '{print \$1}' | xargs kill;rm -rf ${dist_path};mkdir -p ${dist_path};"
echo $?
echo "scp -P 22 -v  ${temppath}/file/* root@${IP}:${dist_path}"
scp -P 22 -v  ${temppath}/file/* root@${IP}:${dist_path}
if [ $? -eq 0 ];then
    echo -e "\033[1;32;40m${IP} scp source_path: ${temppath}/file/* success,dist_path: ${dist_path} \033[0m" 
else 
    echo -e "\033[1;31;40m${IP} scp source_path: ${temppath}/file/* failed,dist_path:${dist_path} \033[0m" 
    exit 2
fi

done


# need params   master-node-ip  all-ip
master_ip=$(echo `awk -F":" '/master/{print $1}' ${IP_file}`)
echo $master_ip
all_ip=$(echo `awk -F":" '{print $1}' ${IP_file}`)
if [ -z "$master_ip" ];then
echo "this app has not mater node"
    echo -e "\033[1;31;40mERROR:this app has not mater node,master_ip: ${master_ip} \033[0m" 
    echo -e "\033[1;31;40m      please insert ${IP_file} Usage: ip:port:user:pwd:master/slave  \033[0m" 
    exit 1
fi
if [ -z "$all_ip" ];then
    echo -e "\033[1;31;40mERROR:this app has not node , all_ip: ${all_ip} \033[0m" 
    echo -e "\033[1;31;40m      please insert ${IP_file} Usage: ip:port:user:pwd:master/slave  \033[0m" 
    exit 1
fi


echo $all_ip
echo "------------------------------------------install & gen start/shutdown shell" 
for j in $(cat ${IP_file})
do 
IP=$(echo "${j}" |awk -F":" '{print $1}')  
PORT=$(echo "${j}" |awk -F":" '{print $2}')  
PW=$(echo "${j}" |awk -F":" '{print $4}')
NODE=$(echo "${j}" |awk -F":" '{print $5}')
echo "ssh -p ${PORT} root@${IP} \"cd ~; cd ${dist_path};chmod +x ${dist_path}/install.sh;${dist_path}/install.sh ${IP} ${dist_path} ${NODE} \"${master_ip}\" \"${all_ip}\" ;\""
ssh -p ${PORT} root@${IP} "cd ~; cd ${dist_path};chmod +x ${dist_path}/install.sh;${dist_path}/install.sh ${IP} ${dist_path} ${NODE} \"${master_ip}\" \"${all_ip}\" ${service_url} ;"
#${temppath}/bin/autologinshell.exp ${IP} ${PW} ${dist_path}/install.sh

if [ $? -eq 0 ];then
    echo -e "\033[1;32;40m${IP} ssh install shell is success,path:${dist_path} \033[0m" 
else 
    echo -e "\033[1;31;40m${IP} ssh install shell is failed,path: ${dist_path}  \033[0m" 
    exit 1
fi
done

${temppath}/start.sh
if [ $? -eq 0 ];then
    echo -e "\033[1;32;40mssh start shell is success,path:${dist_path} \033[0m" 
else 
    echo -e "\033[1;31;40mssh start shell is failed,path: ${dist_path}  \033[0m" 
    exit 1
fi

#echo "------------------------------------------ start"
#for j in $(cat ${IP_file})
#do 
#IP=$(echo "${j}" |awk -F":" '{print $1}')  
#PW=$(echo "${j}" |awk -F":" '{print $4}')
#ssh -p 22 root@${IP} "cd ~; cd ${dist_path};chmod +x ${dist_path}/start.sh;${dist_path}/start.sh ${IP} ${dist_path} ;"

#if [ $? -eq 0 ];then
#    echo -e "\033[1;32;40m ${IP} ssh start shell is success,path:${dist_path} \033[0m" 
#else 
#    echo -e "\033[1;31;40m ${IP} ssh start shell is failed,path: ${dist_path}  \033[0m" 
#    exit 1
#fi
#done
sleep 10
${temppath}/resetpwd.sh
if [ $? -eq 0 ];then
    echo -e "\033[1;32;40mssh resetpwd shell is success,path:${dist_path} \033[0m" 
else 
    echo -e "\033[1;31;40mssh resetpwd shell is failed,path: ${dist_path}  \033[0m" 
    exit 1
fi
#echo "------------------------------------------ reset pwd"
# $master_ip
#reset_ip="192.168.160.71"

#echo "ssh -p 22 root@${reset_ip} \"cd ~; cd ${dist_path};chmod +x ${dist_path}/resetpwd.sh;${dist_path}/resetpwd.sh ${reset_ip}  ${dist_path};\""
#ssh -p 22 root@${reset_ip} "cd ~; cd ${dist_path};chmod +x ${dist_path}/resetpwd.sh;${dist_path}/resetpwd.sh ${reset_ip}  ${dist_path};"
#if [ $? -eq 0 ];then
#    echo -e "\033[1;32;40m ${IP} ssh start shell is success,path:${dist_path} \033[0m" 
#else 
#    echo -e "\033[1;31;40m ${IP} ssh start shell is failed,path: ${dist_path}  \033[0m" 
#    exit 1
#fi

${temppath}/shutdown.sh
if [ $? -eq 0 ];then
    echo -e "\033[1;32;40mssh stop shell is success,path:${dist_path} \033[0m" 
else 
    echo -e "\033[1;31;40mssh stop shell is failed,path: ${dist_path}  \033[0m" 
    exit 1
fi
#echo "------------------------------------------ stop"
#for j in $(cat ${IP_file})
#do 
#IP=$(echo "${j}" |awk -F":" '{print $1}')  
#PW=$(echo "${j}" |awk -F":" '{print $4}')
#ssh -p 22 root@${IP} "cd ~; cd ${dist_path};chmod +x ${dist_path}/shutdown.sh;${dist_path}/shutdown.sh ${IP} ${dist_path} ;"

#if [ $? -eq 0 ];then
#    echo -e "\033[1;32;40m ${IP} ssh start shell is success,path:${dist_path} \033[0m" 
#else 
#    echo -e "\033[1;31;40m ${IP} ssh start shell is failed,path: ${dist_path}  \033[0m" 
#    exit 1
#fi
#done


