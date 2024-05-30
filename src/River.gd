extends Node

class_name River

var worm : PerlinWorm = PerlinWorm.new()

var parent_river : River
var children : Array[River] = []
var iterations : int = 0
var width : int = 0

var start_point : Vector2i = Vector2i.ZERO
var split_point_chance = 0.5
var target_point : Vector2i = Vector2i.ZERO


func create_river(starting_point : Vector2i, target_point : Vector2i, bounds : Vector2i, width : int = 0, start_dir : Vector2i = Vector2i.ZERO):
	self.min_width = min_width
	self.max_width = max_width
	
	worm.bounds = bounds
	worm.target_points = [target_point * 3]
	
	worm.generate_path(starting_point, start_dir, target_point)
	
	
	



func get_all_points() -> Array[Vector2i]:
	var result : Array[Vector2i] = []
	for point in worm.get_all_path_positions():
		for x in range(-width, width):
			for y in range(-width, width):
				result.append(point + Vector2i(x, y))
				
	for child in children:
		result.append_array(child.get_all_points())
		
	return result

func get_worm_path(bounds: Vector2i) -> Array[Vector2i]:
	var result : Array[Vector2i] = []
	for point in worm.path:
		if VectorTools.a_inside_b(point, bounds):
			result.append(point)
	for child in children:
		result.append_array(child.get_worm_path(bounds))
		
	return result
	
func descendent_count() -> int:
	var result = children.size()
	for child in children:
		result += child.descendent_count()
		
	return result
func calc_divergence_width(parent_width : int):
	if parent_width % 2 == 0:
		return (parent_width / 2) + 1
	else: return (parent_width + 1 / 2) + 1
func find_split_points(path : Array[Vector2i]) -> Array[Vector2i]:
	var result : Array[Vector2i] = [path[randi_range(path.size() / 2, path.size() - 1)]]
	return result

