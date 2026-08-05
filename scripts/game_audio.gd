extends Node2D

var end_g:= false

func _ready():
	SignalBus.connect("restart_level", initialize)
	SignalBus.connect("use_card", use_card)
	SignalBus.connect("end_turn", end_turn)
	SignalBus.connect("enter_hand_mode", mode_button)
	SignalBus.connect("enter_remove_mode", mode_button)
	SignalBus.connect("enter_rotate_mode", mode_button)
	SignalBus.connect("grow_plant", grow_plant)
	SignalBus.connect("end_game", end_game)
	
	initialize(0)


func end_game(win: bool):
	end_g = win
	if win:
		AudioManager.stop_all_active()
		AudioManager.play_sfx_once("beep_2")
	else:
		AudioManager.stop_all_active()
		AudioManager.play_sfx2("beep_1")


func initialize(_n):
	AudioManager.play_music(Constants.audio_keys["main_music"],true,-5)
	pass


func use_card():
	AudioManager.play_sfx_once("place_tile", 4)
	

func end_turn():
	if end_g == false:
		AudioManager.play_sfx2("click", 15)
		AudioManager.play_sfx_once("end_turn", 2)


func grow_plant(n):
	AudioManager.stop_all_active()
	AudioManager.play_sfx_once("growth", 7)
	await get_tree().create_timer(4).timeout
	AudioManager.play_music(Constants.audio_keys["main_music"],true)

func mode_button():
	AudioManager.play_sfx2("click", 15)
