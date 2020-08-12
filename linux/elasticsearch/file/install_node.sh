#!/bin/sh

curuser=`id -u`
if [ "$curuser" -ne "0" ];then
    echo "ERROR: you are not the root!" 
    exit 1
fi

if [ ! -n "$1" ];then
    echo "This Shell script execution needs to specify a parameter, The parameter is local IP address."
    echo "Usage: "
    echo -ne "\t For example:  sh `basename $0` 192.168.1.100"
    echo -ne "\n"
    exit 1
fi
#port=`/sbin/ifconfig -a|grep inet|grep -v 127.0.0.1|grep -v inet6|awk '{print $2}'|tr -d "addr:"`

#elasticsearchip=$port

elasticsearchip=$1
elasticsearchName="elasticsearch-7.5.0"
apppath=/opt/openlab/elasticsearch
if [ -d "$apppath" ]; then
    #tar -czvf  /opt/openlab/elasticsearch_`date \"+%Y%m%d%H%M%S\"`.tar.gz -C /opt/openlab elasticsearch/
    rm -rf $apppath
fi
mkdir -p $apppath

install_elasticsearch(){
    # base prop
    if grep -q "vm.max_map_count = 262144" /etc/sysctl.conf; then
        echo ""
    else
        echo 'vm.max_map_count = 262144' >>/etc/sysctl.conf
        sysctl -p
    fi
   
    if grep -q "root     hard  nofile    65536" /etc/security/limits.conf; then
        echo ""
    else
        echo 'root     hard  nofile    65536' >>/etc/security/limits.conf
        echo 'root     soft  nofile    65536' >>/etc/security/limits.conf
        echo '*        hard  nofile   65536' >>/etc/security/limits.conf
        echo '*        soft  nofile   65536' >>/etc/security/limits.conf
    fi
  
    if grep -q "elasticsearch" /etc/passwd; then
        echo ""
    else
        useradd elasticsearch
    fi

    tar -zxvf $elasticsearchName.tar.gz

    # three nodes  master slave1 slave2
    master_ES_HOME=$apppath/$elasticsearchName-master

     cp -rf $elasticsearchName $master_ES_HOME

    sed -i "s@node.name: master@node.name: master@g" $master_ES_HOME/config/elasticsearch.yml
    sed -i "s@node.master: true@node.master: true@g" $master_ES_HOME/config/elasticsearch.yml
    sed -i "s@node.data: false@node.data: false@g" $master_ES_HOME/config/elasticsearch.yml
    sed -i "s@network.host: 192.168.120.83@network.host: $elasticsearchip@g" $master_ES_HOME/config/elasticsearch.yml
    sed -i "s@http.port: 9200@http.port: 19200@g" $master_ES_HOME/config/elasticsearch.yml
    sed -i "s@transport.tcp.port: 9300@transport.tcp.port: 19300@g" $master_ES_HOME/config/elasticsearch.yml
    sed -i "s@discovery.zen.ping.unicast.hosts: \[\"192.168.120.83:9300\",\"192.168.120.83:9301\",\"192.168.120.83:9302\"\]@discovery.zen.ping.unicast.hosts: \[\"$elasticsearchip:19300\",\"$elasticsearchip:19301\",\"$elasticsearchip:19302\"\]@g" $master_ES_HOME/config/elasticsearch.yml

    sed -i "s@root=E:/tools/elk/elasticsearch-7.5.0-master/plugins/elasticsearch-analysis-hanlp-7.5.0/@root=/$master_ES_HOME/plugins/elasticsearch-analysis-hanlp-7.5.0@g" $master_ES_HOME/config/analysis-hanlp/hanlp.properties
    sed -i "s@http://192.168.160.23:18201/dict@http://$elasticsearchip:18201/dict@g" $master_ES_HOME/config/analysis-hanlp/hanlp-remote.xml
    sed -i "s@http://192.168.160.23:18201/stop_words@http://$elasticsearchip:18201/stop_words@g" $master_ES_HOME/config/analysis-hanlp/hanlp-remote.xml
    
    if [ ! -d "/etc/elasticsearch" ]; then
        mkdir -p /etc/elasticsearch
        $master_ES_HOME/bin/elasticsearch-certutil ca -out /etc/elasticsearch/elastic-certificates.p12 -pass ""
        chown -R elasticsearch:elasticsearch  /etc/elasticsearch/elastic-certificates.p12
    fi
    cp /etc/elasticsearch/elastic-certificates.p12 $master_ES_HOME/config
     
    chown -R -h elasticsearch:elasticsearch $master_ES_HOME

    if [ ! -f "$apppath/start.sh" ]; then
        touch $apppath/start.sh
        chmod +x $apppath/start.sh
        echo "#!/bin/sh">> $apppath/start.sh
        echo "# Start ES..." >>$apppath/start.sh
        echo "su - elasticsearch -c \"$master_ES_HOME/bin/elasticsearch -d\"" >> $apppath/start.sh
    fi

    if [ ! -f "$apppath/shutdown.sh" ]; then
        touch $apppath/shutdown.sh
        chmod +x $apppath/shutdown.sh
        echo "#!/bin/sh">> $apppath/shutdown.sh
        echo "# Stop ES..." >>$apppath/shutdown.sh

        echo "netstat -tlnp | grep 19200 | awk '{print \$7}' | awk -F "/" '{print \$1}' | xargs kill">> $apppath/shutdown.sh
        echo "netstat -tlnp | grep 19300 | awk '{print \$7}' | awk -F "/" '{print \$1}' | xargs kill">> $apppath/shutdown.sh
    fi

    if grep -q "$master_ES_HOME/bin/elasticsearch -d" $apppath/start.sh; then
        echo ""
    else
        echo "su - elasticsearch -c \"$master_ES_HOME/bin/elasticsearch -d\"" >> $apppath/start.sh
        echo "netstat -tlnp | grep 19200 | awk '{print \$7}' | awk -F "/" '{print \$1}' | xargs kill">> $apppath/shutdown.sh
        echo "netstat -tlnp | grep 19300 | awk '{print \$7}' | awk -F "/" '{print \$1}' | xargs kill">> $apppath/shutdown.sh
    fi
    echo "cp $master_ES_HOME end"

    #slave1
    slave1_ES_HOME=$apppath/$elasticsearchName-slave1

    cp -rf $elasticsearchName $slave1_ES_HOME

    sed -i "s@node.name: master@node.name: slave1@g" $slave1_ES_HOME/config/elasticsearch.yml
    sed -i "s@node.master: true@node.master: false@g" $slave1_ES_HOME/config/elasticsearch.yml
    sed -i "s@node.data: false@node.data: true@g" $slave1_ES_HOME/config/elasticsearch.yml
    sed -i "s@network.host: 192.168.120.83@network.host: $elasticsearchip@g" $slave1_ES_HOME/config/elasticsearch.yml
    sed -i "s@http.port: 9200@http.port: 19500@g" $slave1_ES_HOME/config/elasticsearch.yml
    sed -i "s@transport.tcp.port: 9300@transport.tcp.port: 19301@g" $slave1_ES_HOME/config/elasticsearch.yml
    sed -i "s@discovery.zen.ping.unicast.hosts: \[\"192.168.120.83:9300\",\"192.168.120.83:9301\",\"192.168.120.83:9302\"\]@discovery.zen.ping.unicast.hosts: \[\"$elasticsearchip:19300\",\"$elasticsearchip:19301\",\"$elasticsearchip:19302\"\]@g" $slave1_ES_HOME/config/elasticsearch.yml

    sed -i "s@root=E:/tools/elk/elasticsearch-7.5.0-master/plugins/elasticsearch-analysis-hanlp-7.5.0/@root=/$slave1_ES_HOME/plugins/elasticsearch-analysis-hanlp-7.5.0@g" $slave1_ES_HOME/config/analysis-hanlp/hanlp.properties
    sed -i "s@http://192.168.160.23:18201/dict@http://$elasticsearchip:18201/dict@g" $slave1_ES_HOME/config/analysis-hanlp/hanlp-remote.xml
    sed -i "s@http://192.168.160.23:18201/stop_words@http://$elasticsearchip:18201/stop_words@g" $slave1_ES_HOME/config/analysis-hanlp/hanlp-remote.xml
    
    cp /etc/elasticsearch/elastic-certificates.p12 $slave1_ES_HOME/config
    chown -R elasticsearch:elasticsearch $slave1_ES_HOME

    if grep -q "$slave1_ES_HOME/bin/elasticsearch -d" $apppath/start.sh; then
        echo ""
    else
        echo "su - elasticsearch -c \"$slave1_ES_HOME/bin/elasticsearch -d\"" >> $apppath/start.sh
        echo "netstat -tlnp | grep 19500 | awk '{print \$7}' | awk -F "/" '{print \$1}' | xargs kill">> $apppath/shutdown.sh
        echo "netstat -tlnp | grep 19301 | awk '{print \$7}' | awk -F "/" '{print \$1}' | xargs kill">> $apppath/shutdown.sh

    fi
    echo "cp $slave1_ES_HOME end"

    #slave2
    slave2_ES_HOME=$apppath/$elasticsearchName-slave2

    cp -rf $elasticsearchName $slave2_ES_HOME

    sed -i "s@node.name: master@node.name: slave2@g" $slave2_ES_HOME/config/elasticsearch.yml
    sed -i "s@node.master: true@node.master: false@g" $slave2_ES_HOME/config/elasticsearch.yml
    sed -i "s@node.data: false@node.data: true@g" $slave2_ES_HOME/config/elasticsearch.yml
    sed -i "s@network.host: 192.168.120.83@network.host: $elasticsearchip@g" $slave2_ES_HOME/config/elasticsearch.yml
    sed -i "s@http.port: 9200@http.port: 19700@g" $slave2_ES_HOME/config/elasticsearch.yml
    sed -i "s@transport.tcp.port: 9300@transport.tcp.port: 19302@g" $slave2_ES_HOME/config/elasticsearch.yml
    sed -i "s@discovery.zen.ping.unicast.hosts: \[\"192.168.120.83:9300\",\"192.168.120.83:9301\",\"192.168.120.83:9302\"\]@discovery.zen.ping.unicast.hosts: \[\"$elasticsearchip:19300\",\"$elasticsearchip:19301\",\"$elasticsearchip:19302\"\]@g" $slave2_ES_HOME/config/elasticsearch.yml

    sed -i "s@root=E:/tools/elk/elasticsearch-7.5.0-master/plugins/elasticsearch-analysis-hanlp-7.5.0/@root=$slave2_ES_HOME/plugins/elasticsearch-analysis-hanlp-7.5.0@g" $slave2_ES_HOME/config/analysis-hanlp/hanlp.properties
    sed -i "s@http://192.168.160.23:18201/dict@http://$elasticsearchip:18201/dict@g" $slave2_ES_HOME/config/analysis-hanlp/hanlp-remote.xml
    sed -i "s@http://192.168.160.23:18201/stop_words@http://$elasticsearchip:18201/stop_words@g" $slave2_ES_HOME/config/analysis-hanlp/hanlp-remote.xml
        
    cp /etc/elasticsearch/elastic-certificates.p12 $slave2_ES_HOME/config

    chown -R elasticsearch:elasticsearch $slave2_ES_HOME
    
    if grep -q "$slave2_ES_HOME/bin/elasticsearch -d" $apppath/start.sh; then
        echo ""
    else
        echo "su - elasticsearch  -c \"$slave2_ES_HOME/bin/elasticsearch -d\"" >> $apppath/start.sh
        echo "netstat -tlnp | grep 19700 | awk '{print \$7}' | awk -F "/" '{print \$1}' | xargs kill">> $apppath/shutdown.sh
        echo "netstat -tlnp | grep 19302 | awk '{print \$7}' | awk -F "/" '{print \$1}' | xargs kill">> $apppath/shutdown.sh
    fi
    echo "cp $slave2_ES_HOME end"

    chown -R elasticsearch:elasticsearch $apppath
    
    #remove tar file
    rm -rf  $elasticsearchName

    if  $master_ES_HOME/bin/elasticsearch-users list | grep -q "my_admin" ; then
        echo "my_admin exist"
    else
        $master_ES_HOME/bin/elasticsearch-users useradd my_admin -p my_password -r superuser
    fi
    
    #starting 
    su - elasticsearch -c " $master_ES_HOME/bin/elasticsearch -d "
    su - elasticsearch -c " $slave1_ES_HOME/bin/elasticsearch -d "
    su - elasticsearch -c " $slave2_ES_HOME/bin/elasticsearch -d "

    started=0
    n=1
    echo "try $n times elasticsearch service starting"
    while true
    do
        if test $n -gt 20
        then
            echo "elasticsearch service failed"
            started=1
            break
        fi
        sleep 10
        n=$(($n+1))
        echo "try $n times elasticsearch service starting "
        port=`netstat -lntp | egrep "19300|19301|19302"`
        if [ ${#port} -gt 2 ]; then
            echo "elasticsearch service is started"
            break;
        fi
    done
  
    if  [ $started -eq 0 ]; then
        echo "#!/bin/sh">> $apppath/resetpwd.sh
        echo "# reset pwd..." >>$apppath/resetpwd.sh
        echo "$master_ES_HOME/bin/elasticsearch-users useradd my_admin -p my_password -r superuser" >> $apppath/resetpwd.sh
        echo " echo $? " >> $apppath/resetpwd.sh
        echo "curl -H \"Content-Type:application/json\" -XPOST -u my_admin:my_password http://$elasticsearchip:19200/_xpack/security/user/elastic/_password -d '{ \"password\" : \"elasticsearch_2017@*))\" }'
       " >>  $apppath/resetpwd.sh
        echo " echo $? " >> $apppath/resetpwd.sh
        echo "curl -u \"elastic:elasticsearch_2017@*))\" http://$elasticsearchip:19200/_cat/health?v" >> $apppath/resetpwd.sh
        echo " echo $? " >> $apppath/resetpwd.sh
        echo "$master_ES_HOME/bin/elasticsearch-users userdel my_admin" >>  $apppath/resetpwd.sh
        echo " echo $? " >> $apppath/resetpwd.sh
        chmod +x $apppath/resetpwd.sh
        curl -H "Content-Type:application/json" -XPOST -u my_admin:my_password http://$elasticsearchip:19200/_xpack/security/user/elastic/_password -d '{ "password" : "elasticsearch_2017@*))" }'
        echo $?
        curl -u "elastic:elasticsearch_2017@*))" http://$elasticsearchip:19200/_cat/health?v
        echo $?
        $master_ES_HOME/bin/elasticsearch-users userdel my_admin
        echo $?
        #停止
        #ps -ef | grep elasticsearch.bootstrap | grep java | grep -v grep |awk '{print $2}' | xargs  kill
        echo " INFO:elasticsearch installed success.You can search, please have fun."
        echo " INFO: set elastic : curl -H \"Content-Type:application/json\" -XPOST -u my_admin:my_password http://$elasticsearchip:19200/_xpack/security/user/elastic/_password -d '{ \"password\" : \"elasticsearch_2017@*))\" }' "
        echo " INFO: please run cmd get lastest status : curl -u \"elastic:elasticsearch_2017@*))\" http://$elasticsearchip:19200/_cat/health?v "
        echo " INFO: you can start/stop elasticsearch use shell : $apppath/shutdown.sh  $apppath/start.sh"
        echo " INFO: resetpwd elasticsearch : $apppath/resetpwd.sh"
    else
        echo " WARN: Installed OK.but there are some problems with the startup."
        echo " WARN: set elastic : curl -H \"Content-Type:application/json\" -XPOST -u my_admin:my_password http://$elasticsearchip:19200/_xpack/security/user/elastic/_password -d '{ \"password\" : \"elasticsearch_2017@*))\" }' "
        echo " WARN: please run cmd get lastest status : curl -u \"elastic:elasticsearch_2017@*))\" http://$elasticsearchip:19200/_cat/health?v "
        echo " WARN: if status is not green; run again..."
    fi
}


install_elasticsearch
