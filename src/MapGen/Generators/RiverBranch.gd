extends PerlinWorm

class_name RiverBranch

var m_iterations : int = 0
var m_width : int = 0
var m_heightmap : Image
var m_end : Vector2i = Vector2i.ZERO
var m_height_direction_weight : float
func _init():
	super._init()
	m_max_speed = 4
	m_noise_weight = 0.25
	_m_noise.noise_type = FastNoiseLite.TYPE_CELLULAR
	m_cur_direction_weight = 0.35
	
	m_noise_weight = 0.2
	m_cur_direction_weight = 0.3
	m_target_direction_weight = 0.4
	m_height_direction_weight = 0.1

func create_river(start : Vector2i, target : Vector2i, bounds : Vector2i, heightmap : Image, start_dir : Vector2i = Vector2i.ZERO):
	
	self.m_bounds = bounds
	m_heightmap = heightmap
	var done = false
	while not done:
		self.generate_path(start, target, start_dir, true)
		done = not self.failure
		


func update_direction():
	self.m_last_direction = self.m_cur_direction
	
	var local_min = m_heightmap.get_pixelv(m_cur_position).v
	var lowest_neighbour
	for point in VectorTools.vec2i_range(-m_cur_speed, m_cur_speed, true, true):
		if VectorTools.a_inside_b(point, m_bounds):
			if lowest_neighbour == null || m_heightmap.get_pixelv(point).v <= local_min:
				lowest_neighbour = point
				local_min = m_heightmap.get_pixelv(point).v
	
	var height_direction = Vector2(lowest_neighbour - m_cur_position).normalized()
	var target_direction = Vector2(m_target_point - m_cur_position).normalized()

		
	var noise_value = _m_noise.get_noise_2dv(m_cur_position)
	var noise_direction = NoiseTools.noise_val_to_dir(noise_value, m_max_turn_angle)
	
	
	var direction_dict = {
		noise_direction : self.m_noise_weight,
		self.m_cur_direction : self.m_cur_direction_weight,
		target_direction : self.m_target_direction_weight,
		height_direction : self.m_height_direction_weight
	}
	
	var new_dir = interpolate_directions_weighted(direction_dict)
	var new_angle = new_dir.angle_to(m_cur_direction)
	if abs(rad_to_deg(new_angle)) > m_max_turn_angle:
		new_angle = sign(new_angle) * deg_to_rad(m_max_turn_angle)
		var dx = cos(new_angle)
		var dy = sin(new_angle)
		new_dir = Vector2(dx, dy)
	self.m_cur_direction = new_dir
# returns all points, adjusted for width
func get_final_river_points(map_size : Vector2i) -> Array[Vector2i]:
	var result : Array[Vector2i] = []
		
	var width = m_width
	for point in self.get_full_path_in_bounds(map_size):
		result.append(point)
		for x in range(-width / 2, width / 2):
			for y in range(-width / 2, width / 2):
				if result.find(point + Vector2i(x, y)) == -1 and VectorTools.a_inside_b(point, map_size):
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
		
func has(point : Vector2i):
	for point1 in m_path:
		if point == point1: return true
	return false 

func get_idx_of(point : Vector2i):
	return m_path.find(point)
	
func trim_to_vert(point : Vector2i):
	var idx = get_idx_of(point)
	if idx != -1:
		trim_path_to_idx(idx)
