extends Node

class_name NoiseTools

static func noise_val_to_dir(value: float, max_angle_deg : float) -> Vector2:
	value = (value + 1) / 2
	var angle = deg_to_rad(lerp(-max_angle_deg, max_angle_deg, value))
	var dx = cos(angle)
	var dy = sin(angle)
	return Vector2(dx, dy)
