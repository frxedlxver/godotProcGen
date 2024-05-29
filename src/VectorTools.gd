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
