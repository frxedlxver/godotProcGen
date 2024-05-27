extends Node

class_name River

var worm : PerlinWorm = PerlinWorm.new()

var parent_river : River
var children : Array[River] = []

var start_point : Vector2i = Vector2i.ZERO
var split_point_chance = 0.5
var branch_width_dict : Dictionary = {}
var split_points : Array[Vector2i]
var max_width : int = 4
var min_width : int = 1
var target_points : Vector2i = Vector2i.ZERO


func create_river(starting_point : Vector2i, target_point : Vector2i, bounds : Vector2i, min_width : int, max_width : int):
	self.min_width = min_width
	self.max_width = max_width
	worm.bounds = bounds
	worm.target_points = [target_point]
	
	var starting_dir = VectorTools.normalize_vec2i(target_point - starting_point)
	worm.find_worm_points( starting_point, VectorTools.normalize_vec2i(target_point - starting_point))
	
	var main_path : Array[Vector2i] = worm.path
	
	if max_width > min_width:
		split_points = find_split_points(main_path)
		print(split_points)
		print("finding split");
		
		for point in split_points:
			target_point = Vector2i(Vector2(target_point).rotated(deg_to_rad(randf_range(-10, 10))))
			var new_child = River.new()
			new_child.parent_river = self
			children.append(new_child)
			new_child.create_river(point, target_point, bounds, min_width, max_width - 1)
			
func get_all_points() -> Array[Vector2i]:
	var result : Array[Vector2i] = []
	for point in worm.path:
		if split_points.count(point) > 0:
			max_width -= 1
		for x in range(-max_width, max_width):
			for y in range(-max_width, max_width):
				result.append(point + Vector2i(x, y))
	#
	for child in children:
		result.append_array(child.get_all_points())
		
	return result

func find_split_points(path : Array[Vector2i]) -> Array[Vector2i]:
	var result : Array[Vector2i] = [path.pick_random()]
	return result

