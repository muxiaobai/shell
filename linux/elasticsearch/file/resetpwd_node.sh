#!/bin/bash




# 停服务

# 设置超级用户密码
bin/elasticsearch-users useradd my_admin -p my_password -r superuser

# 启动服务

# curl修改密码
curl -H "Content-Type:application/json" -XPOST -u my_admin:my_password 'http://192.168.120.83:9200/_xpack/security/user/elastic/_password' -d '{ "password" : "elasticsearch_pwd@*))" }'

# 校验
curl -u elastic 'http://192.168.120.83:9200/_xpack/security/_authenticate?pretty'

# 删除超级用户密码

bin/elasticsearch-users userdel my_admin
