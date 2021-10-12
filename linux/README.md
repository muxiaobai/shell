### 为了方便部署系统，编写这两个shell脚本，

就当是对shell脚本编写的练习。

#### common 常用脚本

- 30天日志自动清理
- 把class修改到jar中
- 导入pgsql数据库,导出数据库
- netstat 判断端口监听，服务是否启动。

#### docker 

- docker/docker.sh docker常用语句 查看日志，保存镜像 
- docker/Dockerfile 构建镜像文件

#### elasticsearch 集群

- elasticsearch/install.sh

#### k8s 常用的语句
- k8s/k8s.sh 查看日志，进入容器，拷贝文件
#### pgsql 常用的语句
- pgsql/pgsql.sh  导入导出创建查询

#### redis 常用的语句
- redis/redis.txt 进入和查看数据 



#### tomcat_upgrade_rollback 升级jar或者回退
- 原始版本rollback.sh  upgrade.sh
- 项目上可使用版本 bak_tomcat_20180919.sh   up_tomcat_20180919.sh
- 整理后版本 up_roll_2018.sh  使用参数

