extends Node
class_name PerlinWorm

var _split_chance = 0.02
var _points : Dictionary = {}
var _split_point : Vector2i = Vector2i.ZERO
var cur_width : int = 2
var max_width : int = 6
var min_width : int = 2
var _seed : int = -1
var _max_move_speed : int = 1
var _cur_move_speed : int = 1
var _color : Color

var cur_position : Vector2i = Vector2i.ZERO
var cur_direction : Vector2 = Vector2.RIGHT
var target_points : Array[Vector2i] = []
var target_point : Vector2i = Vector2i.ZERO
var bounds : Vector2i = Vector2i.ZERO
var range : float = 2

var _noise : FastNoiseLite
var _dir_noise_image : Image
var _size_noise_image : Image


func _init(thickness : int = 3, worm_color : Color = Color.DODGER_BLUE, max_move_speed: int = 10,seed : int = -1):
	self.cur_width = thickness
	self._color = worm_color
	self._max_move_speed = max_move_speed
	self._seed = seed
	if self._seed < 0:
		self._seed = randi()
	
	self._noise = get_noise()
	
	
func find_worm_points(staring_point : Vector2i = self.cur_position, starting_direction : Vector2i = self.cur_direction):
	if a_inside_b(staring_point, self.bounds):
		self.self.cur_position = staring_point
		self.cur_direction = starting_direction
		var temp_targets = [target_point]
		while temp_targets.size() > 0  and a_inside_b(self.self.cur_position, self.bounds):
			target_point = temp_targets[0]
			if a_within_range_of_b(self.cur_position, target_point, 10):
				target_points[0] = self.cur_position
				temp_targets.remove_at(0)
				if (temp_targets.size() > 0):
					target_point = temp_targets[0]
			get_next_point()


func a_within_range_of_b(a : Vector2i, b : Vector2i, r : float):
	var distance = abs((b - a).length())
	return distance <= r


func get_next_point():
	self.cur_width = calculate_thickness()
	var value = _noise.get_noise_2dv(self.cur_position)
	
	var _last_direction = self.cur_direction
	# Calculate next position and update current direction
	var next_pos = next_worm_pos_targeted(value, self.cur_position.x, self.cur_position.y, _cur_move_speed)
	self.cur_direction = normalize_vec2(next_pos - self.cur_position)
	
	# Calculate the difference between last direction and current direction
	var direction_diff = _last_direction.angle_to( self.cur_direction)
	
	# Adjust speed based on direction difference
	_cur_move_speed = calculate_speed(direction_diff)
	append_points_between(self.cur_position, next_pos, self.cur_width)
	self.cur_position = next_pos


func draw_next_pos(image: Image):
	if (has_next_pos()):
		var nextPoint = self.points_width_dict.keys()[0]
		var thickness = self.points_width_dict.get(nextPoint)
		draw_pixels(image, thickness, nextPoint, _color)
		self.points_width_dict.erase(nextPoint)


func has_next_pos() -> bool:
	return self.points_width_dict.keys().size() > 0


func append_points_between(start, end, thickness):
	for i in range(_cur_move_speed):
		var new_point = calc_position_rounded(i, self.cur_direction, start)
		self.points_width_dict[new_point] = self.cur_width


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
	return clampi(_cur_move_speed + delta_speed, 1, _max_move_speed)


# Function to calculate thickness inversely proportional to current speed
func calculate_thickness():
	var ratio = 1 - (_cur_move_speed / _max_move_speed)
	return round(self.cur_width * 0.6 + clampi( self.max_width * ratio, self.min_width,  self.max_width) * 0.4)


# finds next appropriate point as a weighted interpolation of current direction, noise direction influence, and target direction
func next_worm_pos_targeted(value : float, cur_x: int, cur_y: int, move_speed: int = 1) -> Vector2i:
	var noise_direction = noise_val_to_dir(value)
	var target_direction = (Vector2(target_point) - Vector2(cur_x, cur_y)).normalized()
	self.cur_direction = (self.cur_direction * 0.3 + noise_direction * 0.3 + target_direction * 0.4).normalized()
	return calc_position_rounded(_cur_move_speed, self.cur_direction, self.cur_position)


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
	for point in self.points_width_dict:
		if target_points.count(point) > 0:
			draw_pixels(result_image, self.points_width_dict[point], point, Color.RED)
		else:
			draw_pixels(result_image, self.points_width_dict[point], point, _color)
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
	self.cur_direction = self.cur_direction * 0.5 + noise_val_to_dir(value) * 0.5
	var next_pos = Vector2(cur_x, cur_y) + self.cur_direction * move_speed
	return Vector2i(round(next_pos.x), round(next_pos.y))
	
static func noise_val_to_dir(value: float) -> Vector2:
	var angle = value * 2 * PI
	var dx = cos(angle)
	var dy = sin(angle)
	return Vector2(dx, dy)
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
