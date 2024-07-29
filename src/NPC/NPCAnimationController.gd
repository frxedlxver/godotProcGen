extends Node2D
class_name NPCAnimationController

@onready var sprite = get_node("../AnimatedSprite2D")

func set_animation(animation_name : String, force_update : bool = false) -> bool:
	if sprite.animation == animation_name && !force_update:
		return false
	else:
		sprite.animation = animation_name
		sprite.play()
		return true

func play():
	sprite.play()

func stop():
	sprite.stop()
