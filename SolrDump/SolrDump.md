## Solr Dump Notları


# Ekleme Yapılacak.
```
<dataConfig>
  <document>
    <entity name="sep" processor="SolrEntityProcessor"
            url="http://10.0.60.93:8983/solr/TableName"
            query="date:[20210901 TO *]"
            fl="id,type,date,cdate,media,journalist,title,text,tags"/>
  </document>
</dataConfig>
```


