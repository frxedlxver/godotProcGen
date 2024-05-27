extends Node
class_name PerlinWorm

var path : Array[Vector2i]
var cur_width : int = 2
var max_width : int = 4
var min_width : int = 2

var cur_position : Vector2i = Vector2i.ZERO
var _last_direction : Vector2 = Vector2.RIGHT
var cur_direction : Vector2 = Vector2.RIGHT
var target_points : Array[Vector2i] = []
var target_point : Vector2i = Vector2i.ZERO
var bounds : Vector2i = Vector2i.ZERO
var target_point_range : float = 2

var noise_weight : float = 0.4
var cur_direction_weight : float = 0.2
var target_direction_weight : float = 0.4

var _noise : FastNoiseLite
var _seed : int = -1
var _max_move_speed : int = 1
var cur_speed : int = 1
var _color : Color


func _init(thickness : int = 3, worm_color : Color = Color.DODGER_BLUE, max_move_speed: int = 10, noise_seed : int = -1):
	self.cur_width = thickness
	self._color = worm_color
	self._max_move_speed = max_move_speed
	self._seed = noise_seed



	if self._seed < 0:
		self._seed = randi()
	
	var settings = NoiseSettings2D.new()
	settings.type = FastNoiseLite.TYPE_PERLIN
	settings.freq = 0.005
	self._noise =  Noise2D.get_noise(settings)
	_noise.seed = self._seed
	
func find_worm_points(staring_point : Vector2i = self.cur_position, starting_direction : Vector2i = self.cur_direction):
	if VectorTools.a_inside_b(staring_point, self.bounds):
		
		self.cur_position = staring_point
		self.cur_direction = starting_direction
		
		# make a copy of target_points to operate on
		var temp_targets = target_points.duplicate(true)
		
		# break if out of targets or outside of bounds
		while temp_targets.size() > 0  and VectorTools.a_inside_b(self.cur_position, self.bounds):
			target_point = temp_targets[0]
			if VectorTools.a_within_range_of_b(self.cur_position, target_point, 10):
				target_points[0] = self.cur_position
				temp_targets.remove_at(0)
				if (temp_targets.size() > 0):
					target_point = temp_targets[0]
			get_next_point()


func get_next_point():
	var value = _noise.get_noise_2dv(self.cur_position)
	
	self._last_direction = self.cur_direction
	
	# Calculate next position and update current direction
	var next_pos = next_worm_pos_targeted(value)
	self.cur_direction = Vector2(next_pos - self.cur_position).normalized()
	
	# Calculate the difference between last direction and current direction
	var direction_diff = _last_direction.angle_to( self.cur_direction)
	
	# Adjust speed based on direction difference
	cur_speed = calculate_speed(direction_diff)

	# Add new points to path
	# maximum is +1 because
	for i in range(cur_speed + 1):
		var new_point = calc_next_position_rounded(i)
		self.path.append(new_point)

	self.cur_position = next_pos

# Function to calculate speed based on direction difference
func calculate_speed(direction_diff):
	var delta_speed = 1
	if abs(direction_diff) > deg_to_rad(30):  # Example threshold
		delta_speed = -1
	return clampi(cur_speed + delta_speed, 1, _max_move_speed)


# finds next appropriate point as a weighted interpolation of current direction, noise direction influence, and target direction
func next_worm_pos_targeted(noise_value : float) -> Vector2i:
	var noise_direction = NoiseTools.noise_val_to_dir(noise_value)
	var target_direction = Vector2(target_point - cur_position).normalized()
	self.cur_direction = (
		self.cur_direction * cur_direction_weight 
		+ noise_direction * noise_weight 
		+ target_direction * target_direction_weight
		).normalized()
	return calc_next_position_rounded()


func calc_next_position_rounded(distance : float = self.cur_speed) -> Vector2i:
	var next_pos = Vector2(cur_position.x, cur_position.y) + (cur_direction * distance)
	return Vector2i(round(next_pos.x), round(next_pos.y))


# Function to get the next worm position in a tile-based manner
func next_worm_pos(value : float, cur_x: int, cur_y: int, move_speed: int = 1) -> Vector2i:
	self.cur_direction = self.cur_direction * 0.5 + NoiseTools.noise_val_to_dir(value) * 0.5
	var next_pos = Vector2(cur_x, cur_y) + self.cur_direction * move_speed
	return Vector2i(round(next_pos.x), round(next_pos.y))
	
