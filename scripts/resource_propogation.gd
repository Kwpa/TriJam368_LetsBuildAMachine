extends Node2D


@onready var layer : TileMapLayer = $tile_map
@onready var resource_icon_layer : Node2D = $resource_icon_layer

# keep an uptodate list of generators and dispensers
var electricity_generators : Array[Vector2i] = []
var water_generators : Array[Vector2i] = []
var nutrient_generators : Array[Vector2i] = []
var water_dispenser : Array[Vector2i] = []
var nutrient_dispenser : Array[Vector2i] = []
var light_dispenser : Array[Vector2i] = []

# cells that are being used in the tilemaplayer
var used_cells = []

# array of tiles, storing the boardstate here
var current_active_tiles : Dictionary = {}
var queued_active_tiles : Dictionary = {}

var slow_fill = false


func _ready():
	SignalBus.connect("propogate_resources", propogate_resources)
	create_blank_grid()
	update_grid()
	create_initial_resource_tile_icons()


func create_blank_grid():
	for j in 5:
		for i in 5:
			var coords = Vector2i(i,j)
			var inst_tile_data = InstantiatedTileData.new()
			inst_tile_data.coords = coords 
			queued_active_tiles[coords] = inst_tile_data


func update_grid():
	current_active_tiles = queued_active_tiles


func check_tile_has_resource(tile_coordinates : Vector2i, resource : Constants.resource):
	return queued_active_tiles[tile_coordinates].has_resource(resource
)


func create_initial_resource_tile_icons():
	resource_icon_layer.create_icons(current_active_tiles)


func propogate_resources():
	create_blank_grid()
	used_cells = layer.get_used_cells()
	
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
	
	# then dispense resources ?
	#
	#
	
	# now update the grid
	update_grid()
	
	# now update resource icon layer 
	resource_icon_layer.update_resource_icons(current_active_tiles)
	
	print_debug("stop")
	
	


func check_if_connected(start_tile : Vector2i, other_tile : Vector2i)->bool:
	return layer.check_if_tile_is_colliding(1, start_tile, other_tile)


func set_resource(tile_coords, resource_id:int):
	queued_active_tiles[tile_coords].resources.append(resource_id)
	return false


func find_generators():
	electricity_generators.clear()
	water_generators.clear()
	nutrient_generators.clear()
	
	for tile in used_cells:
		var tile_data = layer.get_cell_tile_data(tile)
		if tile_data != null:
			
			var card_id = tile_data.get_custom_data("card_id")
			
			#try to update this to use the CardData.resource property
			match card_id:
				10:
					electricity_generators.append(tile)
				6:
					water_generators.append(tile)
				7:
					nutrient_generators.append(tile)
				8:
					nutrient_generators.append(tile)

func flood_fill(start_pos, resource : int):
	
	# set resource on the generator
	
	set_resource(start_pos,resource)
	
	var neighbors = [Vector2i.RIGHT, Vector2i.LEFT, Vector2i.UP, Vector2i.DOWN]
	var checked = []
	var queue = [start_pos]
	
	while queue.is_empty() == false:
		var current = queue.pop_back()
		checked.append(current)
		
		for n in neighbors:
			var next_tile = current + n
			if used_cells.has(next_tile) == false:
				continue	
			if checked.has(next_tile):
				continue
			if check_if_connected(current, next_tile) == false:
				continue
			if slow_fill == true:
				await get_tree().create_timer(0.07).timeout
			
			if electricity_generators.has(next_tile):
				continue
			if water_generators.has(next_tile) and resource == Constants.resource.nutrients:
				continue
			if nutrient_generators.has(next_tile) and resource == Constants.resource.water:
				continue
			else:
				#works OK except for if you add the generator later?
				queue.append(next_tile)
				set_resource(next_tile, resource)
