extends TileMapLayer


func _ready() -> void:
	SignalBus.connect("update_dispenser_layer", update_dispenser_layer)


func update_dispenser_layer(add_array: Array[InstantiatedTileData], remove_array:Array[InstantiatedTileData]):
	for add_tile in add_array:
		set_cell(add_tile.coords, 5, get_tile_from_resources(add_tile.resources),0)
	
	for remove_tile in remove_array:
		erase_cell(remove_tile.coords)


func get_tile_from_resources(resources : Array[Constants.resource]):
	var light_check = resources.has(Constants.resource.light)
	var nutrients_check = resources.has(Constants.resource.nutrients)
	var water_check = resources.has(Constants.resource.water)
	
	if light_check and nutrients_check and water_check:
		return Constants.tile_card_mapping[Constants.card_id.dispensed_all].atlas_coords

	if light_check == false and nutrients_check and water_check:
		return Constants.tile_card_mapping[Constants.card_id.dispensed_water_nutrients].atlas_coords
	
	if light_check and nutrients_check == false and water_check:
		return Constants.tile_card_mapping[Constants.card_id.dispensed_water_light].atlas_coords
	
	if light_check and nutrients_check and water_check == false:
		return Constants.tile_card_mapping[Constants.card_id.dispensed_nutrients_light].atlas_coords
	
	if light_check and nutrients_check == false and water_check == false:
		return Constants.tile_card_mapping[Constants.card_id.dispensed_light].atlas_coords	
	
	if light_check == false and nutrients_check and water_check == false:
		return Constants.tile_card_mapping[Constants.card_id.dispensed_nutrients].atlas_coords
	
	if light_check == false and nutrients_check == false and water_check:
		return Constants.tile_card_mapping[Constants.card_id.dispensed_water].atlas_coords
	
	return null
	
