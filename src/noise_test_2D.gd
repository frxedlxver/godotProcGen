extends Node2D

var image : Image
var texture : ImageTexture
var settings : NoiseSettings2D
var palette = Palettes.cm_blue_yellow
var ctrlHeld = false
var shiftHeld = false
var offset : float = 0
var p

# Called when the node enters the scene tree for the first time.
func _ready():
	get_viewport().canvas_item_default_texture_filter=Viewport.DEFAULT_CANVAS_ITEM_TEXTURE_FILTER_NEAREST	
	get_tree().get_root().size_changed.connect(_updateTexture) 	

	test_worms()
	_updateTexture()
	
func test_worms():
	var size = 256
	image = ImageProcessing.get_empty_image(1, 1)
	image.set_pixel(0, 0, Color.GREEN)
	image = ImageProcessing.resize_2D(image, size, size)
	
	var worm : PerlinWorm = PerlinWorm.new()
	worm._target_points = [Vector2i(100, 150), Vector2(256, 256)]
	worm.find_worm_points(Vector2i(50, 50), image.get_size())
	image = worm.draw_worm_points(image)
	_updateTexture()
	
func test_2d_noise():
	settings = NoiseSettings2D.new()
	settings.freq = 0.04
	settings.width = 256
	settings.height = 256
	settings.invert = false
	settings.randomSeed = false
	settings.normalize = true
	settings.type = FastNoiseLite.TYPE_PERLIN
	settings.layers = 4

	p = Palettes.cm_red_cyan
	p.append_array(Palettes.cm_blue_yellow)
	p = Palettes.sort_palette(p, Palettes.value_ascending)
func _updateImage():
	image = Noise2D.layered_noise_image_2d(settings)

	image = ImageProcessing.posterize_2D(image, p, offset)
	
	_updateTexture()
func _updateTexture():
	if image != null:
		texture = ImageTexture.create_from_image(image)		
		var zoom_amount : Vector2 = get_zoom_to_fit_amount(Vector2(image.get_width(), image.get_height()), get_viewport_rect().size)
		
		get_viewport().get_camera_2d().zoom = zoom_amount

func _unhandled_key_input(event : InputEvent):
	var key : InputEventKey = event
	if key.is_pressed():
		if key.physical_keycode == KEY_CTRL:
			ctrlHeld = true
		elif key.physical_keycode == KEY_SHIFT:
			shiftHeld = true
		
		if key.physical_keycode == KEY_EQUAL:
			settings.width *= 2
			settings.height *= 2
			settings.freq /= 2
			_updateImage()
		elif key.physical_keycode == KEY_MINUS:
			settings.width /= 2
			settings.height /= 2
			settings.freq *= 2			
			_updateImage()
		elif key.physical_keycode == KEY_UP:
			if ctrlHeld: settings.freq = maxf(settings.freq - 0.001, 0)
			elif shiftHeld: offset += 0.01
			else: settings.layers += 1
			_updateImage()
		elif key.physical_keycode == KEY_DOWN:
			if ctrlHeld: settings.freq += 0.001
			elif shiftHeld: offset -= 0.01
			else: settings.layers -= 1
			settings.layers = max(settings.layers, 1)
			_updateImage()
		elif key.physical_keycode == KEY_R:
			settings.seed = randi()
			_updateImage()
		elif key.physical_keycode == KEY_I:
			settings.invert = !settings.invert
			_updateImage()
		elif key.physical_keycode == KEY_N:
			settings.type = (settings.type + 1) % 6
			print(settings.type)
			_updateImage()
	elif key.is_released():
		if key.physical_keycode == KEY_CTRL:
			ctrlHeld = false
		elif key.physical_keycode == KEY_SHIFT:
			shiftHeld = false
		
static func get_zoom_to_fit_amount(image_size : Vector2, viewport_size : Vector2) -> Vector2:
	var shortest_side = mini(viewport_size.x, viewport_size.y)
	var ratio
	if shortest_side == viewport_size.y:
		ratio = viewport_size.y / image_size.y
	else:
		ratio = viewport_size.y / image_size.x
		
	return Vector2.ONE * ratio
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	queue_redraw()
	
func _draw():
	if (texture != null):
		draw_texture(texture, -texture.get_size() / 2)
		

