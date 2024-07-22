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
var target_position
var moving_towards_target : bool = false


var acceleration_coroutine : Callable
var navagent : NavigationAgent2D

func _ready():
	navagent = get_node("NavigationAgent2D")


func _physics_process(delta):
	navagent.target_position = get_global_mouse_position()
	target_position = navagent.get_next_path_position();
	var dir = (target_position - position).normalized()
	velocity = velocity.lerp(dir * max_speed, acceleration * delta)
	move_and_collide(velocity * delta)
