extends Sprite2D

var area : Area2D

var opacity_increment : float = 0.02
var player_inside : bool
# Called when the node enters the scene tree for the first time.
func _ready():
	area = get_node("Area2D")
	area.body_entered.connect(on_body_enter_building)
	area.body_exited.connect(on_body_exit_building)

func _process(delta):
	if player_inside && self_modulate.a > 0:
		self_modulate.a = clampf(self.self_modulate.a - (255 * opacity_increment * delta), 0, 1)
	elif !player_inside && self_modulate.a < 1:
		self_modulate.a = clampf(self_modulate.a + (255 * opacity_increment * delta), 0, 1)
		
func on_body_enter_building(body : Node2D):
	print(body.name + "entered cabin")
	if body.name == "Player":
		player_inside = true
	
	
func on_body_exit_building(body : Node2D):
	print(body.name)
	if body.name == "Player":
		player_inside = false
