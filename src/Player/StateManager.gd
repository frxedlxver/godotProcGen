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
	connectStateSignals()
	
func connectStateSignals():
	inputHandler.dirInputChanged.connect(
		func (dirInput : Vector2i):
			var state = IdleState.new() if dirInput == Vector2i.ZERO else MoveState.new()
			setState(state)
	)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func setState(state : State):
	var enterargs = 0
	var exitargs = 0

	if state.statename == "move":
		enterargs = inputHandler.dirInput
	if state == curState: return
	state.exit(exitargs)	
	onStateExit.emit(curState)
	curState = state
	state.enter(enterargs)
	onStateEnter.emit(state)

