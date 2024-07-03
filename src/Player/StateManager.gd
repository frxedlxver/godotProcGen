extends Node
class_name StateManager

var states : Array[State]
var curState : State
var inputHandler : InputHandler

signal onStateExit(state : State)
signal onStateEnter(state : State)

# Called when the node enters the scene tree for the first time.
func _ready():
	setState(IdleState.new())
	inputHandler = get_node("../InputHandler")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func setState(state : State):
	if state == curState: return
	onStateExit.emit(curState)
	curState = state
	onStateEnter.emit(state)

