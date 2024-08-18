extends Node2D

@onready var level = $"../../TileMap"
@onready var small = $Small
@onready var big = $Big

var clicked = false
var placable = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if clicked:
		position = get_global_mouse_position()


func _on_area_2d_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed and placable:
		#if clicked == false:
			#level.pickupBlock(self)
			#clicked = true
		#else:
			#if level.placeBlock():
				#clicked = true
		if clicked == false:
			level.pickupBlock(self)
		else:
			level.placeBlock()
		clicked = !clicked


