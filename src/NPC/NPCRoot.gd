class_name NPCRoot extends CharacterBody2D

@onready var body_controller : NPCBodyController = get_node("NPCBodyController")
@onready var animation_controller : NPCAnimationController = get_node("NPCAnimationController")
@onready var npc_data : NPCData = get_node("NPCData")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func move_to(new_position : Vector2):
	body_controller.target_position = new_position

func stop_moving():
	body_controller.target_position = self.position

func is_moving():
	return body_controller.is_moving()
	
func is_finished_navigating():
	return body_controller.is_finished_navigating()
	
func get_animation_direction_suffix(direction):
	var x : float = direction.x
	if x >= 0:
		return "_right"
	elif x < 0:
		return "_left"
