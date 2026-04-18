extends TileMapLayer

var selected_tile:Vector2i = Vector2i(-1,-1)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	pass

func _input(event) -> void:
	if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
		print("cell was left-clicked at ")
		print(local_to_map(get_global_mouse_position()))
		#set_cell(pos.x, pos.y)
		set_cell(local_to_map(get_global_mouse_position()), 0, selected_tile)


	if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_RIGHT && event.pressed:
		print("cell was right-clicked" || local_to_map(get_global_mouse_position()))
		set_cell(local_to_map(get_global_mouse_position()), 0, Vector2i(0,2))


			
func remove_tile() -> void:
	set_cell(local_to_map(get_global_mouse_position()), -1)
	print("Tile was removed")
	# emit a signal so the hand manager can add the card to the hand
