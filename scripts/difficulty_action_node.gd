extends Button

var index: int = 2


func _initialize(_index: int):
	index = _index


func _on_pressed():
	get_parent().handle_input(index)
