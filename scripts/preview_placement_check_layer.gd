extends TileMapLayer

func _ready() -> void:
	SignalBus.connect("enter_place_mode", enter_preview_mode)
	SignalBus.connect("enter_hand_mode", enter_hand_mode)
	SignalBus.connect("enter_rotate_mode", enter_rotate_mode)
	SignalBus.connect("enter_remove_mode", enter_remove_mode)
	SignalBus.connect("rotate_preview_tile", rotate_tile)	
	
var mode := "hand"
var preview_tile_alternative_tile := 0
var dispenser_aoe_offsets = [
	[Vector2i(0,1),Vector2i(0,2),Vector2i(-1,2),Vector2i(1,2)],
	[Vector2i(-1,0),Vector2i(-2,0),Vector2i(-2,-1),Vector2i(-2,1)],
	[Vector2i(0,-1),Vector2i(0,-2),Vector2i(-1,-2),Vector2i(1,-2)],
	[Vector2i(1,0),Vector2i(2,0),Vector2i(2,-1),Vector2i(2,1)],
]

var uses_dispenser_aoe := false
var last_cell_coords_aoe := [Vector2i(0,0),Vector2i(0,0),Vector2i(0,0),Vector2i(0,0)]

@onready var tile_map : TileMapLayer = $"../tile_map"

var last_cell_coords := Vector2i(0,0)


func enter_preview_mode(atlas_coords : Vector2i, alternative_tile_id):
	mode = "place"
	preview_tile_alternative_tile = alternative_tile_id
	uses_dispenser_aoe = check_if_dispenser(atlas_coords)
	

func rotate_tile(new_alt_id : int):
	preview_tile_alternative_tile = new_alt_id



func check_if_dispenser(atlas_coords : Vector2i) -> bool:
	match atlas_coords:
		Vector2i(2,1):
			return true
		Vector2i(3,5):
			return true
	return false


func enter_rotate_mode():
	mode = "rotate"
	uses_dispenser_aoe = false
	erase_all()


func enter_remove_mode():
	mode = "remove"
	uses_dispenser_aoe = false
	erase_all()


func enter_hand_mode():
	mode = "hand"
	uses_dispenser_aoe = false
	erase_all()


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
	update_preview_tile()
	if uses_dispenser_aoe:
		update_dispenser_aoe_preview_tiles()


func update_preview_tile():
	erase_cell(last_cell_coords)
	var cell_selected_coords = local_to_map(to_local(get_global_mouse_position()))
	if cell_selected_coords.x >= 0 and cell_selected_coords.x < 5 and cell_selected_coords.y >= 0 and cell_selected_coords.y < 5:
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


func remove_dispenser_aoe_preview_tiles():
	for last_cell_coord_aoe in last_cell_coords_aoe:
		erase_cell(last_cell_coord_aoe)


func erase_all():
	for n in range(0,5):
		for m in range(0,5):
			erase_cell(Vector2i(n,m))


func update_dispenser_aoe_preview_tiles():
	remove_dispenser_aoe_preview_tiles()
	var i := 0
	for offset in dispenser_aoe_offsets[preview_tile_alternative_tile]:
		var cell_selected_coords = local_to_map(to_local(get_global_mouse_position()))+offset	
		if cell_selected_coords.x >= 0 and cell_selected_coords.x < 5 and cell_selected_coords.y >= 0 and cell_selected_coords.y < 5:
			last_cell_coords_aoe[i] = cell_selected_coords
			set_cell(last_cell_coords_aoe[i],3,Vector2i(1,0))
		i += 1
