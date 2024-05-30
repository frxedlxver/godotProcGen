extends Node
class_name PerlinWorm

class PathVertex:
	var position : Vector2i
	var speed : int
	var direction : Vector2
	
	func _init(position, speed, direction):
		self.position = position
		self.speed = speed
		self.direction = direction
		
static var MAX_SPEED : int = 1
static var SPEED_ANGLE_THRESHOLD : int = 30

var path : Array[PathVertex]

var cur_position : Vector2i = Vector2i.ZERO
var _last_direction : Vector2 = Vector2.RIGHT
var cur_direction : Vector2 = Vector2.RIGHT
var target_point : Vector2i = Vector2i.ZERO
var actual_end_point : Vector2i = Vector2i.ZERO
var bounds : Vector2i = Vector2i.ZERO
var target_point_range : float = 10

var noise_weight : float = 0.3
var cur_direction_weight : float = 0.3
var target_direction_weight : float = 0.4

var _noise : FastNoiseLite
var _seed : int = -1
var cur_speed : int = 1


func _init(noise_seed : int = -1):
	self._seed = noise_seed

	if self._seed < 0:
		self._seed = randi()
	
	var settings = NoiseSettings2D.new()
	settings.type = FastNoiseLite.TYPE_PERLIN
	settings.freq = 0.01
	self._noise =  Noise2D.get_noise(settings)
	_noise.seed = self._seed
	
func generate_path(starting_point : Vector2i, target_point : Vector2i, starting_direction : Vector2 = Vector2.ZERO, clear_old_path : bool = false):
	if clear_old_path:
		path = []

	if not VectorTools.a_inside_b(starting_point, self.bounds):
		print("Starting point (", starting_point,") out of bounds (", self.bounds ,")")
		return
	
	self.cur_position = starting_point
	self.cur_direction = starting_direction
	
	# break if in proximity of target or outside of bounds
	var at_target = false
	var out_of_bounds = false
	while not at_target and not out_of_bounds:
		find_next_vertex()
		
		# check if near target
		if VectorTools.a_within_range_of_b(self.cur_position, target_point, target_point_range):
			at_target = true
			actual_end_point = self.cur_position
		
		# check if oob
		if not VectorTools.a_inside_b(self.cur_position, self.bounds):
			out_of_bounds = true

# if target param left empty, use same target_point
func regenerate_from_idx(idx : int, target : Vector2i = Vector2i.MAX):
	if target == Vector2i.MAX:
		target = self.target_point
	
	# returns true if success, else false
	if self.trim_path_to_idx(idx):
		self.generate_path(self.cur_position, self.cur_direction, self.target_point)

func trim_path_to_idx(idx : int) -> bool:
	if idx > path.size():
		print_debug("Tried to trim path but idx ", idx, " larger than path size.")
		print_stack()
		return false
		
	var new_path = []
	for i in range(0, idx + 1):
		new_path.append(path[i])
	
	path = new_path
	self.actual_end_point = new_path.back()
	self.cur_position = self.actual_end_point
	
	self.update_direction()
	self.update_speed()
	return true

	
func get_vertices_in_bounds(bounds: Vector2i):
	var result = []
	for vertex in path:
		if VectorTools.a_inside_b(vertex.position, bounds):
			result.append(vertex)
			
	return result
	
func get_all_path_positions():
	var result = []
	for vertex in path:
		result.append(vertex.position)
		
		# append all extra vertices if speed is higher than 1
		if vertex.speed > 1:
			for i in range(1, vertex.speed + 1):
				var displacement = calc_displacement_rounded(i, vertex.direction)
				var new_pos = vertex.position + displacement
				if !result.has(new_pos):
					result.append(new_pos)
					

func find_next_vertex():
	# caches last direction and updates current
	update_direction()
	

	
	# Calculate next position
	var displacement = PerlinWorm.calc_displacement_rounded(cur_speed, cur_direction)
	var next_pos = self.cur_direction + displacement
	
	# create new vertex and add to path
	var new_point = PathVertex.new(next_pos, cur_speed, self.cur_direction)
	self.path.append(new_point)


	self.cur_position = next_pos

func update_direction():
	self._last_direction = self.cur_direction
	
	var noise_value = _noise.get_noise_2dv(self.cur_position)
	
	var noise_direction = NoiseTools.noise_val_to_dir(noise_value)
	var target_direction = Vector2(target_point - cur_position).normalized()
	
	var direction_dict = {
		noise_direction : noise_weight,
		self.cur_direction : cur_direction_weight,
		target_direction : self.target_direction_weight
	}
	
	self.cur_direction = interpolate_directions_weighted(direction_dict)


func update_speed():
	# Calculate the difference between last direction and current direction
	var direction_diff = rad_to_deg(_last_direction.angle_to( self.cur_direction))
	
	# Adjust speed based on direction difference
	self.cur_speed = PerlinWorm.calculate_new_speed(self.cur_speed, direction_diff)
# Function to calculate speed based on direction difference
static func calculate_new_speed(speed, direction_diff):
	var delta_speed = 1
	if abs(direction_diff) > deg_to_rad(SPEED_ANGLE_THRESHOLD):
		delta_speed = -1
	return clampi(speed + delta_speed, 1, PerlinWorm.MAX_SPEED)

static func interpolate_directions_weighted(weighted_direction_dict : Dictionary) -> Vector2:
	
	var summed_direction : Vector2 = Vector2.ZERO
	
	for dir in weighted_direction_dict.keys():
		var weight = weighted_direction_dict[dir]
		summed_direction += (dir * weight)
		
	
	var new_direction = summed_direction.normalized()
		
	return new_direction

static func calc_displacement_rounded(distance : float, direction : Vector2) -> Vector2i:
	var displacement : Vector2 = (direction * distance)
	return Vector2i(round(displacement.x), round(displacement.y))
	
func set_seed(seed : int):
	_noise.seed = seed
	
func set_noise_type(noise_type : FastNoiseLite.NoiseType):
	_noise.noise_type = noise_type
	
func set_freq(freq : float):
	_noise.frequency = freq
