var fs = require('fs')
var items = require('./mongoimport.json')

//48.844800, 2.383192 48.844812, 2.383289
var p1 = [2.383075, 48.844875]
var p2 = [2.383708, 48.844931]
var q1 = [2.383192, 48.844800]
var q2 = [2.383289, 48.844812]
var diff = {
	long: p1[0] - p2[0] + q1[0] - q2[0],
	lat: p1[1] - p2[1] + q1[1] - q2[1]
}
// diff.long : -0.00073
// diff.lat : -0.000068

function transformCoords(coords){
	//more precise values than above
	return [coords[0] - 0.000724, coords[1] - 0.0000685]
}



items.map(function(item){
	var g = item.geometry,
	coordList = g.coordinates;
	item.geometry.coordinates = coordList.map(function(coords){
		if (typeof coords[0] !== "object" && coords.length === 2){
			return transformCoords(coords)
		} else {
			return coords.map(function(deeperCoords){
				return transformCoords(deeperCoords)
			})
		}
	})
	return item
})

fs.writeFile("./d.ok.json", JSON.stringify(items), function(err) {
    if(err) {
        return console.log(err);
    }

    console.log("The file was saved!");
});
