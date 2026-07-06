extends Node2D

var mode = "hand"
@onready var layer = $"../tile_map"


func _ready() -> void:
	SignalBus.connect("enter_hand_mode", hand_mode)
	SignalBus.connect("enter_rotate_mode", rotate_mode)
	SignalBus.connect("enter_remove_mode", remove_mode)


func hand_mode():
	mode = "hand"
	$control/rotate.visible=false
	$control/remove.visible=false


func rotate_mode():
	mode = "rotate"
	$control/rotate.visible=true
	$control/remove.visible=false
	

func remove_mode():
	mode = "remove"
	$control/rotate.visible=false
	$control/remove.visible=true


func _input(event: InputEvent) -> void:
	if mode == "remove" or mode == "rotate":
		var cell_selected_coords = layer.local_to_map(to_local(get_global_mouse_position()))
		#if cell_selected_coords.x >= 0 and cell_selected_coords.x < 5 and cell_selected_coords.y >= 0 and cell_selected_coords.y < 5:
