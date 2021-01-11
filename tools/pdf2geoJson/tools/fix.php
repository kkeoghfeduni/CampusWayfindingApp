<?php
$json_data = file_get_contents('FP-MTHBLevel0.geojson');
//var_dump(json_decode($json_data, true));

$indata = json_decode($json_data, true);

foreach ($indata['features'] as &$ft){
	foreach ($ft['geometry']['coordinates'][0] as &$coords) {
		$temp = $coords[0];
		$coords[0] = $coords[1];
		$coords[1] = $temp;
	}
}

echo "<pre>";
var_dump($indata);

$fp = fopen('FP-MTHBLevel0_fixed.geojson', 'w');
fwrite($fp, json_encode($indata));
fclose($fp);

echo "</pre>";
?>

