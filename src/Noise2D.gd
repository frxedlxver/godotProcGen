extends Node2D
class_name Noise2D
	
static func noise_image_2d(settings : NoiseSettings2D) -> Image:
	var noise = get_noise(settings)
	var image = determine_image_func(settings).call(noise)
	return image

static func layered_noise_image_2d(settings: NoiseSettings2D):
	var freq_function = func(a : float): return a * 2
	return layered_noise_image_2d_custom(settings, freq_function)
	
static func layered_noise_image_2d_static(settings: NoiseSettings2D):
	var freq_function = func(a : float): return a + 1
	return layered_noise_image_2d_custom(settings, freq_function)
	
static func seamless_noise_image_2d(settings: NoiseSettings2D):
	var noise = get_noise(settings)
	var image = noise.get_seamless_image(settings.width, settings.height, settings.invert, settings.in_3d_space, settings.skirt, settings.normalize)
	return image

static func determine_image_func(settings : NoiseSettings2D):
		if settings.seamless:
			return func(noise: FastNoiseLite): return noise.get_seamless_image(settings.width, settings.height, settings.invert, settings.in_3d_space, settings.skirt, settings.normalize)
		else:
			return func(noise : FastNoiseLite): return noise.get_image(settings.width, settings.height, settings.invert, settings.in_3d_space, settings.normalize)
			
# todo: add layering modes
static func layered_noise_image_2d_custom(settings: NoiseSettings2D, freq_function : Callable) -> Image:
		var image = ImageProcessing.get_empty_image(settings.width, settings.height)
		var curFreq :float = settings.freq
		var curLayerWeight : float = 1.0
		var noise = get_noise(settings)
		
		# check if seamless or not
		var img_func = determine_image_func(settings)
			
		if settings.layers > 1:
			for l : float in range(settings.layers):
				noise.frequency = curFreq
				var layer = img_func.call(noise)
				image = ImageProcessing.add_layer_to_image(image, layer, curLayerWeight)
				curFreq = freq_function.call(curFreq)
				curLayerWeight /= 2
			
		return image

static func get_noise(settings : NoiseSettings2D) -> FastNoiseLite:
	if settings == null:
		settings = NoiseSettings2D.new()
		print_debug("Settings are null, using default NoiseSettings2D")
	var noise = apply_noise_settings(FastNoiseLite.new(), settings)
	return noise
	
static func apply_noise_settings(noise : FastNoiseLite, settings : NoiseSettings2D) -> FastNoiseLite:
	noise.frequency = settings.freq
	noise.offset = settings.offset
	noise.noise_type = settings.type
	if settings.randomSeed:
		noise.seed = randi()
	else:
		noise.seed = settings.seed
	return noise
