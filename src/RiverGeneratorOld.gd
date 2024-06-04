class_name RiverGenerator
# should rewrite from scratch


var m_max_depth 
var m_maximum_width : int = 10
var m_minimum_width : int = 1
var m_bounds : Vector2i = Vector2i.ZERO

var m_start_edge : Enums.Direction = Enums.Direction.NORTH
var m_target_edge : Enums.Direction = Enums.Direction.SOUTH

var m_branches : Array[RiverBranch] = []

func generate_river():
	var cur_width = m_maximum_width

	m_branches = [RiverBranch.new()]

	var post_step_val = func() :
		var branch = m_branches[0]
		var all_positions = branch.get_vertex_positions()
		var in_bounds_positions = branch.get_positions_in_bounds(m_bounds)
		
		var ratio = float(in_bounds_positions.size()) / float(all_positions.size())
		print("in_bounds: ", in_bounds_positions.size())
		print("total: ", all_positions.size())
		print("ratio: ", ratio)
		print("")
		if ratio < 0.95:
			return false
		
		#if branch._m_worm.m_path[0].m_position != branch.m_start:
			#print("wrong startpoint")
			#return false
			
		print("")
			
		return true

	m_branches[0].m_post_generation_validation_callback = post_step_val
	m_branches[0].flag_regenerate_on_failure = true
	m_branches[0].m_width = m_maximum_width
	var start : Vector2i = VectorTools.random_point_along_edge(m_bounds, m_start_edge)
	var target : Vector2i = VectorTools.random_point_along_edge(m_bounds, m_target_edge)
	m_branches[0].create_river(start, target, m_bounds)
	
	start = m_branches[0].find_split_point()
	var start_idx = 0
	for vert in m_branches[0].m_path:
		if vert.m_position == start:
			start_idx = m_branches[0].m_path.find(vert)
			break
	m_branches[0].trim_path_to_idx(start_idx)
	
	m_branches.append(RiverBranch.new())
	m_branches.append(RiverBranch.new())
	for i in range(1, 3):
		
		var br2 = m_branches[i]
		m_maximum_width -= 1
		br2.m_post_generation_validation_callback = post_step_val
		br2.flag_regenerate_on_failure = true
		br2.m_width = m_maximum_width
		br2.m_cur_direction = m_branches[0].m_cur_direction
		m_branches[i].create_river(start, target, m_bounds)
	

func get_final_river_points(map_size : Vector2i):
	var result : Array[Vector2i] = []

	for branch in m_branches:
		result.append_array(branch.get_final_river_points(map_size))
	print("final size: ", result.size())

	return result
