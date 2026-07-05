extends Button

@export var actions_label: Label

func _ready():
	SignalBus.count_action.connect(count_action)

func end_turn():
	SignalBus.emit_signal("end_turn")

func count_action(actions: int):
	actions_label.text = str("Actions: ", actions)
