extends Node2D
class_name NPCStateManager

var states = [IdleState.new(), MoveState.new()]
var current_state : State
var facing_right = true

signal state_changed(state : State, facing_right)
signal target_position_changed(point : Vector2)

var target_position : Vector2

func _ready():
	# Assuming PhysicsManager is a sibling or accessible via some node path
	var body_controller = get_node("../NPCBodyController")
	body_controller.velocity_updated.connect(_on_velocity_updated)
	set_state(states[0])
	
func _process(delta):
	_set_target_position(get_global_mouse_position())

func _set_target_position(point : Vector2):
	if (!target_position.is_equal_approx(point)):
		target_position = point
		target_position_changed.emit(target_position)
func _on_velocity_updated(velocity):
	if velocity.is_equal_approx(Vector2.ZERO):
		set_state(states[0])
	else:
		update_direction(velocity)
		set_state(states[1])

func update_direction(velocity):
	facing_right = velocity.x >= 0

func set_state(new_state: State):
	if current_state != new_state:
		current_state = new_state
		state_changed.emit(current_state, facing_right)
