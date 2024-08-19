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
		
	if Input.is_action_just_pressed("ScaleSpell") and selectedBlock:
		selectedBlock.flipScale()


func pickupBlock(block, pos, rotatio, isBig):
	selectedBlock = block
	if get_cell_tile_data(gridLayer, selectedTile):
		writeBlock(selectedBlock, selectedTile - pos, false, rotatio, isBig)


func placeBlock(rotatio, isBig):
	if (get_cell_tile_data(gridLayer, selectedTile)):
		if !canBlockBePlaced(selectedBlock, selectedTile, rotatio,isBig):
			return false
		else: 
			writeBlock(selectedBlock, selectedTile, true, rotatio, isBig)
			selectedBlock.position = map_to_local(selectedTile)
	selectedBlock = null
	return true


func canBlockBePlaced(block, pos, rotatio, isBig):
	var blockTilemap = block.big.get_node("TileMap") if isBig else block.small.get_node("TileMap")
	var usedCells = getUsedCells(blockTilemap, rotatio)
	for c in usedCells:
		var newPos = pos + c
		var tileData = get_cell_tile_data(placeLayer, newPos)
		if tileData == null or tileData.get_custom_data("Written") or !tileData.get_custom_data("Writable"):
			return false
	return true


func writeBlock(block, pos, place, rotatio, isBig):
	var blockTilemap = block.big.get_node("TileMap") if isBig else block.small.get_node("TileMap")
	var usedCells = getUsedCells(blockTilemap, rotatio)
	var newBlock = 5 if place else 4
	for c in usedCells:
		var newPos = pos + c
		set_cell(placeLayer, newPos, newBlock, Vector2i(0,0), 0)
		
		
func getUsedCells(tilemap, rotatio:int):
	var usedCells = tilemap.get_used_cells(0)
	var currentRotation = rotatio % 360
	var res = Array()
	if currentRotation != 0:
		for c in usedCells:
			match (currentRotation):
				90:
					res.append(Vector2i(-c.y, c.x))
				180:
					res.append(Vector2i(-c.x, -c.y))
				270:
					res.append(Vector2i(c.y, -c.x))
		return res
	return usedCells
	
