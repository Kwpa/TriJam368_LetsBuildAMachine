extends Node2D

@onready var base_tilemap_layer = $machine_scene/tile_map 

var mode := "hand"

func _ready() -> void:
	# create a game board with 
		# pot in default position
		# generator in random position
	# create a new plant (it will handle its resource levels)
	
	# start the level
	get_level_def(1)
	
	# check resources + update tiles in the machine_scene
	SignalBus.connect("enter_hand_mode",enter_hand_mode)
	SignalBus.connect("enter_rotate_mode",exit_hand_mode)
	SignalBus.connect("enter_remove_mode",exit_hand_mode)
	SignalBus.emit_signal("propogate_resources")
	SignalBus.emit_signal("enter_hand_mode")


func get_level_def(id : int):
	for def in Constants.level_definitions:
		if def.level_id == id:
			base_tilemap_layer.load_level(def)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_tile_map_changed() -> void:
	# check for win
	pass # Replace with function body.

func _on_card_selected() -> void:
	#$machine_scene/TileMapLayer.selected_tile = Vector2i(1,1)
	pass


func enter_hand_mode():
	mode = "hand"
	$hand_scene.modulate = Color(1,1,1,1)


func exit_hand_mode():
	mode = "not_hand"
	$hand_scene.modulate = Color(1,1,1,0.5)
	$machine_scene/preview_tile_layer.preview_mode = false
	for card_track in $hand_scene/HandContainer.get_children():
		if card_track.is_selected:
			card_track.toggle_selection()
