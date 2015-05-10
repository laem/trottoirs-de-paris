# What ? 

Maps are made for cars. Are they still relevant in Paris, where pedestrians ??
This is what a street in Paris looks like on maps : 

[image]

The road isn't so tiny, nor does it span the whole street width. 
What's missing here is the pavement width. 

# How it works 

# Running this project 

Install mongodb 3 : http://docs.mongodb.org/manual/installation/
For ubuntu :
```
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
echo "deb http://repo.mongodb.org/apt/ubuntu "$(lsb_release -sc)"/mongodb-org/3.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.0.list
sudo apt-get update
sudo apt-get install -y mongodb-org
```




[Download](http://parisdata.opendatasoft.com/explore/dataset/trottoirs_des_rues_de_paris/download/?format=geojson&timezone=Europe/Berlin) the 'trottoirs' (pavements) geojson features

Transform the downloaded file for the import :

```
sed 's/{"type":"FeatureCollection","features"://g' trottoirs_des_rues_de_paris.geojson > tmpjson
sed '$s/.$//' tmpjson > mongoimport.json
```

BUT the Paris trottoirs geojson file has a weird offset. Correct that :

```
node d.js
mongoimport --db agreable --collection t --file d.ok.json --jsonArray
```


We should repeat the operation for the 'Volumes Batis' (buildings) [file](http://parisdata.opendatasoft.com/explore/dataset/volumesbatisparis2011/download/?format=geojson&timezone=Europe/Berlin). **Unfortunately**, some of them can't be indexed by mongoDB (malformed geojson polygons).
[Here](LINK) is an export of the buildings filtered (~50 of them are missing).

```
tar -jxvf v-correct.tar.bz2
mongoimport --db agreable --collection v --file v-correct.json --jsonArray
```





[Archive] failed attempt with topojson :
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
