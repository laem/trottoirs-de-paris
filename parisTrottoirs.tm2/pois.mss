////////////////////////////////////////////////
// POI //
////////////////////////////////////////////////

//#poi_label[maki=''] { opacity:1; } // hack for mapnik#1952

// Rail //
#poi_label[type='Rail Station'][network=''] { opacity:1; } // hack for mapnik#1952

// Note: != null condition is a workaround for mapnik#1952.
#poi_label[type='Rail Station'][network!=null][scalerank=1][zoom>=14],
#poi_label[type='Rail Station'][network!=null][scalerank=2][zoom>=15],
#poi_label[type='Rail Station'][network!=null][scalerank=3][zoom>=16],
#poi_label[type='Rail Station'][network!=null][scalerank=4][zoom>=17]{
  marker-file: url("img/rail/[network]-12.svg");
  marker-height: 12;
  marker-allow-overlap: false;
  [zoom=16] {
    marker-file: url("img/rail/[network]-18.svg");
    marker-height: 18;
  }
  [zoom>16] {
    marker-file: url("img/rail/[network]-12.svg");
    marker-height: 24;
    [scalerank=4] { marker-height: 12; }
    [scalerank=4][zoom>18] {
      marker-file: url("img/rail/[network]-18.svg");
      marker-height: 18;
    }
  }
  [zoom>15][scalerank!=4],
  [scalerank=4][zoom>=18] {
    text-name: @name;
    text-face-name: @bold;
    text-character-spacing: 0.5;
    text-fill: @transport_text;
    text-halo-fill: @transport_halo;
    text-halo-radius: 1.5;
    text-halo-rasterizer: fast;
    text-size: 10;
    text-wrap-width: 60;
    text-dy: 11;
    [zoom>=17][scalerank!=4] {
      text-size: 12;
      text-halo-radius: 2;
      text-dy: 15;
    }
  }
}

// Airports //
#poi_label[type='Aerodrome'][zoom>=12] {
  marker-file: url("img/air/[maki]-12.svg");
  text-name: "''";
  text-size: 8;
  text-fill: @transport_text;
  text-halo-fill: @transport_halo;
  text-halo-radius: 1.5;
  text-halo-rasterizer: fast;
  text-face-name: @bold;
  text-character-spacing: 0.5;
  text-placement-type: simple;
  text-placements: "S,N,E,W";
  text-dx: 6; text-dy: 6;
  [zoom>=12][zoom<=13][scalerank=1] {
    text-name: [ref];
  }
  [zoom>=14] {
    text-name: @name;
    text-wrap-before: true;
  }
  [zoom>=12][scalerank=1],
  [zoom>=13][scalerank=2],
  [zoom>=14] {
    marker-file: url("img/air/[maki]-18.svg");
    text-size: 8;
    text-dx: 10; text-dy: 10;
    text-wrap-width: 80;
  }
  [zoom>=13][scalerank=1],
  [zoom>=14][scalerank=2],
  [zoom>=15] {
    marker-file: url("img/air/[maki]-24.svg");
    text-size: 10;
    text-dx: 13; text-dy: 13;
    text-wrap-width: 100;
  }
  [zoom>=14][scalerank=1],
  [zoom>=15][scalerank=2],
  [zoom>=16] {
    marker-file: url("img/air/[maki]-24.svg");
    text-size: 12;
    text-dx: 17; text-dy: 17;
    text-wrap-width: 120;
  }
}

// Mountain peaks //
#poi_label[type='Peak'] {
  marker-file: url("img/maki/triangle-stroked-12.svg");
  marker-fill: @peak_text;
  marker-line-width: 0;  
  text-name: @name;
  text-face-name: @bold;
  text-size: 10;
  text-character-spacing: 0.5;
  text-wrap-width: 55;
  text-fill: @peak_text;
  text-halo-fill: @park_halo;
  text-halo-radius: 1.5;
  text-halo-rasterizer: fast;
  text-line-spacing: -4;
  text-dy: 10;
  [zoom>=15] { 
    text-size: 11; 
    text-dy: 11; 
    text-wrap-width: 60;}
  [zoom>=17] { 
    text-size: 12; 
    text-dy: 12; 
    text-wrap-width: 65;}
  [zoom>=19] { 
      text-size: 13; 
      text-dy: 13; 
      text-wrap-width: 70;
      marker-file: url("img/maki/triangle-stroked-18.svg");
  }
}

// Parks //
#poi_label [maki="park"] [scalerank<=4] {
  [zoom<14],
  [zoom>=14][scalerank<=2][localrank<=1],
  [zoom>=16][scalerank<=3][localrank<=1],
  [zoom>=17][localrank<=4],
  [zoom>=18][localrank<=16],
  [zoom>=19] {
  text-name: @name;
  text-face-name: @bold; 
  text-character-spacing: 0.5;  
  text-fill: @park_text;
  text-size: 10;
  text-halo-fill: @park_halo;
  text-halo-radius: 1.5;
  text-halo-rasterizer: fast;
  text-wrap-width: 55;
  text-line-spacing: -4;
  [scalerank=1] {
      [zoom>=15] { text-size: 11; text-wrap-width: 60; }
      [zoom>=16] { text-size: 12; text-wrap-width: 65; }
      [zoom>=17] { text-size: 14; text-wrap-width: 75; }
      [zoom>=18] { text-size: 16; text-wrap-width: 85; }
    }
    [scalerank=2] {
      [zoom>=16] { text-size: 11; text-wrap-width: 60; }
      [zoom>=17] { text-size: 12; text-wrap-width: 65; }
      [zoom>=18] { text-size: 14; text-wrap-width: 75; }
    }
    [scalerank>=3] {
      [zoom>=17] { text-size: 11; text-wrap-width: 60; }
      [zoom>=19] { text-size: 12; text-wrap-width: 65; }
    }
   } 
  }

// Other POIs

// Scalerank <= 3
#poi_label [maki!='park'][type!='Aerodrome'][type!='Rail Station'][type!='Peak'][scalerank<=3] {
  [zoom<14],
  [zoom>=14][scalerank=1][localrank<=1],
  [zoom>=15][scalerank<=2][localrank<=1],
  [zoom>=16][scalerank<=3][localrank<=1],
  [zoom>=19] {
  text-name: @name;
  text-face-name: @bold;  
  text-fill: @poi_text;  
  text-size: 9;
  text-character-spacing: 0.5;  
  text-halo-fill: @poi_halo;
  text-halo-radius: 1.5;
  text-halo-rasterizer: fast;
  text-wrap-width: 50;
  text-dy: 10; 
  text-line-spacing: -4;
  [scalerank=1] {
    [zoom>=15] { text-size: 11; text-wrap-width: 60; text-dy: 11; }
    [zoom>=16] { text-size: 12; text-wrap-width: 65; text-dy: 12; }
    [zoom>=17] { text-size: 14; text-wrap-width: 75; text-dy: 14; }
    [zoom>=18] { text-size: 16; text-wrap-width: 85; text-dy: 16; }
    [zoom>=19] { text-dy: 19; }
  }
  [scalerank=2] {
    [zoom>=16] { text-size: 11; text-wrap-width: 60; text-dy: 11; }
    [zoom>=17] { text-size: 12; text-wrap-width: 65; text-dy: 12; }
    [zoom>=18] { text-size: 14; text-wrap-width: 75; text-dy: 14; }
    [zoom>=19] { text-dy: 17; }
  }
  [scalerank>=3] {
    [zoom>=17] { text-size: 11; text-wrap-width: 60; text-dy: 11; }
    [zoom>=19] { text-size: 12; text-wrap-width: 65; text-dy: 15; }
  }
  marker-file: url("img/maki/[maki]-12.svg");
  marker-fill: darken(@poi_text, 3);   
  marker-line-color:@poi_halo;
  marker-line-opacity:1;
  [zoom>=19] { marker-file: url("img/maki/[maki]-18.svg"); } 
  [maki='golf'],  
  [maki='cemetery'] { 
      text-fill: @park_text; 
      marker-fill: @park_text;
    }   
  }
}

// Scalerank = 4
#poi_label [maki!='park'][type!='Aerodrome'][type!='Rail Station'][type!='Peak'][scalerank=4] {
  [zoom>=17][localrank<=1],
  [zoom>=18][localrank<=8],
  [zoom>=19] {
  text-name: @name;
  text-face-name: @bold;  
  text-fill: @poi_text;
  text-size: 9;
  text-character-spacing: 0.25;  
  text-halo-fill: @poi_halo;
  text-halo-radius: 1.5;
  text-halo-rasterizer: fast;
  text-wrap-width: 50;
  text-line-spacing: -4;
  text-dy: 9;  
  [zoom>=17] { 
      text-size: 10; 
      text-dy: 10; 
      text-wrap-width: 55;}
  [zoom>=19] { 
      text-size: 11; 
      text-dy: 14; 
      text-wrap-width: 60; 
  }  
  marker-file: url("img/maki/[maki]-12.svg");
  [zoom>=19] { marker-file: url("img/maki/[maki]-18.svg"); }
  marker-fill: darken(@poi_text, 3);
  }
}