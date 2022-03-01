
#!/bin/sh

k8s
https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#cp
service 

kubectl apply -f kuboard_openapp_2021_01_29_11_27_09.yaml

kubectl get svc --all-namespaces
kubectl get pv -A

kubectl -n openapp get pods  | grep search

kubectl -n openapp get pods -o wide 
kubectl -n openapp get pod db-elasticsearch-8687d9d95c-gp7tn  -o yaml  

详细信息
kubectl -n openapp describe pod db-elasticsearch-8684c44cb8-lv5wn 

进入执行
kubectl -n openapp  exec -it svc-app-search-877df6545-j7dzd -c app-search -- sh
kubectl -n openapp  exec -it db-elasticsearch-8684c44cb8-lv5wn -- sh

kubectl -n openapp  exec -it db-fastdfs-storage-0   -- bash
/usr/bin/fdfs_upload_file  /etc/fdfs/client.conf /opt/fastdfs/testfile/1.txt
ll /data/fast_data/data/00/06/CvRBKWFwyI2AZfs5AAAAAAAAAAA393.txt 

获取日志
kubectl -n openapp  logs --tail=200  -f svc-app-search-877df6545-j7dzd 

拷贝文件
kubectl cp openapp/svc-app-search-fb47d75bb-xz8pd:var/jarDir/application.yml application.yaml

kubectl patch pv pvc-8477bd20-ffbe-4fa2-85b9-f864d7b3690c  -p '{"metadata":{"finalizers":null}}' --type=merge
kubectl patch pvc elasticsearch-master-db-elasticsearch-0 -p '{"metadata":{"finalizers":null}}' --type=merge
