import { Component, OnInit} from '@angular/core';
import {IndoorDataService} from "./indoordata.service";

@Component({
  selector: 'app-root',
  templateUrl: 'app.component.html',
  styleUrls: ['app.component.css'],
  providers: [IndoorDataService],
})
export class AppComponent implements OnInit {
  title: string = 'Campus Wayfinding App';
  lat: number = -37.626791;
  lng: number = 143.892266;
  zoom: number = 18;
  geoJsonObject: Object;

constructor (private _indoorDataService: IndoorDataService) {}
 
// function to consume IndoorDataService observable
getGeoJSON(): void {
  this._indoorDataService.getGeoJson()
    .subscribe(resGeoJsonData => {
      this.geoJsonObject = resGeoJsonData.geoJson;
      this.lat = resGeoJsonData.center.lat;
      this.lng = resGeoJsonData.center.lng;
      this.zoom = resGeoJsonData.zoomLevel;
    });
}
// on init lifecycle hook
// We get the GeoJSON here
ngOnInit() : void {
  this.getGeoJSON();
}

styleFunc(feature) {
  // get level - 0/0
  var level = feature.getProperty('level');
  var color = 'green';
  // only show level one features
  var visibility = level == 0 ? true : false;
  return {
    // icon for point geometry(in this case - doors)
    icon: 'assets/door.png',
    // set fill color for polygon features
    fillColor: color,
    // stroke color for polygons
    strokeColor: color,
    strokeWeight: 1,
    // make layer 1 features visible
    visible: visibility
  };
}
}
