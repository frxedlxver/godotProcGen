extends Camera2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _unhandled_key_input(event):
	
	if event.keycode == KEY_UP:
		self.offset.y -= 100 / self.zoom.y
	elif event.keycode == KEY_DOWN:
		self.offset.y += 100 / self.zoom.y
	elif event.keycode == KEY_LEFT:
		self.offset.x -= 100 / self.zoom.x
	elif event.keycode == KEY_RIGHT:
		self.offset.x += 100 / self.zoom.x
	elif event.keycode == KEY_W:
		self.zoom *= 1.5
	elif event.keycode == KEY_S:
		self.zoom /= 1.5
