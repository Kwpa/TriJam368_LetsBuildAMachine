extends Node2D

var rng = RandomNumberGenerator.new()
var card_track_scene = preload("res://scenes/card_track.tscn")
var selected_card_track
var draw_interval = 0.4

var actions_remaining: int
var can_act: bool = false
var initializing: bool

signal card_selected(card_data)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$HandContainer.size.x = 160 * Constants.HAND_SIZE_LIMIT
	deal_opening_hand()
	SignalBus.connect("use_card",use_selected_card)
	SignalBus.connect("end_turn", end_turn)

func deal_opening_hand() -> void:
	initializing = true
	var deck_pos = $DeckParent.global_position
	
	# set actions to default count for one turn
	actions_remaining = Constants.TURN_ACTION_COUNT
	
	# let the player begin with a hand of cards containing at least one generator of each kind
	for res in [Constants.resource.water, Constants.resource.nutrients]: 
		add_card_to_hand(get_random_by_resource(res), deck_pos, false)
		await get_tree().create_timer(1).timeout
	
	# also give them a lamp and a sprinkler for easy testing
	add_card_to_hand(Constants.all_cards.get(Constants.card_id.lamp), deck_pos, false)
	await get_tree().create_timer(1).timeout
	add_card_to_hand(Constants.all_cards.get(Constants.card_id.sprinkler), deck_pos, false)
	await get_tree().create_timer(1).timeout
	
	# allow the player to take actions once the cards are all dealt
	can_act = true
	
	initializing = false
	return

func count_action(spend: bool):
	# count the action
	if spend:
		actions_remaining -= 1
	else:
		actions_remaining += 1
	#print_debug("there are %s actions left" % actions_remaining)
	
	# send a signal to update the ui
	SignalBus.count_action.emit(actions_remaining)
	
	# show the warning dialogue if actions are all spent
	# in initial testing i found this obnoxious
	#if actions_remaining == 0:
		#$ActionWarning.show()

func add_card_to_hand(card : CardData, pos: Vector2, spend: bool) -> void:

	print_debug("adding card to hand %s" % card.title)
	# disable actions until this action is complete
	can_act = false
	
	var add_tween = create_tween()
	
	# create a real card
	var new_card_track = card_track_scene.instantiate()
	add_child(new_card_track)
	new_card_track.connect('track_selected', _on_card_track_selection_changed)
	new_card_track.set_card_data(card)
	new_card_track.scale = Vector2(0.25, 0.25)
	new_card_track.global_position = pos
	new_card_track.modulate.a = .5
	
	# create a dummy card track and add it to the hand
	var dummy_track = card_track_scene.instantiate()
	dummy_track.modulate.a = 0
	$HandContainer.add_child(dummy_track)
	var dummy_pos_x = dummy_track.position.x - 77 * $HandContainer.get_child_count()
	var dummy_pos_y = dummy_track.position.y - 80

	# grow the dummy to make room 
	add_tween.tween_property(dummy_track, "custom_minimum_size:x", 160, draw_interval).set_delay(draw_interval/3).set_ease(Tween.EASE_IN)
	
	# and move the real card into place
	add_tween.parallel().tween_property(new_card_track, "custom_minimum_size:x", 160, draw_interval)
	add_tween.parallel().tween_property(new_card_track, "position", Vector2(dummy_pos_x, dummy_pos_y - 100), draw_interval)
	add_tween.parallel().tween_property(new_card_track, "scale", Vector2(1,1), draw_interval)
	# delay the card growing for a bit so the animation looks better
	
	# let the real card drop gracefully into place
	add_tween.chain().tween_property(new_card_track, "position", Vector2.DOWN * 100, 0.3).as_relative()
	add_tween.parallel().tween_property(new_card_track, "modulate:a", 1, 0.3)
	
	# add the real card to the hand and delete the dummy at the same time
	add_tween.chain().tween_callback(new_card_track.reparent.bind($HandContainer))
	add_tween.parallel().tween_callback(dummy_track.queue_free)
	
	# count the action if we're not drawing the initial hand
	if initializing == false:
		count_action(spend)
		# enable actions now that this action is complete
		can_act = true

	# enter hand mode
	SignalBus.emit_signal("enter_hand_mode")

func remove_card_from_hand(track : CardTrack) -> void:
	# disable actions until this action is complete
	can_act = false
	
	var tween = get_tree().create_tween()
	
	var discard_position = $DiscardParent/Recycle.position #this is a Vector2
	var discard_interval = .75
	
	# create a dummy track to take the place of the card we're discarding
	var track_index = track.get_index() # need this to insert the dummy at the correct place
	var dummy_track = card_track_scene.instantiate()
	dummy_track.custom_minimum_size.x = 160
	dummy_track.modulate.a = 0
	# reparent the real card so we can move it outside the container
	track.reparent($DiscardParent)
	# add the dummy track into the place the real track was
	$HandContainer.add_child(dummy_track)
	$HandContainer.move_child(dummy_track, track_index)
	
	# shrink the size of the dummy so the hand resizes smoothly
	tween.tween_property(dummy_track, "custom_minimum_size:x", 0, .3) #shrink it down
	
	# move the real card over to the discard spot
	tween.parallel().tween_property(track, "modulate:a", 0.5, .3) #make it partially transparent
	tween.parallel().tween_property(track, "global_position", Vector2.UP*100, .3).as_relative() #raise it up
	tween.tween_callback(dummy_track.queue_free) #and delete the dummy
	tween.chain().tween_property(track, "position", discard_position, discard_interval) #move it to the discard pile
	tween.parallel().tween_property(track, "scale", Vector2(0.66, 0.66), discard_interval) #scale it to the discard scale
	tween.parallel().tween_property(track, "modulate:a", 0, discard_interval) #make it fully transparent
	tween.tween_callback(track.queue_free) #after everything, delete it
	
	# enable actions now that this action is complete
	can_act = true

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
	
	SignalBus.emit_signal("enter_hand_mode")
	
	# disable this function if something else is already happening
	if can_act == false:
		return
	
	# remind the player to spend their turn if they're out of actions
	if actions_remaining == 0:
		$ActionWarning.show()
		return
	
	# check whether hand size limit is reached
	if $HandContainer.get_child_count() < Constants.HAND_SIZE_LIMIT:
		# if hand is small enough, add a new card to the hand
		add_card_to_hand(get_random_card_data(), $DeckParent.global_position, true)
	else:
		$MaxHandWarning.show()

func _on_card_track_selection_changed(track: CardTrack) -> void:
	for card_track in $HandContainer.get_children():
		if card_track != track && card_track.is_selected:
			card_track.toggle_selection()
			#print_debug("%s's selected is %s" % [card_track.get_child(0).custom_to_string(), str(card_track.is_selected)])
	
	if actions_remaining == 0:
		return
	elif track.is_selected:
		# if the selection changed to 'true'
		selected_card_track = track # I'm not sure we'll need this variable
		# emit a signal with data from the selected card
		SignalBus.emit_signal("enter_place_mode",track.get_card_data().coords,0)
	else:
		# this should never occur, because we should never have a card selected outside of hand mode that we could deselect
		SignalBus.emit_signal("enter_hand_mode", track)
		
	
func recycle_selected_card() -> void:
	# disable this function if something else is already happening
	if can_act == false:
		return
	
	for track in $HandContainer.get_children():
		if track.is_selected:
			remove_card_from_hand(track)
			
			# if we want discarding to return an action to the player, uncomment below
			#count_action(false)
	return

func use_selected_card() -> void:
	# remind the player to spend their turn if they're out of actions
	if actions_remaining == 0:
		$ActionWarning.show()
		return
	
	# disable this function if something else is already happening
	if can_act == false:
		return
	
	for track in $HandContainer.get_children():
		if track.is_selected:
			remove_card_from_hand(track)
			
			# count the action
			count_action(true)
	return

func end_turn():
	# deselect any selected cards (this will also exit placement mode)
	for card_track in $HandContainer.get_children():
		if card_track.is_selected:
			card_track.toggle_selection()
			
	# set actions to default count for one turn
	actions_remaining = Constants.TURN_ACTION_COUNT
	SignalBus.count_action.emit(actions_remaining)
