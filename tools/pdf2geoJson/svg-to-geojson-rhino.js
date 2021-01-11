//load('svg-to-geojson/source/index.js');
load('../svg-to-geojson/dist/svg-to-geojson.min.js');
var svg = "<svg height='210' width='500'><polygon points='100,10 40,198 190,78 10,78 160,198' style='fill:lime;stroke:purple;stroke-width:5;fill-rule:nonzero;'/></svg>";
print(svg);
var geoJson = svgtogeojson.svgToGeoJson([
        [143.891121, -37.626194],
        [144.891121, -38.626194]
    ], svg, 3);
print(JSON.stringify(geoJson));