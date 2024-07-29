class_name AlreadyHasTargetPosition extends ConditionLeaf


func tick(actor, blackboard: Blackboard):
	if actor.body_controller.has_next_target_position():
		print("has position already, not moving")		
		return FAILURE
	else:
		print("does not have position. moving")		
		return SUCCESS

