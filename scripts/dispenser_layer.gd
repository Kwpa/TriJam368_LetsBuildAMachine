extends TileMapLayer


func _ready() -> void:
	SignalBus.connect("update_dispenser_layer", update_dispenser_layer)


func update_dispenser_layer(add_array: Array[InstantiatedTileData]):
	clear()
	for add_tile in add_array:
		if add_tile.dispensed:
			var tile_info = get_tile_from_resources(add_tile.resources)
			set_cell(add_tile.coords, tile_info.source_id, tile_info.atlas_coords, 0)
	
	#for remove_tile in remove_array:
		#erase_cell(remove_tile.coords)


func get_tile_from_resources(resources : Array[Constants.resource]):
	var light_check = resources.has(Constants.resource.light)
	var nutrients_check = resources.has(Constants.resource.nutrients)
	var water_check = resources.has(Constants.resource.water)
	
	if light_check and nutrients_check and water_check:
		return Constants.tile_card_mapping[Constants.card_id.dispensed_all]

	if light_check == false and nutrients_check and water_check:
		return Constants.tile_card_mapping[Constants.card_id.dispensed_water_nutrients]
	
	if light_check and nutrients_check == false and water_check:
		return Constants.tile_card_mapping[Constants.card_id.dispensed_water_light]
	
	if light_check and nutrients_check and water_check == false:
		return Constants.tile_card_mapping[Constants.card_id.dispensed_nutrients_light]
	
	if light_check and nutrients_check == false and water_check == false:
		return Constants.tile_card_mapping[Constants.card_id.dispensed_light]
	
	if light_check == false and nutrients_check and water_check == false:
		return Constants.tile_card_mapping[Constants.card_id.dispensed_nutrients]
	
	if light_check == false and nutrients_check == false and water_check:
		return Constants.tile_card_mapping[Constants.card_id.dispensed_water]
	
	return null
	
