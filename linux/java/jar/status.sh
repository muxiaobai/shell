#!/bin/sh

#netstat -tlnp |  egrep "18001|18002|18003|18005|18006|18007" | awk '{print $7}' | awk -F "/" '{print $1}' 

#netstat -tlnp | grep 18201 | awk '{print $7}' | awk -F "/" '{print $1}' 


basesearch=`ps -ef | egrep "18001|18002|18003|18005|18006|18007|18201" | grep java | wc -l `

base=`ps -ef | egrep "18001|18002|18003|18005|18006|18007" | grep java | wc -l `
if [ $basesearch -eq 7 ]; then
    echo -e  "\033[32m INFO base service & search is starting \033[0m"
elif [ $base -eq 6 ];then
    echo -e "\033[33m WARN base service is starting please start search service use shell-search-start.sh to \033[0m"
else
    echo -e  "\033[31m ERROR service is stoped and can't service。pliease stop all service use shutdown.sh, and then start.sh \033[0m"
fi
#ps -ef | egrep "1800|18201" | grep java | grep -v grep |awk '{print $2}' 

#ps -ef | grep 18201 | grep java | grep -v grep |awk '{print $2}'
