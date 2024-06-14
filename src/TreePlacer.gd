extends Node2D

class_name TreePlacer

var tilemap : TileMap
var tree_textures : Array[AtlasTexture]
var _tree_nodes : Array[Sprite2D] = []
var _trees : Array[Sprite2D] = []


func create_sprite_nodes():
	_tree_nodes = []
	tree_textures = [
		ResourceLoader.load("res://res/trees/tree1.tres"),
		ResourceLoader.load("res://res/trees/tree2.tres"),
		ResourceLoader.load("res://res/trees/tree3.tres"),
		ResourceLoader.load("res://res/trees/tree4.tres")
	]
	for tex in tree_textures:
		var t = Sprite2D.new()
		t.texture = tex
		t.z_index = 10
		t.offset = Vector2i(0, -t.texture.get_size().y / 2)
		_tree_nodes.append(t)
		
func place_trees_at_points(tree_locations : Array[Vector2i]):
	create_sprite_nodes()
	for point in tree_locations:
		var pos : Vector2 = tilemap.global_position + tilemap.map_to_local(point)
		var t : Sprite2D = _tree_nodes.pick_random().duplicate()
		t.global_position = pos
		tilemap.add_child(t)  # Add the duplicated sprite to the TileMap
		_trees.append(t)
