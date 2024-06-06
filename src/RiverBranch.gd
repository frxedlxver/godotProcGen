extends PerlinWorm

class_name RiverBranch

var m_iterations : int = 0
var m_width : int = 0

var m_end : Vector2i = Vector2i.ZERO

func _init():
	super._init()
	m_max_speed = 4
	m_noise_weight = 0.25
	_m_noise.noise_type = FastNoiseLite.TYPE_CELLULAR
	m_cur_direction_weight = 0.35

func create_river(start : Vector2i, target : Vector2i, bounds : Vector2i, start_dir : Vector2i = Vector2i.ZERO):
	
	self.m_bounds = bounds
	
	#var validation = func():
		#print("y dir ", _m_worm.cur_direction.y)
		#return _m_worm.cur_direction.y > 0
	#_m_worm.m_step_validation_callback = validation
	var done = false
	while not done:
		self.generate_path(start, target, start_dir, true)
		done = not self.failure

# returns all points, adjusted for width
func get_final_river_points(map_size : Vector2i) -> Array[Vector2i]:
	var result : Array[Vector2i] = []
	for point in self.get_full_path_in_bounds(map_size):
		for x in range(-m_width, m_width):
			for y in range(-m_width, m_width):
				result.append(point + Vector2i(x, y))
		
	return result

func find_split_point():
	return find_split_point_between(0, self.m_path.size() - 1)
	
func find_split_point_between(start_idx : int, end_idx : int):
	if m_path.size() == 0:
		print_debug("Path is empty");
		return
	
	if end_idx < 0 || end_idx >= self.m_path.size():
		print_debug("End idx out of range")
		return		
		
	if start_idx < 0 or start_idx > end_idx:
		print_debug("Start idx out of range")
		return
		
	if start_idx == end_idx:
		return m_path[start_idx]
	else: 
		return m_path[range(start_idx, end_idx).pick_random()]
		
func has(vert : PathVertex):
	if m_path.has(vert): return true
	else:
		var direction = Vector2(m_target_point - m_start).normalized()
		var shortest_dist = 0
		var steps_since_last_shortest_dist = 0
		for v in m_path:
			var dist = (v.m_position - vert.m_position).length()
			if dist < shortest_dist || shortest_dist == 0:
				shortest_dist = dist
			else:
				steps_since_last_shortest_dist += 1
			
			if dist < v.m_speed:
				for i in range(v.m_speed):
					var displacement = VectorTools.calc_displacement_rounded(i, v.m_direction)
					if (v.m_position + displacement - vert.m_position).length() < m_width / 2:
						return true
			elif steps_since_last_shortest_dist == 100:
				return false
			
		return false

