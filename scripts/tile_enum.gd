extends Node

#const RESEVOIR = [Vector2i(0,0), 'Generates water to increase moisture']
#const GENERATOR = [Vector2i(2,0), 'Generates electricity to increase light']
#const COMPOST = [Vector2i(1,1), 'Generates compost to increase nutrients']
#const TEE = [Vector2i(1,0), 'Connects three adjacent parts']
#const ELBOW = [Vector2i(2,1), 'Connects two adjacent parts. Has one input and one output']
#const FOUR_WAY = [Vector2i(1,2), 'Connects four adjacent parts.']
#const STRAIGHT = [Vector2i(2,3), 'Connects two adjacent parts. Has one input and one output']



func get_card_details(id: Constants.card_id):
	var details = all_cards[id]
	
