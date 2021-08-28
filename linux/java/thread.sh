
#!/bin/sh

javapath=/opt/vsb/jdk
#javapid=`${javapath}/bin/jps -m -l`
javapid=19054
pwdpath=`pwd`
info=dumpinfo.log
if [ -e "${pwdpath}/dump.log" ];then
	rm -rf ${pwdpath}/dump*
fi

echo "------------------uptime信息--------------------" >>${pwdpath}/dump.log
uptime  >>${pwdpath}/dump.log
#top -c >>${pwdpath}/dump.log

# jmap
if [ -e  "$javapath/bin/jmap" ];then
    echo -e "\033[1;32;40m INFO: ${javapath}/bin/jmap exist,dumpHeap.hprof  https://heaphero.io/  \033[0m"
#生成hprof文件生成堆文件
${javapath}/bin/jmap -dump:live,format=b,file=${pwdpath}/dumpHeap.hprof ${javapid}

echo "#实例数量前十的类：" >> ${pwdpath}/dump.log
${javapath}/bin/jmap -histo ${javapid} | sort -n -r -k 2 | head -20 >>${pwdpath}/dump.log

echo "#实例容量前十的类：" >>${pwdpath}/dump.log
${javapath}/bin/jmap -histo ${javapid} | sort -n -r -k 3 | head -20 >>${pwdpath}/dump.log

echo "------------------heap信息--------------------" >>${pwdpath}/dump.log
${javapath}/bin/jmap -heap ${javapid} >>${pwdpath}/dump.log

else
    echo -e "\033[1;31;40m ERROR: ${javapath}/bin/jmap  is not exist \033[0m"
fi

# jstat
if [ -e  "$javapath/bin/jstack" ];then
    echo -e "\033[1;32;40m INFO: ${jabapath}/bin/jstat exist,dumpThread.log,you can use https://fastthread.io/, or jvisualvm \033[0m"

echo "------------------是否有死锁线程信息--------------------" >>${pwdpath}/dump.log
#${javapath}/bin/jstack  ${javapid} | grep -i –E deadlock  >>${pwdpath}/dump.log
${javapath}/bin/jstack  ${javapid} | grep -i -E 'BLOCKED' >>${pwdpath}/dump.log
#dumpThread.log
${javapath}/bin/jstack  ${javapid} >${pwdpath}/dumpThread.log

else
    echo -e "\033[1;31;40m ERROR: jstack  is not exist \033[0m"
fi


echo "-----------------jstat gc 信息--------------------------" >>${pwdpath}/dump.log
${javapath}/bin/jstat -gc ${javapid} 250 4 >>${pwdpath}/dump.log

echo
if [ $? -eq 0 ];then
    echo -e "\033[1;32;40m INFO ${pwdpath}/`basename $0` success \033[0m"
else
    echo -e "\033[1;31;40m ERROR ${pwdpath}/`basename $0` failed \033[0m"
    exit 2
fi


