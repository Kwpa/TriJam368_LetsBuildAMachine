extends TileMapLayer

# note on rotation of tiles, used to make alternative tiles: 
# if fliph and transpose: 90 degrees clockwise
# if fliph and flipv: 180 degrees clockwise
# if flipv and transpose: 270 degrees clockwise 

var selected_tile:Vector2i = Vector2i(-1,-1)

var mode = "hand"

var flip_h = TileSetAtlasSource.TRANSFORM_FLIP_H
var flip_v = TileSetAtlasSource.TRANSFORM_FLIP_V
var t_transpose = TileSetAtlasSource.TRANSFORM_TRANSPOSE

var tile_transformations := {
	Vector2i(0,-1) : 0,
	Vector2i(1,0) : 1,
	Vector2i(0,1) : 2,
	Vector2i(-1,0) : 3
}

var tile_direction := Vector2i(0,-1)
var applied_transform : int


func load_level(level_def : LevelData):
	for tile in level_def.tiles:
		set_cell(tile.tilemap_coords, tile.source_id, tile.atlas_coords, tile.alternative_id) 


func rotate_cw():
	rotate_tile("cw")


func rotate_ccw():
	rotate_tile("ccw")


func rotate_tile(dir):
	if dir == "cw":
		tile_direction = Vector2i(tile_direction[1] * -1, tile_direction[0])
	else:
		tile_direction = Vector2i(tile_direction[1], tile_direction[0] * -1)
	
	applied_transform = 0
	applied_transform = tile_transformations[tile_direction]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.connect("enter_remove_mode", enter_remove_mode)
	SignalBus.connect("enter_rotate_mode", enter_remove_mode)
	SignalBus.connect("enter_hand_mode", enter_remove_mode)
	SignalBus.connect("enter_place_mode", enter_place_mode)


# find out if certain tiles connect with each other based on tile colliders
func test_check():
	print("******________")
	print("check two vertical")
	check_if_tile_is_colliding(1,Vector2i(2,1),Vector2i(2,2))
	print("________")
	print("check two horizontal")
	check_if_tile_is_colliding(1,Vector2i(2,2),Vector2i(3,2))
	print("******________")


func enter_remove_mode():
	mode = "remove"


func enter_place_mode(a,b):
	mode = "place"


func enter_rotate_mode():
	mode = "rotate"
	

func enter_hand_mode():
	mode = "hand"


func removal_check(card_id : int) -> bool:
	if card_id == Constants.card_id.plant or card_id == Constants.card_id.generator:
		return false
	else:
		return true 


func _input(event) -> void:
	
	## remove mode
	match mode:
		"remove":
			# on left click, remove the tile if it is removeable
			if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
				var pos = local_to_map(to_local(get_global_mouse_position()))
				var atlas_coords = get_cell_atlas_coords(pos)
				if atlas_coords != Vector2i(-1,-1):
					var card_id = get_cell_tile_data(pos).get_custom_data("card_id")
					if removal_check(card_id):
						erase_cell(local_to_map(to_local(get_global_mouse_position())))
		"hand":
			pass
		"place":
			if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
				var pos = local_to_map(to_local(get_global_mouse_position()))
				if pos.x >= 0 and pos.x < 4 and pos.y >= 0 and pos.y < 4:
					var atlas_coords = get_cell_atlas_coords(pos)
					if atlas_coords == Vector2i(-1,-1):
						set_cell(local_to_map(to_local(get_global_mouse_position())), 1, Vector2i(0,0),0)
						SignalBus.emit_signal("enter_hand_mode")
				
			if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_RIGHT && event.pressed:
				var currently_selected_alt_id = 0
				match currently_selected_alt_id:
					0:
						currently_selected_alt_id = 1
					1:
						currently_selected_alt_id = 2
					2:
						currently_selected_alt_id = 3
					3:
						currently_selected_alt_id = 0
						
				SignalBus.emit_signal("rotate_preview_tile", currently_selected_alt_id)
				
				
		"rotate":
			## rotating with right click
			if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_RIGHT && event.pressed:
				var pos = local_to_map(to_local(get_global_mouse_position()))
				var cell_coords = get_cell_atlas_coords(pos)
				if cell_coords != Vector2i(-1,-1):
					var card_id = get_cell_tile_data(pos).get_custom_data("card_id")
					if removal_check(card_id):
						var cell_alt_id = get_cell_alternative_tile(pos)
						match cell_alt_id:
							0:
								applied_transform = 1
							1:
								applied_transform = 2
							2:
								applied_transform = 3
							3:
								applied_transform = 0
						
						selected_tile = cell_coords
						
						set_cell(pos, 1, selected_tile, applied_transform)

	# a button press to test a number of predetermined tiles and if they are connected
	if event is InputEventKey && event.keycode == KEY_T && event.pressed:
		test_check()
	
	# swap to hand mode
	if event is InputEventKey && event.keycode == KEY_1 && event.pressed:
		mode = "hand"
		print("hand mode")
	# swap to rotate mode
	if event is InputEventKey && event.keycode == KEY_2 && event.pressed:
		mode = "rotate"
		print("rotate mode")
	# swap to remove mode
	if event is InputEventKey && event.keycode == KEY_3 && event.pressed:
		mode = "remove"
		print("remove mode")

			
func remove_tile() -> void:
	# remove tile by setting its tile source index to -1
	set_cell(local_to_map(to_local(get_global_mouse_position())), -1)
	print("Tile was removed")
	# emit a signal so the hand manager can add the card to the hand
	

func check_if_tile_is_colliding(layer : int, tile1_coords : Vector2i, tile2_coords : Vector2i):
	
	# get the tiles at the coordinates
	var tile1 = get_cell_tile_data(tile1_coords)
	var tile2 = get_cell_tile_data(tile2_coords)
	print("tile1 " + str(get_cell_alternative_tile(tile1_coords)))
	print("tile2 " + str(get_cell_alternative_tile(tile2_coords)))
	
	var polys_overlap = 0
	
	# make sure the tiles exist
	if tile1 != null and tile2 != null:
		
		# make sure the tiles have colliders
		var tile1_poly_count = tile1.get_collision_polygons_count(layer)
		var tile2_poly_count = tile2.get_collision_polygons_count(layer)
		if tile1_poly_count > 0 && tile2_poly_count > 0:
			
			# for each collider on tile one
			for i in tile1_poly_count:
				# get the collision polygon
				var polygon_1 : PackedVector2Array = tile1.get_collision_polygon_points(layer,i)
				# offset polygons
				for k in polygon_1.size():
						polygon_1[k] = polygon_1[k]+map_to_local(tile1_coords)
						#print(polygon_1[k])
				#print("2")	
				for j in tile2_poly_count:
					var polygon_2 : PackedVector2Array = tile2.get_collision_polygon_points(layer,j)
					
					# offset polygons
					for l in polygon_2.size():
						polygon_2[l] = polygon_2[l]+map_to_local(tile2_coords)
						#print(polygon_2[l])
					
					# check for intersections
					var intersect_array : Array[PackedVector2Array] = Geometry2D.intersect_polygons(polygon_1, polygon_2)
					if intersect_array.is_empty() == false:
						print("hurrah!")
						polys_overlap += 1

	return polys_overlap > 0
			
			
			
		 
	
#func rotate_tile(layer : int, tile : TileData) -> PackedVector2Array:
	#for i in tile.get_collision_polygons_count(layer):
		#for j in tile.get_collision_polygon_points(layer,i).size():
			#if tile.transpose == false:
				#if tile.flip_h && tile.flip_v:
					##
					#pass
				#if !tile.flip_h && tile.flip_v:
					#pass
				#if !tile.flip_h && !tile.flip_v:
					##normal
					#pass
				#if tile.flip_h && !tile.flip_v:
					#pass
			#else:
				#if tile.flip_h && tile.flip_v:
					#pass
				#if !tile.flip_h && tile.flip_v:
					#pass
				#if !tile.flip_h && !tile.flip_v:
					#
					#pass
				#if tile.flip_h && !tile.flip_v:
					#pass
	#var a
	#return a 
