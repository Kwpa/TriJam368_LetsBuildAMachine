extends Button

@export var mode := "hand"

func _on_pressed() -> void:
	#print_debug(mode)
	match mode:
		# use the mode_button's mode to emit the correct signal
		"hand":
			SignalBus.emit_signal("enter_hand_mode")
			print_debug("entering hand mode from button")
			if mode == "hand":
				button_pressed = true
		"rotate":
			SignalBus.emit_signal("enter_rotate_mode")
			print_debug("entering rotate mode from button")
			if mode == "rotate":
				button_pressed = true
		"remove":
			SignalBus.emit_signal("enter_remove_mode")
			print_debug("entering remove mode from button")
			if mode == "remove":
				button_pressed = true
		"turn":
			SignalBus.emit_signal("end_turn")
