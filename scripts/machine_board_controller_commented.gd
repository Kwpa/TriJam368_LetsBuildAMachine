extends TileMapLayer

var selected_tile:Vector2i = Vector2i(-1,-1)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	check_if_tile_is_colliding(1,Vector2i(9,2),Vector2i(9,3))
	check_if_tile_is_colliding(1,Vector2i(10,2),Vector2i(10,3))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	pass



func _input(event) -> void:
	# on left click, place the selected tile
	if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
		print("cell was left-clicked at ")
		print(local_to_map(get_global_mouse_position()))
		#set_cell(pos.x, pos.y)
		# set the tile: at the clicked coordinates, using tile source index 0, to the selected tile within that atlas
		set_cell(local_to_map(get_global_mouse_position()), 0, selected_tile)

	# on right click, set the clicked tile to the pot..?
	if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_RIGHT && event.pressed:
		print("cell was right-clicked" || local_to_map(get_global_mouse_position()))
		set_cell(local_to_map(get_global_mouse_position()), 0, Vector2i(0,2))


			
func remove_tile() -> void:
	# remove tile by setting its tile source index to -1
	set_cell(local_to_map(get_global_mouse_position()), -1)
	print("Tile was removed")
	# emit a signal so the hand manager can add the card to the hand
	

func check_if_tile_is_colliding(layer : int, tile1_coords : Vector2i, tile2_coords : Vector2i):
	
	# get the tiles at the coordinates
	var tile1 = get_cell_tile_data(tile1_coords)
	var tile2 = get_cell_tile_data(tile2_coords)
	
	var polys_overlap = false
	
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
				## print("1")
				## for point : Vector2 in polygon_1:
				## 	print(point)
				## 	point.x += 0 #tile1_coords.x*128
				## 	point.y += 0 #tile1_coords.y*128
				## print("2")
				
				# get each collision polygon of the second tile
				for j in tile2_poly_count:
					var polygon_2 : PackedVector2Array = tile2.get_collision_polygon_points(layer,j)
					## for point : Vector2 in polygon_2:
					## 	print(point)
					##	point.x += 10000 #tile2_coords.x*128
					##	point.y += 10000 #tile2_coords.y*128
					
					# check for intersections
					var intersect_array : Array[PackedVector2Array] = Geometry2D.intersect_polygons(polygon_1, polygon_2)
					if intersect_array.is_empty() == false:
						print("hurrah!")
						polys_overlap = true
						break
			
	return polys_overlap
