#!/bin/sh

curuser=`id -u`
if [ "$curuser" -ne "0" ];then
    echo "ERROR: you are not the root!" 
    exit 1
fi

if [ ! -n "$1" ];then
    echo "This Shell script execution needs to specify a parameter, The parameter is local IP address."
    echo "Usage: "
    echo -ne "\t For example:  sh `basename $0` 192.168.1.100 /opt/demo/elasticsearch master/slave master_ip all_ip "
    echo -ne "\n"
    exit 1
fi
if [ ! -n "$2" ];then
    echo "This Shell script execution needs to specify a parameter, The parameter is remote elasticsearch path."
    echo "Usage: "
    echo -ne "\t For example:  sh `basename $0` 192.168.1.100 /opt/demo/elasticsearch master/slave master_ip all_ip"
    echo -ne "\n"
    exit 1
fi

#port=`/sbin/ifconfig -a|grep inet|grep -v 127.0.0.1|grep -v inet6|awk '{print $2}'|tr -d "addr:"`

#elasticsearchip=$port

elasticsearchip=$1
elasticsearchName="elasticsearch-7.5.0"
apppath=$2
node=$3
master_ip=$4
all_ip=$5
service_url=$6
#if [ -d "$apppath" ]; then
    #tar -czvf  /opt/demo/elasticsearch_`date \"+%Y%m%d%H%M%S\"`.tar.gz -C /opt/demo elasticsearch/
#    rm -rf $apppath
#fi
echo -e "\033[1;32;40m install `basename $0` $1 $2  \033[0m "
# base prop
base_config(){
    if grep -q "vm.max_map_count = 262144" /etc/sysctl.conf; then
        echo "vm.max_map_count= 262144"
    else
        echo 'vm.max_map_count = 262144' >>/etc/sysctl.conf
        sysctl -p
    fi
   
    if grep -q "root     hard  nofile    65536" /etc/security/limits.conf; then
        echo "hard nofile 65536"
    else
        echo 'root     hard  nofile    65536' >>/etc/security/limits.conf
        echo 'root     soft  nofile    65536' >>/etc/security/limits.conf
        echo '*        hard  nofile   65536' >>/etc/security/limits.conf
        echo '*        soft  nofile   65536' >>/etc/security/limits.conf
    fi
  
    if grep -q "elasticsearch" /etc/passwd; then
        echo "elasticsearch user has been created"
    else
        useradd elasticsearch
    fi
}
origin_file(){
tar -xzvf ${apppath}/$elasticsearchName.tar.gz -C ${apppath}
ES_HOME=$apppath/$elasticsearchName
mkdir -p $ES_HOME
#cp -rf ${apppath}/$elasticsearchName ${ES_HOME}
#mv  ${apppath}/$elasticsearchName/ ${ES_HOME}
}

change_config(){


echo $master_ip
echo $all_ip

#master_nodes="\"192.168.160.71\""
# "ip","ip"
OLD_IFS="$IFS" 
IFS=" " 
arr=($master_ip) 
IFS="$OLD_IFS" 
master_nodes=""
for s in ${arr[@]} 
do    
  master_nodes="${master_nodes}\"$s\""  
done

master_nodes="${master_nodes//\"\"/\",\"}"
echo $master_nodes

#all_nodes "ip:19200","ip:19200","ip:19200"
all_nodes=""
OLD_IFS="$IFS" 
IFS=" " 
arr=($all_ip) 
IFS="$OLD_IFS" 

for s in ${arr[@]} 
do 
 all_nodes="${all_nodes}\"$s:19300\""
done


all_nodes="${all_nodes//\"\"/\",\"}"
echo "$all_nodes"
# http://192.168.120.83:18201
#service_ip=

#all_nodes="\"192.168.160.71:19200\",\"192.168.160.72:19200\",\"192.168.160.73:19200\""
if [ "${node}"x = "master"x ];then
    sed -i "s@node.master: true@node.master: true@g" $ES_HOME/config/elasticsearch.yml
    sed -i "s@node.data: false@node.data: false@g" $ES_HOME/config/elasticsearch.yml
else
    sed -i "s@node.master: true@node.master: false@g" $ES_HOME/config/elasticsearch.yml
    sed -i "s@node.data: false@node.data: true@g" $ES_HOME/config/elasticsearch.yml
fi
    
    sed -i "s@node.name: master@node.name: $elasticsearchip@g" $ES_HOME/config/elasticsearch.yml
    sed -i "s@network.host: 192.168.120.83@network.host: $elasticsearchip@g" $ES_HOME/config/elasticsearch.yml
    sed -i "s@http.port: 9200@http.port: 19200@g" $ES_HOME/config/elasticsearch.yml
    sed -i "s@transport.tcp.port: 9300@transport.tcp.port: 19300@g" $ES_HOME/config/elasticsearch.yml
    sed -i "s@cluster.initial_master_nodes: \[\"master\"\]@cluster.initial_master_nodes: \[${master_nodes}\]@g" $ES_HOME/config/elasticsearch.yml
    sed -i "s@discovery.zen.ping.unicast.hosts: \[\"192.168.120.83:9300\",\"192.168.120.83:9301\",\"192.168.120.83:9302\"\]@discovery.zen.ping.unicast.hosts: \[${all_nodes}\]@g" $ES_HOME/config/elasticsearch.yml
    sed -i "s@root=E:/tools/elk/elasticsearch-7.5.0-master/plugins/elasticsearch-analysis-hanlp-7.5.0/@root=/$ES_HOME/plugins/elasticsearch-analysis-hanlp-7.5.0@g" $ES_HOME/config/analysis-hanlp/hanlp.properties
    sed -i "s@http://192.168.160.23:18201/dict@${service_url}/dict@g" $ES_HOME/config/analysis-hanlp/hanlp-remote.xml
    sed -i "s@http://192.168.160.23:18201/stop_words@${service_url}/stop_words@g" $ES_HOME/config/analysis-hanlp/hanlp-remote.xml
    
    sed -i "s@xpack.security.enabled: true@xpack.security.enabled: true@g" $ES_HOME/config/elasticsearch.yml
    sed -i "s@-Xms2g@-Xms1g@g" $ES_HOME/config/jvm.options
    sed -i "s@-Xmx2g@-Xmx1g@g" $ES_HOME/config/jvm.options

   echo "  $ES_HOME config change  ok end"
}

install_cert(){
    chown -R elasticsearch:elasticsearch ${apppath}/elastic-certificates.p12
    cp ${apppath}/elastic-certificates.p12 $ES_HOME/config     
    chown -R -h elasticsearch:elasticsearch $ES_HOME
   echo "  $ES_HOME cert chown  ok end"
}
install_elasticsearch(){
base_config
origin_file
change_config
install_cert

rm -rf ${apppath}/${elasticsearchName}.tar.gz

}

install_elasticsearch
gen_start_shell(){
    echo -e "\033[1;32;40mgen shell start/resetpwd/shutdown start .\033[0m"
    if [ ! -f "$apppath/start.sh" ]; then
        touch $apppath/start.sh
        chmod +x $apppath/start.sh
        echo "#!/bin/sh">> $apppath/start.sh
        echo "# Start ES..." >>$apppath/start.sh
        echo "su - elasticsearch -c \"$ES_HOME/bin/elasticsearch -d\"" >> $apppath/start.sh
 cat >> $apppath/start.sh <<EOF
    
    started=0
    n=1
    echo "try \$n times elasticsearch service starting"
    while true
    do
        if test \$n -gt 20
        then
            echo "elasticsearch service failed"
            started=1
            break
        fi
        sleep 10
        n=\$((\$n+1))
        echo "try \$n times elasticsearch service starting "
        port=\`netstat -lntp | grep "19200"| wc -l\`
        if [ \${#port} -gt 0 ]; then
            echo "elasticsearch service is started"
            break;
        fi
    done
   
    if  [ \$started -ne 0 ]; then
	exit 1
    fi
EOF

fi

    echo -e "\033[1;32;40mgen shell start success .\033[0m"
    if [ ! -f "$apppath/shutdown.sh" ]; then
        touch $apppath/shutdown.sh
        chmod +x $apppath/shutdown.sh
        echo "#!/bin/sh">> $apppath/shutdown.sh
        echo "# Stop ES..." >>$apppath/shutdown.sh

        echo "netstat -tlnp | grep 19200 | awk '{print \$7}' | awk -F "/" '{print \$1}' | xargs kill">> $apppath/shutdown.sh
        echo "netstat -tlnp | grep 19300 | awk '{print \$7}' | awk -F "/" '{print \$1}' | xargs kill">> $apppath/shutdown.sh
    fi

    echo -e "\033[1;32;40mgen shell shutdown success.\033[0m"
   if [ ! -f "$apppath/resetpwd.sh" ]; then
        touch $apppath/resetpwd.sh
        chmod +x $apppath/resetpwd.sh
 
cat >> ${apppath}/resetpwd.sh <<EOF
    #!/bin/sh
    curuser=\`id -u\`
    if [ "\$curuser" -ne "0" ];then
        echo "ERROR: you are not the root!"
        exit 1
    fi

    # reset pwd...
    echo "start reset pwd"
    ${ES_HOME}/bin/elasticsearch-users useradd my_admin -p my_password -r superuser
    if [ \$? -eq 0 ];then
    echo "add user success"
    fi
    sleep 5
    curl -H "Content-Type:application/json" -XPOST -u "my_admin:my_password" http://${elasticsearchip}:19200/_xpack/security/user/elastic/_password -d '{ "password" : "elasticsearch_pwd@*))" }'
    if [ \$? -eq 0 ];then
    echo "update elastic pwd"
    fi
    curl -u "elastic:elasticsearch_pwd@*))" http://${elasticsearchip}:19200/_cat/health?v
    echo \$?
    ${ES_HOME}/bin/elasticsearch-users userdel my_admin
    echo \$?
EOF
fi
  echo -e "\033[1;32;40mgen shell resetpwd success.\033[0m"
}
gen_start_shell


