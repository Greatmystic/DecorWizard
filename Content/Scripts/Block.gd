extends Node2D

@onready var small = $Small
@onready var big = $Big

var clicked = false
var placable = true
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if clicked:
		position = get_global_mouse_position()


func _on_area_2d_input_event(viewport, event, shape_idx):
	print("OKAY")
	if event is InputEventMouseButton and event.pressed and placable:
		clicked = !clicked

