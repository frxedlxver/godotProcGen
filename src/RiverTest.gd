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

var MIN_RIVER_SIZE : int = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	get_viewport().canvas_item_default_texture_filter=Viewport.DEFAULT_CANVAS_ITEM_TEXTURE_FILTER_NEAREST	
	get_tree().get_root().size_changed.connect(_updateTexture) 	
	get_window().mode = Window.MODE_MAXIMIZED
	initialize_image(512)
	test_river()
	_updateTexture()
	
func initialize_image(size : int = 512):
	image = ImageProcessing.get_empty_image(1, 1)
	image.set_pixel(0, 0, Color.GREEN)
	image = ImageProcessing.resize_2D(image, size, size)
	
func test_river():
	river.iterations = 2
	MIN_RIVER_SIZE = image.get_size().x * (river.iterations + 1)
	var start : Vector2i = image.get_size()
	var i : int = 0
	while (start.x > (image.get_size().x / 4)):
		print(start)
		i += 1
		start = VectorTools.random_point_along_edge(image.get_size(), Enums.Direction.NORTH)
		
	print("took ", i, " tries")
	
	var target = image.get_size()
	i = 0
	target = VectorTools.random_point_along_edge(image.get_size(), Enums.Direction.SOUTH)
	print("took ", i, " tries")
		
	i = 1
	river.create_river(start, target, image.get_size(), 2, 6)
	
	while river.worm.path[river.worm.path.size() - 1].y < image.get_size().y or river.descendent_count() < 2:
		river = River.new()
		river.iterations = 2		
		print(river.descendent_count())
		i += 1
		river.create_river(start, target, image.get_size(), 2, 6)
	print("Min river size: ", MIN_RIVER_SIZE)
	print("river_size: ", river.get_worm_path(image.get_size()).size())
	print("took ", i, " tries")
	
	for point in river.get_all_points():
		if VectorTools.a_inside_b(point, image.get_size()):
			image.set_pixelv(point, Color.BLUE)
	for point in river.lakes:
		image.set_pixelv(point, Color.RED)
	
	var r = 2
	for x in range(image.get_width()):
		for y in range(image.get_height()):
			var point = Vector2i(x, y)
			if VectorTools.a_inside_b(point, image.get_size()):
				if image.get_pixelv(point) == Color.GREEN:
					var sand = false
					for x1 in range(-r, r):
						if sand:
							break
						for y1 in range(-r, r):
							if image.get_pixelv(point + Vector2i(x1, y1)) == Color.BLUE:
								sand = true
								break
					if sand:
						image.set_pixelv(point, Color.BISQUE)
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
		

