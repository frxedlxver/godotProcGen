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
	noise.noise_type = FastNoiseLite.TYPE_PERLIN
	noise.frequency = 0.01
	for point in ImageProcessing.find_all_by_color(image, Palettes.GRASS_COLOR):
		if noise.get_noise_2dv(point) > 0.25:
			image.set_pixelv(point, Color.DARK_GREEN)
	return image
	
func gradient_value(y : float, max_y : float, invert : bool = false):
	if invert:
		return y / max_y
	return 1 - (y / max_y)
	
func generate_heightmap(width: int, height: int, noise_weight : float, gradient_weight : float) -> Image:
	
	var noise = FastNoiseLite.new()	
	noise.seed = randi()
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH
	noise.frequency = 0.01
	var noise_image = noise.get_image(width, height,false,false,true)
	
	var heightmap : Image = Image.create(width, height, false, Image.FORMAT_RGB8)
	
	for y in range(height):
		var cur_gradient_val : float = gradient_value(y, height)
		for x in range(width):
			var v = (noise_image.get_pixel(x, y).v * noise_weight + cur_gradient_val * gradient_weight)
			print(v)
			heightmap.set_pixel(x, y, Color.from_hsv(0,0,v))
	return heightmap
