//@pedestrian-color:  #009688;
@pedestrian-color:  #a0e0ca;
//@pedestrian-color:  #ECE5C4;
//@pedestrian-color:  #D9CCBE;
//@pedestrian-color:  #839ac2;
//@pedestrian-color:  #c6a296;
//@pedestrian-color:  #dfb4bc;

#trottoirs-centre {
  polygon-fill: @pedestrian-color  ;
  polygon-pattern-comp-op: darken;
  polygon-pattern-opacity: 0;
  polygon-pattern-alignment: global;
  polygon-pattern-file: url('zebra-bw.png');
   [zoom<=16] {
      polygon-fill: darken(@pedestrian-color,3);  
    }
   [zoom<=15] {
      polygon-fill: darken(@pedestrian-color,9);  
    }
} 

//squares and pedestrian areas
#road[type='pedestrian'] {
  polygon-fill: @pedestrian-color;
  polygon-opacity: 1;
    [zoom<=16] {
      polygon-fill: darken(@pedestrian-color,1);  
    }
   [zoom<=15] {
      polygon-fill: darken(@pedestrian-color,3);  
    }
}

// parks

//http://wiki.openstreetmap.org/wiki/FR:Tag:highway%3Dpedestrian
//:amenity marketplace 
//:amenity=plaza
//:amenity=square
//feature Pedestrian

//:area yes
//:highway pedestrian

//:highway pedestrian
//:highway footway


