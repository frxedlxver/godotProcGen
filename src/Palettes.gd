class_name Palettes

class PaletteEntry:
	var min : float = 0
	var max : float = 0
	var color : Color = Color.WHITE
	
	func _init(color :Color , min: float, max: float):
		self.color = color
		self.min = min
		self.max = max
		
static var blue_lv = 0.4

static var DEEP_WATER_COLOR : Color = Color8(0, 25, 78)
static var WATER_COLOR : Color = Color8(0, 25, 102)
static var SAND_COLOR : Color = Color8(178, 153, 128)
static var GRASS_COLOR : Color = Color8(65, 102, 33)
static var RICH_GRASS_COLOR : Color = Color8(85, 125, 30)


static var p_terrain : Array[PaletteEntry] = [
	PaletteEntry.new(DEEP_WATER_COLOR, 0, 0.25),
	PaletteEntry.new(WATER_COLOR, 0.25, 0.3),
	PaletteEntry.new(SAND_COLOR, 0.3, 0.35),
	PaletteEntry.new(GRASS_COLOR, 0.35, 1.0),
]

static var p_test_bands : Array[PaletteEntry] = [
	PaletteEntry.new(Color(0.0,0.0,0.4), 0.00, 0.1),
	PaletteEntry.new(Color(0.7, 0.6, 0.5), 0.1, 0.2),
	PaletteEntry.new(Color(0.0,0.0,0.4), 0.02, 0.3),
	PaletteEntry.new(Color(0.7, 0.6, 0.5), 0.3, 0.4),
	PaletteEntry.new(Color(0.0,0.0,0.4), 0.4, 0.5),
	PaletteEntry.new(Color(0.7, 0.6, 0.5), 0.5, 0.6),
	PaletteEntry.new(Color(0.0,0.0,0.4), 0.6, 0.7),
	PaletteEntry.new(Color(0.7, 0.6, 0.5), 0.7, 0.8),
	PaletteEntry.new(Color(0.0,0.0,0.4), 0.8, 0.9),
	PaletteEntry.new(Color(0.7, 0.6, 0.5), 0.9, 1.0),
	PaletteEntry.new(Color(0.0,0.0,0.4), 0.00, 0.1),
	PaletteEntry.new(Color(0.7, 0.6, 0.5), 0.1, 0.2),
]

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
	Color(0.125,0.125, blue_lv),
	Color(0.125,0.125, blue_lv),
	Color(0.25, blue_lv, 0.125),
	Color(0.25, blue_lv, 0.125),
	Color(0.25, 0.35, 0.125),
	Color(0.35, blue_lv, 0.125),
	Color(0.35, blue_lv, 0.125),
	Color(0.5,0.5,0.5),
	Color(0.5,0.5,0.5),
	Color(0.75,0.75,0.75),
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
