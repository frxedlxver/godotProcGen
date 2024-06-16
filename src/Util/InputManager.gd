extends Node2D

var mapGenerator : MapGenerator
func _ready():
	mapGenerator = get_node("../MapGenerator")
# Called every frame. 'delta' is the elapsed time since the previous frame.

func _unhandled_key_input(event):
	var kevent : InputEventKey = event
	if kevent.keycode == KEY_R and kevent.is_pressed():
		mapGenerator.generate_and_instantiate(512)
		
