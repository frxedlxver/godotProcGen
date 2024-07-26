extends Node2D

class_name Building

var sprite : Sprite2D
var body_inside : bool
var area : Area2D

func _ready():
	sprite = get_node("ExteriorSprite")
	area = get_node("InteriorArea2D")

func _process(delta):
	var fade_rate = -0.02 if body_inside else 0.02
	sprite.modulate.a = clamp(sprite.modulate.a + fade_rate, 0, 1)
	if body_inside: print("body inside")


func _on_interior_area_2d_body_entered(body):
	if body.name == "Player":
		body_inside = true


func _on_interior_area_2d_body_exited(body):
	if body.name == "Player":
		body_inside = false
