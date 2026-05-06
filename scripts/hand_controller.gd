extends Node2D

var card_scene = preload("res://scenes/card.tscn")
var card_track = preload("res://scenes/card_track.tscn")
var rng = RandomNumberGenerator.new()
var selected_card_track

signal card_selected(card_data)

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
	print_debug("hand size is " + str($HandContainer.get_child_count()))
	
	# check whether hand size limit is reached
	if $HandContainer.get_child_count() < Constants.HAND_SIZE_LIMIT:
		
		# if hand is small enough, create a new card
		var new_card_track = card_track.instantiate()
		new_card_track.set_card_data(get_random_card_data())
		print_debug(new_card_track.get_child(0).custom_to_string())
		
		# add the card to the hand
		$HandContainer.add_child(new_card_track)
		
		# hook up the track's signal to the appropriate function
		new_card_track.connect('track_selected', _on_card_track_selection_changed)
	
	else:
		# maybe we'll make a UI warning
		print("Hand is too large. You must first discard a card.")

func _on_card_selected(card) -> void:
	SignalBus.card_selected.emit(card)
	print_debug("card % selected" % card.custom_to_string())
	# this will be responsible for deselecting other card
		


func _on_card_track_selection_changed(track) -> void:
	if track.is_selected:
		# if the selection changed to 'true'
		selected_card_track = card_track # I'm not sure we'll need this variable
		# emit a signal with data from the selected card
		# the game controller can use this to enter placement mode
		card_selected.emit(track.get_card_data())
		
	for card_track in $HandContainer.get_children():
		if card_track != track && card_track.is_selected:
			card_track.toggle_selection()
			print_debug("%s's selected is %s" % [card_track.get_child(0).custom_to_string(), str(card_track.is_selected)])
