extends ColorRect

var mode := "hand"


func _ready() -> void:
	SignalBus.connect("enter_hand_mode",enter_hand_mode)
	SignalBus.connect("enter_rotate_mode",exit_hand_mode)
	SignalBus.connect("enter_remove_mode",exit_hand_mode)


func enter_hand_mode():
	mode = "hand"
	visible = true


func exit_hand_mode():
	mode = "not_hand"
	visible = false
