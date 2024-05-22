extends Node
class_name PerlinWorm

var _split_chance = 0.02
var _points : Dictionary = {}
var _split_point : Vector2i = Vector2i.ZERO
var _thickness : int
var _seed : int
var _max_move_speed : int
var _color : Color

var _cur_point : Vector2i
var _cur_direction : Vector2
var _target_points : Array[Vector2i]
var _target_point : Vector2i

var _noise : FastNoiseLite
var _dir_noise_image : Image
var _size_noise_image : Image


func _init(thickness : int = 3, worm_color : Color = Color.DODGER_BLUE, max_move_speed: int = 4,seed : int = -1):
	self._thickness = thickness
	self._color = worm_color
	self._max_move_speed = max_move_speed
	self._seed = seed
	
	
func find_worm_points(staring_point : Vector2i, image_size : Vector2i, starting_direction : Vector2i = Vector2i.RIGHT):
	if self._seed < 0:
		self._seed = randi()
	
	if a_inside_b(staring_point, image_size):
		self._noise = get_noise()
		self._cur_point = staring_point
		self._cur_direction = starting_direction
		var temp_targets = _target_points.duplicate(true)
		while temp_targets.size() > 0 and a_inside_b(self._cur_point, image_size):
			#if (randf_range(0, 1) <= self._split_chance && self._split_point == Vector2i.ZERO):
				#_split_point = self._cur_point
				#_thickness = maxi(_thickness / 2, 1)
			_target_point = temp_targets[0]
			if _cur_point == _target_point:
				temp_targets.remove_at(0)
				if temp_targets.size() == 0:
					break
				_target_point = temp_targets[0]
			var value = _noise.get_noise_2dv(_cur_point)
			
			# todo: append all points if move speed > 1
			self._cur_point = next_worm_pos_targeted(value, _cur_point.x, _cur_point.y, randi_range(1, self._max_move_speed + 1))
			self._points[_cur_point] = _thickness
			
			
func next_worm_pos_targeted(value : float, cur_x: int, cur_y: int, move_speed: int = 1) -> Vector2i:
	var noise_direction = noise_val_to_dir(value)
	var target_direction = (Vector2(_target_point) - Vector2(cur_x, cur_y)).normalized()
	_cur_direction = (_cur_direction * 0.2 + noise_direction * 0.3 + target_direction * 0.5).normalized()
	var next_pos = Vector2(cur_x, cur_y) + _cur_direction * move_speed
	return Vector2i(round(next_pos.x), round(next_pos.y))
	
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
			result_image.set_pixelv(Vector2(position.x + x, position.y + y), color)
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
