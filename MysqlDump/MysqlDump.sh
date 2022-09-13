echo "select table_name from information_schema.tables where (table_name like concat('%', date_format( now() - Interval 1 month ,'%Y'),'_', date_format( now() - Interval 1 month ,'%m')) or  table_name like concat('%', date_format( now() - Interval 2 month ,'%Y'),'_',date_format( now() - Interval 2 month ,'%m') ))  and table_schema='dbname'
union all
select table_name from information_schema.tables  where  table_name  like concat('%', date_format(now(),'%Y')) and table_schema='dbname'
union all
select table_name from information_schema.tables  where  not table_name like '%20___%' and table_schema='dbname' and not table_name like 'temp%'
" >> tables.sql


export DBPASSWORD=password
mysql -u dbuser -p$DBPASSWORD -h x.x.x.x -e"source tables.sql" -s -N > TableList.out
filename=TableList.out
while read x; do
echo $x
mysqldump --single-transaction -u dbuser -p$DBPASSWORD -h x.x.x.x dbnane  $x > $x.sql 

mysql -u dbuser  -h 10.0.60.120 -D test_dbname < $x.sql

rm $x.sql
done < $filename

rm -rf tables.sql TableList.out
