extends Node

class_name RiverBranch

var _m_worm : PerlinWorm = PerlinWorm.new()

var m_iterations : int = 0
var m_width : int = 0

var m_start : Vector2i = Vector2i.ZERO
var m_end : Vector2i = Vector2i.ZERO
var m_split_point_chance = 0.5
var m_target_point : Vector2i = Vector2i.ZERO


func create_river(start_edge, target_edge, bounds : Vector2i):
	
	_m_worm.m_bounds = bounds
	
	#var validation = func():
		#print("y dir ", _m_worm.cur_direction.y)
		#return _m_worm.cur_direction.y > 0
	#_m_worm.m_step_validation_callback = validation
	var done = false
	while not done:
		var start = VectorTools.random_point_along_edge(bounds, start_edge)
		var target = VectorTools.random_point_along_edge(bounds, target_edge)
		_m_worm.generate_path(start, target, true)
		done = not _m_worm.failure

# returns all points, adjusted for width
func get_final_river_points(map_size : Vector2i) -> Array[Vector2i]:
	var result : Array[Vector2i] = []
	for point in _m_worm.get_full_path_in_bounds(map_size):
		for x in range(-m_width, m_width):
			for y in range(-m_width, m_width):
				result.append(point + Vector2i(x, y))
		
	return result
