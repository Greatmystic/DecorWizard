extends TileMap

@onready var selectedTile = Vector2i(0,0);

var selectedBlock = null;

var selectionLayer = 2
var placeLayer = 1


func _process(_delta):
	pass
	
	##get new selection
	var newSelectedTile = local_to_map(get_global_mouse_position())
	#
	if (selectedTile != newSelectedTile):
		
		#erase and replace old selection with new
		erase_cell(selectionLayer, selectedTile)
		selectedTile = newSelectedTile
		
		# write only if tile is writable
		if (get_cell_tile_data(0, selectedTile)):
			set_cell(selectionLayer, selectedTile, 2, Vector2i(0,0), 0)
	
	#if Input.is_action_just_pressed("Place"):
		#if (get_cell_tile_data(0, selectedTile)):
			#set_cell(placeLayer, selectedTile, 3, Vector2i(0,0), 0)
			

func pickupBlock(block):
	selectedBlock = block
	
func placeBlock():
	var newSelectedTile = local_to_map(get_global_mouse_position())
	if (get_cell_tile_data(0, selectedTile)):
		#if !canBlockBePlaced(selectedBlock, newSelectedTile):
			#return false
		selectedBlock.position = map_to_local(newSelectedTile)
	selectedBlock = null
	return true

func canBlockBePlaced(block, pos):
	#var usedCells = block.small.get_node("TileMap").get_used_cells(0)
	#for c in usedCells:
		#var newPos = pos + c
		#print(newPos)
		#var tileData = get_cell_tile_data(1, newPos)
		#if tileData.get_custom_data("Written") or !tileData.get_custom_data("Writable"):
			#return false
	return true
		
		
