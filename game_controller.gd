extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# create a game board with 
		# pot in default position
		# generator in random position
	# create a deck of cards
	# create a hand of random cards
	# create a new plant (it will handle its resource levels)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_tile_map_changed() -> void:
	# check for win
	pass # Replace with function body.

func _on_card_selected() -> void:
	#$machine_scene/TileMapLayer.selected_tile = Vector2i(1,1)
	pass
