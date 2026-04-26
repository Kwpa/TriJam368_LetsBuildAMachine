extends HBoxContainer

# array of cards
var card_deck:Array = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func add_card(new_card_coords:Vector2i) -> void:
	# create a new card
	# the blank constructor uses placeholder values
	var card = Card.new()
	
	# set the coordinates of the tile within the tileset
	card.set_tile_coords(new_card_coords)
	print(card)
	
	# add the created card to the hand
	self.add_child(card)
	print(self)

func _on_deck_pressed() -> void:
	
	# select a card randomly from the deck
	var new_card = card_deck.pick_random()
	
	# Q: do we want to remove the card from the deck?
	# add the card to the hand
	add_card(new_card)
	print('card deck clicked')
	print(new_card)
