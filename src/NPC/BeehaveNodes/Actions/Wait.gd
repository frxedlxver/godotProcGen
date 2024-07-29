extends ActionLeaf

var tick_limit = 100
var cur_ticks = 0
var moved = true
func tick(actor, blackboard: Blackboard):
	if cur_ticks < tick_limit:
		cur_ticks += 1
		if(cur_ticks % 10 == 0):
			print(cur_ticks)
		return RUNNING
	else:
		moved = true
		cur_ticks = 0
		return SUCCESS

