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
	
func setFacingDir():
	if direction.y < 0 : facingDir = dir.N;
	elif direction.y > 0 : facingDir = dir.S;
	elif direction.x > 0 : facingDir = dir.E;
	elif direction.x < 0 : facingDir = dir.W; 
