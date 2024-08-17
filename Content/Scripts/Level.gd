extends TileMap

var selectedTile
var selectionLayer = 2

func _ready():
	
	selectedTile = Vector2i(0,0);
	
	
	
func _process(_delta):
	
	#get new selection
	var newSelectedTile = local_to_map(get_global_mouse_position())
	
	if (selectedTile != newSelectedTile):
		
		#erase and replace old selection with new
		erase_cell(selectionLayer, selectedTile)
		selectedTile = newSelectedTile
		
		# write only if tile is writable
		if (get_cell_tile_data(0, selectedTile)):
			set_cell(selectionLayer, selectedTile, 2, Vector2i(0,0), 0)

