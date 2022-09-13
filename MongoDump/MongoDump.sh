#Year formatı sadece yılı gösterir.
year="$(date +"%Y")"
#Lastmonth formatı geçtiğimiz ayı getirir.
lastmonth="$(date -d"1 month ago" "+%m" )"
#Lastmonth2 Formatı 2 ay öncesini getirir.
lastmonth2="$(date -d"2 month ago" "+%m" )"

#function formati ile sayfanın en altındaki tag'a ait verileri çekmeye yarar.
function Check {
	#local formatı ise location anlamında kullanılır function tagı içerisinde ilk tırnak içerisindeki veriyi alır.
	local archive=${1}

#if döngüsünde ki -e formatı bulunduğu klasör içerisinde archive de olan veri başlığında ki dosyayı arar.
if [ -e "$archive" ]
then
    echo "There is $archive"
#dosya içerisinde daha önceden ana sunucudan cekilmiş archive var ise direkt sunucuya ekleme yapacaktır.

mongo -u mongousername -p password --authenticationDatabase test-dbname <<EOF
use test-dbname;
db.$archive.drop();
EOF

mongorestore -u mongousername -p password --db test-dbname dump/dbname/$archive.bson --authenticationDatabase test-dbname

else
    echo "None $archive"
#dosya içerisinde geçen aya ait veri yok ise önce ana sunucudan archive çekecektir sonra sunucuya ekleme yapacaktır.

mongo -u mongousername -p password --authenticationDatabase test-dbname <<EOF
use test-dbname;
db.$archive.drop();
EOF

mongodump  --host=x.x.x.x --port=27017 --db dbname  --collection $archive  -o dump/

mongorestore -u mongousername -p password --db test-dbname dump/dbname/$archive.bson --authenticationDatabase test-dbname


rm -rf dump/dbname/$archive.bson
fi
}

#Datatable isimleri
Check "dm_$year$lastmonth"
Check "dm_$year$lastmonth2"
Check "na_$year$lastmonth"
Check "na_$year$lastmonth2"
Check "pm_$year$lastmonth"
Check "pm_$year$lastmonth2"
Check "bc_$year$lastmonth"
Check "bc_$year$lastmonth2"
Check "temp-gno"
