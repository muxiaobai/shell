
#!/bin/sh

docker run -d \--name mmmysql -p 3300:3306 -m 500M
-v v1:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=123456 \--privileged \--net=mysql-net --ip 172.19.0.2 mysql:latest

docker run -d \--name tomcat1 -p 3300:3306 \--net mysql-net \--ip 172.19.0.2 -v v1:/var/lib/mysql mytomcat:latest

# 主机 ： 3300  v1
#容器内： 3306 /var/lib/mysql

### 实例

# 运行容器
docker ps
# 所有容器
docker ps -a
# 进入容器
docker exec -it mmmysql /bin/bash
# 最新的100行
docker logs -f -t  --tail=100 mmmysql
# 容器信息
docker inspect mmmysql


# delete container
docker rm -f app-test-0.0.1
# delete image
docker rmi -f app-test-0.0.1

# 查看 app-test-0.0.1 log
docker logs -f -t --tail 300 app-test-0.0.1


