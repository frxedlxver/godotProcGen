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

var noise_weight : float = 0.3
var cur_direction_weight : float = 0.3
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
	settings.freq = 0.01
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
			if VectorTools.a_within_range_of_b(self.cur_position, target_point, 15):
				target_points[0] = self.cur_position
				temp_targets.remove_at(0)
				if (temp_targets.size() > 0):
					target_point = temp_targets[0]
			get_next_point()

func get_points_in_bounds(bounds: Vector2i):
	var result = []
	for point in path:
		if VectorTools.a_inside_b(point, bounds):
			result.append(point)
			
	return result

func get_next_point():
	self._last_direction = self.cur_direction
	
	self.cur_direction = calculate_new_direction()
	# Calculate next position and update current direction
	var next_pos = next_worm_pos()
	
	# Calculate the difference between last direction and current direction
	var direction_diff = _last_direction.angle_to( self.cur_direction)
	
	# Adjust speed based on direction difference
	cur_speed = calculate_speed(direction_diff)

	# Add new points to path
	# maximum is +1 because
	for i in range(cur_speed + 1):
		var new_point = calc_displacement_rounded(cur_position, i, cur_direction)
		self.path.append(new_point)

	self.cur_position = next_pos

# Function to calculate speed based on direction difference
func calculate_speed(direction_diff):
	var delta_speed = 1
	if abs(direction_diff) > deg_to_rad(30):  # Example threshold
		delta_speed = -1
	return clampi(cur_speed + delta_speed, 1, _max_move_speed)

func calculate_new_direction() -> Vector2:
	var noise_value = _noise.get_noise_2dv(self.cur_position)
	
	var noise_direction = NoiseTools.noise_val_to_dir(noise_value)
	var target_direction = Vector2(target_point - cur_position).normalized()
	var new_direction = (
		self.cur_direction
		+ noise_direction
		+ target_direction
		).normalized()
		
	return new_direction

# finds next appropriate point as a weighted interpolation of current direction, noise direction influence, and target direction
func next_worm_pos() -> Vector2i:
	return calc_displacement_rounded(cur_position, cur_speed, cur_direction)

func calc_displacement_rounded(start: Vector2i, distance : float, direction : Vector2) -> Vector2i:
	var next_pos : Vector2 = Vector2(start) + (direction * distance)
	return Vector2i(round(next_pos.x), round(next_pos.y))
