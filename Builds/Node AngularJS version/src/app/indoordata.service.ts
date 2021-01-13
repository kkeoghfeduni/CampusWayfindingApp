import { Injectable } from '@angular/core';
import { HttpClient, HttpResponse } from '@angular/common/http';
import { map } from 'rxjs/operators';
import { Observable } from "rxjs";


@Injectable()
export class IndoorDataService {

  theDataSource: Observable<any>;
 
  // location of GeoJSON file in server
  private _url: string = 'assets/e0test.geojson';
 
  constructor(private _http: HttpClient) {}
 
  // fetch the file and parse the result as JSON
  getGeoJson() {
    return this._http.get(this._url)
    .pipe(map((response: any) => response.json()));
  }
}