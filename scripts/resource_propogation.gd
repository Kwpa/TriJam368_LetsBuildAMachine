extends TileMapLayer

var electricity_generators : Array[Vector2i] = []
var water_generators : Array[Vector2i] = []
var nutrient_generators : Array[Vector2i] = []
var water_dispenser : Array[Vector2i] = []
var nutrient_dispenser : Array[Vector2i] = []
var light_dispenser : Array[Vector2i] = []



var store_dictionary 

var used_cells = []

var slow_fill = false

func _ready():
	pass


func check_tile_has_resource(tile : Vector2i, resource : Constants.resource):
	


func propogate_resources():
	used_cells = get_used_cells()
	
	#connect generators
	find_generators()
	for tile in electricity_generators:
		flood_fill(tile, Constants.resource.electricity)
	for tile in water_generators:
		if check_tile_has_resource(tile, Constants.resource.electricity):
			flood_fill(tile, Constants.resource.water)
	for tile in nutrient_generators:
		if check_tile_has_resource(tile, Constants.resource.electricity):
			flood_fill(tile, Constants.resource.nutrients)
	


	# then dispense resources 



func check_if_connected()->bool:
	return false


func set_resource(tile, resource_id:int)->bool:
	return false

func find_generators():
	electricity_generators.clear()
	water_generators.clear()
	light_generators.clear()
	
	for tile in used_cells:
		if get_cell_tile_data(tile).get_custom_data("card_id") == 10:
			generators.append(tile)


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
