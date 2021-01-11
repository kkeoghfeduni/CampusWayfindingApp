//require('./svg-to-geojson/source/index.js');
require('./svg-to-geojson/dist/svg-to-geojson.min.js');
var svg = "<svg height='210' width='500'><polygon points='100,10 40,198 190,78 10,78 160,198' style='fill:lime;stroke:purple;stroke-width:5;fill-rule:nonzero;'/></svg>";
var geoJson = svgtogeojson.svgToGeoJson([
        [143.891121, -37.626194],
        [144.891121, -38.626194]
    ], svg, 3);
var http = require('http');
    http.createServer(function (req, res) {
      res.writeHead(200, {'Content-Type': 'text/plain'});
      res.end('Hello World\n');
    }).listen(1337, "127.0.0.1");
    console.log('Server running at http://127.0.0.1:1337/');
	console.log(JSON.stringify(geoJson));