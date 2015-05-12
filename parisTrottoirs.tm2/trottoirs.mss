@large: #8cd4bb;
@medium: #b1b0e6;
@small: #ff9800;
@tiny: #f44336;
@vivid-tiny: #fd0000;

#trottoirs-centre[t-width > 5] {
  polygon-fill: @large  ;
} 
#trottoirs-centre[t-width < 5] {
  polygon-fill: @medium  ;
} 
#trottoirs-centre[t-width < 2] {
  polygon-fill: @small  ;
} 
#trottoirs-centre[t-width <= 1.5 ] {
  polygon-fill: @tiny  ;
   [zoom>= 18] {
      polygon-fill: @vivid-tiny
    }
}


//squares and pedestrian areas
#road[type='pedestrian'] {
  polygon-fill: @large;
}
