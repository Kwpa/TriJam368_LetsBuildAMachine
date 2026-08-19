extends TileMapLayer


func _ready() -> void:
	SignalBus.connect("enter_place_mode", enter_preview_mode)
	SignalBus.connect("enter_hand_mode", enter_hand_mode)
	SignalBus.connect("rotate_preview_tile", rotate_tile)
	
var preview_mode := false
@onready var tile_map : TileMapLayer = $"../tile_map"

var preview_tile_atlas_coords := Vector2i(0,0)
var preview_tile_alternative_tile := 0
var last_cell_coords := Vector2i(0,0)



func rotate_tile(new_alt_id : int):
	preview_tile_alternative_tile = new_alt_id


func enter_hand_mode():
	preview_mode = false
	erase_cell(last_cell_coords)


func enter_preview_mode(atlas_coords : Vector2i, alternative_tile_id : int):
	preview_mode = true
	preview_tile_atlas_coords = atlas_coords
	preview_tile_alternative_tile = alternative_tile_id
	


func check_if_tile_is_free() -> bool:
	var atlas_coords = tile_map.get_cell_atlas_coords(last_cell_coords)
	if atlas_coords == Vector2i(-1,-1):
		return true
	else:
		return false


func _process(delta: float) -> void:
	if preview_mode:
		placement_preview()
		


func placement_preview():
	var cell_selected_coords = local_to_map(to_local(get_global_mouse_position()))
	if cell_selected_coords.x >= 0 and cell_selected_coords.x < 5 and cell_selected_coords.y >= 0 and cell_selected_coords.y < 5:
		# if cell_selected_coords != last_cell_coords:
			erase_cell(last_cell_coords)
			last_cell_coords = cell_selected_coords
			if check_if_tile_is_free():
				modulate = Color(1,1,1,0.5)
			else:
				modulate = Color(1,1,1,0.3)
			set_cell(last_cell_coords, 1, preview_tile_atlas_coords, preview_tile_alternative_tile)
	else: 
		erase_cell(last_cell_coords)
