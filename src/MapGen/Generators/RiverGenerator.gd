class_name RiverGenerator
# should rewrite from scratch


var m_max_depth 
var m_maximum_width : int = 10
var m_minimum_width : int = 2
var m_bounds : Vector2i = Vector2i.ZERO

var m_start_edge : Enums.Direction = Enums.Direction.NORTH
var m_target_edge : Enums.Direction = Enums.Direction.SOUTH

var m_branches : Array[RiverBranch] = []

var unhandled_convergences : Dictionary = {}

func generate(max_starting_rivers : int, maximum_width : int, heightmap : Image):
	m_branches = []
	for i in range(0, randi_range(1, max_starting_rivers)):
		var branch = generate_river(randi_range(2, 4), heightmap)
		m_branches.append(branch)
	
	var convergence_dict = {}
	var processed_points = []
	var processed_branches = []
	for branch in m_branches:
		for point in branch.m_path:
			for other in m_branches:
				if other == branch: continue
				else:
					if other.has(point):
						if convergence_dict.keys().has(point):
							if !convergence_dict[point].has(branch):
								convergence_dict[point].append(branch)
							if  !convergence_dict[point].has(other):
								convergence_dict[point].append(other)
						else:
							convergence_dict[point] = [branch, other]
		processed_branches.append(branch)		

	while convergence_dict.keys().size() > 0:
		var new_start_points = {}
		for point : Vector2i in convergence_dict.keys():
			processed_points.append(point)
			var point_removed = false
			var largest_branch : RiverBranch
			for branch : RiverBranch in convergence_dict[point]:
				if largest_branch == null || branch.m_width > largest_branch.m_width:
					largest_branch = branch
				var idx = branch.m_path.find(point)
				if idx == -1:
					point_removed = true
				
			if !point_removed:
				for branch : RiverBranch in convergence_dict[point]:
					branch.trim_to_vert(point)
				new_start_points[point] = \
					[min(m_maximum_width, largest_branch.m_width + (convergence_dict[point].size() - 1)), 
					largest_branch.m_target_point]

		for point in new_start_points.keys():
			m_branches.append(generate_river(new_start_points[point][0], heightmap, point, new_start_points[point][1]))
		
		convergence_dict = {}
		for branch in m_branches:
			if processed_branches.find(branch) != -1:
				continue
			for point in branch.m_path:
				for other in m_branches:
					if processed_branches.find(branch) != -1: continue
					if other == branch: continue
					elif processed_points.has(point): continue
					else:
						if other.has(point):
							if convergence_dict.keys().has(point):
								if !convergence_dict[point].has(branch):
									convergence_dict[point].append(branch)
								if  !convergence_dict[point].has(other):
									convergence_dict[point].append(other)
							else:
								convergence_dict[point] = [branch, other]
			processed_branches.append(branch)

func generate_river(width, heightmap : Image, start : Vector2i = Vector2i.ONE * -1, target : Vector2i = Vector2i.ONE * -1, dir : Vector2 = Vector2.ZERO):
	
	var branch = RiverBranch.new()
	branch.m_post_generation_validation_callback = func(): post_gen_validation(branch)
	branch.flag_regenerate_on_failure = true
	branch.m_width = width
	if width <= 1: width == 2
	if start == Vector2i.ONE * -1:
		start = VectorTools.random_point_along_edge(m_bounds, m_start_edge)
	if target == Vector2i.ONE * -1:
		target = VectorTools.random_point_along_edge(m_bounds, m_target_edge)
	if dir != Vector2.ZERO:
		branch.m_cur_direction = dir
	branch.create_river(start, target, m_bounds, heightmap)
	return branch

		
func post_gen_validation(branch : RiverBranch):
	var all_positions = branch.m_path
	

	var in_bounds_positions = branch.get_full_path_in_bounds(branch.m_bounds)
	
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
	var result : Array[Array] = []

	for branch in m_branches:
		result.append(branch.get_final_river_points(map_size))

	return result
