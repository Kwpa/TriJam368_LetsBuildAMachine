extends Node

@export var photosynthesis_vital : VitalTracker
@export var moisture_vital : VitalTracker
@export var nutrients_vital : VitalTracker

var starting_plant_size : int = 1
var final_plant_size : int = 3

var current_plant_size : int = 1
var plant_statisfied_round_count : int = 0

var warning_queue : Array = []

func _ready():
	print("hook up events")


func play_turn():
	# check 
	if check_if_plant_is_fully_grown() == false:
		
		photosynthesis_vital.current_vital_level -= 1
		moisture_vital.current_vital_level -= 1
		nutrients_vital.current_vital_level -= 1
	
	if photosynthesis_vital.check_if_level_is_zero() || moisture_vital.check_if_level_is_zero() || nutrients_vital.check_if_level_is_zero():
		## lose!
		print("Pass event to gamemanger")
	
	var vitals_optimal_count = 0
	
	if photosynthesis_vital.check_if_level_is_optimal() == false:
		warning_queue.append("photosynthesis levels are out of range")
	else:
		vitals_optimal_count += 1
		
	if moisture_vital.check_if_level_is_optimal() == false:
		warning_queue.append("moisture levels are out of range")
	else:
		vitals_optimal_count += 1
	
	if nutrients_vital.check_if_level_is_optimal() == false:
		warning_queue.append("nutrients levels are out of range")
	else:
		vitals_optimal_count += 1

	if vitals_optimal_count == 3:
		increase_satisfied_count()
	else:
		reset_satisfied_count()
		send_warning_queue()
	
	if plant_statisfied_round_count == 3:
		if current_plant_size < final_plant_size:
			grow_plant()
	


func grow_plant():
	## send signal to sprites to change
	if current_plant_size == final_plant_size:
		## win!
		print("player win!")
		

func check_if_plant_tile_has_enough_inputs() -> bool:
	return false


func check_if_plant_is_fully_grown() -> bool:
	return false


func increase_satisfied_count():
	plant_statisfied_round_count += 1
	print("send_signal_to_round_counter")


func reset_satisfied_count():
	plant_statisfied_round_count = 0
	print("send_signal_to_round_counter")


func send_warning_queue():
	warning_queue.clear()
