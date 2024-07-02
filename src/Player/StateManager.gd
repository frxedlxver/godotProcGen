extends Node2D
class_name StateManager

enum State {
	IDLE,
	WALK_UP,
	WALK_DOWN,
	WALK_LEFT,
	WALK_RIGHT
}

var up_pressed : bool
var down_pressed : bool
var left_pressed : bool
var right_pressed : bool

signal onStateEnter(state : State)
signal onStateExit(state: State)

var curState : State

func _ready():
	setState(State.IDLE)
	
func _input(event):
	var ievent : InputEvent = event
	
	pollInput(event)
	
	if up_pressed: setState(State.WALK_UP)
	elif down_pressed: setState(State.WALK_DOWN)
	elif left_pressed: setState(State.WALK_LEFT)
	elif right_pressed:setState(State.WALK_RIGHT)
	else: setState(State.IDLE)
	

func pollInput(event : InputEvent):
	var state = false
	
	# todo: change to vector
	if event.is_pressed(): state = true
	if event.is_released(): state = false
	if event.is_action("walk_up"): up_pressed = state;
	if event.is_action("walk_down"): down_pressed = state;
	if event.is_action("walk_left"): left_pressed = state;
	if event.is_action("walk_right"): right_pressed = state;
	
func setState(state : State):
	if state == curState: return
	onStateExit.emit(curState)
	curState = state
	onStateEnter.emit(state)
