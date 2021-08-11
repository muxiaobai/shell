
#!/bin/sh

use apptest;
#添加账号
db.createUser({user:"test_mongo",pwd:"MongoDB_pwd",roles:[{role:"readWrite",db:"apptest"}],mechanisms : ["SCRAM-SHA-1"]})
#启动
./mongod -f mongo-master.conf

# 登陆后台
./mongo host:port/db -u user -p pwd
#mongo 127.0.0.1:9430/admin -u root -p FpTH2a
db.getCollection('test').find({});



# 备份生产数据：
/db/mongodb-3.4.7/bin/mongodump -h 127.0.0.1:9430 -d daochufilename -o  /db/mongodb-3.4.7/data/mongo_bak/180414

删除老数据:

> 进入测试mongdb:       ./mongo 127.0.0.1:9430
查看所有的库:           show dbs
选择待删除的库:         use  databaseName
删除当前库:             db.dropDatabase()
退出:                   exit

# 导入数据

/db/mongodb-3.4.7/bin/mongorestore --host=127.0.0.1 --port 9430 --db databasename	 /db/mongodb-3.4.7/data/mongo_bak/180414/daochufilename
