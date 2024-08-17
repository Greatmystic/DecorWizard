extends TileMap

var GridSize = 4
var Dic = {}

func _ready():
	for x in GridSize:
		for y in GridSize:
			Dic[str(Vector2(x,y))] ={
			"Type" : "Grass"
			}
			set_cell(0, Vector2(x, y), 0, Vector2i(0,0), 0)
			
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var tile = local_to_map(get_global_mouse_position())
	
	for x in GridSize:
		for y in GridSize:
			erase_cell(1, Vector2(x, y))
			
		if Dic.has(str(tile)):
			set_cell(1, tile, 1, Vector2i(0,0), 0)
