extends TileMap

var selectedTile = Vector2i(0,0);
var selectedBlock = null

var selectionLayer = 2
var placeLayer = 1
var gridLayer = 0


func _ready():
	for c in get_used_cells(0):
		set_cell(placeLayer, c, 4, Vector2i(0,0), 0)
	


func _process(_delta):
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
			


func pickupBlock(block, pos):
	selectedBlock = block
	if get_cell_tile_data(gridLayer, selectedTile):
		writeBlock(selectedBlock, selectedTile - pos, false)


func placeBlock():
	if (get_cell_tile_data(gridLayer, selectedTile)):
		if !canBlockBePlaced(selectedBlock, selectedTile):
			return false
		else: 
			writeBlock(selectedBlock, selectedTile, true)
			selectedBlock.position = map_to_local(selectedTile)
	selectedBlock = null
	return true


func canBlockBePlaced(block, pos):
	var usedCells = block.small.get_node("TileMap").get_used_cells(0)
	for c in usedCells:
		var newPos = pos + c
		var tileData = get_cell_tile_data(placeLayer, newPos)
		if tileData == null or tileData.get_custom_data("Written") or !tileData.get_custom_data("Writable"):
			return false
	return true


func writeBlock(block, pos, place):
	var usedCells = block.small.get_node("TileMap").get_used_cells(0)
	var newBlock = 5 if place else 4
	for c in usedCells:
		var newPos = pos + c
		set_cell(placeLayer, newPos, newBlock, Vector2i(0,0), 0)

