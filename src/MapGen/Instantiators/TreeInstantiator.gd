extends Node2D

class_name TreePlacer

var tilemap : TileMap
var terrain_tilemap : TileMap
var tree_layer
var tree_layer_name = "Trees"
var large_tree_chance = 30

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
			tile_pos = Vector2i(2, 0)
			lg_chance /= 8
			is_forest = true
		else:
			tile_pos= Vector2i(randi_range(0,3), randi_range(0,1) * 2)
		var source = 0;
		if randi_range(0, lg_chance) == 1:
			source = 1
			tile_pos *= 2
		tilemap.set_cell(0,point,source,tile_pos, 0)
