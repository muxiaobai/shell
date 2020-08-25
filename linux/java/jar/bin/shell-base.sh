#!/bin/sh
JAVA_OPTIONS='-Xmx256m -Xms256m'
eurekaip=--eureka.client.serviceUrl.defaultZone=http://test:test@192.168.31.40:18001/eureka/
vsburl=--vsb.url=http://192.168.31.40:8080

datasource=--spring.datasource.druid.url=jdbc:postgresql://192.168.31.40:15432/appsystem
datasourceusername=--spring.datasource.druid.username=pgsql
datasourcepwd='--spring.datasource.druid.password=pgsql_pwd'
rabbitmq=--spring.rabbitmq.host=192.168.31.40
redis=--spring.redis.host=192.168.31.40
javapath=/opt/jar/jdk1.8.0_201/bin
fdfstracker=--fdfs.trackerList=192.168.31.40:22122
#nohup ${javapath}/java ${JAVA_OPTIONS} -jar app-auth-0.0.1.jar ${eurekaip} ${datasource}  ${datasourceusername} ${datasourcepwd} ${redis} ${rabbitmq}  ${vsburl}  > ./app-auth-0.0.1.log  2>&1 &
#nohup ${javapath}/java ${JAVA_OPTIONS} -jar app-gateway-0.0.1.jar ${eurekaip} ${datasource}  ${datasourceusername} ${datasourcepwd}  ${vsburl}  > ./app-gateway-0.0.1.log  2>&1  &
#nohup ${javapath}/java ${JAVA_OPTIONS} -jar app-system-0.0.1.jar ${eurekaip} ${datasource} ${datasourceusername} ${datasourcepwd}   ${redis} ${rabbitmq} ${vsburl}  > ./app-system-0.0.1.log  2>&1  &
#nohup ${javapath}/java ${JAVA_OPTIONS} -jar app-filesystem-0.0.1.jar ${eurekaip} ${datasource}  ${datasourceusername} ${datasourcepwd}  ${redis} ${rabbitmq} ${fdfstracker} ${vsburl}  > ./app-filesystem-0.0.1.log  2>&1  &

nohup ${javapath}/java ${JAVA_OPTIONS} -jar app-auth-0.0.1.jar ${eurekaip} ${datasource}  ${datasourceusername} ${datasourcepwd} ${redis} ${rabbitmq}  ${vsburl}  > /dev/null  2>&1 &
nohup ${javapath}/java ${JAVA_OPTIONS} -jar app-gateway-0.0.1.jar ${eurekaip} ${datasource}  ${datasourceusername} ${datasourcepwd}  ${vsburl}  > /dev/null  2>&1  &
nohup ${javapath}/java ${JAVA_OPTIONS} -jar app-system-0.0.1.jar ${eurekaip} ${datasource} ${datasourceusername} ${datasourcepwd}   ${redis} ${rabbitmq} ${vsburl}  > /dev/null  2>&1  &
nohup ${javapath}/java ${JAVA_OPTIONS} -jar app-filesystem-0.0.1.jar ${eurekaip} ${datasource}  ${datasourceusername} ${datasourcepwd}  ${redis} ${rabbitmq} ${fdfstracker} ${vsburl}  > /dev/null  2>&1  &
