extends NavigationAgent2D
class_name NPCNavigator

var parent : Node2D

func _ready():
	parent = get_parent()

func dir_to_next_position() -> Vector2:
	return (get_next_path_position() - parent.position).normalized()

