extends Node2D

var sprite : AnimatedSprite2D
var detectionArea : Area2D
var isOpen : bool


# Called when the node enters the scene tree for the first time.
func _ready():
	sprite = get_node("AnimatedSprite2D")
	detectionArea = get_node("DoorDetectionZone")
	sprite.animation = "closed"
	sprite.stop()
	
	sprite.animation_finished.connect(on_animation_finished)
	detectionArea.body_entered.connect(_open_door)
	detectionArea.body_exited.connect(_close_door)

func _open_door(area):
	print("entered");
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
