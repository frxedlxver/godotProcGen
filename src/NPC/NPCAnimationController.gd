extends Node2D
class_name NPCAnimationController

@onready var sprite = get_node("AnimatedSprite2D")
@onready var state_manager: NPCStateManager = get_node("../NPCStateManager")

func _ready():
	state_manager.state_changed.connect(_on_state_changed)

func _on_state_changed(state : State):
	var anim_name = state.name + _get_direction_suffix()
	sprite.animation = anim_name
	sprite.play()
	
func _get_direction_suffix():
	if state_manager.facing_right:
		return "_right"
	else:
		return "_left"
