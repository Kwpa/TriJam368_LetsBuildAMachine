extends HBoxContainer

var card_deck:Array = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func add_card(new_card_coords:Vector2i) -> void:
	var card = Card.new()
	card.set_tile_coords(new_card_coords)
	print(card)
	self.add_child(card)
	print(self)


func _on_deck_pressed() -> void:
	var new_card = card_deck.pick_random()
	# Q: do we want to remove the card from the deck?
	add_card(new_card)
	print('card deck clicked')
	print(new_card)
