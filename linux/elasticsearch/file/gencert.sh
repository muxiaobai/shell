#!/bin/sh

curuser=`id -u`
if [ "$curuser" -ne "0" ];then
    echo "ERROR: you are not the root!" 
    exit 1
fi

if [ ! -n "$1" ];then
    echo "This Shell script execution needs to specify a parameter, The parameter is elasticsearch path."
    echo "Usage: "
    echo -ne "\t For example:  sh `basename $0` /root/ssh/file"
    echo -ne "\n"
    exit 1
fi
apppath=$1
elasticsearchName="elasticsearch-7.5.0"
#apppath=/root/ssh/file
#if [ -e ${apppath}/elastic-certificates.p12 ];then
#    echo -e "\033[1;32;40m INFO `basename $0` gen_elasticsearch_cert file ${apppath} success \033[0m" 
#    exit 0
#fi
gen_cert(){
    tar -zxvf ${apppath}/$elasticsearchName.tar.gz -C ${apppath}
    base_es_home=${apppath}/${elasticsearchName}     
    if [ -d /etc/elasticsearch ];then
    rm -rf /etc/elasticsearch
    fi     
    mkdir -p /etc/elasticsearch
    ${base_es_home}/bin/elasticsearch-certutil ca -out /etc/elasticsearch/elastic-certificates.p12 -pass ""
    cp /etc/elasticsearch/elastic-certificates.p12 ${apppath} 
    rm -rf ${apppath}/${elasticsearchName}
}

gen_cert
if [ $? -eq 0 ];then
    echo -e "\033[1;32;40m INFO `basename $0` gen_elasticsearch_cert file ${apppath} success \033[0m" 
else 
    echo -e "\033[1;31;40m ERROR `basename $0`gen_elasticsearch_cert file ${apppath} failed \033[0m" 
    exit 2
fi
 
