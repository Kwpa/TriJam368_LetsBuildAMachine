extends TileMapLayer

func _ready() -> void:
	SignalBus.connect("enter_place_mode", enter_preview_mode)
	SignalBus.connect("enter_hand_mode", enter_hand_mode)
	
var preview_mode := false
@onready var tile_map : TileMapLayer = $"../tile_map"

var last_cell_coords := Vector2i(0,0)


func enter_preview_mode(atlas_coords : Vector2i, n):
	preview_mode = true


func enter_hand_mode():
	preview_mode = false
	erase_cell(last_cell_coords)


func check_if_tile_is_free() -> bool:
	var atlas_coords = tile_map.get_cell_atlas_coords(last_cell_coords)
	if atlas_coords == Vector2i(-1,-1):
		return true
	else:
		return false


func _process(delta: float) -> void:
	if preview_mode:
		var cell_selected_coords = local_to_map(to_local(get_global_mouse_position()))
		if cell_selected_coords.x >= 0 and cell_selected_coords.x < 5 and cell_selected_coords.y >= 0 and cell_selected_coords.y < 5:
			if cell_selected_coords != last_cell_coords:
				erase_cell(last_cell_coords)
				last_cell_coords = cell_selected_coords
				if check_if_tile_is_free():
					set_cell(last_cell_coords,3,Vector2i(0,0))
					modulate = Color(1,1,1,0.5)
				else:
					set_cell(last_cell_coords,3,Vector2i(0,1))
					modulate = Color(1,1,1,0.5)
		else:
			erase_cell(last_cell_coords)
