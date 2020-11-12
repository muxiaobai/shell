#!/bin/bash
#需要替换的包名称
jar=$1
#需要替换的文件名称
file=$2
jdk=/opt/jdk/bin
#找到替换文件路径
# 多个重名的文件，会出错,会找到不同的路径
#jarpath=`\$jdk/jar -tvf \$jar|grep \$file|awk '{print \$NF}'`
filepath=$3
echo $jar
echo $file
echo filepath
#把要替换的文件解压出来
$jdk/jar -xvf $jar $filepath
#删掉原文件
rm -rf $filepath
#换掉文件
cp  $file $filepath
#重新将文件加入到jar包中
$jdk/jar -uvf $jar $filepath
echo '替换完成'
#删除解压文件
rm -rf $filepath

# 编译java  需要制定引用的jar或者classpath
# Spring Boot  重命名 可以unzip jar  然后在当前目录编译 需要制定路径
# $jdk/javac -encoding utf-8 -cp ./BOOT-INF/classes:./BOOT-INF/lib/* -d ./BOOT-INF/classes/  xxx.java
# 打包到jar  $jdk/jar -uvf $jar ./BOOT-INF/classes/$filepath
#$jdk/javac -classpath  .:/opt/xxx.jar -d  .  xxx.java
##
