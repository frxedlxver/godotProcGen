extends State
class_name MoveState

var direction : Vector2i
var facingDir : dir
enum dir {
	N,
	E,
	S,
	W
}

func _init():
	statename = "move"

func enter(args):
	direction = args
	setFacingDir()
	
func get_animation_name():
	var anim_name = "walk"
	match(facingDir):
		dir.N: anim_name += "_up"
		dir.E: anim_name += "_right"
		dir.S: anim_name += "_down"
		dir.W: anim_name += "_left"
		
	return anim_name
	
func setFacingDir():
	if direction.y < 0 : facingDir = dir.N;
	elif direction.y > 0 : facingDir = dir.S;
	elif direction.x > 0 : facingDir = dir.E;
	elif direction.x < 0 : facingDir = dir.W; 
