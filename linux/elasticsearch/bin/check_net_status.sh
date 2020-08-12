#!/bin/bash
#------------------------------------------------------------------------------------------------------------------#
#|          Some people die at the age of 25 and don't bury themselves in the earth until they are 75             |#
#------------------------------------------------------------------------------------------------------------------#
#|                      $$$$ $$   $$ $$$$$$ $$    $$   $$$$$$          $$     $$$$$$ $$$$$$                       |#
#|                     $$    $$   $$ $$     $$ $$ $$  $$               $$     $$     $$                           |#
#|                    $$     $$$$$$$ $$$$$  $$  $$ $ $$  $$$$$$        $$     $$$$$  $$$$$                        |#
#|                     $$    $$   $$ $$     $$   $ $  $$     $$        $$     $$     $$                           |#
#|                      $$$$ $$   $$ $$$$$$ $$    $$   $$$$$ $$        $$$$$$ $$$$$$ $$$$$$                       |#
#------------------------------------------------------------------------------------------------------------------#
 
function  main(){
if [ $UID -ne  0 ]
  then
    echo "|----------------------------------------------------------------------------------------------------------------|"
    echo "|------------------------------------------[权限不足...请切换至root用户]-----------------------------------------|"
    echo "|----------------------------------------------------------------------------------------------------------------|"
    exit 1;
else
judge
fi
}
 
function judge(){
    echo
    offfile=`ls | grep expect-*.tar.gz`
    if [[ "$offfile" != "" ]]
    then
        echo "|----------------------------------------------------------------------------------------------------------------|"
        echo "|--------------------------------------------------[发现离线包]--------------------------------------------------|"
        echo "|----------------------------------------------------------------------------------------------------------------|"
        # rpm -ivh expect
	exit 1
    else
        echo "|----------------------------------------------------------------------------------------------------------------|"
        echo "|-------------------------------------------------[未发现离线包]-------------------------------------------------|"
        echo "|--------------------------------------------[开始判断是否连接外网安装]------------------------------------------|"
        network
    fi
}
 

function network(){
    httpcode=`curl -I -m 10 -o /dev/null -s -w %{http_code}'\n' http://www.baidu.com`
    net1=$(echo $httpcode | grep "200")
    if [[ "$net1" != "" ]]
    then
        echo "|----------------------------------------------------------------------------------------------------------------|"
        echo "|-----------------------------------------------------[联网]-----------------------------------------------------|"
        echo "|-------------------------------------------------[准备联网安装]-------------------------------------------------|"
        echo "|----------------------------------------------------------------------------------------------------------------|"
	intend    
  	 exit 0
    else
        echo "|----------------------------------------------------------------------------------------------------------------|"
        echo "|-------------------------------------------[未联网,无离线安装包,准备退出]---------------------------------------|"
        echo "|----------------------------------------------------------------------------------------------------------------|"
        /usr/bin/sleep 3
        exit 1;
    fi
}
function intend(){
   echo "|****************************************************************************************************************|"
    echo "|            WW             WW EEEEEEE LL     CCCCC   OOOOOO      MM      MM     EEEEEEE                         |"
    echo "|             WW    WWWW   WW  EE      LL    CC      OO    OO    MMMM    MMMM    EE                              |"
    echo "|              WW  WW WW  WW   EEEEE   LL   CC      OO      OO  MM  MM  MM  MM   EEEEE                           |"
    echo "|               WW W   W WW    EE      LL    CC      OO    OO  MM    M M     MM  EE                              |"
    echo "|                WW     WW     EEEEEEE LLLLLL CCCCC   OOOOOO  MM     MMM      MM EEEEEEE                         |"
    echo "|****************************************************************************************************************|"
}

main