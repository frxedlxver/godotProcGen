extends Node
class_name PerlinWorm

var _split_chance = 0.02
var _points : Dictionary = {}
var _split_point : Vector2i = Vector2i.ZERO
var _thickness : int
var _max_thickness : int = 6
var _min_thickness : int = 2
var _seed : int
var _max_move_speed : int
var _cur_move_speed : int
var _color : Color

var _cur_point : Vector2i
var _cur_direction : Vector2
var _target_points : Array[Vector2i]
var _target_point : Vector2i

var _noise : FastNoiseLite
var _dir_noise_image : Image
var _size_noise_image : Image


func _init(thickness : int = 3, worm_color : Color = Color.DODGER_BLUE, max_move_speed: int = 10,seed : int = -1):
	self._thickness = thickness
	self._color = worm_color
	self._max_move_speed = max_move_speed
	self._seed = seed
	if self._seed < 0:
		self._seed = randi()
	
	self._noise = get_noise()
	
	
	
func find_worm_points(staring_point : Vector2i, image_size : Vector2i, starting_direction : Vector2i = Vector2i.RIGHT):

	if a_inside_b(staring_point, image_size):
		self._cur_point = staring_point
		self._cur_direction = starting_direction
		var temp_targets = _target_points.duplicate(true)
		while temp_targets.size() > 0 and a_inside_b(self._cur_point, image_size):
			_target_point = temp_targets[0]
			if _cur_point == _target_point:
				temp_targets.remove_at(0)
				_target_point = temp_targets[0]
			get_next_point()
			

func get_next_point():
	_thickness = calculate_thickness()

	var value = _noise.get_noise_2dv(_cur_point)
	
	var _last_direction = _cur_direction
	# Calculate next position and update current direction
	var next_pos = next_worm_pos_targeted(value, _cur_point.x, _cur_point.y, _cur_move_speed)
	self._cur_direction = normalize_vec2(next_pos - _cur_point)
	
	# Calculate the difference between last direction and current direction
	var direction_diff = _last_direction.angle_to(self._cur_direction)
	
	# Adjust speed based on direction difference
	_cur_move_speed = calculate_speed(direction_diff)
	
	
	append_points_between(_cur_point, next_pos, _thickness)
	_cur_point = next_pos
			
func append_points_between(start, end, thickness):
	for i in range(_cur_move_speed):
		var new_point = calc_position_rounded(i, _cur_direction, start)
		_points[new_point] = _thickness
		
# Function to normalize a vector2
func normalize_vec2(v):
	var length = sqrt(v.x * v.x + v.y * v.y)
	if length != 0:
		return Vector2(v.x / length, v.y / length)
	else:
		return Vector2(0, 0)
		
# Function to calculate speed based on direction difference
func calculate_speed(direction_diff):
	var delta_speed = 1
	if abs(direction_diff) > PI / 12:  # Example threshold
		delta_speed = -1
		
	print(_cur_move_speed)
	return clampi(_cur_move_speed + delta_speed, 1, _max_move_speed)
	
func calculate_thickness():
	var ratio = 1 - (_cur_move_speed / _max_move_speed)
	return round(_thickness * 0.6 + clampi(_max_thickness * ratio, _min_thickness, _max_thickness) * 0.4)
	
func next_worm_pos_targeted(value : float, cur_x: int, cur_y: int, move_speed: int = 1) -> Vector2i:
	var noise_direction = noise_val_to_dir(value)
	var target_direction = (Vector2(_target_point) - Vector2(cur_x, cur_y)).normalized()
	_cur_direction = (_cur_direction * 0.3 + noise_direction * 0.3 + target_direction * 0.4).normalized()
	var next_pos = Vector2(cur_x, cur_y) + _cur_direction * move_speed
	return Vector2i(round(next_pos.x), round(next_pos.y))
	
static func calc_position_rounded(speed, direction, current_position) -> Vector2i:
	var next_pos = Vector2(current_position.x, current_position.y) + (direction * speed)
	return Vector2i(round(next_pos.x), round(next_pos.y))
	
#todo:
func next_worm_pos_height(height_map : Image, cur_x: int, cur_y: int):
	var darkest_neighbour
	
	for x in range (-_cur_move_speed, _cur_move_speed):
		for y in range(-_cur_move_speed, _cur_move_speed):
			pass
	
func draw_worm_points(result_image : Image):
	for point in _points:
		if _target_points.count(point) > 0:
			draw_pixels(result_image, _points[point], point, Color.RED)
		else:
			draw_pixels(result_image, _points[point], point, _color)
	return result_image

static func draw_pixels(result_image : Image, thickness : int, position : Vector2i, color : Color):
	for x in range(-thickness, thickness):
		for y in range(-thickness, thickness):
			var pixel_pos = Vector2i(position.x + x, position.y + y)
			if a_inside_b(pixel_pos, result_image.get_size()):
				result_image.set_pixelv(pixel_pos, color)

static func get_noise(seed: int = 0) -> FastNoiseLite:
	var settings = NoiseSettings2D.new()
	settings.type = FastNoiseLite.TYPE_PERLIN
	settings.freq = 0.02
	return Noise2D.get_noise(settings)
	
static func a_inside_b(point : Vector2, bounds : Vector2) -> bool:
	return point.x >= 0 && point.y >= 0 && point.x < bounds.x && point.y < bounds .y;
# Function to get the next worm position in a tile-based manner
func next_worm_pos(value : float, cur_x: int, cur_y: int, move_speed: int = 1) -> Vector2i:
	_cur_direction = _cur_direction * 0.5 + noise_val_to_dir(value) * 0.5
	var next_pos = Vector2(cur_x, cur_y) + _cur_direction * move_speed
	return Vector2i(round(next_pos.x), round(next_pos.y))
	
static func noise_val_to_dir(value: float) -> Vector2:
	var angle = value * 2 * PI
	var dx = cos(angle)
	var dy = sin(angle)
	return Vector2(dx, dy)
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
