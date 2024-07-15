extends Node2D

var sprite : AnimatedSprite2D
var detectionArea : Area2D
var isOpen : bool
var buildingExterior : Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	sprite = get_node("AnimatedSprite2D")
	buildingExterior = get_node("../ExteriorSprite");
	detectionArea = get_node("Area2D")
	sprite.animation = "closed"
	sprite.stop()
	
	sprite.animation_finished.connect(on_animation_finished)
	detectionArea.body_entered.connect(_open_door)
	detectionArea.body_exited.connect(_close_door)
	
func _process(delta):
	if buildingExterior.player_inside && sprite.animation == "closed":
		if sprite.self_modulate.a > 0:
			sprite.self_modulate.a = clamp(sprite.self_modulate.a - (0.02 * 255 * delta), 0.2, 1);
	elif sprite.self_modulate.a < 1:
		sprite.self_modulate.a = clamp(sprite.self_modulate.a + (0.02 * 255 * delta), 0.4, 1);

func _open_door(area):
	if (!isOpen):
		sprite.animation = "opening"
		sprite.play()
		isOpen = true
	
func _close_door(area):
	if (isOpen):
		sprite.animation = "opening"	
		sprite.play_backwards()
		isOpen = false
		
func on_animation_finished():
	if sprite.animation == "opening":
		if isOpen:		
			sprite.animation = "opened"
			sprite.stop()
		else:
			sprite.animation = "closed"
			sprite.stop()
