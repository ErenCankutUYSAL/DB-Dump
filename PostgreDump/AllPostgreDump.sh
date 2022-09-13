echo "SELECT tablename FROM pg_catalog.pg_tables WHERE schemaname = 'public';" >> dbname.sql

export PGPASSWORD=password
psql -U dbuser -h x.x.x.x -d dbname -f dbname.sql -o dbnamelist.out -t
filename=dbnameList.out
while read x; do

export PGPASSWORD=password
pg_dump  -U dbuser -h x.x.x.x -d dbname -t $x   -Ft > $x.tar

export PGPASSWORD=password
pg_restore  -U dbuser -c   -d  dbname $x.tar  -v

rm $x.tar
done < $filename

rm -rf dbname.sql dbnamelist.out
