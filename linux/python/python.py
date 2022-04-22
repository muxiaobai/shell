
import subprocess
import json
import pycurl
import StringIO
from urlparse import *
from datetime import datetime
import re
begin = 0
size = 100
total = 0
start = datetime.now()
index_name = 'index'
base_url = 'http://localhost:9200'+'/'+index_name
user_pwd = 'elastic:elasticsearch'

def send(begin,size,total):
    print(begin,size,total)
    response = StringIO.StringIO()
    c = pycurl.Curl()
    c.setopt(c.URL,base_url+'/_search')
    c.setopt(pycurl.USERPWD,user_pwd)
    c.setopt(c.WRITEFUNCTION, response.write)
    c.setopt(c.HTTPHEADER, ['Content-Type: application/json','Accept-Charset: UTF-8'])
    # post_data_dic = '{"track_total_hits": "true","size":10}'
    post_data_dic = '{"track_total_hits": "true","from": ' + str(begin*size) + ',"size": ' + str(size) + ', "_source": ["id","url","column","columnName","owner","ownerName","auditing"],"query": {"term": {"auditing": {"value": "1"}}}}'
    # post_data_dic = '{"track_total_hits": "true","from": ' + str(begin) + ',"size": ' + str(size) + ', "_source": ["id","url","column","columnName","owner","ownerName","auditing"],"query":{"bool":{"filter":[{"term":{"auditing":"1"}}]}}}'
    print(post_data_dic)
    c.setopt(c.POSTFIELDS, post_data_dic)
    c.perform()
    c.close()
    j = response.getvalue()
    # print j
    d = json.loads(j)
    # set max total
    # handle
    if(d["hits"]["total"]["value"]==0):
        return 0
    for values in d["hits"]["hits"]:
        # print values 
        # if(values["_source"]["auditing"]==1):
        # _source = values.get('_source', {})
        # url = _source.get('url', '')
        # id = _source.get('id', '')
        # owner = _source.get('owner', '')
        verifyUrl(values["_id"],values["_source"]["url"],values["_source"]["id"],values["_source"]["owner"])
        # verifyUrl(values["_id"],url,id,owner)
        
    print(begin,"time",(datetime.now()-start).seconds)
    return d["hits"]["total"]["value"]
  
def verifyUrl(index_id,verify_url,news_id,owner_id):
    pattern = re.compile(ur'^(http|https):\/\/*')
    result = urlparse(verify_url)
    if(pattern.search(verify_url)):
        x =1
    else:
        result = urlparse('http:'+verify_url)
    command = 'curl -I  ' + result.scheme+'://'+result.netloc + result.path + '  -w %{http_code} -s -m 10 -o /dev/null'
    # print(command)
    p = subprocess.Popen(command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    out, err = p.communicate()
    # print(out)
    # append to file
    if(out =="200"):
        with open(index_name+'_200.txt',mode='a') as filename:
            filename.write(index_id+','+verify_url+','+str(news_id)+','+str(owner_id)+'\n')
    elif(out == "301"):
        with open(index_name+'_301.txt',mode='a') as filename:
            filename.write(index_id+','+verify_url+','+str(news_id)+','+str(owner_id)+'\n')
    elif(out == "302"):
        with open(index_name+'_302.txt',mode='a') as filename:
            filename.write(index_id+','+verify_url+','+str(news_id)+','+str(owner_id)+'\n')
    elif(out == "404"):
        # get(index_id)
        # delete(index_id)
        with open(index_name+'_404.txt',mode='a') as filename:
            filename.write(index_id+','+verify_url+','+str(news_id)+','+str(owner_id)+'\n')
    else:
        with open(index_name+'_other.txt',mode='a') as filename:
            filename.write(index_id+','+verify_url+','+str(news_id)+','+str(owner_id)+'\n')


def delete(url_index_id):
    command = 'curl -u "' + user_pwd + '" -XDELETE ' +base_url+'/_doc/'+ url_index_id
    print(command)
    p = subprocess.Popen(command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    out, err = p.communicate()
    print out

def get(url_index_id):
    command = 'curl -u "' + user_pwd + '" -XGET ' +base_url+'/_doc/'+ url_index_id
    p = subprocess.Popen(command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    out, err = p.communicate()
    print out

def notExistIdAndOwner():
    command = 'curl -u "' + user_pwd + '"' +' -d \'{"track_total_hits":true,"from":"0","size":100,"query":{"bool": {"must_not": [{"exists":{"field": "id"}}]}}}\' ' + ' -H \'Content-type:application/json\' ' +' -XPOST ' +base_url+'/_search'
    print command
    p = subprocess.Popen(command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    out, err = p.communicate()
    print out
    d = json.loads(out)
    if(d["hits"]["total"]["value"]==0):
        return 0
    for values in d["hits"]["hits"]:
        delete(values["_id"])


notExistIdAndOwner()
total = send(begin,size,total)
print(begin, total, begin < total/size)
while(begin<=total/size):
    begin = begin + 1
    send(begin,size,total)

end =datetime.now()

print("curl 404 finish")
print(begin,total,"cost seconds :",(end - start).seconds)

try:
    filename = open(index_name+"_404.txt")
    while True:
        line = filename.readline()
        if line:
            delete(line[0:line.find(',')])
        else:
            break
    print("\033[33m delete finish \033[0m")
    filename.close()
except IOError:
    print("\033[32m scan finish,no 404, you're lucky \033[0m")




# url = 404 indexId delete

# curl -I -XGET http://localhost:8083  -w %{http_code} -s -m 10 -o /dev/null
# curl   -H 'Content-type:application/json' -XDELETE http://10.195.108.18:19200/open_data/_doc/REKop34Bilr8kJ6SHZkY
# cat open_data_200.txt | uniq -d -c | awk '{sum +=$1}END{print sum}'
# wc -l
# curl  -H 'Content-type:application/json' -XPOST -d '{"track_total_hits":true ,"size":0,"query": {"term": {"auditing":{"value": "1"}}}}' http://10.195.108.18:19200/article_data/_search
