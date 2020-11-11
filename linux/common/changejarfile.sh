#!/bin/bash
#需要替换的包名称
jar=$1
#需要替换的文件名称
file=$2
jdk=/opt/jdk/bin
#找到替换文件路径
jarpath=`\$jdk/jar -tvf \$bmc|grep \$file|awk '{print \$NF}'`
# 多个重名的文件，会出错
echo $jar
echo $file
echo $jarpath
#把要替换的文件解压出来
$jdk/jar -xvf $jar $jarpath
#删掉原文件
rm -rf $jarpath
#换掉文件
cp  $file $jarpath
#重新将文件加入到jar包中
$jdk/jar -uvf $jar $jarpath
echo '替换完成'
#删除解压文件
rm -rf $jarpath
