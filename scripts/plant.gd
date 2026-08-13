extends Node

# vitals
@export var photosynthesis_vital : VitalTracker
@export var moisture_vital : VitalTracker
@export var nutrients_vital : VitalTracker
@export var status_label : RichTextLabel

# size variables
var starting_plant_size : int = 1
var final_plant_size : int = 3
var current_plant_size : int = 1

var plant_id : int

# for how long has the plant been at optimal levels?
var plant_statisfied_round_count : int = 0

# if the plant is in danger, how so?
var warning_queue : Array = []

# what is the plant receiving from the machine right now?
var resource_inputs : Array[String] = []

## Some notes on how this works:
## 
## A plant is made up on one, two or three tiles.
## The plant tiles cannot be moved by the player. New plant tiles are added by the game as the plant grows.

# Tristan: The assets currently allow plants to be one or two tiles, with the second tile always being above the first tile.
# The plant should continue tracking vitals at two tiles, and the game is won when it would have grown to its third tile.

## Each of the plant tiles reports to a plant node, with this script on it.

# Tristan: If each plant tile needs a script to report its values, how do we attach it?
# It might make more sense to have the machine board save cell coordinates that contain plant.

## Whenever the player places, rotates, removes or moves another tile, the plant tiles first check for valid inputs,
## then sends them to this script.
## Each input gets added/removed as a string to the resources_inputs array. 
## If a plant is receiving an input resource, the corresponding vital will only increase 
## and not decrease if the amount of input resource is equal to the size of the plant (e.g. num of tiles).
##
## Once the inputs are checked and a turn is completed, the plant node will receive a signal to run the play_turn() function
## to work out if the plant is outside an optimal vitals range (and in risk of dying), has a vital reached zero
## (thus has died) or has survived 3 turns at optimal vitals to be able to grow to the next size (note that as 
## soon as vitals are out of range again the 3 rounds of survival counter will be reset). 
##
## order of signals:
## - clear resource inputs 
## - send new resource inputs
## - if action spent, begin new turn


func _ready():
	## sigal for input growth
	
	# Note that this will set the highest id for all plants. 
	# In order to set a plant manager for each plant, 
	# we would need to have the machine board controller instantiate the plant manager.
	SignalBus.connect("set_plant_id", set_id)
	SignalBus.connect("add_resource_input_to_plant", resource_input)
	SignalBus.connect("end_turn", end_turn)
	SignalBus.connect("reset_resource_inputs_on_plant", clear_resource_inputs)
	SignalBus.connect("restart_level", initialize)
	SignalBus.connect("start_level", _initialize)
	

func set_id(_id: int):
	plant_id = _id

## also to hook up so the tilemanager can refresh the plant's resource list
func clear_resource_inputs(_id: int):
	if _id == plant_id:
		resource_inputs.clear()


func _initialize(level: int):
	initialize()


func initialize():
	photosynthesis_vital.value = photosynthesis_vital.vital_lower_optimal
	moisture_vital.value = moisture_vital.vital_lower_optimal
	nutrients_vital.value = nutrients_vital.vital_lower_optimal
	current_plant_size = starting_plant_size
	clear_resource_inputs(plant_id)
	warning_queue.clear()
	update_plant_status()


## to hook up to signal for when a tile is placed, moved or rotated, and we need to add or remove resources going into the plant 
func resource_input(_id: int, input_name:String, action_type: String):
	print(action_type, " ", input_name, " on plant ", _id)
	if _id == plant_id || _id == plant_id + 1:
		match action_type:
			"remove": 
				if resource_inputs.has(input_name):
					var index = resource_inputs.find(input_name)
					resource_inputs.remove_at(index)
			"add":
				resource_inputs.append(input_name)


## check the resource inputs to see if they're enough to make the plant grow 
func check_inputs_for_growth() -> bool:
	var photosyn_count = 0
	var moisture_count = 0
	var nutrients_count = 0
	for input : String in resource_inputs:
		match input:
			"light":
				photosyn_count += 1
			"water":
				moisture_count += 1
			"fertilizer":
				nutrients_count += 1
	
	## show icons signalling inputs contributing to what plant is getting
	
	## Update the vitals
	if (photosyn_count >= current_plant_size):
		photosynthesis_vital.value += 1
	else:
		photosynthesis_vital.value -= 1
		warning_queue.append("The plant needs more light.")
		
	if (moisture_count >= current_plant_size):
		moisture_vital.value += 1
	else:
		moisture_vital.value -= 1
		warning_queue.append("The plant needs more water.")
		
	if (nutrients_count >= current_plant_size):
		nutrients_vital.value += 1
	else:
		nutrients_vital.value -= 1
		warning_queue.append("The plant needs more compost.")
	
	if photosyn_count >= current_plant_size && moisture_count >= current_plant_size && nutrients_count >= current_plant_size:
		return true
	else:
		return false


## called by the game manager, needs a signal
func end_turn():
	
	var inputs_met = check_inputs_for_growth()
	
	#if check_if_plant_is_fully_grown() == false:
		#photosynthesis_vital.current_vital_level -= 1
		#moisture_vital.current_vital_level -= 1
		#nutrients_vital.current_vital_level -= 1
	
	if photosynthesis_vital.check_if_level_is_zero() || moisture_vital.check_if_level_is_zero() || nutrients_vital.check_if_level_is_zero():
		## lose!
		SignalBus.end_game.emit(false)
		return
	
	var vitals_optimal_count = 0
	
	if photosynthesis_vital.check_if_level_is_optimal() == true:
		vitals_optimal_count += 1
		
	if moisture_vital.check_if_level_is_optimal() == true:
		vitals_optimal_count += 1
	
	if nutrients_vital.check_if_level_is_optimal() == true:
		vitals_optimal_count += 1
	
	if vitals_optimal_count == 3:
		increase_satisfied_count()
	else:
		reset_satisfied_count()
	
	update_plant_status()
	
	print("plant status " + str(plant_statisfied_round_count))
	
	if inputs_met && plant_statisfied_round_count >= 3:
		if current_plant_size < final_plant_size:
			grow_plant()


func grow_plant():
	print("growing plant")
	current_plant_size += 1
	## send signal to add new tile / change tile images
	SignalBus.grow_plant.emit(plant_id)
	reset_satisfied_count()
	
	if current_plant_size == final_plant_size:
		## plant grown success!
		# game win condition
		SignalBus.end_game.emit(true)
	else:
		# set_plant_levels(5)
		decrease_plant_levels(3)


func decrease_plant_levels(amount: int):
	photosynthesis_vital.value -= amount
	moisture_vital.value -= amount
	nutrients_vital.value -= amount


func set_plant_levels(value: int):
	photosynthesis_vital.value = value
	moisture_vital.value = value
	nutrients_vital.value = value


func check_if_plant_tile_has_enough_inputs() -> bool:
	return false


func check_if_plant_is_fully_grown() -> bool:
	return false


func increase_satisfied_count():
	plant_statisfied_round_count += 1


func reset_satisfied_count():
	plant_statisfied_round_count = 0


func update_plant_status():
	var warnings: String
	if warning_queue.size() == 0:
		warnings = "The plant is thriving!"
	else:
		warnings = " ".join(warning_queue)
	
	status_label.text = warnings
	warning_queue.clear()
