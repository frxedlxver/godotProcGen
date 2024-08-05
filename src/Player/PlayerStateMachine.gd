class_name StateMachine extends Node

var _state : State
var _states : Array[State]
signal state_exited(state: State)
signal state_entered(state: State)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
