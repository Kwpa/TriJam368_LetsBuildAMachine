extends Control

var is_raised : bool = false
var is_selected : bool = false

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
	# raises a card when the mouse enters it
	print_debug('mouse entered card')
	raise_card()
	
func _on_card_mouse_exited() -> void:
	# lower a card unless the card has been selected
	print_debug('mouse exited card')
	if is_selected == false:
		lower_card()

func _card_input_handler(event : InputEvent) -> void:
	if event is InputEventMouseButton && event.pressed:
		on_card_clicked()

func on_card_clicked() -> void:
	# clicking on a card selects the card
	is_selected = not is_selected
	# also tell the card how to style itself
	$card.on_selected_changed(is_selected)
	
