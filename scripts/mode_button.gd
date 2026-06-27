extends Button

@export var mode := "hand"


func _ready()->void:
	SignalBus.connect("enter_hand_mode", enter_hand_mode)
	SignalBus.connect("enter_rotate_mode", enter_rotate_mode)
	SignalBus.connect("enter_remove_mode", enter_remove_mode)


func enter_hand_mode():
	if mode == "hand":
		grab_focus()


func enter_rotate_mode():
	if mode == "rotate":
		grab_focus() 


func enter_remove_mode():
	if mode == "remove":
		grab_focus()


func _on_pressed() -> void:
	match mode:
		"hand":
			SignalBus.emit_signal("enter_hand_mode")
		"rotate":
			SignalBus.emit_signal("enter_rotate_mode")
		"remove":
			SignalBus.emit_signal("enter_remove_mode")
		"turn":
			SignalBus.emit_signal("end_turn")
