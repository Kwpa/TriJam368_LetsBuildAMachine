extends Node2D

func _ready():
	SignalBus.connect("restart_level", initialize)
	initialize(0)

func initialize(n):
	AudioManager.play_music(Constants.audio_keys["main_music"],true,0,1,0)
