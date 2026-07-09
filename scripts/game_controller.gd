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
	SignalBus.connect("enter_place_mode",enter_hand_mode)
	SignalBus.connect("enter_rotate_mode",enter_rotate_mode)
	SignalBus.connect("enter_remove_mode",enter_remove_mode)
	SignalBus.connect("end_game", end_game)
	SignalBus.connect("restart_level", initialize)


func initialize(level: int):
	get_level_def(level)
	SignalBus.emit_signal("propogate_resources")


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
	#print_debug("entering hand mode")
	mode = "hand"
	$card_scene.modulate = Color(1,1,1,1)
	$ui/modes_layout/mode_button_hand.button_pressed = true
	$ui/modes_layout/mode_button_rotate.button_pressed = false
	$ui/modes_layout/mode_button_remove.button_pressed = false

func enter_rotate_mode():
	#print_debug("entering rotate mode")
	exit_hand_mode()
	mode = "rotate"
	#TODO: why doesn't the button group do this properly?
	$ui/modes_layout/mode_button_hand.button_pressed = false
	$ui/modes_layout/mode_button_rotate.button_pressed = true
	$ui/modes_layout/mode_button_remove.button_pressed = false

func enter_remove_mode():
	#print_debug("entering remove mode")
	exit_hand_mode()
	mode = "remove"
	#TODO: why doesn't the button group do this properly?
	$ui/modes_layout/mode_button_hand.button_pressed = false
	$ui/modes_layout/mode_button_rotate.button_pressed = false
	$ui/modes_layout/mode_button_remove.button_pressed = true
	

func exit_hand_mode():
	mode = "not_hand"
	$card_scene.modulate = Color(1,1,1,0.5)	
	$machine_scene/preview_tile_layer.preview_mode = false
	for card_track in $card_scene/HandContainer.get_children():
		if card_track.is_selected:
			card_track.toggle_selection()


func end_game(win: bool):
	if win:
		$ui/win_screen.visible = true
		$ui/win_screen/background/layout/close_button.pressed.connect(initialize, 1)
	else:
		$ui/lose_screen.visible = true
		$ui/lose_screen/background/layout/close_button.pressed.connect(initialize, 1)
