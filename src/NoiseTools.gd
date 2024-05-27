extends Node

class_name NoiseTools

static func noise_val_to_dir(value: float) -> Vector2:
	var angle = value * 2 * PI
	var dx = cos(angle)
	var dy = sin(angle)
	return Vector2(dx, dy)
