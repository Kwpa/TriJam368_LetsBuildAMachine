extends Node2D


@onready var layer : TileMapLayer = $tile_map
@onready var resource_icon_layer : Node2D = $resource_icon_layer

# keep an uptodate list of generators and dispensers
var electricity_generators : Array[Vector2i] = []
var water_generators : Array[Vector2i] = []
var nutrient_generators : Array[Vector2i] = []
var sprinklers : Array[Vector2i] = []
var lamps : Array[Vector2i] = []
var plants : Array[Vector2i] = []

# cells that are being used in the tilemaplayer
var used_cells = []

# array of tiles, storing the boardstate here
var current_active_tiles : Dictionary = {}
var queued_active_tiles : Dictionary = {}

var current_active_dispensed_tiles : Dictionary = {}
var queued_active_dispensed_tiles : Dictionary = {}

var prev_dispensed_state_array : Array[InstantiatedTileData]
var current_dispensed_state_array : Array[InstantiatedTileData]

var slow_fill = false


func _ready():
	SignalBus.connect("propogate_resources", propogate_resources)
	SignalBus.connect("grow_plant", on_plant_grow)
	create_blank_grid()
	update_grid()
	create_initial_resource_tile_icons()


func get_plant_by_id(plant_id: int) -> Vector2i:
	return plants[plant_id]

func on_plant_grow(plant_id: int):
	var plant_location = get_plant_by_id(plant_id)
	var plant_grow_location = plant_location + Vector2i.UP
	plants.append(plant_grow_location)

func create_blank_grid():
	for j in 5:
		for i in 5:
			var coords = Vector2i(i,j)
			var inst_tile_data = InstantiatedTileData.new()
			inst_tile_data.coords = coords
			queued_active_tiles[coords] = inst_tile_data
			var inst_tile_data_dispensed = InstantiatedTileData.new()
			inst_tile_data_dispensed.coords = coords
			queued_active_dispensed_tiles[coords] = inst_tile_data_dispensed


func update_grid():
	current_active_tiles = queued_active_tiles
	current_active_dispensed_tiles = queued_active_dispensed_tiles


func check_tile_has_resource(tile_coordinates : Vector2i, resource : Constants.resource):
	return queued_active_tiles[tile_coordinates].has_resource(resource)
	

func check_tile_has_dispensed_resource(tile_coordinates : Vector2i, resource : Constants.resource):
	return queued_active_dispensed_tiles[tile_coordinates].has_resource(resource)


func create_initial_resource_tile_icons():
	resource_icon_layer.create_icons(current_active_tiles,current_active_dispensed_tiles)


func propogate_resources():
	#print_debug("propogating")
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
	
	find_dispensers()
	for tile in sprinklers:
		var nutrient_check = check_tile_has_resource(tile, Constants.resource.nutrients)
		var water_check = check_tile_has_resource(tile, Constants.resource.water)
		if nutrient_check:
			dispense_nutrients(tile)
		if water_check:
			dispense_water(tile)
		
	for tile in lamps:
		var electricity_check = check_tile_has_resource(tile, Constants.resource.electricity)
		if electricity_check:
			dispense_light(tile)
	
	## update visuals using info dispenser_layer
	
	prev_dispensed_state_array = current_dispensed_state_array
	current_dispensed_state_array = get_all_dispensed_resources()
	update_dispensed_layer()
	
	
	## plants
	for n in plants.size():
		SignalBus.reset_resource_inputs_on_plant.emit(n)
		if check_tile_has_resource(plants[n], Constants.resource.water):
			SignalBus.add_resource_input_to_plant.emit(n, "water", "add")
		if check_tile_has_resource(plants[n], Constants.resource.light):
			SignalBus.add_resource_input_to_plant.emit(n, "light", "add")
		if check_tile_has_resource(plants[n], Constants.resource.nutrients):
			SignalBus.add_resource_input_to_plant.emit(n, "fertilizer", "add")
		if check_tile_has_dispensed_resource(plants[n], Constants.resource.water):
			SignalBus.add_resource_input_to_plant.emit(n, "water", "add")
		if check_tile_has_dispensed_resource(plants[n], Constants.resource.light):
			SignalBus.add_resource_input_to_plant.emit(n, "light", "add")
		if check_tile_has_dispensed_resource(plants[n], Constants.resource.nutrients):
			SignalBus.add_resource_input_to_plant.emit(n, "fertilizer", "add")
		
	
	
	# now update the grid
	update_grid()
	
	# now update resource icon layer 
	resource_icon_layer.update_resource_icons(current_active_tiles, current_active_dispensed_tiles)
	#print_debug("stop")


func check_if_connected(start_tile : Vector2i, other_tile : Vector2i)->bool:
	return layer.check_if_tile_is_colliding(1, start_tile, other_tile)


func set_resource(tile_coords, resource_id:int):
	if queued_active_dispensed_tiles.has(tile_coords):
		queued_active_tiles[tile_coords].resources.append(resource_id)


func set_dispensed_resource(tile_coords, resource_id:int):
	if queued_active_dispensed_tiles.has(tile_coords):
		queued_active_dispensed_tiles[tile_coords].resources.append(resource_id)
		queued_active_dispensed_tiles[tile_coords].dispensed = true


func get_all_dispensed_resources() -> Array[InstantiatedTileData]:
	var array : Array[InstantiatedTileData]
	for instantiated_tile in queued_active_dispensed_tiles.values():
		if instantiated_tile.resources.size() > 0:
			array.append(instantiated_tile)
	return array


func update_dispensed_layer():
	SignalBus.emit_signal("update_dispenser_layer", current_dispensed_state_array)


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
				Constants.card_id.plant:
					if (!plants.has(tile)):
						plants.append(tile)


func find_dispensers():
	lamps.clear()
	sprinklers.clear()
	
	for tile in used_cells:
		var tile_data = layer.get_cell_tile_data(tile)
		if tile_data != null:
			
			var card_id = tile_data.get_custom_data("card_id")
			
			match card_id:
				Constants.card_id.sprinkler:
					sprinklers.append(tile)
				Constants.card_id.lamp:
					lamps.append(tile)


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


func get_spray_shape_tiles(tile) -> Array[Vector2i]:
	var tile_rotation = layer.get_cell_alternative_tile(tile)
	match tile_rotation:
		Constants.rotation.half_cw: # straght down
			return [tile + Vector2i(0,-1),tile + Vector2i(-1,-2),tile + Vector2i(0,-2),tile + Vector2i(1,-2)]
		Constants.rotation.quarter_cw: # spray left
			return [tile + Vector2i(-1,0),tile + Vector2i(-2,1),tile + Vector2i(2,0),tile + Vector2i(2,-1)]
		Constants.rotation.zero_rot: # spray up
			return [tile + Vector2i(0,1),tile + Vector2i(-1,2),tile + Vector2i(0,2),tile + Vector2i(1,2)]
		Constants.rotation.three_quarter_cw: # spray right
			return [tile + Vector2i(1,0),tile + Vector2i(2,-1),tile + Vector2i(2,0),tile + Vector2i(2,1)]
	# else return nothing
	return []

func dispense_light(tile : Vector2i):
	for light_tile in get_spray_shape_tiles(tile):
		set_dispensed_resource(light_tile, Constants.resource.light)


func dispense_nutrients(tile : Vector2i):
	for nutrients_tile in get_spray_shape_tiles(tile):
		set_dispensed_resource(nutrients_tile, Constants.resource.nutrients)


func dispense_water(tile : Vector2i):
	for water_tile in get_spray_shape_tiles(tile):
		set_dispensed_resource(water_tile, Constants.resource.water)
