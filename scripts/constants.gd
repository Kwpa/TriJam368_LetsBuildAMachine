extends Node

enum card_id {
	elbow, reservoir, compost, water, tee
}

enum resource {
	water, light, nutrients, none
}

var all_cards : Dictionary = { 
	card_id.elbow: card_data.new(
		"Elbow",
		"Connects two adjacent tiles at a right angle",
		Vector2(0, 0),
		Constants.resource.none
	) }
