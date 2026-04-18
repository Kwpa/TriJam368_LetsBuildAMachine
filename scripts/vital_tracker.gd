extends Node

class_name VitalTracker

@export var vital_name : String
@export var current_vital_level : int
@export var vital_lower_opitmal : int
@export var vital_upper_optimal : int
@export var vital_max : int


func check_if_level_is_optimal() -> bool:
	if current_vital_level >= vital_lower_opitmal || current_vital_level <= vital_upper_optimal:
		return true
	else:
		return false


func check_if_level_is_zero() -> bool:
	return current_vital_level == 0


func check_if_level_is_max() -> bool:
	return current_vital_level >= vital_max
