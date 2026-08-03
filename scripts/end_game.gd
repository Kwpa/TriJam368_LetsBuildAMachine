extends Control


@onready var current_level: int = Constants.select_level


func on_restart():
	self.visible = false
	SignalBus.restart_level.emit(Constants.select_level)


func on_next_level():
	self.visible = false
	current_level += 1
	if Constants.level_definitions.size() <= current_level:
		current_level = Constants.select_level
	SignalBus.restart_level.emit(current_level)
