import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { AppComponent } from './app.component';
import { AgmCoreModule } from '@agm/core';
import { HttpClientModule } from '@angular/common/http';
import { HeaderComponent } from './components/header/header.component';



@NgModule({
  imports: [
    BrowserModule,
    CommonModule,
    FormsModule,
    HttpClientModule,
    AgmCoreModule.forRoot({
      apiKey: 'AIzaSyAhk_-q37Q8sAyA2OyLrsIfAe2T8PH155U'
    }),

  ],
  providers: [],
  declarations: [ AppComponent, HeaderComponent ],
  bootstrap: [ AppComponent ]
  
})
export class AppModule {}