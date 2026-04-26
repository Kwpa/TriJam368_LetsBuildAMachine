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
	

func check_if_tile_is_colliding(layer : int, tile1_coords : Vector2i, tile2_coords : Vector2i):
	
	var tile1 = get_cell_tile_data(tile1_coords)
	var tile2 = get_cell_tile_data(tile2_coords)
	
	var polys_overlap = false
	if tile1 != null and tile2 != null:
		var tile1_poly_count = tile1.get_collision_polygons_count(layer)
		var tile2_poly_count = tile2.get_collision_polygons_count(layer)
	
		if tile1_poly_count > 0 && tile2_poly_count > 0:
			
			for i in tile1_poly_count:
				var polygon_1 : PackedVector2Array = tile1.get_collision_polygon_points(layer,i)
				print("1")
				for k in polygon_1.size():
						polygon_1[k] = polygon_1[k]+map_to_local(tile1_coords)
						print(polygon_1[k])
				print("2")	
				for j in tile2_poly_count:
					var polygon_2 : PackedVector2Array = tile2.get_collision_polygon_points(layer,j)
					for l in polygon_2.size():
						polygon_2[l] = polygon_2[l]+map_to_local(tile2_coords)
						print(polygon_2[l])
					
					var intersect_array : Array[PackedVector2Array] = Geometry2D.intersect_polygons(polygon_1, polygon_2)
					if intersect_array.is_empty() == false:
						print("hurrah!")

	return polys_overlap
			
			
			
		 
	
func rotate_tile(layer : int, tile : TileData) -> PackedVector2Array:
	for i in tile.get_collision_polygons_count(layer):
		for j in tile.get_collision_polygon_points(layer,i).size():
			if tile.transpose == false:
				if tile.flip_h && tile.flip_v:
					#
					pass
				if !tile.flip_h && tile.flip_v:
					pass
				if !tile.flip_h && !tile.flip_v:
					#normal
					pass
				if tile.flip_h && !tile.flip_v:
					pass
			else:
				if tile.flip_h && tile.flip_v:
					pass
				if !tile.flip_h && tile.flip_v:
					pass
				if !tile.flip_h && !tile.flip_v:
					
					pass
				if tile.flip_h && !tile.flip_v:
					pass
	var a
	return a 
