extends NavigationAgent2D
class_name NPCNavigator

@onready var parent : CharacterBody2D = get_parent()
var next_position_is_queued : bool
var next_target_position : Vector2 :
	set(value):
		if timer.is_stopped():
			timer.start()
		next_position_is_queued = true
		_next_target_position_internal = value
	get:
		return _next_target_position_internal
var _next_target_position_internal : Vector2
var position_last_timeout : Vector2
@onready var timer : Timer = get_node("path_recalculation_timer")

# used to check for nav timeout (if stuck, stop trying to move to target)
var ticks_at_position_until_timeout : int = 0
var cur_ticks : int = 0

func dir_to_next_position() -> Vector2:
	return (get_next_path_position() - parent.position).normalized()

func _on_recalculation_timer_timeout():
	if (next_position_is_queued):
		target_position = next_target_position
		next_position_is_queued = false
	#if stuck, increment timer or stop navigating if timeout reached
	elif position_last_timeout.is_equal_approx(parent.global_position):
		cur_ticks += 1
		if cur_ticks >= ticks_at_position_until_timeout:
			cur_ticks = 0
			target_reached.emit()
			timer.stop()
	else:
		position_last_timeout = parent.global_position


