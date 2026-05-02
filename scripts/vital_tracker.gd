extends ProgressBar
# Changed script to use built-in progress bar and range properties

class_name VitalTracker

# what is being tracked
# switch to enum?
@export var vital_name : String

# optimal levels
@export var vital_lower_optimal : int
@export var vital_upper_optimal : int

# is level in the optimal range?
func check_if_level_is_optimal() -> bool:
	if value >= vital_lower_optimal || value <= vital_upper_optimal:
		return true
	else:
		return false

# is level at zero?
func check_if_level_is_zero() -> bool:
	return value == 0

# is level at max?
func check_if_level_is_max() -> bool:
	return value >= max_value
