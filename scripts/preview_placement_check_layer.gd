extends TileMapLayer

func _ready() -> void:
	SignalBus.connect("enter_place_mode", enter_preview_mode)
	SignalBus.connect("enter_hand_mode", enter_hand_mode)
	SignalBus.connect("enter_rotate_mode", enter_rotate_mode)
	SignalBus.connect("enter_remove_mode", enter_remove_mode)
	
var mode := "hand"


@onready var tile_map : TileMapLayer = $"../tile_map"

var last_cell_coords := Vector2i(0,0)


func enter_preview_mode(atlas_coords : Vector2i, n):
	mode = "place"
	

func enter_rotate_mode():
	mode = "rotate"


func enter_remove_mode():
	mode = "remove"	


func enter_hand_mode():
	mode = "hand"
	erase_cell(last_cell_coords)


func check_if_tile_is_free() -> bool:
	var atlas_coords = tile_map.get_cell_atlas_coords(last_cell_coords)
	if atlas_coords == Vector2i(-1,-1):
		return true
	else:
		return false


func check_if_tile_is_rotatable() -> bool:
	var tile_data = tile_map.get_cell_tile_data(last_cell_coords)
	if tile_data != null:
		var card_id = tile_data.get_custom_data("card_id")
		match card_id:
			10:
				return false
			11:
				return false
			25:
				return false
		
		# otherwise
		return true
	else: 
		return false


func check_if_tile_is_removeable() -> bool:
	
	var tile_data = tile_map.get_cell_tile_data(last_cell_coords)
	if tile_data != null:
		
		var card_id = tile_data.get_custom_data("card_id")
		match card_id:
			10:
				return false	
			11:
				return false
			25:
				return false
		
		# otherwise
		return true
	else: 
		return false


func _process(delta: float) -> void:
			var cell_selected_coords = local_to_map(to_local(get_global_mouse_position()))
			if cell_selected_coords.x >= 0 and cell_selected_coords.x < 5 and cell_selected_coords.y >= 0 and cell_selected_coords.y < 5:
				if cell_selected_coords != last_cell_coords:
					erase_cell(last_cell_coords)
					last_cell_coords = cell_selected_coords
				match mode:
					"place":
						if check_if_tile_is_free():
							set_cell(last_cell_coords,3,Vector2i(0,0))
							modulate = Color(1,1,1,0.5)
						else:
							set_cell(last_cell_coords,3,Vector2i(0,1))
							modulate = Color(1,1,1,0.5)
					"hand":
						pass
					"rotate":
						set_cell(last_cell_coords,4,Vector2i(0,0))
						if check_if_tile_is_rotatable():
							modulate = Color(0.216, 0.894, 0.278, 0.502)
						else:
							modulate = Color(1.0, 0.224, 0.067, 0.502)
					"remove":
						set_cell(last_cell_coords,4,Vector2i(0,0))
						if check_if_tile_is_removeable():
							modulate = Color(0.905, 0.176, 0.812, 0.502)
						else:
							modulate = Color(1.0, 0.224, 0.067, 0.502)
			else:
				erase_cell(last_cell_coords)
			
		
