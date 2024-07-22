extends Node
class_name PhysicsController

var body : CharacterBody2D
var cur_state : State
var move_force = 300

func _ready():
	body = get_node("../../PlayerRoot")
	var state_manager : StateManager = get_node("../StateManager")
	state_manager.onStateEnter.connect(onStateEntered)
	
func _physics_process(delta):
	var new_move_force = Vector2.ZERO
	if cur_state != null:
		match cur_state.statename:
			"move":
				var move_state : MoveState = cur_state
				var dir = Vector2(move_state.direction)
				if move_state.direction.x != 0 and move_state.direction.y != 0:
					new_move_force = move_force * 0.7071 * dir
				else:
					new_move_force = move_force * dir
			"idle":
				new_move_force = Vector2.ZERO
				
	body.velocity = new_move_force;
	var collision = body.move_and_collide(new_move_force * delta)
	
	if collision != null:
		handle_collision(collision)

func handle_collision(collision):
	pass

func onStateEntered(state : State):
	cur_state = state
	print("Phys: " + state.statename)
