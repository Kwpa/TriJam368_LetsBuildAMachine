extends Control

var current_index = 0
@onready var pages = [$Page1, $Page2, $Page3, $Page4, $Page5]
@onready var next_button = $NextButton
@onready var prev_button = $PrevButton

func on_close():
	AudioManager.play_sfx2("click", 10)
	self.visible = false

func on_open():
	AudioManager.play_sfx2("click", 10)
	self.visible = true

func next_page() -> void:
	prev_button.visible = true
	pages[current_index].visible = false
	current_index += 1
	pages[current_index].visible = true 
	
	if current_index == pages.size() - 1:
		next_button.visible = false
	else:
		next_button.visible = true
	
func prev_page() -> void:
	next_button.visible = true
	pages[current_index].visible = false
	current_index -= 1 
	pages[current_index].visible = true
	
	if current_index == 0:
		prev_button.visible = false
	else:
		prev_button.visible = true
