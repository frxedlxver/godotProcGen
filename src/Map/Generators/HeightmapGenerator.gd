class_name HeightmapGenerator

static func generate_heightmap(width: int, height: int) -> Image:
	
	var n1_weight = 0.66
	var n2_weight = 0.34
	
	var n1 = FastNoiseLite.new()	
	n1.seed = randi()
	n1.noise_type = FastNoiseLite.TYPE_CELLULAR
	n1.cellular_distance_function = FastNoiseLite.DISTANCE_MANHATTAN
	n1.cellular_return_type = 5
	n1.frequency = 0.008
	n1.cellular_jitter = 1.0
	
	var n2 = FastNoiseLite.new()
	n2.seed = randi()
	n2.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH
	n2.frequency = 0.016
	
	var n1_image = n1.get_image(width, height,false,false,true)
	var n2_img = n2.get_image(width, height, false, false, true)
	var heightmap : Image = Image.create(width, height, false, Image.FORMAT_RGB8)
	for y in range(height):
		var cur_gradient_val : float = ImageProcessing.gradient_value(y, height)
		for x in range(width):
			var v = (n1_image.get_pixel(x, y).v * n1_weight + n2_img.get_pixel(x, y).v * n2_weight)
			heightmap.set_pixel(x, y, Color.from_hsv(0,0,v))
	return heightmap
