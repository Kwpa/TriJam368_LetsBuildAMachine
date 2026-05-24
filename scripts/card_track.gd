extends Control

var is_raised : bool = false
var is_selected : bool = false

signal track_selected(track)

# controls mouse-card-handcontainer interactions

func set_card_data(data: CardData) -> void:
	$card.set_data(data)
	
func get_card_data() -> CardData:
	return $card.card_data

func raise_card() -> void:
	$card.position.y = 0
	is_raised = true
	
func lower_card() -> void:
	$card.position.y = 128 
	is_raised = false

func _on_card_mouse_entered() -> void:
	# raises its card. Connected to child's mouse_entered() signal
	raise_card()
	
func _on_card_mouse_exited() -> void:
	# lowers its card, unless the card has been selected
	# Connected to child's mouse_exited() signal
	if is_selected == false:
		lower_card()

func _card_input_handler(event : InputEvent) -> void:
	# generic handler for input of the child card
	if event is InputEventMouseButton && event.pressed:
		toggle_selection()
		track_selected.emit(self)
		print_debug('card track for %s has been selected' % $card.custom_to_string())
		
	# we can expand this for non-mouse inputs
	
func toggle_selection() -> void:
	# toggles whether it's selected
	is_selected = not is_selected
	# tell the card how to style itself in its new state 
	$card.on_selected_changed(is_selected)
	print("toggle_selection called. new state for %s is %s" % [$card.custom_to_string(), str(is_selected)])
	if is_selected:
		activate_place_mode()
	else:
		deactivate_place_mode()
		#lower_card() we do this in entering hand mode


func activate_place_mode():
	var card_data : CardData = $card.card_data
	SignalBus.emit_signal("enter_place_mode",card_data.coords,0)

func deactivate_place_mode():
	SignalBus.emit_signal("enter_hand_mode")
	lower_card()
	is_selected = false
