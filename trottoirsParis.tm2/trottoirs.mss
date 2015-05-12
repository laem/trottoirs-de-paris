@large: #8cd4bb;
@medium: #b1b0e6;
@small: #ff9800;
@tiny: #f44336;


#trottoirs-centre[t-width > 6] {
  polygon-fill: @large  ;
} 
#trottoirs-centre[t-width < 6] {
  polygon-fill: @medium  ;
} 
#trottoirs-centre[t-width < 2.5] {
  polygon-fill: @small  ;
} 
#trottoirs-centre[t-width <= 1.5 ] {
  polygon-fill: @tiny  ;
}
