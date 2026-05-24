extends Node2D

var resource_icon_debug = preload("res://scenes/resource_icon_on_tile.tscn")

var store_icon_debugs : Dictionary = {}

@onready var layer = $"../tile_map"


func create_icons(active_tiles : Dictionary):
	for key in active_tiles.keys():
		var new_icon_on_tile : Node2D = resource_icon_debug.instantiate()
		new_icon_on_tile.custom_init(active_tiles[key].coords)
		add_child(new_icon_on_tile)
		
		new_icon_on_tile.position = layer.map_to_local(active_tiles[key].coords)
		store_icon_debugs[key] = new_icon_on_tile


func update_resource_icons(active_tiles : Dictionary):
	for key in active_tiles.keys():
		store_icon_debugs[key].update_resource_icons(active_tiles[key].resources)
