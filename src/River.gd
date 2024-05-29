extends Node

class_name River

var worm : PerlinWorm = PerlinWorm.new()

var parent_river : River
var children : Array[River] = []
var iterations : int = 0
var lakes : Array[Vector2i]

var start_point : Vector2i = Vector2i.ZERO
var split_point_chance = 0.5
var branch_width_dict : Dictionary = {}
var split_points : Array[Vector2i]
var max_width : int = 4
var min_width : int = 1
var target_points : Vector2i = Vector2i.ZERO


func create_river(starting_point : Vector2i, target_point : Vector2i, bounds : Vector2i, min_width : int, max_width : int, start_dir : Vector2i = Vector2i.ZERO):
	self.min_width = min_width
	self.max_width = max_width
	
	worm.bounds = bounds
	worm.target_points = [target_point * 3]
	
	if start_dir == Vector2i.ZERO:
		start_dir = VectorTools.normalize_vec2i(target_point - starting_point)
	worm.find_worm_points( starting_point, start_dir)
	
	var main_path : Array[Vector2i] = worm.path
	
	
	if iterations > 0 && max_width > min_width && worm.get_points_in_bounds(bounds).size() > 0:
		split_points = find_split_points(main_path)
		
		for point in split_points:
			var point_idx = worm.path.find(point)
			var new_target = worm.path[randi_range(point_idx, worm.path.size() - 1)]
			var new_child : River = River.new()
			new_child.iterations = iterations - 1
			new_child.parent_river = self
			children.append(new_child)
			new_child.create_river(point, new_target, bounds, min_width, calc_divergence_width(max_width), worm.cur_direction)
			var child_end = new_child.worm.path.size() - 1
			for i in range(child_end, 0, -1):
				if worm.path.has(new_child.worm.path[i]) && !split_points.has(new_child.worm.path[i]):
					child_end = i
			
			for i in range(new_child.worm.path.size() - 1, child_end - 1, -1):
				new_child.worm.path.remove_at(i)
			
			
			
		
			
func get_all_points() -> Array[Vector2i]:
	var result : Array[Vector2i] = []
	for point in worm.path:
		if split_points.has(point):
			max_width = calc_divergence_width(max_width)
		for x in range(-max_width, max_width):
			for y in range(-max_width, max_width):
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

