class_name Palettes

static var gm_gray_8 : Array[Color] = [
	Color(0,0,0),
	Color(0.125, 0.125, 0,125),
	Color(0.25,0.25,0.25),
	Color(0.375,0.375,0.375),
	Color(0.5,0.5,0.5),
	Color(0.625,0.625,0.625),
	Color(0.75,0.75,0.75),
	Color(0.875,0.875,0.875),
	Color(1,1,1),
]

static var cm_gray_4 : Array[Color] = [
	Color(0,0,0),
	Color(0.33,0.33,0.33),
	Color(0.66,0.66,0.66),
	Color(0.99,0.99,0.99)
]
static var red_lv = 0.4
static var cm_red_cyan : Array[Color] = [
	Color(red_lv,0,0),
	Color(red_lv, 0.125, 0,125),
	Color(red_lv,0.25,0.25),
	Color(red_lv,0.375,0.375),
	Color(red_lv,0.5,0.5),
	Color(red_lv,0.625,0.625),
	Color(red_lv,0.75,0.75),
	Color(red_lv,0.875,0.875),
	Color(red_lv,1,1),
]

static var blue_lv = 0.4
static var cm_blue_yellow : Array[Color] = [
	Color(0.0,0.0,blue_lv),
	Color(0.125,0.125, blue_lv),
	Color(0.25,0.25,blue_lv),
	Color(0.375,0.375,blue_lv),
	Color(0.5,0.5,blue_lv),
	Color(0.625,0.625,blue_lv),
	Color(0.75,0.75,blue_lv),
	Color(0.875,0.875,blue_lv),
	Color(1.0,1.0,blue_lv),
]

static var cm_terrain : Array[Color] = [
	Color(0.0,0.0,blue_lv),
	Color(0.0,0.0,blue_lv),
	Color(0.0,0.0,blue_lv),
	Color(0.0,0.0,blue_lv),
	Color(0.0,0.0,blue_lv),	
	Color(0.125,0.125, blue_lv),
	Color(0.125,0.125, blue_lv),
	Color(0.125,0.125, blue_lv),
	Color(0.125,0.125, blue_lv),
	Color(0.25, blue_lv, 0.125),
	Color(0.25, blue_lv, 0.125),	
	Color(0.25, blue_lv, 0.125),	
	Color(0.25, blue_lv, 0.125),	
	Color(0.25, blue_lv, 0.125),	
	Color(0.25, blue_lv, 0.125),
	Color(0.5,0.5,0.5),
	Color(0.5,0.5,0.5),
	Color(0.75,0.75,0.75),
	Color(1,1,1),
]

static func get_palette_as_image(palette : Array[Color]) -> Image:
	var image = ImageProcessing.get_empty_image(1080, 1080)
	
	for x : float in range(1080):
		var idx = floor((x / 1080) * palette.size())
		for y in range(1080):
			image.set_pixel(x, y, palette[idx])
		
	return image

static func sort_palette(palette : Array[Color], function: Callable):
	palette.sort_custom(function)
	return palette
	
static func value_descending(a : Color, b : Color) -> bool:
	return a.v > b.v;
	
static func value_ascending(a : Color, b : Color) -> bool:
	return a.v < b.v;

static func alpha_ascending(a: Color, b : Color) -> bool:
	return a.a > b.a;

static func alpha_descending(a: Color, b : Color) -> bool:
	return a.a < b.a;
	
static func red_ascending(a: Color, b : Color) -> bool:
	return a.r > b.r;

static func red_descending(a: Color, b : Color) -> bool:
	return a.r < b.r;

static func green_ascending(a: Color, b : Color) -> bool:
	return a.g > b.g;

static func green_descending(a: Color, b : Color) -> bool:
	return a.g < b.g;
	
static func blue_ascending(a: Color, b : Color) -> bool:
	return a.b > b.b;

static func blue_descending(a: Color, b : Color) -> bool:
	return a.b < b.b;
