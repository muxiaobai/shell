#!/bin/sh
started=0
n=1
echo "try $n times  service starting"
while true
do
	if test $n -gt 20
	then
		echo " service is stopped"
		started=1
		break
	fi
	sleep 10
	n=$(($n+1))
	echo "try $n times  service starting "
	port=`netstat -lntp | egrep "8080" | wc -l`
	if [ ${port} -gt 0 ]; then
		echo " service is started"
		break;
	fi
done
