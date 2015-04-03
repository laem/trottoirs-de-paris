Import the array of features json with

```
mongoimport --db agreable --collection trottoirs --file trottoirs.json --jsonArray
```

The Paris trottoirs geojson file has a weird offset. 
```
topojson -o t.topo.json trottoirs_des_rues_de_paris.geojson -q 1e6
# Change the topojson translation property, then back to geojson
tail -c 200 t.topo.json
sed "s/2.226665275505943/2.236665275505943/g" t.topo.json > t2.topo.json
topojson-geojson t2.topo.json

sed 's/{"type":"FeatureCollection","features"://g' trottoirs_des_rues_de_paris.json > tmpjson
sed '$s/.$//' tmpjson > mongoimport.topo.json

mongoimport --db agreable --collection t2 --file mongoimport.topo.json --jsonArray

# Mongo fails at indexing these topojson to geojson features...
```
