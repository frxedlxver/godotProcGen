extends Node
class_name InputHandler

var dirInput : Vector2;

func _ready():
	pass
	
func _process(delta):
	pollInput()

func pollInput():
	self.dirInput = Vector2(
		Input.get_action_strength("walk_right") - Input.get_action_strength("walk_left"),
		Input.get_action_strength("walk_up") - Input.get_action_strength("walk_down")
	)
