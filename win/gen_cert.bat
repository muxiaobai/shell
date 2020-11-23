set pwd=123456
set name=zhang
set dd=%cd%

:: 生成jks
rmdir /s /q jks
mkdir jks
cd jks
keytool -genkeypair -alias %name% -keystore %name%.jks -storetype pkcs12 -keypass %pwd% -storepass %pwd%  -keyalg RSA -keysize 2048 -validity 365 -dname "CN=http://192.168.1.243,OU=xx，O=dy, L=nb,ST=zj,C=china"

keytool -exportcert -keystore %name%.jks -file %name%.cer -alias %name% -storepass %pwd%
cd %dd%

:: 转换jks->pfx
rmdir /s /q pfx
mkdir pfx
keytool -importkeystore -srckeystore %dd%/jks/%name%.jks -destkeystore %dd%/pfx/%name%.pfx -srcstoretype PKCS12 -deststoretype PKCS12 -srcstorepass %pwd% -deststorepass %pwd%



:: 转换pfx->pem/key
rmdir /s /q pem
mkdir pem
openssl pkcs12 -in %dd%/pfx/%name%.pfx -nodes -out %dd%/pem/%name%.pem -password pass:%pwd%
openssl rsa -in %dd%/pem/%name%.pem -out %dd%/pem/%name%.key
cd %dd%
keytool -list -v -keystore %dd%/jks/%name%.jks -storepass %pwd%

rem pause  