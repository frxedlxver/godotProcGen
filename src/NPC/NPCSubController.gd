extends Node2D
class_name NPCSubController
# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("../StateManager").onStateEnter.connect(on_state_entered)

func on_state_entered(state : State):
	pass
