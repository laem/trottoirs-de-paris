Import the array of features json with

http://parisdata.opendatasoft.com/explore/dataset/trottoirs_des_rues_de_paris/?tab=map&dataChart=eyJxdWVyaWVzIjpbeyJjb25maWciOnsiZGF0YXNldCI6InRyb3R0b2lyc19kZXNfcnVlc19kZV9wYXJpcyIsIm9wdGlvbnMiOnsidGFiIjoiYW5hbHl6ZSJ9fSwiY2hhcnRzIjpbeyJ0eXBlIjoiY29sdW1uIiwiZnVuYyI6IkNPVU5UIiwiY29sb3IiOiIjNjZjMmE1In1dLCJ4QXhpcyI6ImxpYmVsbGUiLCJtYXhwb2ludHMiOm51bGwsInNvcnQiOiIifV19&location=19,48.84582,2.37975

```
mongoimport --db agreable --collection t --file ARRAY_of_GEOJSON_FEATURES.json --jsonArray
```

To transform the downloaded file for the import :

```
sed 's/{"type":"FeatureCollection","features"://g' trottoirs_des_rues_de_paris.geojson > tmpjson
sed '$s/.$//' tmpjson > mongoimport.json
```

BUT the Paris trottoirs geojson file has a weird offset.

```
node d.js
mongoimport --db agreable --collection t --file d.ok.json --jsonArray
```

Then import the Bati file. TODO C
Some of theme are wrong TODO C


Failed attempt with topojson :
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
