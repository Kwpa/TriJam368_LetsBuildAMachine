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
	

func enter_rotate_mode():
	mode = "rotate"
	

func enter_hand_mode():
	mode = "hand"


func _input(event) -> void:
	
	## remove mode
	match mode:
		"remove":
			# on left click, set the clicked tile to the pot..?
			if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
				erase_cell(local_to_map(get_global_mouse_position()))
		"hand":
			if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
				set_cell(local_to_map(get_global_mouse_position()), 1, Vector2i(0,0),0)
			
			## rotating with right click
			elif event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_RIGHT && event.pressed:
				var pos = local_to_map(get_global_mouse_position())
				var cell_coords = get_cell_atlas_coords(pos)
				var cell_data = get_cell_tile_data(pos)
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
				
				#if cell_data != null:
					#selected_tile = cell_coords
					#if is_cell_flipped_h(pos) && is_cell_transposed(pos):
						#tile_direction = Vector2i(1,0)
					#elif is_cell_flipped_h(pos) && is_cell_flipped_v(pos):
						#tile_direction = Vector2i(0,1)
					#elif is_cell_flipped_v(pos) && is_cell_transposed(pos):
						#tile_direction = Vector2i(-1,0)
					#else:
						#tile_direction = Vector2i(0,-1) 
					#print(tile_direction)
					#rotate_cw()
					#
					#print("Rotate using " + str(selected_tile) + " & " + str(applied_transform))
					
				set_cell(pos, 1, selected_tile, applied_transform)


	## on left click, place the selected tile
	#if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
		#print("cell was left-clicked at ")
		#print(local_to_map(get_global_mouse_position()))
		##set_cell(pos.x, pos.y)
		## set the tile: at the clicked coordinates, using tile source index 0, to the selected tile within that atlas
		#set_cell(local_to_map(get_global_mouse_position()), 0, selected_tile)

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
	set_cell(local_to_map(get_global_mouse_position()), -1)
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
