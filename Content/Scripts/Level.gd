extends TileMap

@onready var blocks = $"../Blocks"
@onready var bigQuotaLabel = $"../Decor/CanvasLayer/Quota/BigQuota"
@onready var smallQuotaLabel = $"../Decor/CanvasLayer/Quota/SmallQuota"
@onready var winLabel = $"../Decor/CanvasLayer/Win"

var selectedTile = Vector2i(0,0);
var selectedBlock = null
var selectedBlockGrid = Array()
var canBlockBePlacedVar = false

var selectionLayer = 2
var placeLayer = 1
var gridLayer = 0

var bigQuota = 0
var smallQuota = 0
var totalBlocks = 0
var blocksPlaced = 0


func _ready():
	totalBlocks = blocks.get_child_count()
	
	for c in get_used_cells(0):
		set_cell(placeLayer, c, 4, Vector2i(0,0), 0)
	
	for b in blocks.get_children():
		if b.isBig:
			bigQuota += 1
		else:
			smallQuota += 1
	updateQuotas()
	winLabel.visible = false


func _process(_delta):
	
	var newSelectedTile = local_to_map(get_global_mouse_position())
	if (selectedTile != newSelectedTile):
		selectedTile = newSelectedTile
		updateSelectionPlacement()
		
		
	if Input.is_action_just_pressed("ScaleSpell") and selectedBlock:
		selectedBlock.flipScale()
		updateQuotas()
		updateSelectionPlacement()
	
	
	
func updateSelectionPlacement():
	##get new selection
		#erase and replace old selection with new
		for c in selectedBlockGrid:
			erase_cell(selectionLayer, c)
		
		# write only if tile is writable
		if (get_cell_tile_data(0, selectedTile) and selectedBlock):
			showBlockPlacement(selectedBlock, selectedTile, selectedBlock.rotation_degrees, selectedBlock.isBig)
		
	
func showBlockPlacement(block, pos, rotatio, isBig):
	setBlockGrid(pos, rotatio, isBig)
	canBlockBePlacedVar = canBlockBePlaced(block, pos, rotatio, isBig)
	var newBlock = 5 if canBlockBePlacedVar else 6
	for c in selectedBlockGrid:
		if get_cell_tile_data(0, pos):
			set_cell(selectionLayer, c, newBlock, Vector2i(0,0), 0)
	
	
func pickupBlock(block, pos, rotatio, isBig):
	selectedBlock = block
	if get_cell_tile_data(gridLayer, selectedTile):
		writeBlock(selectedBlock, selectedTile - pos, false, rotatio, isBig)
		selectedBlock.placedInGrid = false
		blocksPlaced -= 1


func placeBlock(rotatio, isBig):
	if (get_cell_tile_data(gridLayer, selectedTile)):
		if !canBlockBePlacedVar:
			return false
		else: 
			writeBlock(selectedBlock, selectedTile, true, rotatio, isBig)
			selectedBlock.position = map_to_local(selectedTile)
			selectedBlock.placedInGrid = true
			blocksPlaced += 1
			
			if blocksPlaced == totalBlocks and bigQuota == smallQuota:
				winLevel()
				
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

func setBlockGrid(pos, rotatio, isBig):
	if selectedBlock:
		var blockTilemap = selectedBlock.big.get_node("TileMap") if isBig else selectedBlock.small.get_node("TileMap")
		selectedBlockGrid = Array()
		for c in getUsedCells(blockTilemap, rotatio):
			selectedBlockGrid.append(pos + c)

func updateQuotas():
	bigQuotaLabel.text = str(bigQuota)
	smallQuotaLabel.text = str(smallQuota)


func winLevel():
	winLabel.visible = true
