extends Node

class_name VitalTracker

# what is being tracked?
@export var vital_name : String

# current level
@export var current_vital_level : int

# optimal levels
@export var vital_lower_optimal : int
@export var vital_upper_optimal : int

# maximum level
@export var vital_max : int
# miniumum is zero

# is level in the optimal range?
func check_if_level_is_optimal() -> bool:
	if current_vital_level >= vital_lower_optimal || current_vital_level <= vital_upper_optimal:
		return true
	else:
		return false

# is level at zero?
func check_if_level_is_zero() -> bool:
	return current_vital_level == 0

# is level at max?
func check_if_level_is_max() -> bool:
	return current_vital_level >= vital_max
