extends Node2D

var image : Image
var texture : ImageTexture
var settings : NoiseSettings2D
var palette = Palettes.cm_blue_yellow
var ctrlHeld = false
var shiftHeld = false
var offset : float = 0
var worm : PerlinWorm = PerlinWorm.new()
var p

# Called when the node enters the scene tree for the first time.
func _ready():
	get_viewport().canvas_item_default_texture_filter=Viewport.DEFAULT_CANVAS_ITEM_TEXTURE_FILTER_NEAREST	
	get_tree().get_root().size_changed.connect(_updateTexture) 	
	get_window().mode = Window.MODE_MAXIMIZED
	test_worms()
	_updateTexture()
	
func test_worms():
	var size = 256
	image = ImageProcessing.get_empty_image(1, 1)
	image.set_pixel(0, 0, Color.GREEN)
	image = ImageProcessing.resize_2D(image, size, size)
	worm._target_point = Vector2i(size, size)
	worm._cur_point = Vector2i(0, 0)
	
	
	_updateTexture()

func _updateImage():
	image = Noise2D.layered_noise_image_2d(settings)

	image = ImageProcessing.posterize_2D(image, p, offset)
	
	_updateTexture()
	
func _updateTexture():
	if image != null:
		texture = ImageTexture.create_from_image(image)

		zoom_to_fit(image.get_size(), get_viewport_rect().size)
		
func zoom_to_fit(image_size : Vector2, viewport_size : Vector2):
	var shortest_side = mini(viewport_size.x, viewport_size.y)
	var ratio
	if shortest_side == viewport_size.y:
		ratio = viewport_size.y / image_size.y
	else:
		ratio = viewport_size.y / image_size.x
		
	get_viewport().get_camera_2d().zoom = Vector2.ONE * ratio
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	process_smooth()
	_updateTexture()
	queue_redraw()
		
func process_smooth():
	if (!worm.has_next_pos()):
		if (PerlinWorm.a_inside_b(worm._cur_point, image.get_size())):
			worm.get_next_point()
	else:
		while(worm.has_next_pos()):
			worm.draw_next_pos(image)
		
func process_fast():
	while(worm.has_next_pos()):
		worm.draw_next_pos(image)
	if (PerlinWorm.a_inside_b(worm._cur_point, image.get_size())):
		worm.get_next_point()
	
func process_instant():
	worm._target_points = [Vector2i(75, 25), image.get_size()]
	worm.find_worm_points(Vector2i.ZERO, image.get_size())
	image = worm.draw_worm_points(image)
func _draw():
	if (texture != null):
		draw_texture(texture, -texture.get_size() / 2)
		

