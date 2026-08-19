extends Button

@export var actions_label: Label

var flash_button := false

func _ready():
	SignalBus.count_action.connect(count_action)

func end_turn():
	SignalBus.emit_signal("end_turn")
	SignalBus.emit_signal("enter_hand_mode")
	flash_button = false


func count_action(actions: int):
	actions_label.text = str("Actions: ", actions)
	if actions == 0:
		flash_button = true
	else:
		flash_button = false
	update_flash_visibility()
	


func update_flash_visibility():
	$"../turn_button2".visible = flash_button
