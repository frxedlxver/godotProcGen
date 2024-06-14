extends Node2D

# todo: create heightmap class, change landscapegenerator to take heightmap as parameter
class_name MapGen

var terrain_image : Image
var heightMap : Image
var texture : ImageTexture

var settings : NoiseSettings2D
var palette = Palettes.cm_blue_yellow
var offset : float = 0

var flora_gen : FloraGenerator = FloraGenerator.new()
var tree_positions : Array[Vector2i]

@export var tilemap : TileMap

var MIN_RIVER_SIZE : int = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	get_viewport().canvas_item_default_texture_filter=Viewport.DEFAULT_CANVAS_ITEM_TEXTURE_FILTER_NEAREST	
	get_tree().get_root().size_changed.connect(_updateTexture) 	
	get_window().mode = Window.MODE_MAXIMIZED
	generate_map(Vector2i(256, 256))
	instantiate_map()
	zoom_to_fit_tilemap(terrain_image.get_size(), 32)
	
func run_test(iterations : int, map_size : int):
	for i in range(iterations):
		generate_map(Vector2i(map_size, map_size))
		var path = "C:\\Users\\rhend\\repos\\godotProcGen\\src\\test\\output_" + var_to_str(i) + ".jpg"
		terrain_image.save_jpg((path), 0.5);
		
func generate_map(map_size : Vector2i):
	var landscape_generator = LandscapeGenerator.new()
	var heightmap : Image = landscape_generator.generate_heightmap(map_size.x, map_size.y, 0.1, 0.9)
	
	# generate intial terrain
	terrain_image = landscape_generator.generate_terrain(heightmap)
	
	#add rivers
	terrain_image = generate_river(terrain_image)
	
	# generate positions to place trees in next step
	tree_positions = flora_gen.generate_flora(terrain_image)
		
func instantiate_map():
	# instantiate landscape tiles
	var converter : ImageToTilemapConverter = ImageToTilemapConverter.new()
	converter.m_tilemap = tilemap
	converter.image_to_tilemap(terrain_image)
	converter.queue_free()
	
	# instantiate trees relative to tilemap_positions
	var tree_placer = TreePlacer.new()
	tree_placer.tilemap = tilemap
	tree_placer.place_trees_at_points(tree_positions)
	tree_placer.queue_free()
	
func draw_grid(image : Image, grid_size : int):
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
	
func generate_river(map : Image) -> Image:
	var river_generator = RiverGenerator.new()
	river_generator.m_maximum_width = 3;
	river_generator.m_bounds = map.get_size()
	river_generator.generate_river()
	var new_map = map.duplicate(true)
	for point in river_generator.get_final_river_points(map.get_size()):
		if VectorTools.a_inside_b(point, map.get_size()):
			if !map.get_pixelv(point).is_equal_approx(Palettes.DEEP_WATER_COLOR):
				new_map.set_pixelv(point, Palettes.WATER_COLOR)
	return new_map
	

func add_riverbanks(image : Image, radius : int):
	var r = radius
	if r < 1: return
	for x in range(image.get_width()):
		for y in range(image.get_height()):
			var point = Vector2i(x, y)
			if VectorTools.a_inside_b(point, image.get_size()):
				if image.get_pixelv(point) == Color.GREEN:
					var sand = false
					for x1 in range(-r, r):
						if point.x + x1 >= image.get_width() || point.x + x1 < 0:
							continue
						if sand:
							break
						for y1 in range(-r, r):
							if point.y + y1 >= image.get_height() || point.y + y1 < 0:
								continue
							if image.get_pixelv(point + Vector2i(x1, y1)) == Color.BLUE:
								sand = true
								break
					if sand:
						image.set_pixelv(point, Color.BISQUE)
	
func _updateTexture():
	if terrain_image != null:
		texture = ImageTexture.create_from_image(terrain_image)

		zoom_to_fit(terrain_image.get_size(), get_viewport_rect().size)
		queue_redraw()
		
func zoom_to_fit(image_size : Vector2, viewport_size : Vector2):
	var shortest_side = mini(viewport_size.x, viewport_size.y)
	var ratio
	if shortest_side == viewport_size.y:
		ratio = viewport_size.y / image_size.y
	else:
		ratio = viewport_size.y / image_size.x
		
	get_viewport().get_camera_2d().zoom = Vector2.ONE * ratio
		
		
func zoom_to_fit_tilemap(image_size : Vector2, tile_size : int):
	var viewport_size = get_viewport_rect().size
	var map_size = image_size * tile_size
	zoom_to_fit(map_size, viewport_size)
	var cam_center = get_viewport().get_camera_2d().get_screen_center_position()
	var map_center = map_size / 2
	var dist = map_center - cam_center
	get_viewport().get_camera_2d().position += dist

#func _draw():
	#if (texture != null):
		#draw_texture(texture, -texture.get_size() / 2)
		


