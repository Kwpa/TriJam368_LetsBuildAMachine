class_name Card extends Control

# tile set
@export var tile_set : TileSet = preload("res://scenes/machine_tileset.tres")

var card_data : CardData = Constants.all_cards[Constants.card_id.straight]

	
func custom_to_string() -> String:
	return card_data["title"]

func set_data(data : CardData) -> void:
	card_data = data 
	# set the UI parts
