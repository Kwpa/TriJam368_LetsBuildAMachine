extends Node2D

var rng = RandomNumberGenerator.new()
var card_track_scene = preload("res://scenes/card_track.tscn")
var selected_card_track

signal card_selected(card_data)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$HandContainer.size.x = 160 * Constants.HAND_SIZE_LIMIT
	deal_opening_hand()
	SignalBus.connect("use_card",use_selected_card)

func deal_opening_hand() -> void:
	# let the player begin with a hand of cards containing at least one generator of each kind
	for res in [Constants.resource.water, Constants.resource.nutrients]: 
		add_card_to_hand(get_random_by_resource(res))
		await get_tree().create_timer(1).timeout
	
	# also give them a lamp and a sprinkler for easy testing
	add_card_to_hand(Constants.all_cards.get(Constants.card_id.lamp))
	await get_tree().create_timer(1).timeout
	add_card_to_hand(Constants.all_cards.get(Constants.card_id.sprinkler))
	await get_tree().create_timer(1).timeout
	return

func add_card_to_hand(card : CardData) -> void:
	var tween = create_tween()
	#tween.set_trans(Tween.TRANS_BACK)

	var new_card_track = card_track_scene.instantiate()
	new_card_track.connect('track_selected', _on_card_track_selection_changed)
	new_card_track.set_card_data(card)
	$HandContainer.add_child(new_card_track)
	
	# for aesthetics
	new_card_track.modulate.a = .25
	tween.tween_property(new_card_track, "custom_minimum_size:x", 160, .5)
	tween.parallel().tween_property(new_card_track, "modulate:a", 1, .5)

	await tween.finished
	print_debug('custom minimum size = %s, size = %s' %[new_card_track.custom_minimum_size.x, new_card_track.size.x])

func remove_card_from_hand(track) -> void:
	#this method is called by either placing or recyling a card. We can change it to return a Card if we want to store those
	pass

func get_random_by_resource(type : int) -> CardData:
	# returns a random card that generates the specified resource
	# create an array of card_ids whose cards generate that resource
	var card_ids = []
	for id in Constants.all_cards.keys():
		if Constants.all_cards.get(id).get("resource") == type:
			card_ids.append(id)
			
	## pick a random card_id from that array
	var random_card_id = card_ids.pick_random()
	
	## get CardData from all_card dict with that card_id
	var random_card = Constants.all_cards[random_card_id]
	
	return random_card
	
func get_random_card_data() -> CardData: 
	# maybe we can refactor this to take an optional param and then we can combine it with get_random_by_resource
	# get random weighted int
	var index = rng.rand_weighted(Constants.card_weights)
	
	# get the card_id at that index
	var card_id_values = Constants.card_id.values() # -> array 
	var random_card_id = card_id_values[index]
	
	# get CardData from all_card dict with that card_id
	var random_card = Constants.all_cards[random_card_id]
	
	return random_card


func _on_deck_pressed() -> void:
	# check whether hand size limit is reached
	if $HandContainer.get_child_count() < Constants.HAND_SIZE_LIMIT:
		# if hand is small enough, add a new card to the hand
		add_card_to_hand(get_random_card_data())
	else:
		$MaxHandWarning.show()

func _on_card_track_selection_changed(track) -> void:
	# this is hooked up to a card track's 'track_selected' signal when the track is created
	if track.is_selected:
		# if the selection changed to 'true'
		selected_card_track = track # I'm not sure we'll need this variable
		# emit a signal with data from the selected card
		# the game controller can use this to enter placement mode
		card_selected.emit(track.get_card_data())
		
	for card_track in $HandContainer.get_children():
		if card_track != track && card_track.is_selected:
			card_track.toggle_selection()
			#print_debug("%s's selected is %s" % [card_track.get_child(0).custom_to_string(), str(card_track.is_selected)])

func recycle_selected_card() -> void:
	for track in $HandContainer.get_children():
		if track.is_selected:
			track.queue_free()
	return

func use_selected_card() -> void:
	for track in $HandContainer.get_children():
		if track.is_selected:
			track.queue_free()
	return
	
