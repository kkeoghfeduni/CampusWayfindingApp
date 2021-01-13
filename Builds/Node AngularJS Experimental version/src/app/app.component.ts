import { Component } from '@angular/core';

@Component({
  selector: 'app-root',
  templateUrl: 'app.component.html',
  styleUrls: ['app.component.css'],
})
export class AppComponent {
  title: string = 'Campus Wayfinding App';
  lat: number = -37.626791;
  lng: number = 143.892266;
}
