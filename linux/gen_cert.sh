#!/bin/bash

passwd=123456
name=zhang
temppath=`pwd`
cn='www.baidu.com'
jdk_bin=/opt/jar/jdk1.8.0_201/bin
keytool -help
if [ $? -eq 0 ];then
    jdk_bin=`which keytool`	
    echo -e "\033[1;32;40m INFO `basename $0` installed jdk  \033[0m" 
else     
    ${jdk_bin}/keytool -help
    if [ $? -eq 0 ];then
    	echo -e "\033[1;32;40m INFO `basename $0` installed jdk  \033[0m" 
    else 
       	echo -e "\033[1;31;40m ERROR `basename $0` failed  not install jdk & no keytool \033[0m" 
  	exit 2
    fi
fi

openssl -v
if [ $? -eq 0 ];then
    echo -e "\033[1;32;40m INFO `basename $0` installed openssl  \033[0m" 
else 
    echo -e "\033[1;31;40m ERROR `basename $0` failed  not install openssl \033[0m" 
    exit 2
fi


FILE_NAME="cert_`date \"+%Y%m%d%H%M%S\"`"
mkdir ${FILE_NAME}
home="${temppath}/${FILE_NAME}"
#:: 生成jks
echo -e "\033[1;32;40m gen jks&cer  \033[0m" 
mkdir ${home}/jks
cd ${home}/jks

${jdk_bin}/keytool -genkeypair -alias ${name} -keystore ${name}.jks -storetype pkcs12 -keypass ${passwd} -storepass ${passwd}  -keyalg RSA -keysize 2048 -validity 365 -dname "CN=http://192.168.1.243,OU=xx，O=dy, L=nb,ST=zj,C=china"

${jdk_bin}/keytool -exportcert -keystore ${name}.jks -file ${name}.cer -alias ${name} -storepass ${passwd}


echo -e "\033[1;32;40m 转换jks->pfx  \033[0m" 
mkdir ${home}/pfx
cd ${home}/pfx

${jdk_bin}/keytool -importkeystore -srckeystore ${home}/jks/${name}.jks -destkeystore ${home}/pfx/${name}.pfx -srcstoretype PKCS12 -deststoretype PKCS12 -srcstorepass ${passwd} -deststorepass ${passwd}



echo -e "\033[1;32;40m  转换pfx->pem/key \033[0m" 
mkdir ${home}/pem
cd ${home}/pem

openssl pkcs12 -in ${home}/pfx/${name}.pfx -nodes -out ${home}/pem/${name}.pem -password pass:${passwd}
openssl rsa -in ${home}/pem/${name}.pem -out ${home}/pem/${name}.key

cd ${temppath}
${jdk_bin}/keytool -list -v -keystore ${home}/jks/${name}.jks -storepass ${passwd}
