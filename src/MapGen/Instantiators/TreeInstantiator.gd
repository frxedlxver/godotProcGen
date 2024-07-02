extends Node2D

class_name TreePlacer

var tilemap : TileMap
var terrain_tilemap : TileMap
var tree_layer
var tree_layer_name = "Trees"
var large_tree_chance = 30

var FOREST_TILE_COORD = Vector2i(1, 0)

func initialize():
	if tilemap == null:
		print_debug("No tilemap set.")
		return
	
	for layer in tilemap.layers:
		if layer.name == tree_layer_name:
			tree_layer = layer
			break
			
		

func place_trees_at_points(tree_locations : Array[Vector2i]):
	tilemap.clear()
	for point in tree_locations:
		var lg_chance = large_tree_chance
		var tile_pos
		var is_forest = false
		if terrain_tilemap.get_cell_atlas_coords(0, point) == Vector2i(3, 0):
			tile_pos = FOREST_TILE_COORD + Vector2i(randi_range(0, 10) % 2, 0)
			lg_chance /= 8
			is_forest = true
		else:
			tile_pos= Vector2i(randi_range(0,3), 0)
		var source = 2;
		tilemap.set_cell(0,point,source,tile_pos, 0)
