class_name HeightmapGenerator

static func generate_heightmap(width: int, height: int, n1_weight : float, n2_weight : float, n1_freq : float, n2_freq : float) -> Image:
	
	var n1 = FastNoiseLite.new()	
	n1.seed = randi()
	n1.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH
	n1.frequency = n1_freq
	
	var n2 = FastNoiseLite.new()
	n2.seed = randi()
	n2.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH
	n2.frequency = n2_freq
	
	var n1_image = n1.get_image(width, height,false,false,true)
	var n2_img = n2.get_image(width, height, false, false, true)
	var gradient_weight = 1 - n1_weight - n2_weight
	var heightmap : Image = Image.create(width, height, false, Image.FORMAT_RGB8)
	for y in range(height):
		var cur_gradient_val : float = ImageProcessing.gradient_value(y, height)
		for x in range(width):
			var v = (n1_image.get_pixel(x, y).v * n1_weight + n2_img.get_pixel(x, y).v * n2_weight + cur_gradient_val * (gradient_weight))
			heightmap.set_pixel(x, y, Color.from_hsv(0,0,v))
	return heightmap
