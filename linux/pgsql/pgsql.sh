
#!/bin/sh
export PGPASSWORD='pgsql'; /opt/demo/pgsql/bin/createdb  -h 127.0.0.1 -p 15432 -U pgsql apptest;

export PGPASSWORD='pgsql';  /opt/demo/pgsql/bin/psql -h 127.0.0.1 -p 15432 -d apptest -U pgsql -f  /home/user_pgsql/apptest.sql

export PGPASSWORD='pgsql';  /opt/demo/pgsql/bin/psql -h 127.0.0.1 -p 15432 -d postgres -U pgsql -W 'pgsql'

export PGPASSWORD='pgsql';  /opt/demo/pgsql/bin/dropdb -h 127.0.0.1 -p 15432 -U pgsql apptest
# import apptest.sql to apptest db use pgsql
su - user_pgsql -c "export PGPASSWORD='pgsql'; /opt/pgsql/bin/pg_dump -h 127.0.0.1 -p 15432 -U pgsql --inserts -f /opt/apptest.sql apptest"

#  create apptest
./createdb -h 127.0.0.1 -p 15432 -U pgsql apptest;
#  delete apptest
./dropdb -h 127.0.0.1 -p 15432 -U pgsql apptest

# import public.sql to apptest use pgsql
./psql -h 127.0.0.1 -p 15432 -d apptest -U pgsql -f  public.sql

# export dump db apptest to apptest.sql
./pg_dump -h 127.0.0.1 -p 15432 -U pgsql --inserts -f apptest.sql apptest

# 进入 ./psql
./psql -h 127.0.0.1 -p 15432 -d apptest -U pgsql

# list 所有的数据库
\l    # list all database
# 切换数据库
\c dbName; # change db;

\q # quit
# select tables owner db;
select * from pg_tables where tablename not like '%pg_%';

# psql 命令行帮助
\?
# sql 帮助
\h
# 该库的所有表
\d
# 该表的结构 detail
\d 表名[视图名]