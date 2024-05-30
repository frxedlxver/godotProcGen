extends Node

class_name RiverGenerator


class RiverBranch :
	extends River
	var depth : int = 0
	var width : int = 0
var iterations
var branch_split_dict
var branches
var branch_iteration_dict


# Called when the node enters the scene tree for the first time.
func _ready():
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
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
