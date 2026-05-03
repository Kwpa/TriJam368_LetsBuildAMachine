class_name Card extends Control

# tile set
@export var tile_set : TileSet = preload("res://scenes/machine_tileset.tres")

var card_data : CardData = Constants.all_cards[Constants.card_id.straight]

	
func custom_to_string() -> String:
	return card_data["title"]

func set_data(data : CardData) -> void:
	card_data = data 
	# set the UI parts

func on_selected_changed(is_selected : bool) -> void:
	if is_selected == true:
		$VBoxContainer/card_tile_background/card_tile_image.self_modulate = Color(1,1,1,.5)
	else:
		$VBoxContainer/card_tile_background/card_tile_image.self_modulate = Color(1,1,1,1)
	
