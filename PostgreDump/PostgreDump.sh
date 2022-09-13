#sadece son 2 ay

echo "select relname from pg_catalog.pg_stat_all_tables where relname like '%' || to_char(now() - interval '1 months'  ,'YYYYMM')  and schemaname='public'
or relname like '%' || to_char(now() - interval '2 months'  ,'YYYYMM') and schemaname='public' or relname like '%' || to_char(now(),'YYYYMM') and schemaname='public';" >> Month.sql


export PGPASSWORD=password
psql -U datacrud -h x.x.x.x -d dbname -f Month.sql -o MonthTableList.out -t
sed -i '$ d' MonthTableList.out
monthname=MonthTableList.out
while read x; do

export PGPASSWORD=password
pg_dump  -U datacrud -h x.x.x.x -d dbname -t $x   -Ft > $x.tar

export PGPASSWORD=password
psql -c "drop table public.$x cascade;" -d dbname_test
pg_restore  -U datacrud -c   -d  testdbname $x.tar  -v

rm $x.tar
done < $monthname

rm -rf Month.sql MonthTableList.out 

#Sadece Yıl içerenler

echo "select relname from pg_catalog.pg_stat_all_tables where  relname  like '%' || to_char(now(),'YYYY') and schemaname='public';" >> Yearly.sql

export PGPASSWORD=password
psql -U datacrud -h x.x.x.x -d dbname -f Yearly.sql -o YearlyTableList.out -t
sed -i '$ d' YearlyTableList.out
yearname=YearlyTableList.out
while read x; do

export PGPASSWORD=password
pg_dump  -U datacrud -h x.x.x.x -d dbname -t $x   -Ft > $x.tar

export PGPASSWORD=password
psql -c "drop table public.$x cascade;" -d dbname_test
pg_restore  -U datacrud -c   -d  dbname_test $x.tar  -v

rm $x.tar
done < $yearname

rm -rf Yearly.sql YearlyTableList.out

#Yıl Ay içermeyenler

echo "select relname from  pg_catalog.pg_stat_all_tables where      relname not like '%202_' and  relname not like '%202___'   and schemaname='public';" >> Noannual.sql

export PGPASSWORD=password
psql -U datacrud -h x.x.x.x -d dbname -f Noannual.sql -o NoAnnual.out -t
sed -i '$ d' NoAnnual.out 
noannualname=NoAnnual.out
while read x; do

export PGPASSWORD=password
pg_dump  -U datacrud -h x.x.x.x -d dbname -t $x   -Ft > $x.tar

export PGPASSWORD=password
psql -c "drop table public.$x cascade;" -d dbname_test
pg_restore  -U datacrud -c   -d  dbname_test $x.tar  -v

rm $x.tar
done < $noannualname

rm -rf Noannual.sql NoAnnual.out

#Fresh DB

echo "SELECT relname FROM pg_catalog.pg_stat_all_tables where schemaname='fresh';" >> FreshNoannual.sql

export PGPASSWORD=password
psql -U datacrud -h x.x.x.x -d dbname -f FreshNoannual.sql -o FreshNoannual.out -t
sed -i '$ d' FreshNoannual.out
noannualname=FreshNoannual.out
while read x; do

export PGPASSWORD=password
pg_dump --schema=fresh -U datacrud -h x.x.x.x -d  dbname  $x   -Ft > $x.tar

export PGPASSWORD=password
psql -c "drop table fresh.$x cascade;" -d dbname_test
pg_restore --schema=fresh  -U datacrud -c   -d dbname_test  $x.tar  -v

rm $x.tar
done < $noannualname


rm -rf FreshNoannual.sql FreshNoannual.out










