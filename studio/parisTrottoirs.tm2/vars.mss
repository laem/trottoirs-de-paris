// Languages: name (local), name_en, name_fr, name_es, name_de
@name: '[name_en]';

////////////////////////////////////////////////
// FONTS //
////////////////////////////////////////////////

@med: "Meta Offc Pro Medium", "Arial Unicode MS Regular";
@reg: "Meta Offc Pro Normal", "Arial Unicode MS Regular";
@lt: "Meta Offc Pro Light", "Arial Unicode MS Regular";
@bold: "Meta Offc Pro Bold", "Arial Unicode MS Bold";
@it: "Meta Offc Pro Normal Italic", "Arial Unicode MS Regular";

////////////////////////////////////////////////
// COLORS //
////////////////////////////////////////////////

@black: #222;
@gray-1: #F5F5F5;
@gray-2: #E5E5E5;
@gray-3: #CCC;
@gray-4: #999;
@gray-5: #666;

@blue: #21B5EA;
@blue_lt: lighten(@blue,10);
@yellow: #fcf302;
@blue-gray: desaturate(@blue, 40);
//@green: #05E29E;
@green: #05e24e;
@green-desat: desaturate(lighten(@green, 30), 45);

// Landuse colors //

// Core landuse colors
@water: desaturate(@blue, 45);
@land: @gray-2;
@park: @green-desat;
@sand: mix(@yellow, @land, 15);
@snow: lighten(desaturate(@blue, 45), 35);

// All these variables are based off of core landuse colors
@cemetery:          mix(@park, @building, 30);
@wooded:            mix(@sand,@park, 30);
@pitch:             @park;
@sports:            @park;
@hospital:          darken(@land,3);
@school:            darken(@land,4);
@industrial:        darken(@land, 5);
@aeroway:           lighten(@land,4);
@glacier:           darken(@snow, 10);
@parking: lighten(@building, 1); // temp, need to change

@building:          @land;
@building_line:     @gray-3;

@fence:             @building_line;
@gate:              @gray-4;
@cliff:             mix(@sand, @land, 30) * 0.9;

// Landcover //
@wooded: @wooded;
@scrub: lighten(@wooded, 3);
@grass: lighten(@wooded, 6);
@crop: lighten(@wooded, 9);
@snow: @snow;

// Road colors //
@rail:              lighten(@gray-3, 2);
@motorway_fill:     lighten(@land, 4);
@motorway_case:     darken(@gray-3, 1);
@piste: 			@glacier;

// Label colors //
@place_halo: fadeout(@land, 90);

@country_text: @black;
@country_text_high: @gray-4;
@country_halo: fadeout(#fff, 90);

@state_text:@gray-4;
@state_halo: fadeout(#fff, 90);

@city_text: @black;
@city_text_high:@gray-4;
@city_halo: fadeout(#fff, 90);
@town_text: @black;
@town_text_high: @city_text_high;
@town_halo: fadeout(#fff, 90);
@village_text: @black;
@village_text_high: @city_text_high;
@village_halo: fadeout(#fff, 90);
@neigh_text: @black;
@neigh_text_high:@city_text_high;
@neigh_halo: fadeout(#fff, 90);

@marine_text: lighten(desaturate(@blue, 20), 10);

@poi_text: darken(@gray-4, 5);
@poi_halo: fadeout(#fff, 95);
@peak_text: @gray-5;
@peak_halo: park_halo;
@park_text: darken(@park, 45);
@park_halo: fadeout(#fff, 90);
@transport_text: @gray-5;
@transport_halo: fadeout(#fff, 90);

@road_text: darken(@gray-4, 3);
@road_text_high:@gray-5;
@road_text_high2:@black;
@road_halo: #fff;
@motorway_halo: @motorway_fill;

// Admin boundaries
@admin_2: darken(@land, 15);
@admin_2_hi: darken(@admin_2, 10);
@admin_2_hi2: darken(@admin_2, 25);
@admin_3: darken(@admin_2, 15);
@admin_3_hi: darken(@admin_2, 25);


