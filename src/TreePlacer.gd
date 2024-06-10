extends Node2D

class_name TreePlacer

@export var tree_map : TileMap
func place_trees_at_points(tree_locations : Array[Vector2i]):
	for point in tree_locations:
		var sprite_variant_x= randi_range(0, 4)
		var sprite_variant_y= randi_range(0, 2)
		tree_map.set_cell(0, point, 0, Vector2i(sprite_variant_x, sprite_variant_y), 0)
