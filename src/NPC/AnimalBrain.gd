extends Node

# processes input and makes decisions
class_name AnimalBrain

var mood : String = "neutral"
var target_position : Vector2;
var target_object : Node2D;

var knowledge : Dictionary = {
	"threat_detected" : false,
	"threat_body" : null,
	"food_detected" : false,
	"food_bodies" : [],
	"desire_type" : null,
	"desire_info" : {}
}

# Called when the node enters the scene tree for the first time.
func _ready():
	var awareness_area : Area2D = get_node("../AwarenessArea");
	awareness_area.body_entered.connect(on_became_aware_of_body)
	awareness_area.body_exited.connect(on_body_left_awareness_area)
	pass # Replace with function body.

func on_became_aware_of_body(body : Node2D):
	if (body.name == "Player"):
		knowledge["threat_detected"] = true
		knowledge["threat_body"] = body

func on_body_left_awareness_area(body : Node2D):
	if (body.name == "Player"):
		knowledge["threat_detected"] = false
		knowledge["threat_body"] = null

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match(mood):
		"neutral":
			process_neutral_state()
		"alert":
			process_alert_state()
	process_always()

	print("bunny is feeling " + mood)
	
func process_alert_state():
	#determine and set action state
	pass

func process_neutral_state():
	#determine and set action state
	match(knowledge["desire_type"]):
		"eat":
			# move towards target_object if too far to eat. Otherwise start eating
			pass
		_:
			#set state idle
			pass
	pass

func process_always():
	pass
