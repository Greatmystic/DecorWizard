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

func getClickedTile():
	var selectedTile = small.get_node("TileMap").local_to_map(get_global_mouse_position())
	var currentTile = small.get_node("TileMap").local_to_map(position)
	return selectedTile - currentTile
	

func _on_area_2d_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed and placable:
		if clicked == false and !level.selectedBlock:
			level.pickupBlock(self, getClickedTile())
			clicked = true
		else:
			
			if level.placeBlock():
				clicked = false


