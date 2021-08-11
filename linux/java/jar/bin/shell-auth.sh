#!/bin/sh
appId=app-auth-0.0.1
ip=192.168.31.40
JAVA_OPTIONS='-Xms256M -Xmx256M'
eurekaip=--eureka.client.serviceUrl.defaultZone=http://test:test@${ip}:18001/eureka/
otherurl=--other.url=http://${ip}:8080
datasource=--spring.datasource.druid.url=jdbc:postgresql://${ip}:15432/appsystem
datasourceusername=--spring.datasource.druid.username=pgsql
datasourcepwd='--spring.datasource.druid.password=pgsql_pwd'
rabbitmq=--spring.rabbitmq.host=${ip}
redis=--spring.redis.host=${ip}
nohup /opt/jar/jdk1.8.0_201/bin/java ${JAVA_OPTIONS}  -jar ${appId}.jar  ${eurekaip} ${datasource}  ${datasourceusername} ${datasourcepwd} ${rabbitmq} ${redis}  ${otherurl} > ${appId}.log  2>&1 &


