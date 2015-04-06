db.t.insert({
	"type": "Feature",
	"properties": {
		"computed": true
	},
	"geometry": {
		"type": "LineString",
		"coordinates": [
			[2.379382788590524, 48.84552083430268],
			[2.378904730323302, 48.84509175567894]
		]
	}
})

db.t.find({
	properties: {
		computed: true
	}
})

db.t.find({
	geometry: {
		$geoIntersects: {
			$geometry: {"type":"LineString","coordinates":[[2.379382788590524,48.84552083430268],[2.3791172006642896,48.84528245774338]]}
		}
	}
})

db.runCommand({
	geoNear: "t",
	near: { type: "Point", coordinates: [2.379382788590524,48.84552083430268] },
	spherical: true,
  maxDistance: 90
}).results.length

db.runCommand({
	geoNear: "v",
	near: { type: "Point", coordinates: [ 2.364621097806873, 48.87054776611247 ] },
	spherical: true,
  maxDistance: 20
}).results.length
