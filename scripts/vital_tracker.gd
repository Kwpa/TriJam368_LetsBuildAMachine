extends ProgressBar
# Changed script to use built-in progress bar and range properties

class_name VitalTracker

# what is being tracked
# switch to enum?
@export var vital_name : String

# optimal levels
@export var concern_threshold : int
@export var vital_lower_optimal : int
@export var vital_upper_optimal : int

@export var alert_style : StyleBoxFlat
var normal_style : StyleBoxFlat

func _ready():
	normal_style = get_theme_stylebox("background")
	SignalBus.connect("restart_level", reset_style)

# is level in the optimal range?
func check_if_level_is_optimal() -> bool:
	if (value < concern_threshold):
		add_theme_stylebox_override("background", alert_style)
	else:
		remove_theme_stylebox_override("background")
	
	if value >= vital_lower_optimal && value <= vital_upper_optimal:
		return true
	else:
		return false


func reset_style():
	remove_theme_stylebox_override("background")


# is level at zero?
func check_if_level_is_zero() -> bool:
	return value == 0

# is level at max?
func check_if_level_is_max() -> bool:
	return value >= max_value
