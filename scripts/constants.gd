extends Node

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
	not_card = 20
}

enum resource {
	none, water, light, nutrients, electricity
}

var all_cards : Dictionary = { 
	card_id.elbow: card_data.new(
		"Elbow",
		"Connects two adjacent tiles at a right angle.",
		Vector2(1, 0),
		Constants.resource.none
	),
	card_id.straight: card_data.new(
		"Straight",
		"Connects two adjacent tiles across from each other.",
		Vector2(0, 0),
		Constants.resource.none
	),
	card_id.cross: card_data.new(
		"Cross",
		"Connects four adjacent tiles.",
		Vector2(0, 1),
		Constants.resource.none
	),
	card_id.tee: card_data.new(
		"Tee",
		"Connects three adjacent tiles.",
		Vector2(1, 1),
		Constants.resource.none
	),
	card_id.sprinkler: card_data.new(
		"Sprinkler",
		"When attached to water, distributes it in a cone.",
		Vector2(2, 1),
		Constants.resource.none,
		{
			Constants.resource.water: Vector2(3, 2),
			Constants.resource.nutrients: Vector2(3, 0)
		}
	),
	card_id.water_straight: card_data.new(
		"Water (Straight)",
		"When attached to electricity, generates water.",
		Vector2(2, 2),
		Constants.resource.water
	),
	card_id.water_tee: card_data.new(
		"Water (Tee)",
		"When attached to electricity, generates water.",
		Vector2(1, 2),
		Constants.resource.water
	),
	card_id.compost_straight: card_data.new(
		"Compost (Straight)",
		"When attached to electricity, generates nutrients.",
		Vector2(2, 5),
		Constants.resource.nutrients
	),
	card_id.compost_tee: card_data.new(
		"Compost (Tee)",
		"When attached to electricity, generates nutrients.",
		Vector2(1, 5),
		Constants.resource.nutrients
	),
	card_id.lamp: card_data.new(
		"Lamp",
		"When attached to electricity, distributes light in a cone.",
		Vector2(3, 5),
		Constants.resource.light,
		{
			Constants.resource.electricity: Vector2(3, 6)
		}
	),
	card_id.generator: card_data.new(
		"Generator",
		"Generates electricity",
		Vector2(3, 4),
		Constants.resource.electricity
	)
	}
