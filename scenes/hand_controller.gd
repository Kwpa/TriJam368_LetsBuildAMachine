extends HBoxContainer

var card_deck:Array = [
	Vector2i(0,0), Vector2i(0,1), Vector2i(0,2), Vector2i(0,3), Vector2i(0,4)
	, Vector2i(1,0), Vector2i(1,1), Vector2i(1,2), Vector2i(1,3), Vector2i(1,4)
	, Vector2i(2,0), Vector2i(2,1), Vector2i(2,2), Vector2i(2,3), Vector2i(4,4)
	, Vector2i(3,0), Vector2i(3,1), Vector2i(3,2), Vector2i(3,3), Vector2i(4,4)
]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func add_card(new_card_coords:Vector2i) -> void:
	var card = Card.new()
	card.tile_coords = new_card_coords
	add_child(card)


func _on_deck_pressed() -> void:
	var new_card = card_deck.pick_random()
	# Q: do we want to remove the card from the deck?
	add_card(new_card)
	print('card deck clicked')
	print(new_card)
