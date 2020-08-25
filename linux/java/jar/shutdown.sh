#!/bin/sh

netstat -tlnp |  egrep "18001|18002|18003|18005|18006|18007|18201" | awk '{print $7}' | awk -F "/" '{print $1}' | xargs kill 

#netstat -tlnp | grep 18201 | awk '{print $7}' | awk -F "/" '{print $1}' | xargs kill 


#ps -ef | grep 1800 | grep java | grep -v grep |awk '{print $2}' | xargs  kill -9

#ps -ef | grep 18201 | grep java | grep -v grep |awk '{print $2}' | xargs  kill -9
