class_name LevelTile extends Node

@export var source : int
@export var tile_coords : Vector2
@export var map_coords : Vector2

func _init(_source: int, _tile_coords: Vector2, _map_coords: Vector2):
	source = _source
	tile_coords = _tile_coords
	map_coords = _map_coords
