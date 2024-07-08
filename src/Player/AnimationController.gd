extends Node
class_name AnimationController

var animatedSprite2D : AnimatedSprite2D

enum PlayerAnimation {
	IDLE,
	WALK_UP,
	WALK_DOWN,
	WALK_LEFT,
	WALK_RIGHT
}

var walkDirectionAnimations : Dictionary = {
	MoveState.dir.N : "walk_up",
	MoveState.dir.E : "walk_right",
	MoveState.dir.S : "walk_down",
	MoveState.dir.W : "walk_left"
}

var idleDirectionAnimations : Dictionary = {
	MoveState.dir.N : "idle",
	MoveState.dir.E : "idle",
	MoveState.dir.S : "idle",
	MoveState.dir.W : "idle"
}

var dirSuffixes : Dictionary = {
	MoveState.dir.N : "_up",
	MoveState.dir.E : "_right",
	MoveState.dir.S : "_down",
	MoveState.dir.W : "_left"
}

func _ready():
	animatedSprite2D = get_node("../Sprite");
	var stateManager = get_node("../StateManager")
	stateManager.onStateEnter.connect(onStateEntered)
		

	
func onStateEntered(state : State):
	var animationName
	match state.statename:
		"move":
			var moveState : MoveState = state;
			animationName = "walk" + dirSuffixes.get(moveState.facingDir)
		"idle":
			animationName = "idle";
		_:
			animationName = "idle"
	animatedSprite2D.play(animationName);
