extends Node2D
class_name AnimationController

var animatedSprite2D : AnimatedSprite2D

enum PlayerAnimation {
	IDLE,
	WALK_UP,
	WALK_DOWN,
	WALK_LEFT,
	WALK_RIGHT
}

var onStateEnter : Signal
func _ready():
	animatedSprite2D = get_node("../Sprite");
	onStateEnter = get_node("../StateManager").onStateEnter
	onStateEnter.connect(set_animation)

func set_animation(animation : PlayerAnimation):
	var anim_name;
	match (animation):
		PlayerAnimation.IDLE: anim_name = "idle"
		PlayerAnimation.WALK_UP: anim_name = "walk_up"
		PlayerAnimation.WALK_DOWN: anim_name = "walk_down"
		PlayerAnimation.WALK_LEFT: anim_name = "walk_left"
		PlayerAnimation.WALK_RIGHT: anim_name = "walk_right"
		
	animatedSprite2D.play(anim_name);
