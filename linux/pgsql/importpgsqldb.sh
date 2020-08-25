#!/bin/sh
apppath=/opt/app
temppath=`pwd`
chown -R pgsql:pgsql ${temppath}/

 pgsqlstatus=`netstat -lntp | egrep "15432" | wc -l`
if [ $pgsqlstatus -gt 1 ]; then
	#for i in `ls`; do 	su - vsb_pgsql -c "export PGPASSWORD='pgsql';$apppath/pgsql/bin/psql -d appsystem -U pgsql  -p 15432 -f $temppath/${i}"; done;
	su - pgsql -c "export PGPASSWORD='pgsql'; /opt/demo/pgsql/bin/createdb  -h 127.0.0.1 -p 15432 -U pgsql apptest"
	su - pgsql -c "export PGPASSWORD='pgsql'; /opt/demo/pgsql/bin/psql  -h 127.0.0.1 -p 15432 -d apptest -U pgsql -f ${temppath}/apptest.sql"
else
	echo "pgsql doesn't start"
fi



# createdb pgsql -f import pg_dump dorpdb

#export PGPASSWORD='pgsql'; /opt/demo/pgsql/bin/createdb  -h 127.0.0.1 -p 15432 -U pgsql apptest;
#export PGPASSWORD='pgsql';  /opt/demo/pgsql/bin/psql -h 127.0.0.1 -p 15432 -d apptest -U pgsql -f  /home/vsb_pgsql/apptest.sql
#export PGPASSWORD='pgsql';  /opt/demo/pgsql/bin/psql -h 127.0.0.1 -p 15432 -d postgres -U pgsql -W 'pgsql'
#export PGPASSWORD='pgsql';  /opt/demo/pgsql/bin/dropdb -h 127.0.0.1 -p 15432 -U pgsql apptest


#./createdb -h 127.0.0.1 -p 15432 -U pgsql apptest;
#./psql -h 127.0.0.1 -p 15432 -d apptest -U pgsql -f  apptest.sql
#./pg_dump -h 127.0.0.1 -p 15432 -U pgsql --inserts -f apptest.sql apptest
#./dropdb -h 127.0.0.1 -p 15432 -U pgsql apptest