class_name NPCBodyController extends Node2D


var dir : Vector2
var velocity : Vector2
@onready var nav_agent : NPCNavigator = get_node("../NPCNavigator")
@onready var npc_data : NPCData = get_node("../NPCData")
@onready var parent : NPCRoot = get_parent()
var position_last_timeout : Vector2
var finished_navigating : bool = false

var target_position : Vector2 :
	get:
		return nav_agent.next_target_position
	set(value):
		_recalculate_path(value)


func _ready():
	nav_agent.target_reached.connect(_on_npc_navigator_target_reached)
func _physics_process(delta):
	if not nav_agent.is_navigation_finished():
		self._update_cached_direction()
		nav_agent.velocity = nav_agent.velocity.lerp(dir * npc_data.move_speed * delta, npc_data.acceleration * delta)
		
func _recalculate_path(new_position):
	finished_navigating = false
	nav_agent.next_target_position = new_position
	
func _on_npc_navigator_velocity_computed(safe_velocity):
	parent.velocity = safe_velocity
	self.velocity = safe_velocity
	parent.move_and_collide(safe_velocity)

func _on_npc_navigator_target_reached():
	finished_navigating = true
	print("finished")
	
func _update_cached_direction():
	var facing = get_direction_string()
	dir = nav_agent.dir_to_next_position()

func is_moving() -> bool:
	return !self.velocity.is_equal_approx(Vector2.ZERO)

func is_finished_navigating():
	return nav_agent.target_reached
	
func get_direction_string() -> String:
	if dir.x >= 0:
		return "right"
	else:
		return "left"

func get_target_position():
	return nav_agent.next_target_position
	
func has_next_target_position():
	return !nav_agent.is_navigation_finished()
