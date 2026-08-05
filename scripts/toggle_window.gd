extends Control

func on_close():
	AudioManager.play_sfx2("click", 10)
	self.visible = false

func on_open():
	AudioManager.play_sfx2("click", 10)
	self.visible = true
