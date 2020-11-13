#!/usr/bin/env bash


# 测试
curl -u elastic:123123 http://192.168.120.83:9200/_cat/health?v


ELK

./filebeat -e -c filebeat.yml
./filebeat.exe -e -c filebeat.yml

logstash
Run bin/logstash -f logstash.conf

elasticsearch
默认端口9200

Kibana
默认端口5601
Run bin/kibana (or bin\kibana.bat on Windows)
http://localhost:5601

#接口指令

GET /_cat/health?v

GET /_nodes/process

GET /liuwunan
DELETE /liuwunan

POST /liuwunan/_search




POST history_query/_search

DELETE history_query/_doc/1C4Il3IB621CgvbDt5UE

GET history_query/_mapping

GET /_stats/fielddata?fields=*

GET /_nodes/stats/indices/fielddata




POST /liuwunan_test/_bulk
{"index":{"_index":"liuwunan_test","_id":"1"}}
{"id": 2,"title":"小明你好"}
{"index":{"_index":"liuwunan_test","_id":"2"}}
{"id": 2,"title":"明天你好"}
{"index":{"_index":"liuwunan_test","_id":"3"}}
{"id": 2,"title":"小明天好"}
{"index":{"_index":"liuwunan_test","_id":"4"}}
{"id": 2,"title":"明天过星期"}


# 根据字段分析或者analyzer分析

POST /liuwunan/_analyze
{
  "field": "title"
, "text": ["环球影音"]
}

POST /liuwunan/_analyze
{
  "field": "title.fpy"
, "text": ["cast公司与NBC环球公司啊，展示，战士，战事"]
}

POST test/_analyze
{
  "text": "美国,|=阿拉斯加州发生8.0级地震",
  "analyzer": "my_hanlp_analyzer"
}


#修改密码

# 查询
curl -u 'elastic:elasticsearch_2017@*))' -H 'Content-type:application/json' -XPOST -d '@es.json' http://192.168.31.40:19200/article_data/_search

# 删除
curl -u 'elastic:elasticsearch_2017@*))' -H 'Content-type:application/json' -XDELETE http://192.168.31.40:19200/article_data/_doc/1C4Il3IB621CgvbDt5UE

