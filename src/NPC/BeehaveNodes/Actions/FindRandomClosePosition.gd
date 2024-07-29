class_name FindValidClosePosition extends ActionLeaf

@onready var query_params : PhysicsPointQueryParameters2D = PhysicsPointQueryParameters2D.new()

func tick(actor, blackboard: Blackboard):
	var cur_pos = actor.global_position
	var random_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	var move_amount = (actor.npc_data.move_range * random_direction)
	var target_pos = cur_pos + move_amount
	if position_is_valid(actor.get_world_2d(), target_pos):
		blackboard.set_value("target_pos", target_pos)
		return SUCCESS
	else:
		return RUNNING

func position_is_valid(world, position):
	return is_position_free(world, position)

func is_position_free(world, position: Vector2) -> bool:
	var space_state = world.direct_space_state
	query_params.position = position
	var result = space_state.intersect_point(query_params, 1)
	return result.is_empty()
