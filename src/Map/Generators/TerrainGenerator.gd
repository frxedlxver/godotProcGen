class_name TerrainGenerator
	
static func terrain_from_heightmap(heightmap : Image) -> Image:
	var terrain_image = heightmap.duplicate(true)
	
	terrain_image = ImageProcessing.posterize(terrain_image, Palettes.p_terrain)
	
	return terrain_image

static func generate_rich_soil_patches(image : Image) -> Image:
	var noise = FastNoiseLite.new()
	noise.seed = randi()
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH
	var noise_scale = 1024 / image.get_width()
	noise.frequency = 0.001 * noise_scale
	for point in ImageProcessing.find_all_by_color(image, Palettes.GRASS_COLOR):
		if noise.get_noise_2dv(point) > 0:
			image.set_pixelv(point, Palettes.RICH_GRASS_COLOR)
	return image


