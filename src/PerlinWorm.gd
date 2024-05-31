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
		
static var MAX_SPEED : int = 10
static var MAX_TURN_ANGLE : float = 90
static var SPEED_ANGLE_THRESHOLD : int = 15

var path : Array[PathVertex]

var _last_direction : Vector2 = Vector2.ZERO
var cur_position : Vector2i = Vector2i.ZERO
var cur_direction : Vector2 = Vector2.ZERO
var cur_speed : int = 1
var target_point : Vector2i = Vector2i.ZERO
var bounds : Vector2i = Vector2i.ZERO
var min_dist_from_target : float = 10


var noise_weight : float = 0.315
var cur_direction_weight : float = 0.335
var target_direction_weight : float = 0.35

var _noise : FastNoiseLite

var per_step_validation_callback : Callable
var use_per_step_validation : bool = false
var end_on_per_step_validation_failure : bool = false
var post_generation_validation_callback : Callable
var use_post_generation_validation : bool = false



func _init(noise_seed : int = -1):
	
	var settings = NoiseSettings2D.new()
	settings.type = FastNoiseLite.TYPE_CELLULAR
	settings.freq = 0.01
	if noise_seed == -1:
		settings.randomSeed = true
	else:
		settings.randomSeed = false
		settings.seed = noise_seed
	self._noise =  Noise2D.get_noise(settings)
	
func generate_path(start : Vector2i, target : Vector2i, starting_direction : Vector2 = Vector2.ZERO, clear_old_path : bool = false):
	if clear_old_path:
		path = []

	if not VectorTools.a_inside_b(start, self.bounds):
		print("Starting point (", start,") out of bounds (", self.bounds ,")")
		return
	
	self.cur_position = start
	self.target_point = target
	self.cur_direction = Vector2.DOWN
	
	
	validate_callbacks()

	# break if in proximity of target or outside of bounds
	var done = false
	while not done:
		find_next_vertex()
		
		# check if near target
		if VectorTools.a_within_range_of_b(self.cur_position, target_point, min_dist_from_target):
			done = true
			print("reached target")
			print_debug_info()

		
		if use_per_step_validation:
			if per_step_validation_callback.call():
				print_debug("per-step validation passed.")
				
			else:
				print_debug("per-step validation failed.")
				if end_on_per_step_validation_failure:
					done = true
			
		## check if oob
		#if not VectorTools.a_inside_b(self.cur_position, self.bounds):
			#done = true
			#print("out of bounds")
			#print_debug_info()
	if use_post_generation_validation:
		if post_generation_validation_callback.call():
			print_debug("Post-generation validation failed.")			
		else:
			print_debug("Post-generation validation passed.")
	

# func to ensure that callbacks exist and return booleans
func validate_callbacks():
	var validate = func(callable, cb_name : String):
		if not callable:
			print_debug("Callback for \'", cb_name, "\' not set --- not using callback.")
			return false
		var result = callable.call()
		if typeof(result) == TYPE_BOOL:
			return true
		else:
			return false
			print_debug("Callback for \'", cb_name, "\' does not return bool --- not using callback.")
			
	
	if validate.call(per_step_validation_callback, "per step validation"):
		use_per_step_validation = true
	
	if validate.call(post_generation_validation_callback, "post generation validation"):
		use_per_step_validation
		

			

func print_debug_info():
	print("Position: ", cur_position)
	print("Direction: ", cur_direction)
	print("Size: ", path.size())
	print("Target: ", target_point)
	print("Target Range: ", min_dist_from_target)
	print("Distance from Target: ", (target_point - cur_position).length())

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
		print_debug_info()
		print_stack()
		return false
		
	var new_path = []
	for i in range(0, idx + 1):
		new_path.append(path[i])
	
	path = new_path
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
	
func get_all_path_positions() -> Array[Vector2i]:
	var result :Array[Vector2i]= []
	for vertex in path:
		result.append(vertex.position)
		
		# append all extra vertices if speed is higher than 1
		if vertex.speed > 1:
			for i in range(1, vertex.speed + 1):
				var displacement = calc_displacement_rounded(i, vertex.direction)
				var new_pos = vertex.position + displacement
				if !result.has(new_pos):
					result.append(new_pos)
	return result
	
func get_actual_endpoint():
	if path.size() > 0:
		return path[path.size() -1].position
		
func distance_to_target():
	return Vector2(target_point - cur_position).length()
	
func find_next_vertex():
	# caches last direction and updates current
	update_direction()
	
	update_speed()
	
	# Calculate next position
	var displacement = PerlinWorm.calc_displacement_rounded(cur_speed, cur_direction)
	var next_pos = self.cur_position + displacement
	
	# create new vertex and add to path
	var new_point = PathVertex.new(next_pos, cur_speed, self.cur_direction)
	self.path.append(new_point)


	self.cur_position = next_pos

func update_direction():
	self._last_direction = self.cur_direction
	
	var noise_value = _noise.get_noise_2dv(self.cur_position)
	
	var noise_direction = NoiseTools.noise_val_to_dir(noise_value, MAX_TURN_ANGLE)
	var target_direction = Vector2(target_point - cur_position).normalized()
	
	var direction_dict = {
		noise_direction : self.noise_weight,
		self.cur_direction : self.cur_direction_weight,
		target_direction : self.target_direction_weight
	}
	
	var new_dir = interpolate_directions_weighted(direction_dict)
	var new_angle = new_dir.angle_to(cur_direction)
	if abs(rad_to_deg(new_angle)) > MAX_TURN_ANGLE:
		print("new angle out of range: ", rad_to_deg(new_angle))
		new_angle = sign(new_angle) * deg_to_rad(MAX_TURN_ANGLE)
		print("clamped angle: ", rad_to_deg(new_angle))
		var dx = cos(new_angle)
		var dy = sin(new_angle)
		new_dir = Vector2(dx, dy)
	self.cur_direction = new_dir
		


func update_speed():
	# Calculate the difference between last direction and current direction
	var direction_diff = rad_to_deg(_last_direction.angle_to( self.cur_direction))
	
	# Adjust speed based on direction difference
	self.cur_speed = PerlinWorm.calculate_new_speed(self.cur_speed, direction_diff)

# Function to calculate speed based on direction difference
static func calculate_new_speed(speed, direction_diff):
	var delta_speed = 1
	print("diff: ", direction_diff)
	print("speed: ", speed)
	if abs(direction_diff) > SPEED_ANGLE_THRESHOLD:
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
