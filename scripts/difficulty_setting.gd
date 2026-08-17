extends HBoxContainer

var pressed: int = 3


func _ready() -> void:
	for n in range(1, 6):
		var action_button: Button = get_node(str("action_node_", n))
		action_button._initialize(n)
	
	SignalBus.connect("set_actions_per_turn", _set_action_count)
	SignalBus.set_actions_per_turn.emit(Constants.TURN_ACTION_COUNT)


func _set_action_count(actions: int) -> void:
	print(actions)
	SignalBus.restart_level.emit()
	for n in range(2, 6):
		_toggle_node(n, n <= actions)


func _toggle_node(index: int, state: bool):
	var action_icon: TextureRect = get_node(str("action_node_", index, "/icon"))
	if state:
		action_icon.modulate = Color.WHITE
	else:
		action_icon.modulate = Color(0.4, 0.4, 0.4, 1)
	var action_button: Button = get_node(str("action_node_", index))
	action_button.button_pressed = state


func handle_input(index: int):
	pressed = index
	$confirm_change.visible = true


func confirm_change():
	SignalBus.set_actions_per_turn.emit(pressed)
