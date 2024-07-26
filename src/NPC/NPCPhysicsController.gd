extends Node2D
class_name NPCBodyController

signal velocity_updated(velocity)

var max_speed : int = 200
var acceleration : int = 100
var target_position : Vector2
@onready var body = get_parent()
@onready var nav_agent : NPCNavigator = get_node("../NPCNavigator")

func _ready():
	get_node("../NPCStateManager").target_position_changed.connect(_set_target_position)

func _physics_process(delta):
	if not nav_agent.is_navigation_finished():
		var dir = nav_agent.dir_to_next_position()
		var new_velocity = nav_agent.velocity.lerp(dir * max_speed, acceleration * delta)
		body.move_and_collide(new_velocity * delta)
		emit_signal("velocity_updated", new_velocity)

func _set_target_position(point : Vector2):
	target_position = point
	
func _on_recalculate_timer_timeout():
	nav_agent.target_position = self.target_position
	
func _on_npc_navigator_velocity_computed(safe_velocity):
	body.velocity = safe_velocity
	velocity_updated.emit()
