#!/bin/bash

#停止ES
echo "Stop ES..."
netstat -tlnp | grep 19200 | awk '{print $7}' | awk -F "/" '{print $1}' | xargs kill 
netstat -tlnp | grep 19500 | awk '{print $7}' | awk -F "/" '{print $1}' | xargs kill 
netstat -tlnp | grep 19700 | awk '{print $7}' | awk -F "/" '{print $1}' | xargs kill 
netstat -tlnp | grep 19300 | awk '{print $7}' | awk -F "/" '{print $1}' | xargs kill 
netstat -tlnp | grep 19301 | awk '{print $7}' | awk -F "/" '{print $1}' | xargs kill 
netstat -tlnp | grep 19302 | awk '{print $7}' | awk -F "/" '{print $1}' | xargs kill 

ps -ef | grep elasticsearch.bootstrap | grep java | grep -v grep |awk '{print $2}' | xargs  kill
echo "Stop ES OK"
echo ""
