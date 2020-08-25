#!/bin/sh
temppath=`pwd`
while read linemsg
do
    key=$(echo $linemsg | cut -d = -f 1)
    value=$(echo $linemsg | cut -d = -f 2-)
#       key=`awk -F "=" '{echo $1}' $linemsg`   
#       value=`awk -F "=" '{ if($3){echo $2"="$3}else{echo $2} }' $linemsg`
#       echo $key $value
if [ "$key" = "JAVA_OPTIONS" ];then
    JAVA_OPTIONS=$value
elif [ "$key" = "JAVA_OPTIONS_SEARCH" ];then
    JAVA_OPTIONS_SEARCH=$value
elif [ "$key" = "eurekaip" ];then
    eurekaip=$value
elif [ "$key" = "vsburl" ];then
    vsburl=$value
elif [ "$key" = "datasourcesystem" ];then
    datasourcesystem=$value
elif [ "$key" = "datasourcesearch" ];then
    datasourcesearch=$value
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


nohup ${temppath}/${javapath}/java ${JAVA_OPTIONS_SEARCH}  -jar ${temppath}/jar/app-search-0.0.1.jar  ${eurekaip} ${vsburl} ${datasourcesearch} ${datasourceusername} ${datasourcepwd} ${rabbitmq} ${redis}  ${esconfigusername} ${esconfigpassword} ${esconfighosts}  > /dev/null  2>&1  &

echo "----------------------------------------------------------------------------------------"
check_search_start(){
    search_started_status=0
    n=1
    echo "try $n times serch service starting"
    while true
    do
        if test $n -gt 20; then
            echo "search service failed"
            search_started_status=1
            break
        fi
        sleep 10
        n=$(($n+1))
        echo "try $n times search service starting "
        port=`netstat -lntp | egrep "18201" | wc -l`
        if [ $port -eq 0 ]; then
            echo "search service is started"
            break;
        fi
    done
}

check_search_start

if [ $search_started_status -ne 0 ]; then
    echo "search service start failed"
    exit 1
else 
    echo "search service start success"
fi


