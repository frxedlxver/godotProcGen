extends Node
class_name AnimationController

var animatedSprite2D : AnimatedSprite2D

func _ready():
	animatedSprite2D = get_node("../Sprite");
	var stateManager = get_node("../StateManager")
	stateManager.state_entered.connect(state_entereded)

func state_entereded(state : State):
	var animationName = state.get_animation_name()
	animatedSprite2D.play(animationName);
