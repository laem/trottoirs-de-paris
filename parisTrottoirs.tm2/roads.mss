////////////////////////////////////////////////
// Roads & Railways //
////////////////////////////////////////////////

#tunnel { opacity: 0.5; }

// Highways and rails are grayed out
#road,
#tunnel,
#bridge {
  ['mapnik::geometry_type'=2] {
    [class='motorway'][zoom>=10],
    [class='motorway_link'][zoom>=10] {
      ::casing {
        line-color: @motorway_case;
        line-width: 1 + 2;
        line-join: round;  
        [zoom>=10] { line-width: 1 + 2; }
        [zoom>=12] { line-width: 1.5 + 2; }    
        [zoom>=14] { line-width: 3 + 2; }  
        [zoom>=16] { line-width: 6 + 2; }
        [zoom>=18] { line-width: 12 + 3; }
      }
      ::fill {
        line-color: @motorway_fill;
        line-width: 1;
        line-join: round;  
        [zoom>=10] { line-width: 1; }
        [zoom>=12] { line-width: 1.5; }  
        [zoom>=14] { line-width: 3; }    
        [zoom>=16] { line-width: 6; }
        [zoom>=18] { line-width: 12; }  
      }
    }
    [class='major_rail'][zoom>=12],
    [class='minor_rail'][zoom>=12] {
       ::rails[zoom>=14]  {
         line-color: @rail;
         line-width: 1;  
         [zoom>=14] { line-offset: 1.5;
                      a/line-offset: -1.5; 
                      a/line-color: @rail; }  
         [zoom>=16] { line-offset: 2;
                      a/line-offset: -2; 
                      a/line-width: 1;  }
         [zoom>=18] { line-offset: 4;
                      a/line-offset: -4; 
                      a/line-width: 1;  }
         [zoom>=20] { line-offset: 5;
                      a/line-offset: -5; 
                      a/line-width: 1;  }  
      }
      ::low-fill[zoom>=12][zoom<=13] { line-color: @rail;
                                       line-width: 2;
      }  
      ::fill[zoom>=14] {
        line-color: @land;
        line-width: 1.5;
        line-opacity: 0.25;
        line-comp-op: color-burn;  
        [zoom>=14] { line-width: 3; 
                     ties/line-width: 3 + 2;
                     ties/line-color: @rail;
                     ties/line-dasharray: 1, 4;
        }    
        [zoom>=16] { line-width: 4; 
                     ties/line-width: 4 + 4;
        }
        [zoom>=18] { line-width: 8;
                     ties/line-width: 8 + 4;
        }  
        [zoom>=20] { line-width: 10;
                     ties/line-width: 10 + 4;
        }    
      }
    }
  }
}

// Adds casings to bridges
#bridge::casing {
  ['mapnik::geometry_type'=2]
    [class!='motorway'][class!='motorway_link']
    [class!='major_rail'][class!='minor_rail'] {
      line-color: @land;
      line-width: 0.5 + 2;
      line-join: round;
      [class='main'] {
        [zoom>=10] { line-width: 1 + 2; }
        [zoom>=12] { line-width: 1.5 + 2; }
        [zoom>=13] { line-width: 2.5 + 2; }
        [zoom>=14] { line-width: 4 + 2; }
        [zoom>=15] { line-width: 6 + 2; }
        [zoom>=16] { line-width: 7 + 3; }
        [zoom>=17] { line-width: 12 + 3; }
        [zoom>=18] { line-width: 15 + 3; }
      }
      [class='street'],
      [class='street_limited'] {
        [zoom<=13] { line-opacity: 0.5 + 2; }
        [zoom>=14] { line-width: 1 + 2; }
        [zoom>=15] { line-width: 1.5 + 2; }
        [zoom>=16] { line-width: 5 + 3; }
        [zoom>=18] { line-width: 8 + 3; }
      }
   // Casing is same width as path (since they're dashed)
      [class='path'][type!='steps'] {
        [zoom<=14] { line-opacity: 0.5; }
        [zoom>=13] { line-width: 0.75; }
        [zoom>=14] { line-width: 1.5; }
        [zoom>=16] { line-width: 2; }
        [zoom>=18] { line-width: 4; }
        [zoom>=20] { line-width: 6; }
      }
   // Casing is same width as stairs (since they're dashed) 
     [class='path'][type='steps'] {
       [zoom>=17] { line-width: 6; }
       [zoom>=18] { line-width: 12; } 
     }
     [class='service'][zoom>=10] {
       [zoom>=14] { line-width: 1 + 2; }
       [zoom>=16] { line-width: 2 + 3; }
       [zoom>=18] { line-width: 3 + 3; }
     }
   // Casing is same width as driveway (since they're dashed) 
     [class='driveway'][zoom>=10] { 
       [zoom>=17] { line-width: 2; }
       [zoom>=18] { line-width: 3; }
     } 
  }
}

#road,
#tunnel,
#bridge {
  ['mapnik::geometry_type'=2]
    [class!='motorway'][class!='motorway_link']
    [class!='major_rail'][class!='minor_rail'] {
    line-color: #fff;
    line-width: 0.5;
    line-cap: round;
    line-join: round;
    [class='main'] {
      [zoom>=10] { line-width: 1; }
      [zoom>=12] { line-width: 1.5; }
      [zoom>=13] { line-width: 2.5; }
      [zoom>=14] { line-width: 4; }
      [zoom>=15] { line-width: 6; }
      [zoom>=16] { line-width: 10; }
      [zoom>=17] { line-width: 12; }
      [zoom>=18] { line-width: 15; }
    }
    [class='street'],
    [class='street_limited'] {
      [zoom<=14] { line-opacity: 0.75; }
      [zoom=14] { line-width: 1; }
      [zoom>=15] { line-width: 1.5; }
      [zoom>=16] { line-width: 5; }
      [zoom>=18] { line-width: 8; }
    }
    [class='street_limited'] { line-dasharray: 4,1; }
    [class='path'][type!='steps'] {
      [zoom>=13] { line-width: 0.75; }
      [zoom>=14] { line-width: 1.25; line-dasharray: 0.5, 1.75;  }
      [zoom>=16] { line-width: 2; line-dasharray: 0.5, 3; }
      [zoom>=18] { line-width: 4; line-dasharray: 1, 5; }
      [zoom>=20] { line-width: 6; line-dasharray: 1, 7; }
      [type='piste'] { line-color: @piste; }
    }
    [class='path'][type='steps'] {
      line-cap: butt;
      line-smooth: 1;  
      [zoom>=17] { line-width: 6; line-dasharray: 2, 2; line-smooth: 1;  }
      [zoom>=18] { line-width: 10; }
      [zoom>=20] { line-dasharray: 3, 3; }  
    }
    [class='service'][zoom>=10] {
      [zoom>=14] { line-width: 1; }
      [zoom>=16] { line-width: 3; }
      [zoom>=18] { line-width: 6; }
    }
    [class='driveway'][zoom>=10] { 
      [zoom>=17] { line-width: 2; line-dasharray: 4, 4; }
      [zoom>=18] { line-width: 3; line-dasharray: 6, 5; }
    }
  }
  // Road polygons, mainly 'street' and 'street_limited' pedestrian zones
  ['mapnik::geometry_type'=3]
    [class!='motorway'][class!='motorway_link']
    [class!='major_rail'][class!='minor_rail'] {
     f/polygon-fill: #fff;
     f/polygon-opacity: 0.5; 
    }
}

////////////////////////////////////////////////
// One-way Arrows //
////////////////////////////////////////////////

// These are drawn on the actual road layers to ensure correct ordering
// of arrows on bridges & tunnels.
#road::fill,
#road,
#bridge::fill,
#bridge,
#tunnel {
  ['mapnik::geometry_type'=2][zoom>=16][oneway=1] {
    [class='motorway_link'],
    [class='main'],
    [class='street'],
    [class='street_limited'] {
      marker-file: url(img/road/oneway.svg);
      marker-allow-overlap: true;
      marker-ignore-placement: true;
      marker-placement:line;
      marker-max-error: 0.5;
      marker-spacing: 200;
      [zoom=16] { marker-transform: "scale(0.75)"; }
      [zoom=17] { marker-transform: "scale(1)"; }
      [zoom>17] { marker-transform: "scale(1.25)"; }
    }
  }
}