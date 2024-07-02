class_name ImageProcessing

static func get_empty_image(width : int, height : int) -> Image:
		return Image.create(width, height, false, Image.FORMAT_RGB8)
		
static func posterize_2D(image : Image, palette : Array[Color], offset : float = 0) -> Image:
	
	var newImage = get_empty_image(image.get_width(), image.get_height())
	var colour_count = palette.size()
	
	for x in range(newImage.get_width()):
		for y in range(newImage.get_height()):
			
			var value = image.get_pixel(x, y).v + offset
			var idx = frac2idx_clamped_linear(value, colour_count)
			
			newImage.set_pixel(x, y, palette[idx])
				
	return newImage
	
	
static func posterize(image : Image, palette, offset : float = 0) -> Image:
	
	var newImage = get_empty_image(image.get_width(), image.get_height())
	
	for x in range(newImage.get_width()):
		for y in range(newImage.get_height()):
			
			var value = image.get_pixel(x, y).v + offset
			
			var c : Color = Color.HOT_PINK
			for entry in palette:
				if(value >= entry.min && value <= entry.max):
					c = entry.color
			newImage.set_pixel(x, y, c)
				
	return newImage
static func posterize_3D_linear(image_3D : Array[Image], palette : Array[Color], offset : float = 0, delta_offset : float = 0):
	for z in range(image_3D.size()):
		image_3D[z] = posterize_2D(image_3D[z], palette, offset)
		offset += delta_offset
	return image_3D
	
static func resize_2D(image : Image, width : int, height : int) -> Image:
	image.resize(width, height, Image.INTERPOLATE_NEAREST)
	return image

static func resize_3D(image_3D : Array[Image], width : int, height : int) -> Array[Image]:
	for z in range(image_3D.size()):
		image_3D[z]  = resize_2D(image_3D[z], width, height)
	return image_3D
	
static func add_layer_to_image(image : Image, layer : Image, weight : float = 1):
	# bad params
	if layer == null || weight <= 0 || weight > 1: 
		return
		
	# nothing to change
	elif weight == 1 || image == null:
		return layer
		
	# add layer
	else:
		for x in range(layer.get_width()):
			for y in range (layer.get_height()):
				if x < image.get_width() and y < image.get_height():
					# calculate new color based on weight of layer 2
					var newColor = (image.get_pixel(x, y) * (1 - weight)) + (layer.get_pixel(x, y) * weight)
					image.set_pixel(x,y, newColor)
					
	return image

static func frac2idx_clamped_linear(fraction : float, array_size : int) -> int:
	var idx = roundi((fraction) * (array_size - 1))
	
	# clamp in case fraction is greater than 1 or less than 0
	return clampi(idx, 0, array_size - 1)
	
static func frac2idx_continuous_linear(fraction : float, array_size : int) -> int:
	var idx = roundi((fraction) * (array_size - 1))
	
	return idx % (array_size)

static func find_all_by_color(image : Image, color : Color) -> Array[Vector2i]:
	var result : Array[Vector2i] = []
	
	for x in range(image.get_width()):
		for y in range(image.get_height()):
			if image.get_pixel(x, y) == color:
				result.append(Vector2i(x, y))
	
	return result
	
static func gradient_value(y : float, max_y : float, invert : bool = false):
	if invert:
		return y / max_y
	return 1 - (y / max_y)
	
static func draw_grid(image : Image, grid_size : int) -> Image:
	var duplicate_image = image.duplicate(true)
	
	# using callables to allow reuse of variable names
	var draw_y = func():
		var y = 0
		while y < image.get_height():
			y += grid_size
			for x in range(image.get_width()):
				image.set_pixel(x, y, Color.BLACK)
	
	var draw_x = func():
		var x = 0
		while x < image.get_width():
			x += grid_size
			for y in range(image.get_height()):
				image.set_pixel(x, y, Color.BLACK)
				
	draw_y.call()
	draw_x.call()
	
	return image
