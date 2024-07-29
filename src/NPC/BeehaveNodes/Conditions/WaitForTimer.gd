class_name WaitForTimer extends ConditionLeaf

var cur_ticks : int
var tick_limit : int
func before_run(actor, blackboard : Blackboard):
	tick_limit = blackboard.get_value("tick_limit")
	
func tick(actor, blackboard: Blackboard):
	if(cur_ticks > tick_limit):
		return SUCCESS
		print("reached_limit")
	else:
		cur_ticks += 1
		if cur_ticks % 10 == 0: print(cur_ticks)
		return RUNNING
		
func after_run(actor, blackboard: Blackboard):
	blackboard.erase_value("tick_limit")
	cur_ticks = 0	
