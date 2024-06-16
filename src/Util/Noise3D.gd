extends Node2D
class_name Noise3D

static func generate_noise_image_3d(settings: NoiseSettings3D) -> Array[Image]:
	var noise = Noise2D.get_noise(settings)
	var image = determine_image_func_3d(settings).call(noise)
	return image
	
static func determine_image_func_3d(settings: NoiseSettings3D) -> Callable:
	if settings.seamless:
		return func(noise : FastNoiseLite): noise.get_seamless_image_3d(settings.width, settings.height, settings.depth, settings.invert, settings.skirt, settings.normalize)
	else:
		return func(noise : FastNoiseLite): noise.get_image_3d(settings.width, settings.height, settings.depth, settings.invert, settings.normalize)
