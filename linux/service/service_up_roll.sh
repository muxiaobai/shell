#!/bin/bash

# Author : muxiaobai
# date : 2018-11-27
# chmod +x ./test.sh  
#         ./test.sh  
# bad interpreter sed -i 's/\r$//' up_roll_2018.sh
echo $1

#===============【change home path】need push ROOT.zip to $UP_BAK_HOME/up dir===============================
UP_BAK_HOME="/thglxt/bak"
TOMCAT_HOME="/thglxt/tomcat-8.5.20"
NGINX_HOME="/usr/local/nginx"
SHELL_NAME="up_roll_2018.sh"

#==========================================upgrad and rollback path==============================================
nginx_start='$NGINX_HOME/bin -s start'
nginx_stop='$NGINX_HOME/bin -s stop'
nginx_reload='$NGINX_HOME/bin -s reload'

startupsh="$TOMCAT_HOME/bin/startup.sh"
shutdownsh="$TOMCAT_HOME/bin/shutdown.sh"
WEB_APPS="$TOMCAT_HOME/web-apps/"
WEB_ROOT="$TOMCAT_HOME/web-apps/ROOT"

FILE_NAME=`date "+%Y%m%d%H%M%S"`
currentTime=`date "+%Y-%m-%d %H:%M:%S"`

# upgrade
UP_HOME="$UP_BAK_HOME/up" 
UP_INCRE="$UP_HOME/incre"
UP_ROOT="$UP_HOME/ROOT"
UP_LOG="$UP_HOME/log"
UP_LOG_FILE="$UP_LOG/up_$FILE_NAME.log"
# rollback
BAK_HOME="$UP_BAK_HOME/bak"
BAK_ROOT="$BAK_HOME/ROOT"
BAK_LOG="$BAK_HOME/log"
BAK_LOG_FILE="$BAK_LOG/bak_$FILE_NAME.log"
#==========================================param=================================================================

PARAM=$1
PARAM2=$2
if [ -z $PARAM ]; then
 echo -e "param is null ,and must use 【./$SHELL_NAME init】 if you use this shell.\n And you will create directory after this command. \n         then use 【upgrade】 to up the ROOT, or run 【rollback】 to  down the service.\n 【del 201811】delete ROOT_201811*.tar.gz,UP_201811*.log,for clear expire file."
 exit 0;
fi
if [  $PARAM  = 'help' ]; then
 echo ' init | upgrade | rollback | del 201811'
 exit 0;
fi

#============================================init=========================================================
if [ $PARAM = 'init' ]; then
echo  "=================init: $currentTime========================="

#===================up_home dir ==============================
#directory 
if [ ! -d $UP_HOME ]; then
mkdir $UP_HOME
else
echo "exit $UP_HOME" 
fi

if [ ! -d $UP_INCRE ]; then
mkdir $UP_INCRE
else
echo "exit $UP_INCRE" 
fi

if [ ! -d $UP_ROOT ]; then
mkdir $UP_ROOT
else
echo "exit $UP_ROOT" 
fi

if [ ! -d $UP_LOG ]; then
mkdir $UP_LOG
else
echo "exit $UP_LOG" 
fi


#=====================rollback dir============================
# directory
if [ ! -d $BAK_HOME ]; then
mkdir $BAK_HOME
else
echo "exit $BAK_HOME"  
fi

if [ ! -d $BAK_ROOT ]; then
mkdir $BAK_ROOT
else
echo "exit $BAK_ROOT" 
fi

if [ ! -d $BAK_LOG ]; then
mkdir $BAK_LOG
else
echo "exit $BAK_LOG"  
fi 

exit 0 
fi
#==========================================upgrade============================================================
# upgrade
if [ $PARAM = 'upgrade' ]; then


echo  "=================upgrade: $currentTime========================="

if [ ! -d $UP_HOME ]; then
echo "plase run ./$SHELL_NAME init"
exit 1
fi

## if not  $UP_HOME/ROOT.zip ,then exit
if [ ! -f "$UP_HOME/ROOT.zip" ]; then
echo "plase upload ROOT.zip to  $UP_HOME"
exit 1
fi

touch "$UP_LOG_FILE"
echo "begin time:$currentTime" >> "$UP_LOG_FILE"

#=================================================
#copy old war 
echo "Old War Name $UP_HOME/up_$FILE_NAME.tar.gz" >>"$UP_LOG_FILE"
tar -czvf  $UP_ROOT/ROOT_$FILE_NAME.tar.gz -C $WEB_APPS/ ROOT/ | tee -a "$UP_LOG_FILE"
#cp $WEB_APPS/ $BAK_HOME/$FILE_NAME.zip

# when you want to stop ,first ensure tomcat running.
#if [ps -ef | grep tomcat wc -l]; then 

#fi

# stop tomcat
echo "$currentTime stoping tomcat..." >>"$UP_LOG_FILE"
$shutdownsh >> "$UP_LOG_FILE"
echo "$currentTime tomcat stoped" >>"$UP_LOG_FILE"
sleep 2s;


#rm -rf $WEB_APPS/ROOT/


# unzip
echo "unzip $UP_HOME/ROOT.zip " >> "$UP_LOG_FILE"
unzip -o $UP_HOME/ROOT.zip -d $WEB_APPS
sleep 2s;

# ps -ef | grep tomcat 没有的时候可以下面执行

# remove cache
echo " rm -rf $TOMCAT_HOME/work " >> "$UP_LOG_FILE"
rm -rf $TOMCAT_HOME/work/Catalina

#start tomcat 
echo " $currentTime start Tomcat..." >>"$UP_LOG_FILE"
$startupsh >> "$UP_LOG_FILE"
echo "$currentTime Tomcat started..." >>"$UP_LOG_FILE"

# move  incre ROOT.zip to other,and ensure  UP_HOME not ROOT.zip 
mv $UP_HOME/ROOT.zip $UP_INCRE/ROOT_$FILE_NAME.zip

# upgrade rollback del only to choose one.
exit 0;
fi

#==========================================rollback=================================================================

# rollback
if  [ $PARAM = 'rollback' ]; then 

echo "===================rollback: $currentTime========================="

#================$check init is run ok,dir=================================

if [ ! -d $BAK_HOME ]; then
echo "plase run ./$SHELL_NAME init"
exit 1
fi

#================old_file $UP_ROOT=================================

# rollbakc Log_File

touch "$BAK_LOG_FILE"
echo "begin  rollback time:$currentTime" >> "$BAK_LOG_FILE"


#tar -czvf "$BAK_ROOT/$FILE_NAME.tar.gz" -C $WEB_APPS ROOT/
# last new tar.gz in $UP_ROOT

newest_file_of(){
ls $UP_ROOT -t "$@" | head -1
}

OLD_FILE=$(newest_file_of)
echo "$OLD_FILE last new tar.gz ">> $BAK_LOG_FILE

# 没有upgrade过的没有rollback old_files

#============stop rollback start==========================

# stop tomcat
echo "$currentTime stoping tomcat..." >>"$BAK_LOG_FILE"
$shutdownsh >> "$UP_LOG_FILE"
echo "$currentTime tomcat stoped" >>"$BAK_LOG_FILE"
sleep 2s;

# remove old web-apps/ROOT file
rm -rf $WEB_ROOT
sleep 2s;

# tar -xzvf 
echo  "tar -xzvf $UP_ROOT/$OLD_FILE $WEB_APPS">> "$BAK_LOG_FILE"
tar -xzvf $UP_ROOT/$OLD_FILE  -C $WEB_APPS ROOT/

# ps -ef | grep tomcat 

# remove cache
echo " rm -rf $TOMCAT_HOME/work " >> "$BAK_LOG_FILE"
rm -rf $TOMCAT_HOME/work/Catalina

#start tomcat 
echo " $currentTime start Tomcat..." >>"$BAK_LOG_FILE"
$startupsh >> "$BAK_LOG_FILE"
echo "$currentTime Tomcat started..." >>"$BAK_LOG_FILE"

#============stop rollback start==========================

exit 0;
fi
#=============================delete old tar.gz and  *.log ,default only remove last month====================================

if  [ $PARAM = 'del' ]; then 

# regexp up_201809* roll_201809* ROOT_201809*
FILE_DATE_REGEXP=$PARAM2
if [ -z $PARAM2 ]; then
FILE_DATE_REGEXP=`date -d "$(date +%Y%m)01 last month" +%Y%m`
fi
#up
rm -rf $UP_INCRE/ROOT_$FILE_DATE_REGEXP*
rm -rf $UP_LOG/up_$FILE_DATE_REGEXP*
rm -rf $UP_ROOT/ROOT_$FILE_DATE_REGEXP*
#bak
rm -rf $BAK_ROOT/ROOT_$FILE_DATE_REGEXP*
rm -rf $BAK_LOG/bak_$FILE_DATE_REGEXP*

exit 0
fi


#!/bin/bash

# Author : muxiaobai
# date : 2018-11-27
# chmod +x ./test.sh  
#         ./test.sh  
# bad interpreter sed -i 's/\r$//' up_roll_2018.sh
echo $1

#===============【change home path】need push ROOT.zip to $UP_BAK_HOME/up dir===============================
UP_BAK_HOME="/thglxt/bak"
TOMCAT_HOME="/thglxt/tomcat-8.5.20"
NGINX_HOME="/usr/local/nginx"
SHELL_NAME="up_roll_2018.sh"

#==========================================upgrad and rollback path==============================================
nginx_start='$NGINX_HOME/bin -s start'
nginx_stop='$NGINX_HOME/bin -s stop'
nginx_reload='$NGINX_HOME/bin -s reload'

startupsh="$TOMCAT_HOME/bin/startup.sh"
shutdownsh="$TOMCAT_HOME/bin/shutdown.sh"
WEB_APPS="$TOMCAT_HOME/web-apps/"
WEB_ROOT="$TOMCAT_HOME/web-apps/ROOT"

FILE_NAME=`date "+%Y%m%d%H%M%S"`
currentTime=`date "+%Y-%m-%d %H:%M:%S"`

# upgrade
UP_HOME="$UP_BAK_HOME/up" 
UP_INCRE="$UP_HOME/incre"
UP_ROOT="$UP_HOME/ROOT"
UP_LOG="$UP_HOME/log"
UP_LOG_FILE="$UP_LOG/up_$FILE_NAME.log"
# rollback
BAK_HOME="$UP_BAK_HOME/bak"
BAK_ROOT="$BAK_HOME/ROOT"
BAK_LOG="$BAK_HOME/log"
BAK_LOG_FILE="$BAK_LOG/bak_$FILE_NAME.log"
#==========================================param=================================================================

PARAM=$1
PARAM2=$2
if [ -z $PARAM ]; then
 echo -e "param is null ,and must use 【./$SHELL_NAME init】 if you use this shell.\n And you will create directory after this command. \n         then use 【upgrade】 to up the ROOT, or run 【rollback】 to  down the service.\n 【del 201811】delete ROOT_201811*.tar.gz,UP_201811*.log,for clear expire file."
 exit 0;
fi
if [  $PARAM  = 'help' ]; then
 echo ' init | upgrade | rollback | del 201811'
 exit 0;
fi

#============================================init=========================================================
if [ $PARAM = 'init' ]; then
echo  "=================init: $currentTime========================="

#===================up_home dir ==============================
#directory 
if [ ! -d $UP_HOME ]; then
mkdir $UP_HOME
else
echo "exit $UP_HOME" 
fi

if [ ! -d $UP_INCRE ]; then
mkdir $UP_INCRE
else
echo "exit $UP_INCRE" 
fi

if [ ! -d $UP_ROOT ]; then
mkdir $UP_ROOT
else
echo "exit $UP_ROOT" 
fi

if [ ! -d $UP_LOG ]; then
mkdir $UP_LOG
else
echo "exit $UP_LOG" 
fi


#=====================rollback dir============================
# directory
if [ ! -d $BAK_HOME ]; then
mkdir $BAK_HOME
else
echo "exit $BAK_HOME"  
fi

if [ ! -d $BAK_ROOT ]; then
mkdir $BAK_ROOT
else
echo "exit $BAK_ROOT" 
fi

if [ ! -d $BAK_LOG ]; then
mkdir $BAK_LOG
else
echo "exit $BAK_LOG"  
fi 

exit 0 
fi
#==========================================upgrade============================================================
# upgrade
if [ $PARAM = 'upgrade' ]; then


echo  "=================upgrade: $currentTime========================="

if [ ! -d $UP_HOME ]; then
echo "plase run ./$SHELL_NAME init"
exit 1
fi

## if not  $UP_HOME/ROOT.zip ,then exit
if [ ! -f "$UP_HOME/ROOT.zip" ]; then
echo "plase upload ROOT.zip to  $UP_HOME"
exit 1
fi

touch "$UP_LOG_FILE"
echo "begin time:$currentTime" >> "$UP_LOG_FILE"

#=================================================
#copy old war 
echo "Old War Name $UP_HOME/up_$FILE_NAME.tar.gz" >>"$UP_LOG_FILE"
tar -czvf  $UP_ROOT/ROOT_$FILE_NAME.tar.gz -C $WEB_APPS/ ROOT/ | tee -a "$UP_LOG_FILE"
#cp $WEB_APPS/ $BAK_HOME/$FILE_NAME.zip

# when you want to stop ,first ensure tomcat running.
#if [ps -ef | grep tomcat wc -l]; then 

#fi

# stop tomcat
echo "$currentTime stoping tomcat..." >>"$UP_LOG_FILE"
$shutdownsh >> "$UP_LOG_FILE"
echo "$currentTime tomcat stoped" >>"$UP_LOG_FILE"
sleep 2s;


#rm -rf $WEB_APPS/ROOT/


# unzip
echo "unzip $UP_HOME/ROOT.zip " >> "$UP_LOG_FILE"
unzip -o $UP_HOME/ROOT.zip -d $WEB_APPS
sleep 2s;

# ps -ef | grep tomcat 没有的时候可以下面执行

# remove cache
echo " rm -rf $TOMCAT_HOME/work " >> "$UP_LOG_FILE"
rm -rf $TOMCAT_HOME/work/Catalina

#start tomcat 
echo " $currentTime start Tomcat..." >>"$UP_LOG_FILE"
$startupsh >> "$UP_LOG_FILE"
echo "$currentTime Tomcat started..." >>"$UP_LOG_FILE"

# move  incre ROOT.zip to other,and ensure  UP_HOME not ROOT.zip 
mv $UP_HOME/ROOT.zip $UP_INCRE/ROOT_$FILE_NAME.zip

# upgrade rollback del only to choose one.
exit 0;
fi

#==========================================rollback=================================================================

# rollback
if  [ $PARAM = 'rollback' ]; then 

echo "===================rollback: $currentTime========================="

#================$check init is run ok,dir=================================

if [ ! -d $BAK_HOME ]; then
echo "plase run ./$SHELL_NAME init"
exit 1
fi

#================old_file $UP_ROOT=================================

# rollbakc Log_File

touch "$BAK_LOG_FILE"
echo "begin  rollback time:$currentTime" >> "$BAK_LOG_FILE"


#tar -czvf "$BAK_ROOT/$FILE_NAME.tar.gz" -C $WEB_APPS ROOT/
# last new tar.gz in $UP_ROOT

newest_file_of(){
ls $UP_ROOT -t "$@" | head -1
}

OLD_FILE=$(newest_file_of)
echo "$OLD_FILE last new tar.gz ">> $BAK_LOG_FILE

# 没有upgrade过的没有rollback old_files

#============stop rollback start==========================

# stop tomcat
echo "$currentTime stoping tomcat..." >>"$BAK_LOG_FILE"
$shutdownsh >> "$UP_LOG_FILE"
echo "$currentTime tomcat stoped" >>"$BAK_LOG_FILE"
sleep 2s;

# remove old web-apps/ROOT file
rm -rf $WEB_ROOT
sleep 2s;

# tar -xzvf 
echo  "tar -xzvf $UP_ROOT/$OLD_FILE $WEB_APPS">> "$BAK_LOG_FILE"
tar -xzvf $UP_ROOT/$OLD_FILE  -C $WEB_APPS ROOT/

# ps -ef | grep tomcat 

# remove cache
echo " rm -rf $TOMCAT_HOME/work " >> "$BAK_LOG_FILE"
rm -rf $TOMCAT_HOME/work/Catalina

#start tomcat 
echo " $currentTime start Tomcat..." >>"$BAK_LOG_FILE"
$startupsh >> "$BAK_LOG_FILE"
echo "$currentTime Tomcat started..." >>"$BAK_LOG_FILE"

#============stop rollback start==========================

exit 0;
fi
#=============================delete old tar.gz and  *.log ,default only remove last month====================================

if  [ $PARAM = 'del' ]; then 

# regexp up_201809* roll_201809* ROOT_201809*
FILE_DATE_REGEXP=$PARAM2
if [ -z $PARAM2 ]; then
FILE_DATE_REGEXP=`date -d "$(date +%Y%m)01 last month" +%Y%m`
fi
#up
rm -rf $UP_INCRE/ROOT_$FILE_DATE_REGEXP*
rm -rf $UP_LOG/up_$FILE_DATE_REGEXP*
rm -rf $UP_ROOT/ROOT_$FILE_DATE_REGEXP*
#bak
rm -rf $BAK_ROOT/ROOT_$FILE_DATE_REGEXP*
rm -rf $BAK_LOG/bak_$FILE_DATE_REGEXP*

exit 0
fi

