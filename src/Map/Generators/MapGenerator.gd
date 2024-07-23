extends Node2D

# todo: create heightmap class, change TerrainGenerator to take heightmap as parameter
class_name MapGenerator

var terrain_image : Image
var heightMap : Image
var texture : ImageTexture

var settings : NoiseSettings2D
var palette = Palettes.cm_blue_yellow
var offset : float = 0

var tree_gen : TreeGenerator = TreeGenerator.new()
var tree_positions : Array[Vector2i]

var terrain_tilemap : TileMap
var destructible_tilemap : TileMap
@export var tilemap_container : Node2D
@export var test_mode : bool

signal generation_started
signal generation_complete
signal instantiation_started
signal instantiation_complete


# Called when the node enters the scene tree for the first time.
func _ready():
	if tilemap_container == null:
		tilemap_container = get_node("/root/YSorted/Tilemaps")
	terrain_tilemap = tilemap_container.get_node("TerrainTilemap")
	destructible_tilemap = tilemap_container.get_node("DestructibleTilemap")
	if test_mode:
		test_generate_and_save_images(512, 100)
	else:
		generate_and_instantiate(64)


func generate_and_instantiate(map_size : int):
	print("generating")
	generate_map(Vector2i(map_size, map_size))
	print("instantiating")
	instantiate_map()
	print("done")
	

func test_generate_and_save_images(map_size : int, iterations : int, out_dir : String = "res://tests/test"):
	var out_dir_name = out_dir
	var i = 1
	var dir = DirAccess.open("res://")
	while dir.dir_exists(out_dir_name):
		out_dir_name = out_dir + var_to_str(i)
		i += 1
	dir.make_dir(out_dir_name)
	var tTotal = 0
	for j in range(iterations):
		var t1 = Time.get_ticks_usec()
		generate_map(Vector2i(map_size, map_size))
		var t2 = Time.get_ticks_usec()
		tTotal += (t2 - t1)
		var path = out_dir_name + "/output_" + var_to_str(j) + ".jpg"
		terrain_image.save_jpg((path), 0.5);
		print(var_to_str(j + 1) + " out of " + var_to_str(iterations) + " complete in " + var_to_str(float(t2 - t1) / 1000000) + " seconds.")
	print("=== RESULTS ===")
	print(var_to_str(iterations) + " completed in " + var_to_str(tTotal / 1000000) + " seconds total.")

func generate_map(map_size : Vector2i):
	generation_started.emit()
	var heightmap : Image = HeightmapGenerator.generate_heightmap(map_size.x, map_size.y, 0.5, 0.3, 0.001, 0.002)
	
	# generate intial terrain
	terrain_image = TerrainGenerator.terrain_from_heightmap(heightmap)
	terrain_image = TerrainGenerator.generate_rich_soil_patches(terrain_image)
	#
	##add rivers
	terrain_image = generate_river(terrain_image, heightmap)
	#
	## generate positions to place trees in next step
	tree_positions = tree_gen.generate_flora(terrain_image)
	generation_complete.emit()

func instantiate_map():
	instantiation_started.emit()
	# instantiate terrain tiles on terrain tilemap
	var terrain_instantiator : TerrainInstantiator = TerrainInstantiator.new()
	terrain_instantiator.m_tilemap = terrain_tilemap
	terrain_instantiator.image_to_tilemap(terrain_image)
	terrain_instantiator.queue_free()
	
	# instantiate trees on destructible tilemap
	var tree_instantiator = TreeInstantiator.new()
	tree_instantiator.tilemap = destructible_tilemap
	tree_instantiator.terrain_tilemap = terrain_tilemap
	tree_instantiator.place_trees_at_points(tree_positions)
	tree_instantiator.queue_free()
	
	instantiation_complete.emit()

func generate_river(map : Image, heightmap : Image) -> Image:
	var new_map = map.duplicate(true)	
	
	var river_generator = RiverGenerator.new()
	river_generator.m_maximum_width = 6;
	river_generator.m_bounds = map.get_size()
	var max_starting_rivers = 6
	river_generator.generate(max_starting_rivers, 3, heightmap)
	var river_points = river_generator.get_final_river_points(map.get_size())
	var drawn_points = []
	for branch in river_points:
		for point in branch:

			if VectorTools.a_inside_b(point, map.get_size()):
				var terrain_color = map.get_pixelv(point)
				if terrain_color.is_equal_approx(Palettes.DEEP_WATER_COLOR) \
					or terrain_color.is_equal_approx(Palettes.DEEP_WATER_COLOR):
					break;
				else:
					new_map.set_pixelv(point, Palettes.WATER_COLOR)
	return new_map

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
