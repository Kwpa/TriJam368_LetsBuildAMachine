extends TileMapLayer


var used_cells = []

var slow_fill = false

func _ready():
	used_cells = get_used_cells()


func check_if_connected()->bool:
	return false


func set_resource(tile, resource_id:int)->bool:
	return false


func flood_fill(mouse_pos, resource : int):
	var start_pos = mouse_pos
	var neighbors = [Vector2.RIGHT, Vector2.LEFT, Vector2.UP, Vector2.DOWN]
	var checked = []
	var queue = [start_pos]

	while queue.empty() == false:
		var current = queue.pop_back()
		checked.append(current)
		
		for n in neighbors:
			var next_tile = current + n
			if used_cells.has(next_tile) == false:
				continue	
			if checked.has(next_tile):
				continue
			if check_if_connected():
				continue
			if slow_fill == true:
				await get_tree().create_timer(0.07).timeout
			queue.append(next_tile)
			set_resource(next_tile, resource)
