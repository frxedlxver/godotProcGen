extends Node
class_name AnimalStateManager

var cur_state : State

signal state_entered(state : State)
signal state_exited(state : State)

func _process(delta):
	cur_state.process_state(delta)

func setState(state : State):
	if state == cur_state: return
	
	var enterargs = 0
	var exitargs = 0

	state.exit(exitargs)
	state_exited.emit(cur_state)
	cur_state = state
	state.enter(enterargs)
	state_entered.emit(state)
