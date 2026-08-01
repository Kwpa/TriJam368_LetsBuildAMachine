extends Control


func on_restart():
	self.visible = false
	SignalBus.restart_level.emit(Constants.select_level)


func on_next_level():
	self.visible = false
	SignalBus.restart_level.emit(Constants.select_level)
