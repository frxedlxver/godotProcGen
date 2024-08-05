extends ActionLeaf

class_name MoveTo

var new_target : Vector2
var npcRoot : NPCRoot
var direction_anim_suffix : String
var started_nav : bool = false

func before_run(actor, blackboard: Blackboard):
	new_target = blackboard.get_value("target_pos", Vector2.ZERO)
	var direction = (new_target - actor.global_position).normalized()
	direction_anim_suffix = actor.get_animation_direction_suffix(direction)
	var anim_name = "move" + direction_anim_suffix
	print("Playing animation:", anim_name)
	actor.animation_controller.sprite.animation = anim_name
	actor.animation_controller.sprite.play(anim_name)
	actor.move_to(new_target)
	started_nav = false

## Executes this node and returns a status code.
## This method must be overwritten.
func tick(actor, blackboard: Blackboard) -> int:
	if started_nav:
		if actor.body_controller.finished_navigating:
			return SUCCESS
		else:
			return RUNNING
	else:
		started_nav = true
		return RUNNING

## Called after the last time it ticks and returns
## [code]SUCCESS[/code] or [code]FAILURE[/code].
func after_run(actor: Node, blackboard: Blackboard) -> void:
	blackboard.erase_value("target_pos")
	var new_anim_name = "idle" + direction_anim_suffix
	print("Setting idle animation:", new_anim_name)
	actor.animation_controller.sprite.animation = new_anim_name
