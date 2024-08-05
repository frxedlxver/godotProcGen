class_name Player extends CharacterBody2D

#members
var facing_dir : Vector2 :
	set(value):
		facing_dir_changed.emit(facing_dir)
		

#signals


signal facing_dir_changed(facing_dir : Vector2)

func _ready():
	self.facing_dir = Direction.NORTH
	print(self.facing_dir)
