#!/bin/bash
#需要替换的包名称
bmc=$1
#需要替换的文件名称
hhwjmc=$2
#找到替换文件路径
thwjlj=`jar -tvf \$bmc|grep \$hhwjmc|awk '{print \$NF}'`

echo $bmc
echo $hhwjmc
echo $thwjlj
#把要替换的文件解压出来
jar -xvf $bmc $thwjlj
#删掉原文件
rm -f $thwjlj
#换掉文件
cp thwj/$hhwjmc $thwjlj
#重新将文件加入到jar包中
jar -uvf $bmc $thwjlj
echo '替换完成'
#删除解压文件
rm -rf $thwjlj
