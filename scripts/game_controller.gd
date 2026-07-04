extends Node2D

@onready var base_tilemap_layer = $machine_scene/tile_map 

var mode := "hand"

func _ready() -> void:
	# create a game board with 
		# pot in default position
		# generator in random position
	# create a new plant (it will handle its resource levels)
	
	# start the level
	initialize(1)
	
	# check resources + update tiles in the machine_scene
	SignalBus.connect("enter_hand_mode",enter_hand_mode)
	SignalBus.connect("enter_rotate_mode",exit_hand_mode)
	SignalBus.connect("enter_remove_mode",exit_hand_mode)
	SignalBus.connect("end_game", end_game)
	
	SignalBus.emit_signal("propogate_resources")
	SignalBus.emit_signal("enter_hand_mode")

func initialize(level: int):
	get_level_def(level)


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
	$card_scene.modulate = Color(1,1,1,1)


func exit_hand_mode():
	mode = "not_hand"
	$card_scene.modulate = Color(1,1,1,0.5)


func end_game(win: bool):
	if win:
		$ui/win_screen.visible = true
		$ui/win_screen/background/layout/close_button.pressed.connect(initialize, 1)
	else:
		$ui/lose_screen.visible = true
		$ui/lose_screen/background/layout/close_button.pressed.connect(initialize, 1)
