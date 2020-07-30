#!/bin/bash

# Author : muxiaobai

#chmod +x ./test.sh  
#./test.sh  
#set fileformat = unix
UP_BAK_HOME="/thglxt/bak"
TOMCAT_HOME="/thglxt/tomcat-8.5.20"


BAK_HOME="$UP_BAK_HOME/bak"
BAK_LOG_PATH="$BAK_HOME/log"
BAK_ROOT="$BAK_HOME/ROOT"
UP_HOME="$UP_BAK_HOME/upgrade"
UP_ROOT="$UP_HOME/ROOT"
UP_LOG="$UP_HOME/log"
WEB_APPS="$TOMCAT_HOME/web-apps"

# mkdir path

if [ ! -d $BAK_HOME ];then
mkdir $BAK_HOME
else
echo "$BAK_HOME 文件夹已经存在"
fi

if [ ! -d $BAK_ROOT ];then
mkdir $BAK_ROOT
else
echo "$BAK_ROOT 文件夹已经存在"
fi

if [ ! -d $BAK_LOG ];then
mkdir $BAK_LOG
else
echo " $BAK_LOG 文件夹已经存在"
fi

currentTime=`date "+%Y-%m-%d %H:%M:%S"`
FILE_NAME=`date "+%Y%m%d%H%M%S"`
BAK_LOG_FILE="$BAK_LOG/$FILE_NAME.log"
#UP_LOG_FILE="$UP_LOG/$FILE_NAME.log"

# log file
touch $BAK_LOG_FILE
#touch $BAK_LOG_FILE

startupsh="$TOMCAT_HOME/bin/startup.sh"
shutdownsh="$TOMCAT_HOME/bin/shutdown.sh"

echo "begin time :$currentTime" >> "$BAK_LOG_FILE"
echo "LOG location:$BAK_LOG_FILE" >> "$BAK_LOG_FILE"
echo "start Tomcat URL:$startupsh" >>"$BAK_LOG_FILE"
echo "stop Tomcat URL:$shutdownsh" >>"$BAK_LOG_FILE"

# tar running ROOT
tar -czvf "$BAK_ROOT/$FILE_NAME.tar.gz" -C $WEB_APPS ROOT/
#copy last tar.gz 
newest_file_of()
{
        ls $BAK_HOME -t "$@" | head -1
}

echo "newest file of *.tar.gz is $(newest_file_of *.tar.gz)"
LAST_FILE=$(newest_file_of *.tar.gz)

echo "last file: $LAST_FILE" >> "$LOG_FILE_PATH"


# if tomcat is run should stop .else skip this  `stop tomcat` step 
echo "$currentTime stoping Tomcat..." >>"$BAK_LOG_FILE"
$shutdownsh
echo "tomcat stoped" >>"$BAK_LOG_FILE"
sleep 2s;


# remove ROOT
rm -rf $WEB_APPS/ROOT

# remove cache
rm -rf $TOMCAT_HOME/work/Catalina

# rollback tar now running,and un last upgrade.tar.gz 
#tar -czvf $BAK_ROOT/$FILE_NAME.tar.gz -C $WEB_APPS ROOT/
tar -xzvf $UP_ROOT/LAST_FILE $WEB_APPS/ROOT

# upgrade use unzip upload ROOT.zip 
#tar -czvf $UP_ROOT/$FILE_NAME.tar.gz -C $WEB_APPS ROOT/
#unzip -o $UP_ROOT/ROOT.zip -d $WEB_APPS/ROOT

#start tomcat 
cd $TOMCAT_HOME
echo " $currentTime starting Tomcat..." >>"$LOG_FILE_PATH"
$startupsh
echo "$currentTime Tomcat started..." >>"$LOG_FILE_PATH"

