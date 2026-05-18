extends Node

var HAND_SIZE_LIMIT = 6
var OPENING_HAND_SIZE = 4

# We are not using the two-tile objects.
# The enum all_cards contains possible cards and the generator.
# When the tile played by the card uses a different sprite depending on its input,
# 	the card contains a when_receiving_input dictionary,
# 	which associates the input received with the sprite location.

# Nutrients must be connected directly to the plant, and cannot be connected to a sprinkler?

enum card_id {
	straight = 0,
	elbow = 1,
	cross = 2,
	tee = 3,
	sprinkler = 4,
	water_straight = 5,
	water_tee = 6,
	compost_straight = 7,
	compost_tee = 8,
	lamp = 9,
	generator = 10,
	plant = 11,
	not_card = 20
}

var card_weights = [
	1, # straight probability
	.75, # elbow probability
	.5, # cross probability
	.75, # tee  probability
	.5, # sprinkler probability
	.25, # water_straight probability
	.25, # water_tee probability
	.25, # compost_straight probability
	.25, # compost_tee probability
	.5, # lamp probability
	0, # generator probability
	0, # not_card probability
]

enum resource {
	none, water, light, nutrients, electricity
}

var level_definitions = [
	LevelData.new(
		0,
		[
			{
				## generator 1 
				"tilemap_coords": Vector2i(0,2),
				"atlas_coords": Vector2i(3,4),
				"source_id": 1,
				"alternative_id": 0 
				## 0 = 0deg; 1 = 90deg; 2 = 180deg; 3 = 270deg  
			},
			{
				## plant 1
				"tilemap_coords": Vector2i(2,4),
				"atlas_coords": Vector2i(0,2),
				"source_id": 2,
				"alternative_id": 0
			}
		]
	),
	LevelData.new(
		1,
		[
			{
				"tilemap_coords": Vector2i(0,0),
				"atlas_coords": Vector2i(0,0),
				"source_id": 1,
				"alternative_id": 0 
				## 0 = 0deg; 1 = 90deg; 2 = 180deg; 3 = 270deg  
			},
			{
				"tilemap_coords": Vector2i(0,0),
				"atlas_coords": Vector2i(0,0),
				"source_id": 2,
				"alternative_id": 0
			},
		]
	)
]

#CardData definition repeated for convenience
#var title : String
#var description: String
#var coords : Vector2i
#var resource : Constants.resource
#var when_receiving_input : Dictionary

var all_cards : Dictionary = { 
	card_id.elbow: CardData.new(
		"Elbow",
		"Connects two adjacent tiles at a right angle.",
		Vector2i(1, 0),
		Constants.resource.none
	),
	card_id.straight: CardData.new(
		"Straight",
		"Connects two adjacent tiles across from each other.",
		Vector2i(0, 0),
		Constants.resource.none
	),
	card_id.cross: CardData.new(
		"Cross",
		"Connects four adjacent tiles.",
		Vector2i(0, 1),
		Constants.resource.none
	),
	card_id.tee: CardData.new(
		"Tee",
		"Connects three adjacent tiles.",
		Vector2i(1, 1),
		Constants.resource.none
	),
	card_id.sprinkler: CardData.new(
		"Sprinkler",
		"When attached to water, distributes it in a cone.",
		Vector2i(2, 1),
		Constants.resource.none,
		{
			Constants.resource.water: Vector2i(3, 2),
			Constants.resource.nutrients: Vector2i(3, 0)
		}
	),
	card_id.water_straight: CardData.new(
		"Water (Straight)",
		"When attached to electricity, generates water.",
		Vector2i(2, 2),
		Constants.resource.water
	),
	card_id.water_tee: CardData.new(
		"Water (Tee)",
		"When attached to electricity, generates water.",
		Vector2i(1, 2),
		Constants.resource.water
	),
	card_id.compost_straight: CardData.new(
		"Compost (Straight)",
		"When attached to electricity, generates nutrients.",
		Vector2i(2, 5),
		Constants.resource.nutrients
	),
	card_id.compost_tee: CardData.new(
		"Compost (Tee)",
		"When attached to electricity, generates nutrients.",
		Vector2i(1, 5),
		Constants.resource.nutrients
	),
	card_id.lamp: CardData.new(
		"Lamp",
		"When attached to electricity, distributes light in a cone.",
		Vector2i(3, 5),
		Constants.resource.light,
		{
			Constants.resource.electricity: Vector2i(3, 6)
		}
	),
	card_id.generator: CardData.new(
		"Generator",
		"Generates electricity",
		Vector2i(3, 4),
		Constants.resource.electricity
	),
	card_id.plant: CardData.new(
		"Plant",
		"Needs to receive light, water, and nutrients to grow.",
		Vector2(0, 2),
		Constants.resource.none
	)
	}
