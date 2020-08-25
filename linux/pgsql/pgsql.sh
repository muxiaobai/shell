
#!/bin/sh
export PGPASSWORD='pgsql'; /opt/demo/pgsql/bin/createdb  -h 127.0.0.1 -p 15432 -U pgsql apptest;

export PGPASSWORD='pgsql';  /opt/demo/pgsql/bin/psql -h 127.0.0.1 -p 15432 -d apptest -U pgsql -f  /home/vsb_pgsql/apptest.sql

export PGPASSWORD='pgsql';  /opt/demo/pgsql/bin/psql -h 127.0.0.1 -p 15432 -d postgres -U pgsql -W 'pgsql'

export PGPASSWORD='pgsql';  /opt/demo/pgsql/bin/dropdb -h 127.0.0.1 -p 15432 -U pgsql apptest
# import apptest.sql to apptest db use pgsql
su - vsb_pgsql -c "export PGPASSWORD='pgsql'; /opt/pgsql/bin/pg_dump -h 127.0.0.1 -p 15432 -U pgsql --inserts -f /opt/apptest.sql apptest"
#  create apptest
./createdb -h 127.0.0.1 -p 15432 -U pgsql apptest;
# import public.sql to apptest use pgsql
./psql -h 127.0.0.1 -p 15432 -d apptest -U pgsql -f  public.sql
# dump db apptest to apptest.sql
./pg_dump -h 127.0.0.1 -p 15432 -U pgsql --inserts -f apptest.sql apptest
#  delete apptest
./dropdb -h 127.0.0.1 -p 15432 -U pgsql apptest

# 进入 ./psql
\l    # list all database
\c dbName; # change db;
 \q # quit
# select tables owner db;
select * from pg_tables where tablename not like '%pg_%';
