#!/bin/sh
appId=app-register-0.0.1
# app-register-0.0.1.jar
#JAVA_OPTIONS='-Xms256M -Xmx256M -Xloggc:./logs/gc.log -XX:+HeapDumpOnOutOfMemoryError -XX:+PrintGCDetails -XX:+PrintGCDateStamps -XX:+PrintTenuringDistribution -XX:+PrintHeapAtGC'
JAVA_OPTIONS='-Xms256M -Xmx256M'
eurekaip=--eureka.client.serviceUrl.defaultZone=http://test:test@${ip}:18001/eureka/
vsburl=--vsb.url=http://192.168.31.40:8080
#nohup /opt/jar/jdk1.8.0_201/bin/java ${JAVA_OPTIONS}  -jar ${appId}.jar  ${eurekaip} ${vsburl} > ${appId}.log  2>&1 &

nohup /opt/jar/jdk1.8.0_201/bin/java ${JAVA_OPTIONS}  -jar ${appId}.jar  ${eurekaip} ${vsburl} > /dev/null  2>&1 &

