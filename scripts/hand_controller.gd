extends Node2D

var card_scene = preload("res://scenes/card.tscn")
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$HandContainer.size.x = 160 * Constants.HAND_SIZE_LIMIT
	print(Constants.card_id.values())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func get_random_card_data() -> CardData:
	# get random weighted int
	var index = rng.rand_weighted(Constants.card_weights)
	
	# get the card_id at that index
	var card_id_values = Constants.card_id.values()
	var random_card_id = card_id_values[index]
	
	# get CardData from all_card dict with that card_id
	var random_card = Constants.all_cards[random_card_id]
	
	return random_card

func _on_deck_pressed() -> void:
	# check whether hand size limit is reached
	print_debug("hand size is " + str($HandContainer.get_child_count()))
	
	if $HandContainer.get_child_count() < Constants.HAND_SIZE_LIMIT:
		# generate card according to weighted probability
		var new_card = card_scene.instantiate()
		new_card.set_data(get_random_card_data())
		print_debug(new_card.custom_to_string())
		#add card to the hand
		$HandContainer.add_child(new_card)
	
	else:
		print("Hand is too large. You must first discard a card.")

func _on_card_selected(card) -> void:
	SignalBus.card_selected.emit(card)
	print_debug("card '%' selected" % card)
