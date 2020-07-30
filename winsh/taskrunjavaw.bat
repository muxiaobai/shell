@echo off

rem -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=18801
start javaw  -jar ./app-core/app-register/target/app-register-0.0.1.jar >./app-core/app-register/target/app-register.log   &
ping -n 8 127.0.0.1 1>null
echo "app-register"
start javaw  -jar ./app-core/app-auth/target/app-auth-0.0.1.jar  >./app-core/app-auth/target/app-auth.log &
echo "app-auth"
start javaw  -jar ./app-core/app-gateway/target/app-gateway-0.0.1.jar >./app-core/app-gateway/target/app-gateway.log &
echo "app-gateway"
start javaw  -jar ./app-system/target/app-system-0.0.1.jar  >./app-system/target/app-system.log &
echo "app-system"
start javaw  -jar ./app-manage-center/target/app-manage-center-0.0.1.jar  > ./app-manage-center/target/app-manage-center.log 
echo "app-manage-center"
start javaw  -jar ./app-filesystem/target/app-filesystem-0.0.1.jar  >./app-filesystem/target/app-filesystem.log &
echo "app-filesystem"
pause  



rem @echo off

rem start javaw -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=18801 -jar ./app-core/app-register/target/app-register-0.0.1.jar >./app-core/app-register/target/app-register.log   &
rem ping -n 8 127.0.0.1 1>null
rem echo "app-register"

rem rem start javaw -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=18808 -jar ./app-core/app-config/target/app-config-0.0.1.jar >./app-core/app-config/target/app-config.log &
rem rem ping -n 50 127.0.0.1 1>null
rem rem echo "app-config"

rem start javaw -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=18803 -jar ./app-core/app-auth/target/app-auth-0.0.1.jar  >./app-core/app-auth/target/app-auth.log &
rem echo "app-auth"
rem start javaw -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=18802 -jar ./app-core/app-gateway/target/app-gateway-0.0.1.jar >./app-core/app-gateway/target/app-gateway.log &
rem echo "app-gateway"
rem start javaw -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=18806 -jar ./app-system/target/app-system-0.0.1.jar  >./app-system/target/app-system.log &
rem echo "app-system"
rem start javaw -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=18807 -jar ./app-manage-center/target/app-manage-center-0.0.1.jar  > ./app-manage-center/target/app-manage-center.log 
rem echo "app-manage-center"
rem start javaw -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=18805 -jar ./app-filesystem/target/app-filesystem-0.0.1.jar  >./app-filesystem/target/app-filesystem.log &
rem echo "app-filesystem"
rem pause  
