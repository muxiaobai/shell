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

PUT /liuwunan
{
    "settings": {
        "index": {
            "max_result_window": 10000000
        },
        "refresh_interval": "5s",
        "number_of_shards": 1,
        "number_of_replicas": 1,
        "analysis": {
            "filter": {
                "pinyin_full_filter": {
                    "keep_joined_full_pinyin": "true",
                    "lowercase": "true",
                    "keep_original": "false",
                    "keep_first_letter": "false",
                    "keep_separate_first_letter": "false",
                    "type": "pinyin",
                    "keep_none_chinese": "false",
                    "limit_first_letter_length": "50",
                    "keep_full_pinyin": "true"
                },
                "pinyin_simple_filter": {
                    "keep_joined_full_pinyin": "true",
                    "lowercase": "true",
                    "none_chinese_pinyin_tokenize": "false",
                    "padding_char": " ",
                    "keep_original": "true",
                    "keep_first_letter": "true",
                    "keep_separate_first_letter": "false",
                    "type": "pinyin",
                    "keep_full_pinyin": "false"
                }
            },
            "analyzer": {
                "pinyinFullIndexAnalyzer": {
                    "filter": ["asciifolding", "lowercase", "pinyin_full_filter"],
                    "type": "custom",
                    "tokenizer": "ik_max_word"
                },
                "ik_pinyin_analyzer": {
                    "filter": ["asciifolding", "lowercase", "pinyin_full_filter", "word_delimiter"],
                    "type": "custom",
                    "tokenizer": "ik_smart"
                },
                "ikIndexAnalyzer": {
                    "filter": ["asciifolding", "lowercase"],
                    "type": "custom",
                    "tokenizer": "ik_max_word"
                },
                "pinyiSimpleIndexAnalyzer": {
                    "type": "custom",
                    "tokenizer": "ik_max_word",
                    "filter": ["pinyin_simple_filter", "lowercase"]
                }
            }
        }
    }
}

GET /liuwunan/_mapping/doc

PUT /liuwunan/_mapping
{
    "dynamic_templates": [{
            "strings": {
                "match_mapping_type": "string",
                "mapping": {
                    "analyzer": "ik_max_word",
                    "fields": {
                        "raw": {
                            "ignore_above": 256,
                            "type": "keyword"
                        }
                    },
                    "search_analyzer": "ik_max_word",
                    "type": "text"
                }
            }
        },
        {
            "integer": {
                "match_mapping_type": "long",
                "mapping": {
                    "fields": {
                        "raw": {
                            "type": "integer"
                        }
                    },
                    "type": "integer"
                }
            }
        }
    ],
    "properties": {
        "title": {
            "type": "text",
            "fields": {
                "fpy": {
                    "type": "text",
                    "index": true,
                    "analyzer": "pinyinFullIndexAnalyzer"
                },
                "spy": {
                    "type": "text",
                    "index": true,
                    "analyzer": "pinyiSimpleIndexAnalyzer"
                }
            },
            "analyzer": "ikIndexAnalyzer"
        }
    }
}

POST /liuwunan/_doc/1
{"title":"cast公司与NBC环球公司啊"}

POST /liuwunan/_doc/2
{"title":"cast公司与NBC环球公司啊,huanqiu,hanqiu"}

POST /liuwunan/_bulk
{"index":{"_index":"liuwunan","_id":"1"}}
{"title":"cast公司与NBC环球公司啊，展示，战士，战事"}
{"index":{"_index":"liuwunan","_id":"2"}}
{"title":"cast公司与NBC环球公司啊，共识"}
{"index":{"_index":"liuwunan","_id":"3"}}
{"title":"cast公司与NBC环球公司啊，展示，战士，战事"}
{"index":{"_index":"liuwunan","_id":"4"}}
{"title":"cast公司与NBC环球公司啊,工作，功能，公式，公事"}



POST /liuwunan/_search

POST /liuwunan/_search
{
    "_source": [ "title"],
  "query": {
    "match": {
      "title.fpy": "展示"
    }
  },
  "highlight": {
    "fields": {
      "title.fpy": {
      }
    }
  }
}

POST /liuwunan/_search

{
    "_source": [ "title"],

  "query": {
    "match": {
      "title.spy": "zs"
    }
  },
  "highlight" : {
    "fields": {
      "title.spy": {
      }
    }
  }
}

POST /liuwunan/_search

{
  "_source": [ "title"],
  "query": {
    "match": {
      "title": "展示"
    }
  },
  "highlight" : {
    "fields": {
      "title": {}
    }
  }
}


POST /liuwunan/_analyze
{
  "field": "title.spy"
, "text": ["展示"]
}
POST /liuwunan/_analyze
{
  "field": "title.fpy"
, "text": ["展示"]
}
POST /liuwunan/_analyze
{
  "text": ["展示"]
, "analyzer": "ikIndexAnalyzer"
}



POST /liuwunan/_analyze
{
  "field": "title.fpy"
, "text": ["环球影音"]
}

POST /liuwunan/_analyze
{
  "field": "title.spy"
, "text": ["环球影音"]
}

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




PUT /medcl3/
{
   "settings" : {
       "analysis" : {
           "analyzer" : {
               "pinyin_analyzer" : {
                   "tokenizer" : "my_pinyin"
                   }
           },
           "tokenizer" : {
               "my_pinyin" : {
                   "type" : "pinyin",
                   "keep_first_letter":true,
                   "keep_separate_first_letter" : true,
                   "keep_full_pinyin" : true,
                   "keep_original" : false,
                   "limit_first_letter_length" : 16,
                   "lowercase" : true
               }
           }
       }
   }
}

POST /medcl3/_mapping
{
  "properties": {
      "name": {
          "type": "keyword",
          "fields": {
              "pinyin": {
                  "type": "text",
                  "store": false,
                  "term_vector": "with_offsets",
                  "analyzer": "pinyin_analyzer",
                  "boost": 10
              }
          }
      }
  }
}

GET /medcl3/_analyze
{
   "text": ["刘德华"],
   "analyzer": "pinyin_analyzer"
}





PUT /liuwunan_test
{
    "settings": {
        "index": {
            "max_result_window": 10000000
        },
        "refresh_interval": "5s",
        "number_of_shards": 1,
        "number_of_replicas": 1,
        "analysis": {
            "filter": {
                "edge_ngram_filter": {
                    "type": "edge_ngram",
                    "min_gram": 1,
                    "max_gram": 50
                },
                "pinyin_full_filter": {
                    "type": "pinyin",
                    "keep_first_letter": false,
                    "keep_separate_first_letter": false,
                    "keep_full_pinyin": true,
                    "keep_original": false,
                    "limit_first_letter_length": 50,
                    "lowercase": true
                },
                "pinyin_simple_filter": {
                    "type": "pinyin",
                    "keep_first_letter": true,
                    "keep_separate_first_letter": false,
                    "keep_full_pinyin": false,
                    "keep_original": false,
                    "limit_first_letter_length": 50,
                    "lowercase": true
                }
            },
            "analyzer": {
                "pinyiSimpleIndexAnalyzer": {
                    "type": "custom",
                    "tokenizer": "keyword",
                    "filter": ["pinyin_simple_filter","edge_ngram_filter","lowercase"]
                },
                "pinyiFullIndexAnalyzer": {
                    "type": "custom","tokenizer": "keyword",
                    "filter": ["pinyin_full_filter", "lowercase"]
                }
            }
        }
    }
}



PUT /liuwunan_test/_mapping
{
    "dynamic_templates": [{
            "text": {
                "match_mapping_type": "string",
                "mapping": {
                    "analyzer": "ik_max_word",
                    "fields": {
                        "raw": {
                            "ignore_above": 256,
                            "type": "keyword"
                        }
                    },
                    "search_analyzer": "ik_max_word",
                    "type": "text"
                }
            }
        },
        {
            "integer": {
                "match_mapping_type": "long",
                "mapping": {
                    "fields": {
                        "raw": {
                            "type": "integer"
                        }
                    },
                    "type": "integer"
                }
            }
        }
    ],
    "properties": {
        "title": {
            "type": "keyword",
            "fields": {
                "fpy": {
                    "type": "text",
                    "index": true,
                    "analyzer": "pinyiFullIndexAnalyzer"
                },
                "spy": {
                    "type": "text",
                    "index": true,
                    "analyzer": "pinyiSimpleIndexAnalyzer"
                }
            }
        }
    }
}

POST /liuwunan_test/_bulk
{"index":{"_index":"liuwunan_test","_id":"1"}}
{"id": 2,"title":"小明你好"}
{"index":{"_index":"liuwunan_test","_id":"2"}}
{"id": 2,"title":"明天你好"}
{"index":{"_index":"liuwunan_test","_id":"3"}}
{"id": 2,"title":"小明天好"}
{"index":{"_index":"liuwunan_test","_id":"4"}}
{"id": 2,"title":"明天过星期"}



POST /liuwunan_test/_search

{
  "query": {
    "match": {
      "title.fpy": "mingtian"
    }
  },
  "highlight" : {
    "fields": {
      "title.fpy": {
      }
    }
  }
}


POST /liuwunan_test/_search
{
    "_source": [ "title"],
  "query": {
    "match": {
      "title.fpy": "mingtian"
    }
  },
  "highlight" : {
    "fields": {
      "title.fpy": {
      }
    }
  }
}

POST /liuwunan_test/_search

{
    "_source": [ "title"],

  "query": {
    "match": {
      "title.spy": "hq"
    }
  },
  "highlight" : {
    "fields": {
      "title.spy": {
      }
    }
  }
}

POST /liuwunan_test/_search

{
    "_source": [ "title"],
  "query": {
    "match": {
      "title.fpy": "环球"
    }
  },
  "highlight" : {
    "fields": {
      "title.fpy": {
      }
    }
  }
}



POST /liuwunan_test/_analyze
{
  "field": "title.fpy"
, "text": ["环球影音"]
}

POST /liuwunan_test/_analyze
{
  "field": "title.spy"
, "text": ["环球影音"]
}

POST /liuwunan/_analyze
{
  "field": "title"
, "text": ["环球影音"]
}







POST test/_analyze
{
  "text": "美国,|=阿拉斯加州发生8.0级地震",
  "analyzer": "my_hanlp_analyzer"
}
POST /_analyze
{
  "text": "不忘初心脏牢记使命令",
  "tokenizer": "hanlp_standard"
}
POST article/_analyze
{
  "field": "title.pinyin"
, "text": ["huanqinu"]
}

POST article/_analyze
{
   "explain": true,
  "text": "公安局",
  "analyzer": "pinyin"
}

POST article/_analyze
{
  "text": "公司开公共复工情况",
  "analyzer": "hanlp_standard_analyzer"
}

POST history_query/_search

DELETE history_query/_doc/1C4Il3IB621CgvbDt5UE

POST article_01,article_02/_search


GET history_query/_mapping

GET /_stats/fielddata?fields=*

GET /_nodes/stats/indices/fielddata

DELETE history_query/_doc/tZfConIBbXEi-nvh96ts

POST history_query/_analyze
{"field": "keyWord","text": ["知识条例测试"]}

POST history_query/_search

POST history_query/_search
