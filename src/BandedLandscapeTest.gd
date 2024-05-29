extends Node2D

class_name BandedLandscapeTest

var noise : FastNoiseLite = FastNoiseLite.new()
var tex : ImageTexture
var image : Image

func _ready():
	noise.seed = randi()
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	noise.frequency = 0.001
	var width = 500
	var height = 1000
	image = Image.create(width, height, false, Image.FORMAT_RGB8)
	print(image.get_size())
	var terrain : Dictionary = generate_terrain(width, height, 8, -200)
	for point in terrain.keys():
		var v = terrain[point]
		var col = Color(v, v, v)
		image.set_pixel(point.x, point.y, col)
	image = ImageProcessing.posterize(image, Palettes.p_terrain)
	tex = ImageTexture.create_from_image(image)
	queue_redraw()

func generate_height(x: float, y: float, map_height : float, bands : int, offset: float) -> float:
	var noise_value = (noise.get_noise_2d(x, y) + 1) / 2
	var gradient_value = (map_height - y) / (map_height + offset) # Adjust the divisor to control the gradient slope
	var combined_value = noise_value * 0.1 + gradient_value * 0.9
	var combined_rounded = roundf(combined_value * bands) / bands
	return combined_rounded

func generate_terrain(width: int, height: int, bands: int, offset: float) -> Dictionary:
	var terrain : Dictionary = {}
	for x in range(width):
		for y in range(height):
			var height_value = generate_height(x, y, height, bands, offset)
			terrain[Vector2i(x, y)] = height_value
	return terrain
	
func _process(delta):
	queue_redraw()

func _draw():
	draw_texture(tex, -tex.get_size() / 2)
