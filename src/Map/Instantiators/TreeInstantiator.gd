extends Node2D

class_name TreeInstantiator

var tilemap : TileMap
var terrain_tilemap : TileMap
var tree_layer
var tree_layer_name = "Trees"
var large_tree_chance = 30

var FOREST_TILE_COORD = Vector2i(1, 0)
var PLAINS_TILE_COORD = Vector2i(1, 0)

func initialize():
	if tilemap == null:
		print_debug("No tilemap set.")
		return
	
	for layer in tilemap.layers:
		if layer.name == tree_layer_name:
			tree_layer = layer
			break
			
		

func place_trees_at_points(tree_positions : Array[Vector2i]):
	tilemap.clear()
	
	var forest_tiles = terrain_tilemap.get_used_cells_by_id(0, 0, )
	var plains_tiles = terrain_tilemap.get_used_cells_by_id(0, 0, PLAINS_TILE_COORD)
	for tree_world_pos in tree_positions:
		var tree_type
		var is_forest = false
		var terrain_at_world_pos = terrain_tilemap.get_cell_atlas_coords(0, tree_world_pos)
		
		if  TerrainInstantiator.get_tile_type(terrain_at_world_pos) == TerrainInstantiator.TileType.FOREST_GRASS:
			tree_type = FOREST_TILE_COORD + Vector2i(randi_range(0, 10) % 2, 0)
			is_forest = true
		else:
			tree_type = Vector2i(randi_range(3, 0), 0)
		var source = 0;
		tilemap.set_cell(0,tree_world_pos,source,tree_type, 0)
