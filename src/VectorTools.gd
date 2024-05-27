extends Node

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