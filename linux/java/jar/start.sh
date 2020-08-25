#!/bin/sh
temppath=`pwd`
while read linemsg
do
    key=$(echo $linemsg | cut -d = -f 1)
    value=$(echo $linemsg | cut -d = -f 2-)
#	key=`awk -F "=" '{echo $1}' $linemsg`	
#	value=`awk -F "=" '{ if($3){echo $2"="$3}else{echo $2} }' $linemsg`
#	echo $key $value
if [ "$key" = "JAVA_OPTIONS" ];then
    JAVA_OPTIONS=$value
elif [ "$key" = "JAVA_OPTIONS_DEMO" ];then
    JAVA_OPTIONS_DEMO=$value
elif [ "$key" = "eurekaip" ];then
    eurekaip=$value
elif [ "$key" = "vsburl" ];then
    vsburl=$value
elif [ "$key" = "datasourcesystem" ];then
    datasourcesystem=$value
elif [ "$key" = "datasourcedemo" ];then
    datasourcedemo=$value
elif [ "$key" = "datasourceusername" ];then
    datasourceusername=$value
elif [ "$key" = "datasourcepwd" ];then
    datasourcepwd=$value
elif [ "$key" = "rabbitmq" ];then
    rabbitmq=$value
elif [ "$key" = "redis" ];then
    redis=$value
elif [ "$key" = "javapath" ];then
    javapath=$value
elif [ "$key" = "fdfstracker" ];then
	fdfstracker=$value
elif [ "$key" = "esconfigusername" ];then
	esconfigusername=$value
elif [ "$key" = "esconfigpassword" ];then
	esconfigpassword=$value
elif [ "$key" = "esconfighosts" ];then
	esconfighosts=$value
fi

done < ${temppath}/config/conf.conf

echo "----------------------------------------------------------------------------------------"
nohup ${temppath}/${javapath}/java ${JAVA_OPTIONS}  -jar ${temppath}/jar/app-register-0.0.1.jar  ${eurekaip} > /dev/null  2>&1 &
echo "starting register"

check_start(){
    register_started_status=0
    n=1
    echo "try $n times app-register service starting"
    while true
    do
        if test $n -gt 20; then
            echo "app-register service failed"
            register_started_status=1
            break
        fi
        sleep 3
        n=$(($n+1))
        echo "try $n times app-register service starting "
        port=`netstat -lntp | egrep "18001" | wc -l`
        if [ $port -eq 1 ]; then
            echo "app-register service is started"
            break;
        fi
    done
}
check_start

if [ $register_started_status -ne 0 ]; then
    echo "app-register service start failed"
    exit 1
else 
    echo "app-register service start success"
fi

#nohup ${temppath}/${javapath}/java ${JAVA_OPTIONS} -jar ${temppath}/jar/app-gateway-0.0.1.jar ${eurekaip} ${datasourcesystem}  ${datasourceusername} ${datasourcepwd}  ${vsburl}  > ${temppath}/logs/app-gateway.log  2>&1  &
#nohup ${temppath}/${javapath}/java ${JAVA_OPTIONS} -jar ${temppath}/jar/app-auth-0.0.1.jar ${eurekaip} ${datasourcesystem}  ${datasourceusername} ${datasourcepwd} ${redis} ${rabbitmq}  ${vsburl}  > ${temppath}/logs/app-auth.log  2>&1 &
#nohup ${temppath}/${javapath}/java ${JAVA_OPTIONS} -jar ${temppath}/jar/app-system-0.0.1.jar ${eurekaip} ${datasourcesystem} ${datasourceusername} ${datasourcepwd}   ${redis} ${rabbitmq} ${vsburl}  > ${temppath}/logs/app-system.log  2>&1  &

nohup ${temppath}/${javapath}/java ${JAVA_OPTIONS} -jar ${temppath}/jar/app-gateway-0.0.1.jar ${eurekaip} ${datasourcesystem}  ${datasourceusername} ${datasourcepwd}  ${vsburl}  > /dev/null  2>&1  &
nohup ${temppath}/${javapath}/java ${JAVA_OPTIONS} -jar ${temppath}/jar/app-auth-0.0.1.jar ${eurekaip} ${datasourcesystem}  ${datasourceusername} ${datasourcepwd} ${redis} ${rabbitmq}  ${vsburl}  > /dev/null  2>&1 &
nohup ${temppath}/${javapath}/java ${JAVA_OPTIONS} -jar ${temppath}/jar/app-system-0.0.1.jar ${eurekaip} ${datasourcesystem} ${datasourceusername} ${datasourcepwd}   ${redis} ${rabbitmq} ${vsburl}  > /dev/null  2>&1  &


echo "----------------------------------------------------------------------------------------"

check_base_start(){
    base_started_status=0
    n=1
    echo "try $n times base service starting"
    while true
    do
        if test $n -gt 20; then
            echo "base service failed"
            base_started_status=1
            break
        fi
        sleep 10
        n=$(($n+1))
        echo "try $n times base service starting "
        port=`netstat -lntp | egrep "18002|18003|18005" | wc -l`
        if [ $port -eq 5 ]; then
            echo "base service is started"
            break;
        fi
    done
}

check_base_start

if [ $base_started_status -ne 0 ]; then
    echo "base service start failed"
    exit 1
else 
    echo "base service start success"
fi

nohup ${temppath}/${javapath}/java ${JAVA_OPTIONS_DEMO}  -jar ${temppath}/jar/app-demo-0.0.1.jar  ${eurekaip} ${vsburl} ${datasourcedemo} ${datasourceusername} ${datasourcepwd} ${rabbitmq} ${redis}  ${esconfigusername} ${esconfigpassword} ${esconfighosts}  > /dev/null  2>&1  &

echo "----------------------------------------------------------------------------------------"
check_search_start(){
    search_started_status=0
    n=1
    echo "try $n times demo service starting"
    while true
    do
        if test $n -gt 20; then
            echo "demo service failed"
            search_started_status=1
            break
        fi
        sleep 10
        n=$(($n+1))
        echo "try $n times demo service starting "
        port=`netstat -lntp | egrep "18201" | wc -l`
        if [ $port -eq 0 ]; then
            echo "demo service is started"
            break;
        fi
    done
}

check_search_start

if [ $search_started_status -ne 0 ]; then
    echo "demo service start failed"
    exit 1
else 
    echo "demo service start success"
fi

echo -ne "\n"
echo "base & demo start success"


