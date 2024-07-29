class_name VectorTools

static func a_within_range_of_b(a : Vector2i, b : Vector2i, r : float):
	var distance = abs((b - a).length())
	return distance <= r

# Function to normalize a vector2
static func normalize_vec2i(v : Vector2i):
	var length = sqrt(v.x * v.x + v.y * v.y)
	if length != 0:
		return Vector2(v.x / length, v.y / length)
	else:
		return Vector2(0, 0)

static func a_inside_b(point : Vector2, bounds : Vector2) -> bool:
	return point.x >= 0 && point.y >= 0 && point.x < bounds.x && point.y < bounds .y;
	
static func random_point_along_edge(bounds : Vector2i, edge : Enums.Direction) -> Vector2i:
	
	var rand_x = randi_range(0, bounds.x)
	var rand_y = randi_range(0, bounds.y)
	
	match edge:
		Enums.Direction.NORTH:
			return Vector2i(rand_x, 0)
		Enums.Direction.SOUTH:
			return Vector2i(rand_x, bounds.y)
		Enums.Direction.WEST:
			return Vector2i(0, rand_y)
		Enums.Direction.EAST:
			return Vector2i(bounds.x, rand_y)
		_:
			return Vector2i.ZERO

static func vec2i_range(low : int, high : int, use_inclusive_max : bool = false, omit_center : bool = false, offset: Vector2i = Vector2i.ZERO) -> Array[Vector2i]:
	var result : Array[Vector2i] = []
	
	
	if use_inclusive_max:
		high += 1
	for x in range (low + offset.x, high + offset.x):
		for y in range(low + offset.y, high + offset.y):
			if omit_center and x == offset.x + 0 and y == offset.y + 0:
				continue
			result.append(Vector2i(x, y))
			
	return result
	
static func randv2():
	return Vector2(randf(), randf())
	
static func randv2_range_f(min: float, max: float):
	var val = randf_range(min, max)
	return Vector2(val, val)
	
static func randv2_range_v2(min : Vector2, max: Vector2):
	return Vector2(randf_range(min.x, max.x), randf_range(min.y, max.y))

static func randv2i():
	return Vector2i(randi(), randi())
	
static func randv2i_range_i(min: int, max: int):
	return Vector2(randi_range(min, max), randi_range(min, max))
	
static func randv2i_range_v2i(min : Vector2i, max: Vector2i):
	return Vector2(randi_range(min.x, max.x), randi_range(min.y, max.y))
	

static func calc_displacement_rounded(distance : float, direction : Vector2) -> Vector2i:
	var displacement : Vector2 = (direction * distance)
	return Vector2i(round(displacement.x), round(displacement.y))
	
	
static func get_filled_circle_positions(radius: int, offset : Vector2i = Vector2.ZERO) -> Array[Vector2i]:
	var points : Array[Vector2i] = []
	var center = Vector2i(0, 0)
	
	# Midpoint circle algorithm
	var x = offset.x + radius
	var y = offset.y
	var decisionOver2 = 1 - x   # Decision criterion divided by 2 evaluated at (x, y) = (radius, 0)
	
	while y <= x:
		# Add points for each octant of the circle
		_add_circle_points(center, x, y, points)
		_add_circle_points(center, y, x, points)
		y += 1
		if decisionOver2 <= 0:
			decisionOver2 += 2 * y + 1
		else:
			x -= 1
			decisionOver2 += 2 * (y - x) + 1
	
	# Fill the circle
	for point in points.duplicate():
		for dx in range(-radius, radius + 1):
			for dy in range(-radius, radius + 1):
				if (Vector2i(dx, dy).length_squared() <= radius * radius) and (center + point + Vector2i(dx, dy) not in points):
					points.append(center + point + Vector2i(dx, dy))
	return points

static func _add_circle_points(center: Vector2i, x: int, y: int, points: Array) -> void:
	points.append(center + Vector2i( x,  y))
	points.append(center + Vector2i(-x,  y))
	points.append(center + Vector2i( x, -y))
	points.append(center + Vector2i(-x, -y))
	
# Static function to quantize a normalized Vector2
static func quantize_normalized_vector2(vec: Vector2, divisions: int) -> Vector2:
	assert(vec.length() == 1.0, "Input vector must be normalized.")
	
	var division_angle = 2 * PI / divisions
	var closest_division = round(vec.angle() / division_angle) % divisions
	
	var angle = closest_division * division_angle
	var quantized_vec = Vector2(cos(angle), sin(angle))
	
	return quantized_vec
	

