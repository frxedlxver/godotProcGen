class_name RiverGenerator

class BranchData:
	var m_branch : RiverBranch
	var m_depth : int

	func _init(branch : RiverBranch, depth : int):
		m_branch = branch
		m_depth = depth


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
		var all_positions = branch._m_worm.get_vertex_positions()
		var in_bounds_positions = branch._m_worm.get_positions_in_bounds(m_bounds)
		
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

	m_branches[0]._m_worm.m_post_generation_validation_callback = post_step_val
	m_branches[0]._m_worm.flag_regenerate_on_failure = true
	m_branches[0].m_width = m_maximum_width
	m_branches[0].create_river(m_start_edge, m_target_edge, m_bounds)

func get_final_river_points(map_size : Vector2i):
	var result : Array[Vector2i] = []

	for branch in m_branches:
		result.append_array(branch.get_final_river_points(map_size))
	print("final size: ", result.size())

	return result
