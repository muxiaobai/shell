
#!/bin/sh
apppath=/opt/demo
temppath=`pwd`
chown -R user_pgsql:user_pgsql ${temppath}/
if [ ! -n "$1" ];then
      echo "This Shell script execution needs to specify a parameter, The parameter is db Name."
      echo "Usage: "
      echo -ne "\t For example:  sh `basename $0` dbName "
      echo -ne "\n"
      exit 1
  fi
dbName=$1
pgsqlstatus=`netstat -lntp | egrep "15432" | wc -l`
if [ ${pgsqlstatus} -gt 1 ]; then
    su - pgsql -c "export PGPASSWORD='pgsql';  /opt/demo/pgsql/bin/pg_dump -h 127.0.0.1 -p 15432 -U pgsql --inserts -f ${temppath}/${dbName}_`date \"+%Y%m%d%H%M%S\"`.sql ${dbName}"
else
    echo "pgsql doesn't start"
fi

# createdb pgsql -f import pg_dump dorpdb

#export PGPASSWORD='pgsql'; /opt/demo/pgsql/bin/createdb  -h 127.0.0.1 -p 15432 -U pgsql apptest;
#export PGPASSWORD='pgsql';  /opt/demo/pgsql/bin/psql -h 127.0.0.1 -p 15432 -d apptest -U pgsql -f  /home/user_pgsql/apptest.sql
#export PGPASSWORD='pgsql';  /opt/demo/pgsql/bin/psql -h 127.0.0.1 -p 15432 -d postgres -U pgsql -W 'pgsql'
#export PGPASSWORD='pgsql';  /opt/demo/pgsql/bin/dropdb -h 127.0.0.1 -p 15432 -U pgsql apptest


#./createdb -h 127.0.0.1 -p 15432 -U pgsql apptest;
#./psql -h 127.0.0.1 -p 15432 -d apptest -U pgsql -f  apptest.sql
#./pg_dump -h 127.0.0.1 -p 15432 -U pgsql --inserts -f apptest.sql apptest
#./dropdb -h 127.0.0.1 -p 15432 -U pgsql apptest