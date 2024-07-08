extends Node
class_name InputHandler

var dirInput : Vector2i;
signal dirInputChanged(value : Vector2i)

func _ready():
	pass
	
func _process(delta):
	pollInput()

func pollInput():
	var new_dirInput = Vector2i(
		Input.get_action_strength("walk_right") - Input.get_action_strength("walk_left"),
		(Input.get_action_strength("walk_up") - Input.get_action_strength("walk_down")) * - 1
	)
	if new_dirInput != dirInput:
		self.dirInput = new_dirInput
		dirInputChanged.emit(self.dirInput)
		
