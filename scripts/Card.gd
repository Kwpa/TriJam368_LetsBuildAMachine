class_name Card extends Control

# tile set
@export var tile_set : TileSet = preload("res://scenes/machine_tileset.tres")
var tile_source : TileSetSource = tile_set.get_source(1)

var card_data : CardData = Constants.all_cards[Constants.card_id.straight]

	
func custom_to_string() -> String:
	return card_data["title"]

func set_data(data : CardData) -> void:
	card_data = data 
	
	# set the UI parts
	$Container/card_title.text = card_data["title"]
	$Container/card_description.text = card_data["description"]
	
	# set the picture
	var atlas_image = tile_source.texture.get_image() # -> Image
	var tile_region = tile_source.get_tile_texture_region(card_data["coords"]) # -> Rect2i
	var tile_image = atlas_image.get_region(tile_region) # -> Image
	var tile_texture = ImageTexture.create_from_image(tile_image) # -> ImageTexture
	$Container/card_tile_background/card_tile_image.texture = tile_texture
	

func on_selected_changed(is_selected : bool) -> void:
	if is_selected == true:
		$Container/card_tile_background/card_tile_image.self_modulate = Color(1,1,1,.5)
	else:
		$Container/card_tile_background/card_tile_image.self_modulate = Color(1,1,1,1)
	
