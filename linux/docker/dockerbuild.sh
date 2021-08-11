#!/usr/bin/env bash
#!/bin/sh
# sh /opt/shell/dockerbuild.sh app-demo-1.0.0  /opt/package/ 18001 app-demo test
echo "===============开始构建镜像并上传到镜像仓库===================="

serverID=$1
packagepath=$2
port=$3

appId=$4
appVersion=$5

dockerfilepath=${packagepath}/dockerfile
echo "开始部署构建${serverID}镜像"

# dockerfile 文件
`cd ${dockerfilepath}`
`touch ${serverID}`
dockerfile=${dockerfilepath}/${serverID}

#安装包
deployzipfile=${packagepath}/${serverID}.jar
echo "安装包为:$deployzipfile"

# 生成dockerFile文件
#echo "FROM base-1.2" >${dockerfile}
echo "FROM openjdk:8-jdk-alpine" >${dockerfile}
#echo "FROM openjdk:8-jdk-oracle" >${dockerfile}
echo "MAINTAINER xxx@gmail.com>" >>${dockerfile}
echo "RUN mkdir /var/jarDir" >>${dockerfile}
echo "ADD ${serverID}.jar /var/jarDir/${serverID}.jar" >>${dockerfile}
#echo "ADD arthas-packaging-3.1.7-bin.tar.gz /var/jarDir/" >>${dockerfile}
echo "COPY --from=hengyunabc/arthas:latest /opt/arthas /opt/arthas" >> ${dockerfile}
echo "RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime" >>${dockerfile}
echo "RUN echo 'Asia/Shanghai' >/etc/timezone" >>${dockerfile}
echo "RUN apk add --no-cache tini" >>${dockerfile}
echo "EXPOSE ${port}" >>${dockerfile}
echo "ENTRYPOINT [\"/sbin/tini\", \"--\"]" >>${dockerfile}
echo "CMD [\"sh\",\"-c\",\"java -Duser.timezone=GMT+08 -XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap -jar /var/jarDir/${serverID}.jar \"] ">>${dockerfile}
#echo "ENTRYPOINT exec java -Duser.timezone=GMT+08  -Xms1500m -Xmx1500M -XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap -jar /var/jarDir/${serverID}.jar  ">>${dockerfile}
#echo "CMD ["sh","-c","java -Xms1500m -Xmx1500M -XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap -jar /usr/local/factoring_web/xxxx.jar"] ">>${dockerfile}
#echo "ENTRYPOINT exec java -Duser.timezone=GMT+08  -jar /var/jarDir/${serverID}.jar" >>${dockerfile}

Flag=`docker images | grep ${serverID} | wc -l`
 # 重启前检查容器是否存在，
if [ $Flag -eq 1 ];
 then
    echo ""
    echo "删除${serverID}镜像"
    docker rmi -f ${serverID}
    echo ""
    echo "删除${serverID}镜像成功"
fi


if [ -f $deployzipfile ]
then
    if [ -f $dockerfile ];
    then
        echo ""
            echo " dockerfile 文件已经生成"
            cat $dockerfile
            sleep 1
        echo ""
            echo "生成docker镜像文件"
            cd ${packagepath}

        pwd
        echo ""
            docker build -f ${dockerfile} -t ${serverID} .
        echo ""

        imagesFlag=`docker images ${serverID} | wc -l`
        # 判断应用镜像是否生成
        if [ $imagesFlag -eq 2 ];
        then
            echo "应用镜像已经生成"
            echo ""
            echo "开始上传${serverID}镜像到私有Harbor仓库"
            echo ""
            echo "登陆仓库"
            docker login dockerhub.com -u xxx -p 'xxx'
            echo ""
            echo "打Tag版本"
            docker tag ${serverID}  dockerhub.com/demo/${appId}:${appVersion}
            echo ""
            echo "推送dockerhub.com/demo/${appId}:${appVersion}镜像"
            docker push dockerhub.com/demo/${appId}:${appVersion}
            echo ""
	    echo ""
	    echo "删除${serverID}镜像"
	    docker rmi -f ${serverID}
	    echo ""
	    echo "删除${serverID}镜像成功"
        else
            echo "${serverID}应用镜像生成失败"
        fi
    else
        echo "${serverID} 的 DockerFile 文件未生成"
    fi
else
	echo "${serverID}部署包不存在，请检查!"
fi


