class_name RiverGenerator
# should rewrite from scratch


var m_max_depth 
var m_maximum_width : int = 10
var m_minimum_width : int = 1
var m_bounds : Vector2i = Vector2i.ZERO

var m_start_edge : Enums.Direction = Enums.Direction.NORTH
var m_target_edge : Enums.Direction = Enums.Direction.SOUTH

var m_branches : Array[RiverBranch] = []

var unhandled_convergences : Dictionary = {}

func generate_river():
	var cur_width = m_maximum_width

	m_branches = [RiverBranch.new()]



	var br = m_branches[0]
	br.m_post_generation_validation_callback = func(): post_gen_validation(br)
	br.flag_regenerate_on_failure = true
	br.m_width = m_maximum_width
	var start : Vector2i = VectorTools.random_point_along_edge(m_bounds, m_start_edge)
	var target : Vector2i = VectorTools.random_point_along_edge(m_bounds, m_target_edge)
	br.create_river(start, target, m_bounds)
	var rand = int(randi())
	if (rand % 2 == 0):
		var split_point : PerlinWorm.PathVertex = br.find_split_point_between(br.size() / 4, br.size() * 3/4)
		split(br, split_point)
	
	


func split(br : RiverBranch, split_point : PerlinWorm.PathVertex):
	# find split point vertex
	
	#get index and trim parent branch to it
	var start_idx = br.m_path.find(split_point)
	br.trim_path_to_idx(start_idx)
	
	# generate two new branches
	# one branch is the split
	# other branch is continuation of parent but with decreased width
	var br_cont  = RiverBranch.new()
	var br_new = RiverBranch.new()
	
	# get direction of last vertex
	var new_branch_dir : Vector2 = br.last().m_direction
	
	br_cont.m_width = br.m_width - 1
	br_new.m_width = br.m_width - 1
	
	br_cont.m_post_generation_validation_callback = func() : post_gen_validation(br_cont)
	br_new.m_post_generation_validation_callback = func() : post_gen_validation(br_new)
	
	br_cont.create_river(split_point.m_position, br.m_target_point, m_bounds, new_branch_dir)
	br_new.create_river(split_point.m_position, VectorTools.random_point_along_edge(m_bounds, m_target_edge), m_bounds, new_branch_dir)
	
	check_convergence(br_new)
	
	m_branches.append(br_cont)
	m_branches.append(br_new)

	
func check_convergence(branch : RiverBranch):

			
		var conv = 0
		var conv_branch
		var done = false
		var min_distance_from_split = 5
		
		var others : Array[RiverBranch] = []
		
		for b in m_branches:
			if b == branch:
				continue
			else:
				others.append(b)
		for i in range(min_distance_from_split, branch.size()):
			var vert = branch.vertex_at(i)
			if done: break
			for other in others:
				if other.has(vert):
					conv = i
					conv_branch = other
					done = true
					break
		if (conv != 0):
			branch.trim_path_to_idx(conv)
		
func post_gen_validation(branch : RiverBranch):
	var all_positions = branch.get_vertex_positions()
	

	var in_bounds_positions = branch.get_positions_in_bounds(m_bounds)
	
	if in_bounds_positions.size() < 100:
		return false
	var ratio = float(in_bounds_positions.size()) / float(all_positions.size())
	#print("in_bounds: ", in_bounds_positions.size())
	#print("total: ", all_positions.size())
	#print("ratio: ", ratio)
	#print("")
	if ratio < 0.95:
		return false
	
	#if branch._m_worm.m_path[0].m_position != branch.m_start:
		#print("wrong startpoint")
		#return false
		
	#print("")
		
	return true

func get_final_river_points(map_size : Vector2i):
	var result : Array[Vector2i] = []

	for branch in m_branches:
		result.append_array(branch.get_final_river_points(map_size))

	return result
