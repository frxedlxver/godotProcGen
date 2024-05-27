extends Node2D

var image : Image
var texture : ImageTexture
var settings : NoiseSettings2D
var palette = Palettes.cm_blue_yellow
var ctrlHeld = false
var shiftHeld = false
var offset : float = 0
var worm : PerlinWorm = PerlinWorm.new()
var river : River = River.new()
var p

# Called when the node enters the scene tree for the first time.
func _ready():
	get_viewport().canvas_item_default_texture_filter=Viewport.DEFAULT_CANVAS_ITEM_TEXTURE_FILTER_NEAREST	
	get_tree().get_root().size_changed.connect(_updateTexture) 	
	get_window().mode = Window.MODE_MAXIMIZED
	initialize_image(1024)
	test_river()
	_updateTexture()
	
func initialize_image(size : int = 256):
	image = ImageProcessing.get_empty_image(1, 1)
	image.set_pixel(0, 0, Color.GREEN)
	image = ImageProcessing.resize_2D(image, size, size)
	
func test_river():
	river.create_river(Vector2i.ZERO, image.get_size(), image.get_size(), 2, 6)
	
	for point in river.get_all_points():
		image.set_pixelv(point, Color.BLUE)
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
	queue_redraw()

func _draw():
	if (texture != null):
		draw_texture(texture, -texture.get_size() / 2)
		

