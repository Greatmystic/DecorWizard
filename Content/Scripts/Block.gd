extends Node2D

@onready var level = $"../../TileMap"
@onready var small = $Small
@onready var big = $Big

var clicked = false
var isBig = false
var placedInGrid = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if clicked:
		position = get_global_mouse_position()

func getClickedTile():
	var selectedTile = small.get_node("TileMap").local_to_map(get_global_mouse_position())
	var currentTile = small.get_node("TileMap").local_to_map(position)
	return selectedTile - currentTile

func flipScale():
	isBig = !isBig
	big.visible = isBig
	small.visible = !isBig
	
	if isBig:
		level.bigQuota += 1
		level.smallQuota -= 1
	else:
		level.bigQuota -= 1
		level.smallQuota += 1



func _on_area_2d_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if clicked == false and !level.selectedBlock:
			level.pickupBlock(self, getClickedTile(), rotation_degrees, isBig)
			clicked = true
		else:
			if level.placeBlock(rotation_degrees, isBig):
				clicked = false
				
	if clicked and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		rotation_degrees += 90
		


