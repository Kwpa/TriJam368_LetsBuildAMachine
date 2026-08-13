extends Node

var HAND_SIZE_LIMIT = 6
var OPENING_HAND_SIZE = 4
var TURN_ACTION_COUNT = 3

var CARD_WEIGHT_MULTIPLIER = 3
var CARD_WEIGHT_DECREASE = 0.5
var CARD_MAX_WEIGHT = 3
var CARD_MIN_WEIGHT = 0.25

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
	water_elbow = 12,
	compost_elbow = 13,
	dispensed_light = 14,
	dispensed_nutrients = 15,
	dispensed_water = 16,
	dispensed_nutrients_light = 17,
	dispensed_water_light = 18,
	dispensed_water_nutrients = 19,
	not_card = 20,
	dispensed_all = 21,
	sprinkler_light = 22,
	sprinkler_nutrients = 23,
	sprinkler_water = 24,
	trellis_empty = 25,
	lamp_active = 26,
	sprinkler_active_water = 27,
	sprinkler_active_nutrients = 28
}

var card_weights = [
	#the index of this array represents the card_id in all_cards, below
	1, # straight probability
	.75, # elbow probability
	.5, # cross probability
	.75, # tee  probability
	.75, # sprinkler probability
	.25, # water_straight probability
	.25, # water_tee probability
	.25, # compost_straight probability
	.25, # compost_tee probability
	.5, # lamp probability
	0, # generator probability
	0, # plant probability
	.25, # water_elbow probability
	.25, # compost_elbow probability
]

enum resource {
	none = 0, 
	electricity = 1,
	water = 2,
	light = 3, 
	nutrients = 4, 
}

enum rotation {
	zero_rot = 0,
	quarter_cw = 1,
	half_cw = 2,
	three_quarter_cw = 3
}

var tile_card_mapping = {
	card_id.straight: {
		"atlas_coords": Vector2i(0,0),
		"source_id": 1
	},
	card_id.elbow: {
		"atlas_coords": Vector2i(1,0),
		"source_id": 1
	},
	card_id.cross: {
		"atlas_coords": Vector2i(0,1),
		"source_id": 1
	},
	card_id.tee: {
		"atlas_coords": Vector2i(1,1),
		"source_id": 1
	},
	card_id.sprinkler: {
		"atlas_coords": Vector2i(2,1),
		"source_id": 1
	},
	card_id.water_straight: {
		"atlas_coords": Vector2i(2,2),
		"source_id": 1
	},
	card_id.water_tee: {
		"atlas_coords": Vector2i(0,2),
		"source_id": 1
	},
	card_id.water_elbow: {
		"atlas_coords": Vector2i(1,2),
		"source_id": 1
	},
	card_id.compost_straight: {
		"atlas_coords": Vector2i(2,5),
		"source_id": 1
	},
	card_id.compost_tee: {
		"atlas_coords": Vector2i(0,5),
		"source_id": 1
	},
	card_id.compost_elbow: {
		"atlas_coords": Vector2i(1,5),
		"source_id": 1
	},
	card_id.lamp: {
		"atlas_coords": Vector2i(3,5),
		"source_id": 1
	},
	card_id.generator: {
		"atlas_coords": Vector2i(3,4),
		"source_id": 1
	},
	card_id.plant : {
		"atlas_coords": Vector2i(0,2),
		"source_id": 2
	},
	card_id.dispensed_light : {
		"atlas_coords": Vector2i(0,1),
		"source_id": 5
	},
	card_id.dispensed_nutrients : {
		"atlas_coords": Vector2i(1,0),
		"source_id": 5
	},
	card_id.dispensed_water : {
		"atlas_coords": Vector2i(2,0),
		"source_id": 5
	},
	card_id.dispensed_nutrients_light : {
		"atlas_coords": Vector2i(0,1),
		"source_id": 5
	},
	card_id.dispensed_water_light : {
		"atlas_coords": Vector2i(1,1),
		"source_id": 5
	},
	card_id.dispensed_water_nutrients : {
		"atlas_coords": Vector2i(2,1),
		"source_id": 5
	},
	card_id.dispensed_all : {
		"atlas_coords": Vector2i(3,1),
		"source_id": 5
	},
	card_id.sprinkler_light : {
		"atlas_coords": Vector2i(0,2),
		"source_id": 5
	},
	card_id.sprinkler_nutrients : {
		"atlas_coords": Vector2i(1,2),
		"source_id": 5
	},
	card_id.sprinkler_water : {
		"atlas_coords": Vector2i(2,2),
		"source_id": 5
	},
	card_id.trellis_empty: {
		"atlas_coords": Vector2i(0,0),
		"source_id": 7
	},
	card_id.not_card: {
		"atlas_coords": null,
		"source_id": null
	}
}

var select_level : int = 1
var level_definitions = [
	LevelData.new(
		0,
		"The First Machine",
		[
			{
				## generator 1 
				"tilemap_coords": Vector2i(0,1),
				"tile": card_id.generator,
				"rotation": rotation.zero_rot 
			},
			{
				## plant 1
				"tilemap_coords": Vector2i(2,4),
				"tile": card_id.plant,
				"rotation": rotation.zero_rot 
			},
			{
				## trellis empty
				"tilemap_coords": Vector2i(2,3),
				"tile": card_id.trellis_empty,
				"rotation": rotation.zero_rot 
			}
		]
	),
	LevelData.new(
		1,
		"The Second Machine",
		[
			{
				## generator 1 
				"tilemap_coords": Vector2i(2,0),
				"tile": card_id.generator,
				"rotation": rotation.quarter_cw 
			},
			{
				## plant 1
				"tilemap_coords": Vector2i(1,4),
				"tile": card_id.plant,
				"rotation": rotation.zero_rot 
			},
			{
				## trellis empty
				"tilemap_coords": Vector2i(1,3),
				"tile": card_id.trellis_empty,
				"rotation": rotation.zero_rot 
			}
		]
	),
	LevelData.new(
		2,
		"The Third Machine",
		[
			{
				## generator 1 
				"tilemap_coords": Vector2i(2,1),
				"tile": card_id.generator,
				"rotation": rotation.three_quarter_cw 
			},
			{
				## plant 1
				"tilemap_coords": Vector2i(2,4),
				"tile": card_id.plant,
				"rotation": rotation.zero_rot 
			},
			{
				## trellis empty
				"tilemap_coords": Vector2i(2,3),
				"tile": card_id.trellis_empty,
				"rotation": rotation.zero_rot 
			}
		]
	),
	#original level 1
	#LevelData.new(
		#1,
		#[
			#{
				### generator 1 
				#"tilemap_coords": Vector2i(0,1),
				#"tile": card_id.generator,
				#"rotation": rotation.zero_rot 
			#},
			#{
				### plant 1
				#"tilemap_coords": Vector2i(2,4),
				#"tile": card_id.plant,
				#"rotation": rotation.zero_rot 
			#},
			#{
				### pipe 1
				#"tilemap_coords": Vector2i(1,1),
				#"tile": card_id.cross,
				#"rotation": rotation.zero_rot
			#},
			#{
				### water 1
				#"tilemap_coords": Vector2i(2,1),
				#"tile":card_id.water_elbow,
				#"rotation": rotation.three_quarter_cw
			#},
			#{
				### dispenser 1
				#"tilemap_coords": Vector2i(2,2),
				#"tile": card_id.sprinkler,
				#"rotation": rotation.zero_rot
			#}
		#]
	#)
]

#CardData definition repeated for convenience
#var title : String
#var description: String
#var coords : Vector2i
#var resource : Constants.resource
#var when_receiving_input : Dictionary

var all_cards : Dictionary = { 
	# this dictionary must have an entry for each index in card_weights
	card_id.straight: CardData.new(
		"Straight",
		"Connects two adjacent tiles across from each other.",
		Vector2i(0, 0),
		Constants.resource.none
	),
	card_id.elbow: CardData.new(
		"Elbow",
		"Connects two adjacent tiles at a right angle.",
		Vector2i(1, 0),
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
		"When attached to water or nutrients, distributes it in a cone.",
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
		Vector2i(0, 2),
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
		Vector2i(0, 5),
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
	),
	card_id.water_elbow: CardData.new(
		"Water (Elbow)",
		"When attached to electricity, generates water.",
		Vector2i(1, 2),
		Constants.resource.water
	),
	card_id.compost_elbow: CardData.new(
		"Compost (Elbow)",
		"When attached to electricity, generates nutrients.",
		Vector2i(1, 5),
		Constants.resource.nutrients
	),
	card_id.lamp_active: CardData.new(
		"Lamp",
		"When attached to electricity, distributes light in a cone.",
		Vector2i(3, 5),
		Constants.resource.light,
		{
			Constants.resource.electricity: Vector2i(3, 6)
		}
	),
	card_id.sprinkler_active_water: CardData.new(
		"Sprinkler",
		"When attached to water or nutrients, distributes it in a cone.",
		Vector2i(2, 1),
		Constants.resource.none,
		{
			Constants.resource.water: Vector2i(3, 2),
			Constants.resource.nutrients: Vector2i(3, 0)
		}
	),
	card_id.sprinkler_active_nutrients: CardData.new(
		"Sprinkler",
		"When attached to water or nutrients, distributes it in a cone.",
		Vector2i(2, 1),
		Constants.resource.none,
		{
			Constants.resource.water: Vector2i(3, 2),
			Constants.resource.nutrients: Vector2i(3, 0)
		}
	)
	}

var audio_keys = {
	"main_music":"audio_game_music_001_2026_07",
	"card_enter":"card"
}
