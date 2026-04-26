extends Node

enum tile_id {
	elbow = 0, 
	reservoir = 1, 
	compost = 2, 
	water = 3, 
	tee = 4
}

enum resource {
	none, water, light, nutrients, electricity
}

var all_tiles : Dictionary = { 
	tile_id.elbow: card_data.new(
		"Elbow",
		"Connects two adjacent tiles at a right angle",
		Vector2(0, 0),
		Constants.resource.none
	) }
