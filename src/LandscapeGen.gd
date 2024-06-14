class_name LandscapeGenerator


#change to use heightmap as parameter
func generate_terrain(heightmap : Image) -> Image:
	
	var image = heightmap.duplicate(true)
	
	image = ImageProcessing.posterize(image, Palettes.p_terrain)
	image = generate_rich_soil_patches(image)
		
	
	return image

func generate_rich_soil_patches(image : Image) -> Image:
	var noise = FastNoiseLite.new()
	noise.seed = randi()
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH
	var noise_scale = 1024 / image.get_width()
	noise.frequency = 0.001 * noise_scale
	for point in ImageProcessing.find_all_by_color(image, Palettes.GRASS_COLOR):
		if noise.get_noise_2dv(point) > 0:
			image.set_pixelv(point, Palettes.RICH_GRASS_COLOR)
	return image
	
func gradient_value(y : float, max_y : float, invert : bool = false):
	if invert:
		return y / max_y
	return 1 - (y / max_y)
	
func generate_heightmap(width: int, height: int, noise_weight : float, gradient_weight : float) -> Image:
	
	var noise = FastNoiseLite.new()	
	noise.seed = randi()
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH
	noise.frequency = 0.005
	
	var n2 = FastNoiseLite.new()
	n2.seed = randi()
	n2.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH
	n2.frequency = 0.01
	var noise_image = noise.get_image(width, height,false,false,true)
	var n2_img = n2.get_image(width, height, false, false, true)
	
	var heightmap : Image = Image.create(width, height, false, Image.FORMAT_RGB8)
	var n_weight  = 0.1
	var n2_weight = 0.2
	for y in range(height):
		var cur_gradient_val : float = gradient_value(y, height)
		for x in range(width):
			var v = (noise_image.get_pixel(x, y).v * n_weight + n2_img.get_pixel(x, y).v * n2_weight + cur_gradient_val * (1-n_weight - n2_weight))
			heightmap.set_pixel(x, y, Color.from_hsv(0,0,v))
	return heightmap
