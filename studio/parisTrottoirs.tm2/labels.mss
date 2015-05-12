////////////////////////////////////////////////
// Places //
////////////////////////////////////////////////

// Countries //
#country_label[zoom>=2] {
  text-name: @name;
  text-face-name: @med;
  text-wrap-width: 140;
  text-wrap-before: true;
  text-fill: @country_text;
  text-halo-fill: @country_halo;
  text-halo-radius: 2;
  text-halo-rasterizer: fast;
  text-size: 12;
  [zoom>=3][scalerank=1],
  [zoom>=4][scalerank=2],
  [zoom>=5][scalerank=3],
  [zoom>=6][scalerank>3] {
    text-size: 14;
    text-wrap-width: 160;
  }
  [zoom>=4][scalerank=1],
  [zoom>=5][scalerank=2],
  [zoom>=6][scalerank=3],
  [zoom>=7][scalerank>3] {
    text-size: 16;
    text-wrap-width: 185;
  }
  [zoom>=8] { text-fill: @country_text_high; }  
}

#country_label_line {
  line-color: #324;
  line-opacity: 0.05;
}

// States //
#state_label[zoom>=4][zoom<=10] {
  text-name: @name;
  text-face-name: @reg;
  text-transform: uppercase;
  text-character-spacing: 1.5;
  text-placement: point;
  text-fill: @state_text;
  text-halo-fill: @state_halo;
  text-opacity: 1;
  text-halo-radius: 1.5;
  text-halo-rasterizer: fast;
  text-size: 10;
  [zoom>=5][zoom<=6] {
    [area>10000] { text-size: 10; }
    [area>50000] { text-size: 11; }
    text-wrap-width: 40;
  }
  [zoom>=7] {
    text-size: 12;
    [area>50000] { text-size: 13;  }
    [area>100000] { text-size: 14; }
    text-wrap-width: 60;
  }
  [zoom>=8] {
    text-size: 16;
    [area>50000] { text-size: 18;  }
    [area>100000] { text-size: 20; }
    text-wrap-width: 80;
  }
  [zoom>=9][zoom<=10] {
    text-size: 18;
    [area>50000] { text-size: 20; }
    text-wrap-width: 100;
  }
}

// City dots – version with markers as text
#place_label::citydots[type='city'][zoom>=4][zoom<=7][localrank<=2] {
 [ldir='N'],[ldir='S'],[ldir='E'],[ldir='W'],
 [ldir='NE'],[ldir='SE'],[ldir='SW'],[ldir='NW'] {
  // explicitly defining all the `ldir` values wer'e going
  // to use shaves a bit off the final project.xml size
 [ldir='E'] {
      text-name: '∘ ' + [name_en];
      text-horizontal-alignment: right; 
      }
    [ldir='W'] {
      text-name: [name_en] + ' ∘';
      text-horizontal-alignment: left; 
      }
    [ldir='S'] { 
      text-name: '∘\n' + [name_en];
      text-line-spacing: -10;
      text-vertical-alignment: bottom;
      } 
     [ldir='N'] {
      text-name: [name_en] + '\n∘';
      text-line-spacing: -10;
      text-vertical-alignment: top;
      }
    [ldir='SE'] {
      text-name: '∘\n  ' + [name_en];
      text-line-spacing: -15;
      text-vertical-alignment: bottom;
      text-horizontal-alignment: right;
      text-align: left;
      }
    [ldir='SW'] {
      text-name: '∘\n' + [name_en] + '  ';
      text-line-spacing: -16;
      text-vertical-alignment: bottom;
      text-horizontal-alignment: left;
      text-align: right;
      }
     [ldir='NE'] {
      text-name: '  ' + [name_en] + '\n∘';
      text-line-spacing: -16;
      text-vertical-alignment: top;
      text-horizontal-alignment: right;
      text-align: left;
      }
    [ldir='NW'] {
      text-name: [name_en] + '  \n∘';
      text-line-spacing: -15;
      text-vertical-alignment: top;
      text-horizontal-alignment: left;
      text-align: right;
      }
    text-name: @name;
    text-size: 16;
    text-face-name: @reg;
    text-placement: point;
    text-fill: @city_text;
    text-halo-fill: @city_halo;
    text-halo-radius: 2;
    text-halo-rasterizer: fast;  
    }
}

#place_label {
  [type='city'][zoom>=8][zoom<=15][localrank<=2] {
    text-name: @name;
    text-face-name: @reg;
    text-fill: @city_text;
    text-halo-fill: @city_halo;
    text-halo-radius: 2;
    text-halo-rasterizer: fast;
    text-size: 16;
    text-line-spacing: -8;
    text-wrap-width: 160;
    text-wrap-before: true;
    [zoom>=9] { 
      text-size: 17; 
      text-wrap-width: 170; }
    [zoom>=10] { 
      text-size: 18; 
      text-wrap-width: 180; }
    [zoom>=12] { 
      text-size: 24;
      text-character-spacing: 0;
      text-wrap-width: 220; 
      }
    [zoom>=14] { 
        text-fill: @city_text_high; 
        text-size: 28;
        text-wrap-width: 250;
      } 
    }
  }

#place_label {  
  [type='town'][zoom>=8][zoom<=17][localrank<=2] {
    text-name: @name;
    text-face-name: @reg;
    text-fill: @town_text;
    text-halo-fill: @town_halo;
    text-halo-radius: 2;
    text-halo-rasterizer: fast;
    text-size: 12;
    text-line-spacing: -8;
    text-wrap-width: 100;
    text-wrap-before: true;
    [zoom>=10] { 
      text-size: 14;
      text-wrap-width: 120;  
       }
    [zoom>=12] { 
      text-size: 20;
      text-wrap-width: 160;  
      }
    [zoom>=14] { 
      text-fill: @town_text_high; 
      text-size: 26;
      text-wrap-width: 200;
      }
    [zoom>=16] { 
      text-size: 28;
      text-wrap-width: 180;  
    }
  }
  [type='village'][zoom>=10][zoom<=18][localrank<=2],
  [type='hamlet'][zoom>=12][zoom<=18][localrank<=2]  {
    text-name: @name;
    text-face-name: @reg;
    text-fill: @village_text;
    text-halo-fill: @village_halo;
    text-halo-radius: 2;
    text-halo-rasterizer: fast;
    text-size: 12;
    text-wrap-width: 100;
    text-line-spacing: -8;
    text-wrap-before: true;
    [type='village'] {
    [zoom>=12] { 
        text-size: 18; 
        text-wrap-width: 180; 
    }
    [zoom>=14] { 
        text-size: 20; 
        text-wrap-width: 200; 
    }
    [zoom>=16] {
        text-fill: @village_text_high;
        text-size: 24; 
        text-wrap-width: 240; 
     }
     [zoom>=18] {
        text-size: 26; 
        text-wrap-width: 250; 
      }
    }
    [type='hamlet'] {
    [zoom>=12] { 
        text-size: 16; 
        text-wrap-width: 160;
    }
    [zoom>=14] { 
        text-size: 18; 
        text-wrap-width: 180; 
     }
     [zoom>=16] {
        text-fill: @village_text_high;
        text-size: 22; 
        text-wrap-width: 220; 
      }
      [zoom>=18] {
        text-size: 24; 
        text-wrap-width: 240; 
       }
    }
 }
  
  [type='suburb'][zoom>=12][zoom<=17][localrank<=2],
  [type='neighbourhood'][zoom>=13][zoom<=17][localrank<=2] {
    text-name: @name;
    text-face-name: @reg;
    text-fill: @neigh_text;
    text-halo-fill: @neigh_halo;
    text-halo-radius: 2;
    text-halo-rasterizer: fast;
    text-size: 14;
    text-wrap-width: 100;
    text-wrap-before: true;
    text-line-spacing: -8;
    [type='suburb'][zoom>=13],
    [type='neighbourhood'][zoom>=14] {
      text-size: 16; 
      text-wrap-width: 160; 
    }
    [type='suburb'][zoom>=14],
    [type='neighbourhood'][zoom>=15] {
      text-size: 18; 
      text-wrap-width: 180;
    }
    [type='suburb'][zoom>=15],
    [type='neighbourhood'][zoom>=16] {
      text-size: 20; 
      text-wrap-width: 200;
      }
     [type='suburb'][zoom>=16],
     [type='neighbourhood'][zoom>=17] {
       text-size: 22; 
       text-wrap-width: 220;
     }
     [type='suburb'][zoom>=17] {
       text-size: 24; 
       text-wrap-width: 240;
      }
    [zoom>=16] { text-fill:@neigh_text_high; }
  }
}

////////////////////////////////////////////////
// Water Features //
////////////////////////////////////////////////

// Water bodies //
#water_label {
  [zoom<=13],  // automatic area filtering @ low zooms
  [zoom>=14][area>500000],
  [zoom>=16][area>10000],
  [zoom>=17] {
    text-name: @name;
    text-face-name: @it;
    text-fill: darken(@marine_text, 10);
    text-character-spacing: 0.5; 
    text-size: 9;
    text-wrap-width: 60;
    text-wrap-before: true;
    text-halo-fill: fadeout(#fff, 95);
    text-halo-radius: 1.5;
    text-halo-rasterizer:fast;
  }
  [zoom>=15][area>500000],
  [zoom>=17][area>10000],
  [zoom>=18]  {
    text-size: 10;
    text-wrap-width: 70;
  }
  [zoom>=16][area>500000],
  [zoom>=18][area>10000],
  [zoom>=19]  {
    text-size: 11;
    text-wrap-width: 80;
  }
  [zoom>=12][area>10000000],
  [zoom>=14][area>5000000]  {
    text-size: 12;
    text-wrap-width: 90;
  }
  [zoom>=10][area>100000000]  {
    text-size: 13;
    text-wrap-width: 90;
  }
}

// Waterways //
#waterway_label {
  [class="river"][zoom>=13],
  [class="canal"][zoom>=15],
  [class="stream"][zoom>=17], 
  [class="stream_intermittent"][zoom>=17] {
    text-placement: line;
    text-avoid-edges:true;
    text-min-distance: 400;
    text-name: @name;
    text-face-name: @it;
    text-fill: darken(@marine_text, 5);
    text-size: 10;
    text-character-spacing: 0.5; 
    text-halo-fill: fadeout(#fff, 95);
    text-halo-radius: 1.5;
    text-halo-rasterizer:fast;
  } 
  [class="river"][zoom>=14],
  [class="canal"][zoom>=16],
  [class="stream"][zoom>=18], 
  [class="stream_intermittent"][zoom>=18] {
    text-size: 11;
  }
  [class='river'][zoom=15],
  [class='canal'][zoom>=17] {
    text-size: 12;
  }
  [class='river'][zoom>=16],
  [class='canal'][zoom>=18] {
    text-size: 13;
  }
}

// Marine (oceans and seas) //
#marine_label {
  text-name: @name;
  text-face-name: @it;
  text-fill: @marine_text;
  text-wrap-width: 70;
  text-wrap-before: true;
  text-halo-fill: fadeout(#fff, 95);
  text-halo-radius: 2;
  [placement = 'point'] {
    text-placement: point;
  }
  [placement = 'line'] {
    text-placement: line;
    text-avoid-edges: true;
  }
  [labelrank = 1] {
    text-wrap-width: 400;
    [zoom = 3] {
      text-size: 14;
      text-character-spacing: 4;
      text-line-spacing: 16;
    }
    [zoom = 4] {
      text-size: 16;
      text-character-spacing: 6;
      text-line-spacing: 24;
    }
    [zoom = 5] {
      text-size: 18;
      text-character-spacing: 8;
      text-line-spacing: 32;
    }
  }
  [labelrank = 2] {
    [zoom = 3] {
      text-size: 10;
      text-character-spacing: 2;
      text-line-spacing: 6;
    }
    [zoom = 4] {
      text-size: 11;
      text-character-spacing: 2;
      text-line-spacing: 8;
    }
    [zoom = 5] {
      text-size: 17;
      text-character-spacing: 4;
      text-line-spacing: 8;
    }
    [zoom = 6] {
      text-size: 19;
      text-character-spacing: 5;
      text-line-spacing: 10;
    }
  }
  [labelrank = 3] {
    [zoom = 3] {
      text-size: 9;
      text-character-spacing: 2;
      text-line-spacing: 3;
    }
    [zoom = 4] {
      text-size: 10;
      text-character-spacing: 2;
      text-line-spacing: 8;
    }
    [zoom = 5] {
      text-size: 12;
      text-character-spacing: 4;
      text-line-spacing: 8;
    }
    [zoom = 6] {
      text-size: 15;
      text-character-spacing: 5;
      text-line-spacing: 10;
    }
  }
  [labelrank = 4][zoom = 4],
  [labelrank = 5][zoom = 5],
  [labelrank = 6][zoom = 6] {
    text-size: 9;
    text-character-spacing: 2;
    text-line-spacing: 6;
  }
  [labelrank = 4][zoom = 5],
  [labelrank = 5][zoom = 6],
  [labelrank = 6][zoom = 7] {
    text-size: 11;
    text-character-spacing: 3;
    text-line-spacing: 8;
  }
  [labelrank = 4][zoom = 6],
  [labelrank = 5][zoom = 7] {
    text-size: 16;
    text-character-spacing: 4;
    text-line-spacing: 1;
  }
}

////////////////////////////////////////////////
// Road labels //
////////////////////////////////////////////////

// Highway shields //
#road_label[class='motorway'][zoom>=10][zoom<=20][reflen>0][reflen<=6] {
  shield-name: "[ref]";
  shield-size: 9;
  shield-face-name: @med;
  shield-fill: @road_text;
  shield-spacing: 200;
  shield-avoid-edges: true;
  shield-min-distance: 50;
  shield-min-padding: 10;
  shield-file: url('img/motorway/motorway_sm_[reflen].png');
  [zoom>14] {
    shield-spacing: 400;
    shield-min-distance: 60;
    shield-size: 11;
    shield-file: url('img/motorway/motorway_lg_[reflen].png');
  }
  [zoom>=16] { shield-fill: @road_text_high; }
}
// Larger roads //
#road_label['mapnik::geometry_type'=2] {
  // Longer roads get a label earlier as they are likely to be more
  // important. This especially helps label density in rural/remote areas.
  // This z14 filter is *not* redundant to logic in SQL queries. Because z14
  // includes all data for z14+ via overzooming, the streets included in a
  // z14 vector tile include more features than ideal for optimal performance.
  [class='motorway'][zoom>=14],
  [class='main'][zoom<=12][len>5000],  
  [class='main'][zoom>=13][len>2000],
  [class='main'][zoom>=14][len>1500], 
  [class='main'][zoom>=15][len>750],  
  [class='main'][zoom>=16],
  [class='street'][zoom>=15][len>1500],  
  [class='street'][zoom>=16],
  [class='street_limited'][zoom>=16] {
    text-avoid-edges: true;
    text-name: [name];
    text-character-spacing: 0.25;
    text-placement: line;
    text-face-name: @reg;
    text-fill: @road_text;
    text-size: 11;
    text-halo-fill: @road_halo;
    text-halo-radius: 1;
    text-halo-rasterizer: fast;
    text-min-distance: 200; // only for labels w/ the same name
    [class='motorway'] { text-halo-fill: @motorway_halo; }
    [zoom>=14] { 
      text-size: 11; 
      text-fill: @road_text_high; 
    }
    [zoom>=16] { text-fill: @road_text_high2; }
    [zoom>=17] { text-size: 12;  }
    [class='motorway'],
    [class='main'] {
      [zoom>=14] { 
        text-size: 12; 
        text-fill: @road_text_high; 
      }
      [zoom>=16] { 
        text-size: 13; 
        text-fill: @road_text_high2;  
      }
      [zoom>=17] { text-size: 14; }
      [zoom>=18] { text-size: 15;  }
    }
  }
}

// Smaller roads //
#road_label['mapnik::geometry_type'=2]
  [class!='motorway']
  [class!='main']
  [class!='street']
  [class!='street_limited'] {
    [len>750][zoom>=16],
    [len>0][zoom>=17] {  
      text-avoid-edges: true;
      text-name: [name];
      text-character-spacing: 0.25;
      text-placement: line;
      text-face-name: @reg;
      text-fill: @road_text;
      text-size: 11;
      text-halo-fill: @road_halo;
      text-halo-radius: 1;
      text-halo-rasterizer: fast;
      text-min-distance: 200; // only for labels w/ the same name
      [zoom>=15] { text-fill: @road_text_high; }
    }   
 }  