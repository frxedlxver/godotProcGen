extends CharacterBody2D

class_name CharBodyController

@export var max_speed : int = 300
@export var acceleration : int = 100
var current_velocity : Vector2
var speed_multiplier : float = 1
var current_dir : Vector2
var current_dir_normalized : Vector2
var dir_speed_mod : float
var halt_stale_coroutines = false
var moving_towards_target : bool = false
var facing_right : bool
var sprite : AnimatedSprite2D 

var navagent : NPCNavigator
var target_node : Node2D

func _ready():
	navagent = get_node("NPCNavigator")
	sprite = get_node("AnimatedSprite2D")


func _physics_process(delta):
	_recalc_path()
	if navagent.is_navigation_finished():
		return
	var dir = navagent.dir_to_next_position()
	navagent.velocity = velocity.lerp(dir * max_speed, acceleration * delta)
	move_and_collide(velocity * delta)

func _process(delta):
	update_sprite()
func update_sprite():
	var anim_name : String
	if velocity.is_equal_approx(Vector2.ZERO):
		anim_name = "idle"
	else:
		anim_name = "move"
	
	if facing_right:
		anim_name += "_right"
	else:
		anim_name += "_left"
	sprite.animation = anim_name
	sprite.play()

func _recalc_path():
	if target_node:
		navagent.target_position = target_node.position
	else:
		navagent.target_position = get_global_mouse_position()


func _on_recalculate_timer_timeout():
	_recalc_path()

func _set_target(node : Node2D):
	target_node = node
	_recalc_path()
	
func _on_npc_navigator_velocity_computed(safe_velocity):
	velocity = safe_velocity
	if !velocity.is_equal_approx(Vector2.ZERO):
		facing_right = velocity.x >= 0;
